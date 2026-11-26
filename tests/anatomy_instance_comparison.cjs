const fs=require('fs'),vm=require('vm'),assert=require('assert');const c=vm.createContext({});vm.runInContext(fs.readFileSync(__dirname+'/../anatomy-learning.js','utf8'),c);let checks=0;
for(let a=0;a<16;a++)for(let b=0;b<16;b++)for(let bit=0;bit<4;bit++){
 const actual=vm.runInContext(`anatomyAdderInstanceInputs({av:${a},bv:${b}},${bit})`,c),mask=(1<<bit)-1;
 assert.deepEqual(Array.from(actual),[(a>>>bit)&1,(b>>>bit)&1,((a&mask)+(b&mask))>>>bit]);checks++;
}
console.log(JSON.stringify({status:'passed',checks}));
