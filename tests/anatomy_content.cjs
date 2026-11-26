const fs=require('fs'),vm=require('vm'),assert=require('assert');const base=__dirname+'/../',ctx=vm.createContext({});for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-context.js','anatomy-learning.js','anatomy-rv32.js','anatomy-regfile32.js','anatomy-immediate32.js','anatomy-decoder32.js','anatomy-cpu32.js','anatomy-board-cpu.js','anatomy-sequence.js','anatomy-float.js','anatomy-representation.js','anatomy-alu4.js','anatomy-pipeline32.js','anatomy-pipeline32-view.js'])vm.runInContext(fs.readFileSync(base+f,'utf8'),ctx);
const report=vm.runInContext(`(()=>{let issues=[],counts={views:0,parts:0,nets:0};for(const [id,b]of Object.entries(ANATOMY)){counts.views++;counts.parts+=b.parts.length;counts.nets+=b.nets.length;let ids=b.parts.map(p=>p.id);if(new Set(ids).size!==ids.length)issues.push(id+':重复器件编号');for(const p of b.parts)if(p.ref&&!ANATOMY[p.ref])issues.push(id+':无展开目标'+p.ref);for(const n of b.nets){for(const end of [n.from,n.to])if(!ids.includes(end.split('.')[0]))issues.push(id+':无端口所属器件'+end);if(!n.name||n.bits<1)issues.push(id+':非法连线')}for(const source of b.sources)if(!ANATOMY_SOURCES[source])issues.push(id+':无来源'+source);if(b.steps.length<3)issues.push(id+':引导步骤不足');const e=anatomyEvaluate(id,anatomyState());if(!Array.isArray(e.watch))issues.push(id+':观察结果非法')}return{counts,issues}})()`,ctx);
assert.deepEqual(report.issues,[]);let cases=0;
function run(code){return vm.runInContext(code,ctx)}
for(let a=0;a<2;a++)for(let b=0;b<2;b++)for(let c=0;c<2;c++){
 const out=JSON.parse(run(`(()=>{let s=anatomyState();s.a=${a};s.b=${b};s.cin=${c};return JSON.stringify(Object.fromEntries(['and','or','xor','nand','nor','not','cmos','mux','fulladder','halfadder'].map(id=>[id,anatomyEvaluate(id,s)])))})()`));
 for(const [id,y]of Object.entries({and:a&b,or:a|b,xor:a^b,nand:1-(a&b),nor:1-(a|b),not:1-a,cmos:1-a,mux:c?b:a,fulladder:a^b^c,halfadder:a^b}))assert.equal(out[id].result,y,id);
 assert.equal(out.fulladder.nets.S,a^b^c);assert.equal(out.fulladder.nets.Cout,(a&b)|((a^b)&c));assert.equal(out.mux.nets.Y,c?b:a);
 for(const id of ['nand','nor','cmos']){assert.ok(!Object.values(out[id].nets).includes('X'),id+'供电短接');for(const net of run(`ANATOMY['${id}'].nets`).filter(n=>n.from==='Y.i'||n.to==='Y.i'))assert.equal(out[id].nets[net.name],out[id].result,id+'输出必须被正确驱动');}
 cases+=16;
}
for(let a=0;a<16;a++)for(let b=0;b<16;b++)for(let op of ['adder','subtract']){const out=JSON.parse(run(`(()=>{let s=anatomyState();s.av=${a};s.bv=${b};return JSON.stringify(anatomyEvaluate('${op}',s))})()`));assert.equal(out.result,op==='adder'?(a+b)&15:(a-b)&15);cases++;}
// Actual state semantics, independent of interface labels.
assert.equal(run(`(()=>{let s=anatomyState();s.a=1;if(anatomyEvaluate('dff',s).result!==0)return false;anatomyAdvance('dff',s);s.a=0;return anatomyEvaluate('dff',s).result===1})()`),true);cases++;
assert.equal(run(`(()=>{let s=anatomyState();s.a=1;anatomyAdvance('synchronizer',s);if(s.s2!==0)return false;anatomyAdvance('synchronizer',s);return s.s2===1})()`),true);cases++;
assert.equal(run(`(()=>{let s=anatomyState();s.data=55;s.we=0;anatomyAdvance('sram',s);if(s.mem[0]!==0)return false;s.we=1;anatomyAdvance('sram',s);return s.mem[0]===55&&s.readQ===0})()`),true);cases++;
assert.equal(run(`(()=>{let s=anatomyState();return anatomyEvaluate('board',s).led===8})()`),true);cases++;
console.log(JSON.stringify({...report.counts,numericCases:cases,status:'passed'}));
