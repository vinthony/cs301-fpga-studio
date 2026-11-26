const fs=require('fs'),vm=require('vm'),assert=require('assert'),c=vm.createContext({});
for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-learning.js'])vm.runInContext(fs.readFileSync(__dirname+'/../'+f,'utf8'),c);
let checks=0;
for(let d=0;d<16;d++)for(let q=0;q<16;q++)for(let en=0;en<2;en++)for(let rst=0;rst<2;rst++){
 const result=vm.runInContext(`(()=>{const s=anatomyState();Object.assign(s,{av:${d},q:${q},enable:${en},reset:${rst}});const next=anatomyRegisterCandidate(s);anatomyAdvance('register',s);return [next,s.q]})()`,c),expected=rst?0:en?d:q;
 assert.deepEqual(Array.from(result),[expected,expected]);checks+=2;
}
console.log(JSON.stringify({status:'passed',checks}));
