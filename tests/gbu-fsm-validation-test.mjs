import assert from 'node:assert/strict';
import fs from 'node:fs';
const source=fs.readFileSync(new URL('../gbu-game/game.js',import.meta.url),'utf8');
const fn=source.slice(source.indexOf('async function validateFSM()'),source.indexOf('async function validateCPU()'));
const make=new Function('simulate','$','feedback',`
 const header='';let campusFSMRows=[];
 function number(bits){return typeof bits==='string'&&/^[01]+$/.test(bits)?parseInt(bits,2):null}
 ${fn}
 return {validateFSM,get rows(){return campusFSMRows}};
`);
const next=[[0,1],[2,1],[0,1]],signals={};
for(let s=0;s<3;s++)for(let b=0;b<2;b++){signals[`s${s}b${b}`]={value:String(next[s][b])};signals[`a${s}b${b}`]={checked:s===2&&b===1}}
let missing=false,unknownState=false;
async function simulate(_code,events){let state=0;return events.map((event,i)=>{if(missing&&i===2)return {};let alarm=0;if(i){let bit=event.sw;alarm=state===2&&bit===1?1:0;state=next[state][bit]}return {led:alarm.toString(2),display:unknownState&&i===2?'xx':state.toString(2)}})}
let messages=[];const c=make(simulate,id=>signals[id],message=>messages.push(message));
assert.equal(await c.validateFSM(),true);assert.deepEqual(c.rows.map(({input,state,alarm})=>[input,state,alarm]),[[1,1,0],[0,2,0],[1,1,1],[0,2,0],[1,1,1]]);
unknownState=true;assert.equal(await c.validateFSM(),true);assert.equal(c.rows[1].state,null);assert.equal(c.rows[2].before,null);
missing=true;assert.equal(await c.validateFSM(),false);assert.equal(c.rows.length,0);assert.match(messages.at(-1),/未知/);
console.log('PASS: FSM replay uses sampled post-edge state and rejects missing alarm data');
