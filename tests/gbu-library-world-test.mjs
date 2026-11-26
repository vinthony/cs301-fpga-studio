import assert from 'node:assert/strict';
import fs from 'node:fs';
const handlers=new Map(),rendered=[];let queued=null;
globalThis.window={addEventListener(type,fn){let a=handlers.get(type)||[];a.push(fn);handlers.set(type,a)}};
globalThis.requestAnimationFrame=fn=>{queued=fn;return 1};globalThis.ResizeObserver=class{constructor(fn){this.fn=fn}observe(){this.fn()}};
globalThis.Image=class{constructor(){this.complete=true}set src(v){this._src=v;this.naturalWidth=v.includes('atlas')?1261:1536;this.naturalHeight=v.includes('atlas')?1247:1024}};
const n=()=>{};let ctx={clearRect:n,fillRect:n,save:n,restore:n,translate:n,scale:n,beginPath:n,ellipse:n,fill:n,drawImage(...a){rendered.push(a[0]._src)}};
let canvas={setAttribute:n,getContext:()=>ctx};globalThis.document={createElement:()=>canvas,querySelectorAll:()=>[]};
let host={clientWidth:1200,clientHeight:800,appendChild:n};let src=fs.readFileSync(new URL('../gbu-game/library-world.js',import.meta.url),'utf8');let {createLibraryWorld}=await import('data:text/javascript;base64,'+Buffer.from(src).toString('base64'));
let room=createLibraryWorld(host,()=>{}),now=performance.now();function frames(n){for(let i=0;i<n;i++){assert.ok(queued);let fn=queued;queued=null;now+=16;fn(now)}}function key(type,key){for(let fn of handlers.get(type)||[])fn({key,preventDefault:n})}
room.setEnabled(true);frames(3);assert.equal(room.getNear(),'exit');assert.ok(rendered.some(x=>x?.includes('library-room.png')));
key('keydown','w');frames(110);key('keyup','w');assert.equal(room.getNear(),'table','walk to reading table');
key('keydown','s');frames(38);key('keyup','s');key('keydown','d');frames(54);key('keyup','d');assert.equal(room.getNear(),'shelf','walk to bookshelf');
room.setEnabled(false);let old=room.getNear();key('keydown','a');frames(60);assert.equal(room.getNear(),old,'modal input lock');room.reset();room.setEnabled(true);frames(2);assert.equal(room.getNear(),'exit','reset restores entry');
console.log('PASS: room render, entrance, reading table, bookshelf, input lock, reset');
