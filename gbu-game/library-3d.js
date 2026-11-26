import * as THREE from 'three';
import {OrbitControls} from '../vendor/three/examples/jsm/controls/OrbitControls.js';
import {avatarPose,screenToWorld} from './avatar-motion.js';

// An interpreted walkable corridor based on one public campus photograph.
// Its building identity, floor plan and exact dimensions remain unverified.
export function createLibrary3d(host,onNear){
 const renderer=new THREE.WebGLRenderer({antialias:true});renderer.setPixelRatio(Math.min(devicePixelRatio,1.5));renderer.outputColorSpace=THREE.SRGBColorSpace;renderer.shadowMap.enabled=true;host.appendChild(renderer.domElement);
 const scene=new THREE.Scene();scene.background=new THREE.Color(0xc6d8ca);const camera=new THREE.OrthographicCamera(-11,11,8,-8,.1,100);camera.position.set(-11,16,22);
 const orbit=new OrbitControls(camera,renderer.domElement);orbit.target.set(0,0,0);orbit.enableDamping=true;orbit.enablePan=false;orbit.minPolarAngle=.48;orbit.maxPolarAngle=1.08;orbit.minZoom=.85;orbit.maxZoom=2.5;orbit.update();
 scene.add(new THREE.HemisphereLight(0xfff7e3,0x7b8d7d,2.2));const sun=new THREE.DirectionalLight(0xffedd2,2);sun.position.set(-7,17,6);sun.castShadow=true;sun.shadow.mapSize.set(1024,1024);Object.assign(sun.shadow.camera,{left:-12,right:12,top:12,bottom:-12});scene.add(sun);
 const mat=(color,extra={})=>new THREE.MeshStandardMaterial({color,roughness:.85,...extra});const white=mat(0xf3f2e7),floor=mat(0xd0d7d0),wall=mat(0xe3e7db),wood=mat(0xb4885e),dark=mat(0x425753),green=mat(0x94bb93),glass=mat(0xb4dcd3,{transparent:true,opacity:.5});
 function box(x,y,z,w,h,d,m){let o=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),m);o.position.set(x,y,z);o.castShadow=true;o.receiveShadow=true;scene.add(o);return o}
 box(0,-.12,0,8.6,.24,17,floor);for(let z=-8;z<=8;z+=1.1)box(0,.01,z,8.5,.015,.012,white);
 // Cutaway shell keeps the shelves, windows and the player visible from above.
 box(-4.2,2.5,0,.20,5,17,mat(0xe3e7db,{transparent:true,opacity:.30,depthWrite:false}));box(0,2.5,-8.4,8.5,5,.2,wall);box(0,2.55,-8.27,6.7,3.55,.08,glass);
 for(let x of [-3.3,0,3.3])box(x,2.55,-8.2,.14,3.7,.14,dark);box(0,2.5,-8.17,6.7,.12,.12,dark);
 for(let x of [-2.6,-1.3,0,1.3,2.6]){box(x,.25,-9.2,1.2,.5,.5,green);box(x,1.35,-9.4,.9,1.7,.15,green)}
 // Wooden world-map puzzle, an illustration of the photographed wall piece.
 // The outlines and puzzle seams are stylised, not a transcription of labels.
 function worldPuzzle(){let c=document.createElement('canvas');c.width=768;c.height=400;let a=c.getContext('2d');const continents=[
  [[42,84],[92,47],[143,49],[163,69],[191,66],[210,93],[197,114],[165,118],[161,146],[136,161],[125,188],[101,181],[86,155],[61,145],[35,118]],
  [[145,176],[182,180],[211,201],[210,232],[192,257],[185,292],[169,330],[150,309],[144,275],[132,248],[137,219]],
  [[216,47],[243,27],[275,31],[287,57],[269,79],[240,84],[225,70]],
  [[303,93],[327,72],[350,79],[365,67],[389,79],[409,72],[428,81],[458,74],[488,66],[523,79],[558,74],[587,91],[625,93],[651,111],[633,134],[596,135],[572,154],[547,151],[526,171],[510,163],[497,190],[475,172],[447,155],[429,154],[406,133],[385,131],[365,148],[347,139],[326,143],[312,124]],
  [[333,153],[365,148],[391,160],[414,184],[406,215],[389,228],[382,265],[359,285],[343,268],[332,235],[316,213],[319,180]],
  [[548,240],[582,227],[618,235],[641,255],[634,278],[607,287],[575,279],[552,267]],
  [[500,180],[516,192],[518,213],[509,223],[499,208]],[[651,284],[660,291],[657,311],[648,309]]];
  a.beginPath();for(const poly of continents){poly.forEach(([x,y],i)=>i?a.lineTo(x,y):a.moveTo(x,y));a.closePath()}a.save();a.shadowColor='rgba(80,53,31,.45)';a.shadowOffsetX=4;a.shadowOffsetY=5;a.shadowBlur=2;a.fillStyle='#b78957';a.fill();a.restore();a.save();a.clip();a.fillStyle='#c99a64';a.fillRect(0,0,768,400);a.strokeStyle='#89603d';a.lineWidth=3;
  for(let x=56;x<740;x+=56){a.beginPath();a.moveTo(x,0);for(let y=0;y<400;y+=50){a.lineTo(x,y+15);a.bezierCurveTo(x-12,y+12,x-12,y+31,x,y+29);a.lineTo(x,y+50)}a.stroke()}
  for(let y=50;y<390;y+=50){a.beginPath();a.moveTo(0,y);for(let x=0;x<768;x+=56){a.lineTo(x+19,y);a.bezierCurveTo(x+16,y-10,x+34,y-10,x+32,y);a.lineTo(x+56,y)}a.stroke()}a.restore();
  let texture=new THREE.CanvasTexture(c);texture.colorSpace=THREE.SRGBColorSpace;const mesh=new THREE.Mesh(new THREE.PlaneGeometry(5.4,2.8),new THREE.MeshBasicMaterial({map:texture,transparent:true,alphaTest:.02,side:THREE.DoubleSide,depthWrite:false}));mesh.rotation.y=-Math.PI/2;mesh.position.set(-4.035,2.55,-1.5);scene.add(mesh)}worldPuzzle();
 // Long white shelving with individually coloured book spines and wooden cap.
 box(3.55,2.05,-.1,.95,3.7,14.8,white);box(3.50,3.95,-.1,1.15,.16,15,wood);box(3.49,.18,-.1,1.13,.15,15,wood);
 for(let z=-7.1;z<=7;z+=1.4){box(3.03,2.05,z,.08,3.72,.08,white)}for(let y of [.65,1.27,1.89,2.51,3.13,3.75])box(3.04,y,-.1,.10,.07,14.8,white);
 const palette=[0x718f83,0xd08a6a,0xe3c477,0x54798a,0xd6d0b1,0x8a7b9a];let colors=palette.map(c=>mat(c));let geo=new THREE.BoxGeometry(1,1,1),holder=new THREE.Object3D();for(let c=0;c<colors.length;c++){let entries=[];for(let row=0;row<5;row++)for(let j=0;j<85;j++)if((j+row*3)%colors.length===c)entries.push([2.99,.92+row*.62,-7.08+j*.165,.12,.38+(j%3)*.045,.12]);let mesh=new THREE.InstancedMesh(geo,colors[c],entries.length);entries.forEach(([x,y,z,w,h,d],i)=>{holder.position.set(x,y,z);holder.scale.set(w,h,d);holder.updateMatrix();mesh.setMatrixAt(i,holder.matrix)});mesh.instanceMatrix.needsUpdate=true;scene.add(mesh)}
 // Window counter and stools are taken from the far end of the photograph.
 box(0,.95,-7.22,5,.12,.72,wood);for(let x of [-1.7,0,1.7]){box(x,.52,-6.45,.55,.1,.55,wood);for(let dx of [-.19,.19])box(x+dx,.26,-6.45,.06,.52,.06,wood)}
 const tex=new THREE.TextureLoader().load('assets/student-walk-atlas.png');tex.colorSpace=THREE.SRGBColorSpace;tex.magFilter=THREE.NearestFilter;tex.minFilter=THREE.NearestFilter;tex.repeat.set(.25,.25);tex.offset.set(.25,.75);const player=new THREE.Sprite(new THREE.SpriteMaterial({map:tex,transparent:true,alphaTest:.08}));player.scale.set(1.6,1.6,1);scene.add(player);
 let enabled=false,near=null,previous='',walk=0,face=3,last=performance.now(),pos={x:0,z:7};const keys=new Set(),valid=new Set(['w','a','s','d','arrowup','arrowdown','arrowleft','arrowright']);
 function open(x,z){return x>-3.55&&x<2.5&&z>-6.15&&z<7.8}
 function nearest(){if(pos.z>6.2)return 'exit';if(pos.z< -5.1)return 'table';if(pos.x>1.45)return 'shelf';if(pos.x< -2.0&&pos.z>-4.4&&pos.z<1.6)return 'map';return null}
 window.addEventListener('keydown',e=>{if(enabled&&valid.has(e.key.toLowerCase())){keys.add(e.key.toLowerCase());e.preventDefault()}});window.addEventListener('keyup',e=>keys.delete(e.key.toLowerCase()));window.addEventListener('blur',()=>keys.clear());
 const dirs={up:'w',down:'s',left:'a',right:'d'};document.querySelectorAll('[data-move]').forEach(b=>{let k=dirs[b.dataset.move];b.addEventListener('pointerdown',e=>{if(enabled){e.preventDefault();keys.add(k);b.setPointerCapture(e.pointerId)}});['pointerup','pointercancel','lostpointercapture'].forEach(t=>b.addEventListener(t,()=>keys.delete(k)))});
 function resize(){let w=host.clientWidth,h=host.clientHeight;if(!w||!h)return;renderer.setSize(w,h,false);let aspect=w/h,half=aspect<1?12:9;camera.left=-half*aspect;camera.right=half*aspect;camera.top=half;camera.bottom=-half;camera.updateProjectionMatrix()}new ResizeObserver(resize).observe(host);resize();
 function frame(now){requestAnimationFrame(frame);let dt=Math.min(.05,(now-last)/1000);last=now;if(!enabled)return;let h=(keys.has('d')||keys.has('arrowright')?1:0)-(keys.has('a')||keys.has('arrowleft')?1:0),v=(keys.has('s')||keys.has('arrowdown')?1:0)-(keys.has('w')||keys.has('arrowup')?1:0),e=camera.matrixWorld.elements,d=screenToWorld(h,v,e[0],e[2],e[8],e[10]),n=Math.hypot(d.x,d.z);if(n){let x=pos.x+d.x/n*dt*3.2,z=pos.z+d.z/n*dt*3.2,old={...pos};if(open(x,pos.z))pos.x=x;if(open(pos.x,z))pos.z=z;if(Math.hypot(pos.x-old.x,pos.z-old.z)>.001){walk+=dt*10;let pose=avatarPose(pos.x-old.x,pos.z-old.z,e[0],e[2],e[8],e[10],walk);face=pose.facing;tex.offset.set(pose.frame/4,(3-face)/4)}}else tex.offset.set(.25,(3-face)/4);player.position.set(pos.x,.85,pos.z);near=nearest();if(near!==previous){previous=near;onNear(near)}orbit.update();renderer.render(scene,camera)}requestAnimationFrame(frame);
 return {setEnabled(v){enabled=v;if(!v)keys.clear();else resize()},getNear(){return near},reset(){pos={x:0,z:7};near=null;previous=''}};
}
