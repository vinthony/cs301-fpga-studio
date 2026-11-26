#!/usr/bin/env python3
"""Run: python3 tests/test_system.py (from any working directory)."""
import importlib.util, json, pathlib, unittest
ROOT = pathlib.Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('fpga_server', ROOT / 'server.py')
server = importlib.util.module_from_spec(spec); spec.loader.exec_module(server)
LESSONS = json.loads((ROOT / 'lesson-manifest.json').read_text())
BY_ID = {l['id']: l for l in LESSONS}
def num(bits):
    return int(bits, 2) if bits and all(c in '01' for c in bits) else bits
def get(sample, key):
    return num(sample.get(key, next((v for k,v in sample['state'].items() if k.endswith('.'+key)), None)))
def execute(l, steps, code=None, program=None):
    return server.simulate({'code':code or l['code'], 'profile':l['profile'], 'program':program if program is not None else l['program'], 'events':steps})
def i(imm,rs,f3,rd,op=0x13): return ((imm&4095)<<20)|(rs<<15)|(f3<<12)|(rd<<7)|op
def r(f7,rs2,rs1,f3,rd): return (f7<<25)|(rs2<<20)|(rs1<<15)|(f3<<12)|(rd<<7)|0x33
def s(imm,rs2,rs1,f3): return (((imm&4095)>>5)<<25)|(rs2<<20)|(rs1<<15)|(f3<<12)|((imm&31)<<7)|0x23
def b(imm,rs2,rs1,f3): return (((imm>>12)&1)<<31)|(((imm>>5)&63)<<25)|(rs2<<20)|(rs1<<15)|(f3<<12)|(((imm>>1)&15)<<8)|(((imm>>11)&1)<<7)|0x63
def j(imm,rd): return (((imm>>20)&1)<<31)|(((imm>>1)&1023)<<21)|(((imm>>11)&1)<<20)|(((imm>>12)&255)<<12)|(rd<<7)|0x6f
class SystemTests(unittest.TestCase):
    def test_course_and_fault_fixes(self):
        count=0
        for l in LESSONS:
            for c in l['tests']:
                with self.subTest(lesson=l['id'],case=c['name']):
                    result=execute(l,c['steps']); failures=[]
                    for e,sample in zip(c['steps'],result['samples']):
                        for key,want in e.get('expect',{}).items():
                            count+=1
                            expected=int(want,0) if want.startswith(('0x','0b')) else int(want)
                            if get(sample,key)!=expected: failures.append(key)
                    self.assertEqual(bool(failures),l['id'].startswith('fault-'))
                    self.assertIn('$enddefinitions',result['vcd'])
                    if l['solution']:
                        fixed=execute(l,c['steps'],l['solution'])
                        for e,sample in zip(c['steps'],fixed['samples']):
                            for key,want in e.get('expect',{}).items():
                                count+=1
                                self.assertEqual(get(sample,key),int(want,0) if want.startswith(('0x','0b')) else int(want))
        self.assertGreaterEqual(count,4600)
    def run_cpu(self,words,extra=10):
        words=words+[0x00100073]
        program='\n'.join(f'{w:08x}' for w in words)
        steps=[dict(reset=1,tick=1),dict()]+[dict(tick=1) for _ in range(len(words)+extra)]
        return execute(BY_ID['cpu'],steps,program=program)['samples'][-1]
    def test_fsm_all_eight_bit_sequences(self):
        steps=[];expected=[]
        for sequence in range(256):
            steps.append(dict(reset=1,tick=1));expected.append(0)
            history=[]
            for pos in range(7,-1,-1):
                value=(sequence>>pos)&1;history.append(value)
                steps.append(dict(sw=value,tick=1));expected.append(int(history[-3:]==[1,0,1]))
        samples=execute(BY_ID['fsm'],steps)['samples']
        for index,(sample,want) in enumerate(zip(samples,expected)):
            self.assertEqual(get(sample,'led'),want,index)
    def test_onehot_switch_and_button_masks(self):
        steps=[dict(sw=1<<i) for i in range(16)]+[dict(btn=1<<i) for i in range(5)]
        samples=execute(BY_ID['led'],steps)['samples']
        for event,sample in zip(steps,samples):
            expected=event.get('sw',0)^event.get('btn',0)
            self.assertEqual(get(sample,'led'),expected)
            self.assertEqual(get(sample,'display'),expected)
    def test_zero_input_initialization_and_internal_wires(self):
        l=BY_ID['alu']; sample=execute(l,[dict(sw=0)])['samples'][0]
        self.assertEqual(get(sample,'display'),0)
        l=BY_ID['adder'];sample=server.simulate(dict(code=l['code'],events=[dict(sw=0x35)],watch=['sum']))['samples'][0]
        self.assertEqual(get(sample,'sum'),8)
        self.assertEqual(get(sample,'display'),8)
    def test_cpu_alu_signed_unsigned_and_x0(self):
        words=[i(-1,0,0,1),i(1,0,0,2),r(0,2,1,2,3),r(0,2,1,3,4),i((0x20<<5)|31,1,5,5),i(31,1,5,6),i(31,2,1,7),r(0,2,1,0,8),r(32,1,2,0,9),r(0,2,1,7,10),r(0,2,1,6,11),r(0,2,1,4,12),i(0,1,2,13),i(-1,1,3,14),i(15,1,7,15),i(8,2,6,16),i(-1,1,4,17),r(0,2,2,1,18),r(0,2,7,5,19),r(32,2,7,5,20),(0x12345<<12)|(21<<7)|0x37,(22<<7)|0x17,i(99,0,0,0)]
        sample=self.run_cpu(words)
        expected={0:0,1:0xffffffff,2:1,3:1,4:0,5:0xffffffff,6:1,7:0x80000000,8:0,9:2,10:1,11:0xffffffff,12:0xfffffffe,13:1,14:0,15:15,16:9,17:0,18:2,19:0x40000000,20:0xc0000000,21:0x12345000,22:21*4}
        for reg,value in expected.items():self.assertEqual(get(sample,f'dbg_x{reg}'),value,f'x{reg}')
        self.assertEqual(get(sample,'dbg_retired'),len(words)+1)
        self.assertEqual(get(sample,'dbg_trap'),0)
    def test_cpu_little_endian_load_store(self):
        words=[i(-128,0,0,1),s(0,1,0,0),i(0,0,0,2,3),i(0,0,4,3,3),i(-1,0,0,4),s(2,4,0,1),i(2,0,1,5,3),i(2,0,5,6,3),i(0,0,2,7,3),s(4,7,0,2),i(4,0,2,8,3)]
        sample=self.run_cpu(words)
        for reg,val in {2:0xffffff80,3:128,5:0xffffffff,6:65535,7:0xffff0080,8:0xffff0080}.items():self.assertEqual(get(sample,f'dbg_x{reg}'),val)
        self.assertEqual(get(sample,'dbg_m0'),0xffff0080);self.assertEqual(get(sample,'dbg_m1'),0xffff0080)
    def test_cpu_control_flow(self):
        words=[i(3,0,0,1),i(0,0,0,2),i(1,2,0,2),i(-1,1,0,1),b(-8,0,1,1),j(8,5),i(99,0,0,2),(6<<7)|0x17,i(16,6,0,6),i(0,6,0,7,0x67),i(88,0,0,2)]
        sample=self.run_cpu(words,30)
        for key,want in {'dbg_x2':3,'dbg_x5':24,'dbg_x7':40,'dbg_retired':16,'dbg_trap':0,'dbg_halted':1}.items():self.assertEqual(get(sample,key),want,key)
    def test_cpu_branch_conditions_and_shift_masks(self):
        for f3 in [0,1,4,5,6,7]:
            for a,bval in [(-1,1),(1,-1),(1,1)]:
                au=a&0xffffffff;bu=bval&0xffffffff
                taken={0:a==bval,1:a!=bval,4:a<bval,5:a>=bval,6:au<bu,7:au>=bu}[f3]
                sample=self.run_cpu([i(a,0,0,1),i(bval,0,0,2),b(8,2,1,f3),i(9,0,0,3)])
                self.assertEqual(get(sample,'dbg_x3'),0 if taken else 9,(f3,a,bval))
                self.assertEqual(get(sample,'dbg_retired'),4 if taken else 5)
        sample=self.run_cpu([i(1,0,0,1),i(33,0,0,2),r(0,2,1,1,3)])
        self.assertEqual(get(sample,'dbg_x3'),2)
        sample=self.run_cpu([i(0x401,1,1,3)])
        self.assertEqual(get(sample,'dbg_trap'),1)
    def test_cpu_traps(self):
        for words in [[0xffffffff],[i(1,0,0,1),i(0,1,2,2,3)],[i(256,0,0,1),i(0,1,2,2,3)]]:
            sample=self.run_cpu(words)
            self.assertEqual(get(sample,'dbg_trap'),1);self.assertEqual(get(sample,'dbg_halted'),1)
    def test_basys_full_digit_decoder(self):
        l=BY_ID['basys']
        for val in range(16):
            sw=val*0x1111
            ev=[dict(btn=1,tick=1),dict(sw=sw)]+[dict(sw=sw,tick=1) for _ in range(3)]
            result=execute(l,ev)['samples'][1:]
            for digit,sample in enumerate(result):
                self.assertEqual(get(sample,'an'),15^(1<<digit))
                self.assertEqual(get(sample,'dp'),1)
                patterns=[0x40,0x79,0x24,0x30,0x19,0x12,0x02,0x78,0,0x10,0x08,0x03,0x46,0x21,0x06,0x0e]
                self.assertEqual(get(sample,'seg'),patterns[val])
    def test_simulator_guards_and_compile_errors(self):
        for q in [dict(code='module bad(',events=[{}]),dict(code=BY_ID['led']['code'],events=[dict(btn=32)]),dict(code=BY_ID['led']['code'],events=[]),dict(code=BY_ID['cpu']['code'],events=[{}],program='not a hex file'),dict(code=BY_ID['cpu']['code'],events=[{}],program=''),dict(code=BY_ID['led']['code'].replace('endmodule','initial $error("assert failed"); endmodule'),events=[{}])]:
            with self.assertRaises(ValueError): server.simulate(q)
    def test_clock_period_and_history_replay(self):
        ev=[dict(reset=1,tick=1),dict(),dict(sw=1,tick=1),dict(sw=1,tick=1)]
        l=BY_ID['counter'];a=execute(l,ev);prefix=execute(l,ev[:3]);continued=execute(l,ev[:3]+[dict(sw=1,tick=1)])
        self.assertEqual(get(prefix['samples'][-1],'display'),1);self.assertEqual(get(continued['samples'][-1],'display'),2)
        sig,changes=server.parse_vcd(a['vcd']);clk=next(s for s in sig if s['name']=='tb.clk');rises=[t for t,v in changes[clk['id']] if v=='1']
        self.assertAlmostEqual(rises[-1]-rises[-2],10,places=6)
if __name__=='__main__':unittest.main(verbosity=2)
