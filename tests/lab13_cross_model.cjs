const fs=require('fs'),vm=require('vm'),path=require('path'),cp=require('child_process'),base=path.resolve(__dirname,'..'),lab=path.join(base,'labs/lab13-single-cycle-cpu');
cp.execFileSync('python3',[path.join(lab,'verification/check_generated.py')],{stdio:'pipe'});
const cases=JSON.parse(fs.readFileSync(path.join(lab,'out/cases.json'),'utf8')),expected=JSON.parse(cp.execFileSync('python3',[path.join(lab,'verification/reference/rv32_interpreter.py')],{input:JSON.stringify(cases),encoding:'utf8',maxBuffer:32*1024*1024}));
const c=vm.createContext({});for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-context.js','anatomy-learning.js','anatomy-rv32.js','anatomy-regfile32.js','anatomy-immediate32.js','anatomy-decoder32.js','anatomy-cpu32.js'])vm.runInContext(fs.readFileSync(path.join(base,f),'utf8'),c);
let checks=0,steps=0;
for(let i=0;i<cases.length;i++){
 c.item=cases[i];vm.runInContext(`var s=anatomyState();s.cpu32=anatomyCPU32State({words:item.words,sourceLines:item.words.map(()=>({line:0,text:'.word'})),sourceText:'.word'},item.name);s.cpuSwitches=item.switches;s.cpuButtons=item.buttons`,c);
 for(const row of expected[i]){
  vm.runInContext('anatomyCPU32Step(s)',c);const actual=JSON.parse(vm.runInContext(`JSON.stringify({pc:s.cpu32.pc,regs:s.cpu32.regs,memory:s.cpu32.memory,retired:s.cpu32.retired,halted:s.cpu32.halted,fault:s.cpu32.fault?.kind||null,led:s.cpu32.led,display:s.cpu32.display,faultValue:s.cpu32.fault?.value||0})`,c));
  if(JSON.stringify(actual)!==JSON.stringify(row))throw Error('web mismatch '+cases[i].name+' step '+steps);checks++;steps++;
 }
}
console.log(JSON.stringify({status:'passed',programs:cases.length,steps,checks,reference:'same independent interpreter as generated RTL check'}));
