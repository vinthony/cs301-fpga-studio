const fs=require('fs'),vm=require('vm'),assert=require('assert'),c=vm.createContext({});vm.runInContext(fs.readFileSync(__dirname+'/../anatomy-learning.js','utf8'),c);let checks=0,seed=301;
for(let table=0;table<32;table++){
 const bits=Array.from({length:64},()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed>>>31});
 for(let addr=0;addr<64;addr++){
  const rows=vm.runInContext(`anatomyLUTSelectionStages({lut:${JSON.stringify(bits)},lutAddr:${addr}})`,c);
  for(let level=0;level<6;level++){
   const r=rows[level];assert.equal(r.a,bits[addr&~(1<<level)]);assert.equal(r.b,bits[addr|(1<<level)]);assert.equal(r.out,bits[addr]);assert.equal(r.node,addr>>>(level+1));assert.equal(r.count,32>>>level);checks+=5;
  }
 }
}
console.log(JSON.stringify({status:'passed',checks}));
