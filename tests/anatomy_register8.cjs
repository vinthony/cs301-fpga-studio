const fs=require('fs'),vm=require('vm'),assert=require('assert'),c=vm.createContext({});
for(const f of ['architecture.js','anatomy-catalog.js','anatomy-model.js','anatomy-experiments.js','anatomy-learning.js'])vm.runInContext(fs.readFileSync(__dirname+'/../'+f,'utf8'),c);
let checks=0;
for(let d=0;d<256;d++)for(const q of [0,1,85,128,170,255])for(let en=0;en<2;en++)for(let rst=0;rst<2;rst++){
const actual=vm.runInContext(`(()=>{const s=anatomyState();Object.assign(s,{av:${d},reg8Q:${q},enable:${en},reset:${rst}});const before=s.reg8Q,next=anatomyRegister8Next(s),e=anatomyEvaluate('register8',s);let candidate=0;for(let i=0;i<8;i++){if(e.nets['CE'+i]!==s.enable||e.nets['RESET'+i]!==s.reset)throw Error('control fanout');candidate|=e.nets['候选'+i]<<i}anatomyAdvance('register8',s);return [before,next,s.reg8Q,candidate]})()`,c);
assert.deepEqual(Array.from(actual),[q,rst?0:en?d:q,rst?0:en?d:q,rst?0:en?d:q]);checks++;
}
console.log(JSON.stringify({status:'passed',checks}));
