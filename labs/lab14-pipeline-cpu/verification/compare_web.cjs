// Compare generated RTL's recorded active edges with the actual teaching-page model.
// Optional second argument: directory containing anatomy-pipeline32.js.
const fs=require('fs'),path=require('path'),vm=require('vm');
const root=path.resolve(__dirname,'..'),app=path.resolve(process.argv[2]||path.join(__dirname,'../../../outputs/芯片细胞实验室'));
if(!fs.existsSync(path.join(app,'anatomy-pipeline32.js')))throw Error('请传入教学板目录：node verification/compare_web.cjs /path/to/芯片细胞实验室');
const ctx=vm.createContext({});
for(const name of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-context.js','anatomy-learning.js','anatomy-rv32.js','anatomy-regfile32.js','anatomy-immediate32.js','anatomy-decoder32.js','anatomy-cpu32.js','anatomy-pipeline32.js'])vm.runInContext(fs.readFileSync(path.join(app,name),'utf8'),ctx,{filename:name});
const cases=JSON.parse(fs.readFileSync(path.join(root,'out/cases.json'),'utf8'));
const lines=fs.readFileSync(path.join(root,'out/pipeline-cycles.txt'),'utf8').trim().split('\n');
const reasons={EBREAK:1,ILLEGAL_INSTRUCTION:2,INSTRUCTION_ACCESS_FAULT:3,INSTRUCTION_ADDRESS_MISALIGNED:4,LOAD_ADDRESS_MISALIGNED:5,STORE_ADDRESS_MISALIGNED:6,LOAD_ACCESS_FAULT:7,STORE_ACCESS_FAULT:8,ECALL:9};
function reader(hex){let value=BigInt('0x'+hex);return bits=>{const result=Number(value&((1n<<BigInt(bits))-1n));value>>=BigInt(bits);return result}}
function snapshot(hex){const take=reader(hex),memory=Array(256),regs=Array(32);for(let i=255;i>=0;i--)memory[i]=take(8);for(let i=31;i>=0;i--)regs[i]=take(32);const display=take(32),led=take(16),faultValue=take(32),reason=take(4),halted=!!take(1),retired=take(32),pc=take(32);return {pc,retired,halted,reason,faultValue,led,display,regs,memory}}
function debug(hex){const take=reader(hex),stagePC=Array(4),stageValid=Array(4);for(let i=3;i>=0;i--)stagePC[i]=take(32);for(let i=3;i>=0;i--)stageValid[i]=!!take(1);const pendingTrap=!!take(1),redirects=take(32),stalls=take(32),cycles=take(32),fetchPC=take(32);return {stagePC,stageValid,pendingTrap,redirects,stalls,cycles,fetchPC}}
let last='',checked=0,programRuns=0;
for(const line of lines){
 const [indexText,modeText,cycleText,actualHex,debugHex,faText,fbText]=line.trim().split(/\s+/),index=Number(indexText),mode=Number(modeText),cycle=Number(cycleText),key=index+':'+mode;
 if(key!==last){ctx.item=cases[index];ctx.hazardMode=mode===1?'stall':'forward';vm.runInContext("globalThis.pipeline=anatomyPipeline32State({words:item.words,sourceLines:[],sourceText:'.word'},hazardMode,item.name)",ctx);last=key;programRuns++;}
 const expected=JSON.parse(vm.runInContext(`(()=>{anatomyPipeline32Tick(pipeline,{switches:item.switches,buttons:item.buttons});const p=pipeline,stages=['ifid','idex','exmem','memwb'].map(k=>p.stages[k]);return JSON.stringify({pc:p.pc,retired:p.retired,halted:p.halted,reason:p.fault?.kind||null,faultValue:p.fault?.value||0,led:p.led,display:p.display,regs:p.regs,memory:p.memory,stageValid:stages.map(Boolean),stagePC:stages.map(s=>s?.pc||0),pendingTrap:p.pendingTrap,redirects:p.redirects,stalls:p.stalls,cycles:p.cycles,fetchPC:p.fetchPC,forwardA:p.lastCycle.forwardA,forwardB:p.lastCycle.forwardB})})()`,ctx));
 expected.reason=expected.reason?reasons[expected.reason]:0;expected.forwardA=expected.forwardA==='EX/MEM'?1:expected.forwardA==='MEM/WB'?2:0;expected.forwardB=expected.forwardB==='EX/MEM'?1:expected.forwardB==='MEM/WB'?2:0;
 const actual={...snapshot(actualHex),...debug(debugHex),forwardA:Number(faText),forwardB:Number(fbText)};actual.stagePC=actual.stagePC.map((pc,i)=>actual.stageValid[i]?pc:0);
 for(const [field,value]of Object.entries(expected))if(JSON.stringify(actual[field])!==JSON.stringify(value))throw Error(`case ${index} ${cases[index].name}, mode ${mode}, cycle ${cycle}, ${field}: RTL=${JSON.stringify(actual[field])}, page=${JSON.stringify(value)}`);
 checked++;
}
const report={status:'passed',programs:cases.length,programRuns,hazardModes:['stall','forward'],activeEdges:checked,compared:['all registers','all RAM bytes','MMIO','architectural PC','fetch PC','retirement','fault and value','four pipeline packet valid/PC pairs','pending trap','stall/redirect counters','EX operand forwarding'],scope:'generated RTL active edges versus current page model; separate Python interpreter check covers architectural outcomes; not physical FPGA timing'};
fs.writeFileSync(path.join(root,'evidence/web-cycle-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
