const fs=require('fs'),vm=require('vm'),readline=require('readline'),path=require('path');
const [root,vectors,bits]=process.argv.slice(2);if(!root||!vectors||!bits)throw Error('node compare_web.cjs APP_DIRECTORY WORD_VECTORS BIT_VECTORS');
const ctx=vm.createContext({});for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js'])vm.runInContext(fs.readFileSync(path.join(root,f),'utf8'),ctx);
const state=vm.runInContext('anatomyState()',ctx),plan=vm.runInContext('anatomyCompare10Plan',ctx),one=vm.runInContext('anatomyCompareBitPlan',ctx);
(async()=>{let pairs=0,bitCases=0;for await(const line of readline.createInterface({input:fs.createReadStream(vectors),crlfDelay:Infinity})){
 const [a,b,eq,lt,emask,lmask]=line.split(' ').map(Number);state.cmp10A=a;state.cmp10B=b;const p=plan(state);let em=1<<10,lm=0;for(const row of p.rows){em|=row.eq<<row.bit;lm|=row.lt<<row.bit}
 if(p.eq!==eq||p.lt!==lt||em!==emask||lm!==lmask)throw Error('prefix mismatch '+pairs);pairs++;
}for await(const line of readline.createInterface({input:fs.createReadStream(bits),crlfDelay:Infinity})){
 const [a,b,e,l,eq,lt]=line.split(' ').map(Number);Object.assign(state,{cmpBitA:a,cmpBitB:b,cmpPrefixEq:e,cmpPrefixLt:l});const p=one(state);if(p.eq!==eq||p.lt!==lt)throw Error('single bit '+bitCases);bitCases++;
}console.log(JSON.stringify({status:'passed',allWordPairs:pairs,singleBitCases:bitCases,comparedBitsPerWordPair:24}));})().catch(e=>{console.error(e);process.exitCode=1});
