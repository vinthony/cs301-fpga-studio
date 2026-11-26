import assert from 'node:assert/strict';
import fs from 'node:fs';

// Exercise the real challenge controller with observed simulator responses,
// including a wrong answer and a missing/unknown output.
const source=fs.readFileSync(new URL('../gbu-game/game.js',import.meta.url),'utf8');
const fn=source.slice(source.indexOf('async function validateBridge()'),source.indexOf('async function validateFSM()'));
const make=new Function('simulate','feedback','drawChallenge',`
 const pairs=[[3,6],[7,9],[15,15]],adder='test';
 let bridgeRound=0,answerBits=0,campusBridgeRows=[];
 function number(bits){return typeof bits==='string'&&/^[01]+$/.test(bits)?parseInt(bits,2):null}
 ${fn}
 return {validateBridge,setAnswer(n){answerBits=n},get rows(){return campusBridgeRows},get round(){return bridgeRound}};
`);
let sample=[],messages=[];
const controller=make(async()=>sample,m=>messages.push(m),()=>{});
controller.setAnswer(9);sample=[];assert.equal(await controller.validateBridge(),false);assert.equal(controller.round,0);assert.match(messages.at(-1),/未知/);assert.equal(controller.rows.length,0);
sample=[{led:'0000000000001001'}];controller.setAnswer(8);assert.equal(await controller.validateBridge(),false);assert.equal(controller.rows.length,0);
for(const [answer,bits] of [[9,'0000000000001001'],[16,'0000000000010000'],[30,'0000000000011110']]){controller.setAnswer(answer);sample=[{led:bits}];assert.equal(await controller.validateBridge(),answer===30)}
assert.deepEqual(controller.rows,[{a:3,b:6,actual:9},{a:7,b:9,actual:16},{a:15,b:15,actual:30}]);
console.log('PASS: adder replay keeps actual samples and rejects wrong or missing outputs');
