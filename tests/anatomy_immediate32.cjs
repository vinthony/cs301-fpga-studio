const fs=require('fs'),vm=require('vm'),os=require('os'),path=require('path'),cp=require('child_process'),base=path.resolve(__dirname,'..'),ctx=vm.createContext({});
for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-context.js','anatomy-learning.js','anatomy-rv32.js','anatomy-regfile32.js','anatomy-immediate32.js','anatomy-decoder32.js','anatomy-cpu32.js','anatomy-board-cpu.js'])vm.runInContext(fs.readFileSync(path.join(base,f),'utf8'),ctx);
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},run=s=>vm.runInContext(s,ctx),formats=['I','S','B','U','J'],rows=[];
const add=(word,fmt,expected)=>rows.push({word:word>>>0,fmt,expected:expected===undefined?undefined:expected>>>0});
// Independent arithmetic encoders enumerate every I/S immediate and every B
// offset; expected signed values come from the original number, not the decoder.
for(let raw=0;raw<4096;raw++){
 const signed=raw>=2048?raw-4096:raw;
 add(raw*2**20+0x13,0,signed);
 add(Math.floor(raw/32)*2**25+(raw%32)*128+0x112023,1,signed);
 const off=raw*2;add(Math.floor(off/4096)*2**31+(Math.floor(off/2048)%2)*128+(Math.floor(off/32)%64)*2**25+(Math.floor(off/2)%16)*256+0x63,2,off>=4096?off-8192:off);
}
let seed=0x30111;const random=()=>seed=(Math.imul(seed,1664525)+1013904223)>>>0;
for(let i=0;i<512;i++){
 const high=random()%2**20;add(high*4096+0xb7,3,high*4096);
 const off=(random()%2**20)*2;add(Math.floor(off/2**20)*2**31+(Math.floor(off/4096)%256)*4096+(Math.floor(off/2048)%2)*2**20+(Math.floor(off/2)%1024)*2**21+0xef,4,off>=2**20?off-2**21:off);
}
for(let f=0;f<5;f++){add(0,f,0);for(let bit=0;bit<32;bit++)add(2**bit,f);add(0xffffffff,f);}
for(const [word,fmt,expected] of [[0xfff00093,0,-1],[0x80000013,0,-2048],[0x7ff00013,0,2047],[0xfe112823,1,-16],[0x00208463,2,8],[0xfe208ee3,2,-4],[0x123450b7,3,0x12345000],[0x001000ef,4,2048],[0xffdff0ef,4,-4]])add(word,fmt,expected);
const outputs=[];
for(const r of rows){const value=run(`anatomyImmediate32(${r.word},'${formats[r.fmt]}')`);outputs.push(value);if(r.expected!==undefined)ok(value===r.expected,'independent immediate '+JSON.stringify(r));}
for(const fmt of formats){const sources=run(`anatomyImmediate32Sources('${fmt}')`);ok(sources.length===32&&sources.every(v=>v===-1||v>=0&&v<=31),'32 valid sources');const e=run(`(()=>{const s=anatomyState();s.immFormat='${fmt}';return anatomyEvaluate('immgen32',s)})()`);ok(Object.keys(e.nets).length===3&&e.result===e.nets['立即数'],'connected output '+fmt);}
ok(run("anatomyImmediate32Sources('B')[11]")===7,'B imm11 from inst7');ok(run("anatomyImmediate32Sources('J')[11]")===20,'J imm11 from inst20');ok(run("anatomyImmediate32Sources('B')[0]")===-1,'B hardwired zero');ok(run("anatomyImmediate32Sources('J')[0]")===-1,'J hardwired zero');
const tmp=fs.mkdtempSync(path.join(os.tmpdir(),'cs301-imm32-'));try{
 fs.writeFileSync(path.join(tmp,'inputs.hex'),rows.map(r=>r.word.toString(16).padStart(8,'0')+r.fmt.toString(16)).join('\n'));
 fs.writeFileSync(path.join(tmp,'tb.v'),`module tb;reg[35:0]vectors[0:${rows.length-1}];reg[31:0]inst;reg[3:0]fmt;wire[31:0]imm;integer i;rv32_immgen dut(inst,fmt[2:0],imm);initial begin $readmemh("inputs.hex",vectors);for(i=0;i<${rows.length};i=i+1)begin {inst,fmt}=vectors[i];#1;$display("%08h",imm);end $finish;end endmodule`);
 cp.execFileSync('iverilog',['-g2012','-o',path.join(tmp,'sim'),path.join(base,'hardware/rv32_immgen.v'),path.join(tmp,'tb.v')]);const lines=cp.execFileSync('vvp',[path.join(tmp,'sim')],{cwd:tmp,encoding:'utf8',maxBuffer:4*1024*1024}).trim().split('\n').filter(l=>/^[0-9a-f]{8}$/i.test(l));ok(lines.length===rows.length,'HDL vector count');lines.forEach((line,i)=>ok(parseInt(line,16)===outputs[i],'HDL mapping mismatch '+JSON.stringify(rows[i])));
}finally{fs.rmSync(tmp,{recursive:true,force:true})}
console.log(JSON.stringify({status:'passed',checks,formats:5,HDLVectors:rows.length,exhaustiveISPatterns:4096,exhaustiveBOffsets:4096}));
