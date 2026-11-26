import assert from 'node:assert/strict';
import fs from 'node:fs';
let source=fs.readFileSync(new URL('../gbu-game/game.js',import.meta.url),'utf8');
let section=source.slice(source.indexOf('function start(){'),source.indexOf("$('viewToggle').onclick="));
assert.ok(section.includes("switchView('three')"),'start uses 3D');
function setup(failThree){let elements=new Map(),messages=[], calls=[];
 const $=id=>{if(!elements.has(id))elements.set(id,{hidden:false,textContent:''});return elements.get(id)};
 let progress=0,attempts=[],discovered,world,worlds={},viewMode='three';
 const fake=(name)=>({setEnabled(){},setProgress(){},getNear(){return null},name});
 const createWorld=()=>{calls.push('three');if(failThree)throw Error('no WebGL');return fake('three')};
 const createPixelWorld=()=>{calls.push('pixel');return fake('pixel')};
 const readSave=()=>null,nearChanged=()=>{},renderMap=()=>{},checkServer=()=>{},showToast=m=>messages.push(m);
 eval(section+'; start();');
 return {elements,messages,calls,viewMode,world};
}
let normal=setup(false);assert.deepEqual(normal.calls,['three']);assert.equal(normal.viewMode,'three');assert.equal(normal.elements.get('viewToggle').textContent,'切换像素游览');
let fallback=setup(true);assert.deepEqual(fallback.calls,['three','pixel']);assert.equal(fallback.viewMode,'pixel');assert.equal(fallback.world.name,'pixel');assert.ok(fallback.messages.at(-1).includes('3D 校园无法启动'));
console.log('PASS: 3D default, WebGL failure falls back to pixel with notice');
