const fs=require('fs'),vm=require('vm'),readline=require('readline'),path=require('path');
const [root,vectors]=process.argv.slice(2);if(!root||!vectors)throw Error('node compare_web.cjs APP_DIRECTORY VECTORS_FILE');
const ctx=vm.createContext({});for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js'])vm.runInContext(fs.readFileSync(path.join(root,f),'utf8'),ctx);
const state=vm.runInContext('anatomyState()',ctx),plan=vm.runInContext('anatomyVGAPlan',ctx),advance=vm.runInContext('anatomyVGAAdvance',ctx);state.vgaSource='uniform';
(async()=>{let vectorsChecked=0,advanced=0,resetInitializations=0;for await(const line of readline.createInterface({input:fs.createReadStream(vectors),crlfDelay:Infinity})){
 const [mode,x,y,enable,reset,color,active,hs,vs,address,rgb,lineEnable,nx,ny]=line.split(' ').map(Number),index=y*800+x;
 if(mode===0)state.pixel=index;else if(state.pixel!==index)throw Error('trajectory '+vectorsChecked);
 state.rgb=color;state.vgaCountEnable=enable;const p=plan(state);
 if(p.x!==x||p.y!==y||p.active!==active||p.hs!==hs||p.vs!==vs||p.address!==(active?address:null)||p.rgb!==rgb||+(enable&&x===799)!==lineEnable)throw Error('request '+vectorsChecked);
 // The web UI has initialization, not a synchronous-reset port. Do not claim
 // it tested hardware reset: reset vectors initialize the next source state.
 if(reset){state.pixel=0;resetInitializations++;}else{advance(state);advanced++;if(state.pixel!==ny*800+nx)throw Error('edge '+vectorsChecked)}
 vectorsChecked++;
}console.log(JSON.stringify({status:'passed',requestVectors:vectorsChecked,realWebAdvanceEdges:advanced,resetInitializations,requestChecksPerVector:8,boundary:'Hardware reset not compared to a nonexistent web reset port. Reset vectors initialize the following source coordinate.'}));})().catch(e=>{console.error(e);process.exitCode=1});
