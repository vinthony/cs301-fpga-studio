import assert from 'node:assert/strict';
import fs from 'node:fs';
// Browser-free model test: synthetic frame clock exercises the real canvas
// controller, routing, depth masks and four-direction atlas selection.
const handlers=new Map(),draws=[];let queued=null,clips=0;
globalThis.window={addEventListener(type,fn){let a=handlers.get(type)||[];a.push(fn);handlers.set(type,a)},dispatchEvent(e){for(const fn of handlers.get(e.type)||[])fn(e)}};
globalThis.CustomEvent=class{constructor(type,options){this.type=type;this.detail=options.detail}};
globalThis.requestAnimationFrame=fn=>{queued=fn;return 1};
globalThis.ResizeObserver=class{constructor(cb){this.cb=cb}observe(){this.cb()}};
globalThis.Image=class{constructor(){this.complete=true}set src(v){this._src=v;this.naturalWidth=v.includes('student-walk')?1261:1733;this.naturalHeight=v.includes('student-walk')?1247:907}get src(){return this._src}};
const noop=()=>{};let playerDrawn=false;let ctx={clearRect(){playerDrawn=false},fillRect:noop,strokeRect:noop,stroke:noop,save:noop,restore:noop,translate:noop,transform:noop,scale:noop,beginPath:noop,ellipse:noop,fill:noop,moveTo:noop,lineTo:noop,closePath:noop,clip(){if(playerDrawn)clips++},drawImage(...a){if(a[0]._src?.includes('student-walk')){draws.push(a);playerDrawn=true}}};
let canvas={setAttribute:noop,getContext:()=>ctx};globalThis.document={createElement:()=>canvas,querySelectorAll:()=>[]};
let host={clientWidth:1200,clientHeight:800,appendChild:noop};let source=fs.readFileSync(new URL('../gbu-game/pixel-world.js',import.meta.url),'utf8');let {createPixelWorld}=await import('data:text/javascript;base64,'+Buffer.from(source).toString('base64'));
let near=[];let world=createPixelWorld(host,i=>near.push(i));let now=performance.now();function frames(n){for(let i=0;i<n;i++){assert.ok(queued,'animation frame scheduled');let f=queued;queued=null;now+=16;f(now)}}
function key(type,k){for(let fn of handlers.get(type)||[])fn({key:k,preventDefault:noop})}
frames(3);assert.equal(world.getNear(),0,'initial position near gate');assert.ok(draws.length>0,'animated atlas rendered');
key('keydown','a');frames(10);key('keyup','a');assert.ok(clips>0,'tree canopy occludes a character behind it');assert.equal(draws.at(-1)[2],1247/4,'left-facing atlas row');
key('keydown','d');frames(12);key('keyup','d');let right=draws.at(-1);assert.equal(right[2],2*(1247/4),'right-facing atlas row');
key('keydown','w');frames(12);key('keyup','w');let up=draws.at(-1);assert.equal(up[2],3*(1247/4),'up-facing atlas row');
key('keydown','s');frames(8);key('keyup','s');assert.equal(draws.at(-1)[2],0,'down-facing atlas row');
world.goTo(1);frames(600);assert.equal(world.getNear(),1,'auto route reaches library around obstacles');
world.goTo(2);frames(1400);assert.equal(world.getNear(),2,'auto route reaches teaching building');
world.goTo(3);frames(2000);assert.equal(world.getNear(),3,'auto route reaches research building');
let reached=-1;window.addEventListener('campus-landmark',e=>reached=e.detail.index);
const destinations=[[-7,13],[-22,11],[0,3.5],[-3,1.5],[3,-3.5],[7,-4],[8,9],[-24,-3.8],[-20,-1.5],[-12,-5],[-25,-10.2],[-20,-11],[18,-3],[12,7.3],[19,6.8],[23,3.4],[-12.2,3]];
for(const [index,[x,z]] of destinations.entries()){
 reached=-1;assert.ok(world.goToPosition(x,z),`route exists for landmark ${index}`);frames(2500);
 assert.equal(reached,index,`route reaches landmark ${index}`);
}
for(let i=0;i<destinations.length;i++){assert.ok(world.setLandmark(i),`transfer to landmark ${i}`);assert.equal(world.getLandmark(),i,`transfer keeps landmark ${i}`)}
world.setEnabled(false);let old=world.getNear();key('keydown','d');frames(100);assert.equal(world.getNear(),old,'controls disabled while dialog is open');
console.log('PASS: atlas render/directions, tree depth, four challenges, 17 landmark routes, modal input lock');
