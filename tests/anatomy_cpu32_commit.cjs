const fs=require('fs'),vm=require('vm'),path=require('path'),base=path.resolve(__dirname,'..'),ctx=vm.createContext({});for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-context.js','anatomy-learning.js','anatomy-rv32.js','anatomy-regfile32.js','anatomy-immediate32.js','anatomy-decoder32.js','anatomy-cpu32.js','anatomy-board-cpu.js'])vm.runInContext(fs.readFileSync(path.join(base,f),'utf8'),ctx);
const run=s=>vm.runInContext(s,ctx);let checks=0,steps=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
for(const source of run('AN_CPU32_DEMOS.map(d=>d.source)').concat(['addi x0,x0,5\nebreak','addi x1,x0,1\nsw x1,1(x0)','addi x1,x0,-1\nsw x1,0(x0)'])){
 run('var s=anatomyState();s.cpu32=anatomyCPU32State(anatomyAssembleCPU32('+JSON.stringify(source)+'))');
 for(let i=0;i<120&&!run('s.cpu32.halted');i++){
  const before=run('JSON.stringify(s)'),plan=run('anatomyCPU32CommitPlan(s)');ok(before===run('JSON.stringify(s)'),'preview does not mutate');run('anatomyCPU32Step(s)');steps++;
  for(const change of plan.changes){const target=change.target;let actual;if(target==='PC')actual=run('s.cpu32.pc');else if(target==='退休计数')actual=run('s.cpu32.retired');else if(/^x/.test(target))actual=run('s.cpu32.regs['+target.slice(1)+']');else if(target.startsWith('RAM'))actual=run('s.cpu32.memory['+target.slice(4,-1)+']');else actual=run('s.cpu32.'+(target.startsWith('LED')?'led':'display'));ok(actual===change.after,'committed '+target)}
  if(plan.status==='fault')ok(run('s.cpu32.halted')&&plan.changes.length===0,'fault gates commits');
 }
}
console.log(JSON.stringify({status:'passed',checks,steps}));
