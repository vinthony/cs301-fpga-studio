const fs=require('fs'),vm=require('vm'),readline=require('readline'),path=require('path');
const [root,vectors]=process.argv.slice(2);if(!root||!vectors)throw Error('node compare_web.cjs APP_DIRECTORY VECTORS_FILE');
const ctx=vm.createContext({});for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js'])vm.runInContext(fs.readFileSync(path.join(root,f),'utf8'),ctx);
const state=vm.runInContext('anatomyState()',ctx),plan=vm.runInContext('anatomyRasterPlan',ctx),advance=vm.runInContext('anatomyAdvance',ctx);
(async()=>{let rows=0;for await(const line of readline.createInterface({input:fs.createReadStream(vectors),crlfDelay:Infinity})){
 const [mode,q,limit,enable,reset,inc,terminal,d,next]=line.split(' ').map(Number);
 if(mode===0)state.rasterQ=q;else if(state.rasterQ!==q)throw Error('trajectory old Q '+rows);
 Object.assign(state,{rasterLimit:limit,rasterEnable:enable,rasterReset:reset});const p=plan(state);
 if(p.increment!==inc||p.terminal!==terminal||p.d!==d||p.next!==next)throw Error('candidate '+rows);
 advance('rastercounter',state);if(state.rasterQ!==next||state.rasterLast.before!==q||state.rasterLast.d!==d||state.rasterLast.after!==next||state.rasterLast.enable!==enable||state.rasterLast.reset!==reset)throw Error('captured '+rows);
 rows++;
}console.log(JSON.stringify({status:'passed',vectors:rows,checksPerVector:10}));})().catch(e=>{console.error(e);process.exitCode=1});
