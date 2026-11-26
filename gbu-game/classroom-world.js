import * as THREE from 'three';
import {OrbitControls} from '../vendor/three/examples/jsm/controls/OrbitControls.js';
import {avatarPose,screenToWorld} from './avatar-motion.js';

// Based on one captioned Songshan Lake classroom photograph. Furniture layout,
// room number, dimensions and the cutaway walls are interpretive.
export function createClassroomWorld(host,onNear){
 const renderer=new THREE.WebGLRenderer({antialias:true});renderer.setPixelRatio(Math.min(devicePixelRatio,1.5));renderer.outputColorSpace=THREE.SRGBColorSpace;renderer.shadowMap.enabled=true;host.appendChild(renderer.domElement);
 const scene=new THREE.Scene();scene.background=new THREE.Color(0xc8d7ce);
 const camera=new THREE.OrthographicCamera(-10,10,7,-7,.1,100);camera.position.set(0,16,18);
 const orbit=new OrbitControls(camera,renderer.domElement);orbit.target.set(0,0,-1);orbit.enablePan=false;orbit.enableDamping=true;orbit.minPolarAngle=.5;orbit.maxPolarAngle=1.1;orbit.minZoom=.8;orbit.maxZoom=2.3;orbit.update();
 scene.add(new THREE.HemisphereLight(0xfff4df,0x7c9288,2));const sun=new THREE.DirectionalLight(0xffe9ca,2);sun.position.set(-8,16,10);sun.castShadow=true;scene.add(sun);
 const mat=c=>new THREE.MeshStandardMaterial({color:c,roughness:.88});const white=mat(0xf2f0e8),orange=mat(0xda872d),floor=mat(0x858d89),floorLine=mat(0x737d79),dark=mat(0x384b4b),metal=mat(0x68716b),wood=mat(0xb99368),yellow=mat(0xc9aa56),board=mat(0x3a655b),glass=new THREE.MeshStandardMaterial({color:0xa8c9be,transparent:true,opacity:.5});
 function box(x,y,z,w,h,d,m,parent=scene){let o=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),m);o.position.set(x,y,z);o.castShadow=true;o.receiveShadow=true;parent.add(o);return o}
 box(0,-.12,0,12,.24,12,floor);for(let x=-5.7;x<5.8;x+=.45)box(x,.01,0,.014,.012,11.9,floorLine);
 // Whiteboard on an orange wall, dark-framed windows, and green teaching board.
 // Hide only walls between the camera and the player, keeping the room
 // readable while orbiting without changing its collision footprint.
 const frontWall=new THREE.Group(),rightWall=new THREE.Group(),leftWall=new THREE.Group();scene.add(frontWall,rightWall,leftWall);
 box(0,2.15,-5.9,12,4.3,.18,orange,frontWall);box(-3.1,2.2,-5.77,4.1,1.55,.08,white,frontWall);box(-3.1,1.39,-5.71,4.25,.06,.10,metal,frontWall);
 box(5.9,2.15,0,.16,4.3,12,glass,rightWall);box(5.78,2.3,-2.8,.08,2.2,4.5,board,rightWall);box(5.72,1.16,-2.8,.13,.10,4.6,wood,rightWall);
 box(-5.9,2.1,0,.16,4.2,11.8,white,leftWall);for(let z of [-4,-2,0,2,4]){box(-5.78,2.25,z,.06,3.15,1.66,glass,leftWall);for(let dz of [-.82,.82])box(-5.71,2.25,z+dz,.12,3.2,.10,dark,leftWall);box(-5.70,1.15,z,.12,.10,1.75,dark,leftWall)}
 // Separate desks and chairs are stylised from the visible photo. Rectangular
 // obstacle extents below keep the player in the aisles between them.
 const desks=[];for(let x of [-2.2,2.2])for(let z of [-2.8,-.8,1.2,3.2]){desks.push({x,z,w:2.45,d:1.45});box(x,.92,z,2.35,.12,.72,white);for(let dx of [-1.02,1.02])for(let dz of [-.25,.25])box(x+dx,.46,z+dz,.07,.88,.07,metal);for(let dx of [-.58,.58]){box(x+dx,.49,z+.72,.62,.1,.55,yellow);box(x+dx,.78,z+1.00,.62,.60,.09,white);for(let sx of [-.24,.24])box(x+dx+sx,.24,z+.72,.05,.48,.05,metal)}}
 // A light lectern and a dark freestanding presentation display.
 box(3.45,.52,-4.65,1.15,1.0,.68,white);box(3.45,1.06,-4.65,1.25,.12,.78,wood);box(4.65,1.45,-4.74,1.15,1.18,.10,dark);box(4.65,.58,-4.74,.08,1.05,.08,metal);
 const tex=new THREE.TextureLoader().load('assets/student-walk-atlas.png');tex.colorSpace=THREE.SRGBColorSpace;tex.magFilter=THREE.NearestFilter;tex.minFilter=THREE.NearestFilter;tex.repeat.set(.25,.25);tex.offset.set(.25,.75);const player=new THREE.Sprite(new THREE.SpriteMaterial({map:tex,transparent:true,alphaTest:.08}));player.scale.set(1.6,1.6,1);scene.add(player);
 let enabled=false,pos={x:0,z:5.2},near=null,previous='',walk=0,face=3,last=performance.now();const keys=new Set(),valid=new Set(['w','a','s','d','arrowup','arrowdown','arrowleft','arrowright']);
 function open(x,z){return x>-5.4&&x<5.4&&z>-5.3&&z<5.65&&!desks.some(q=>Math.abs(x-q.x)<q.w/2+.2&&Math.abs(z-q.z-.30)<q.d/2+.2)&&!(x>2.6&&z< -4.05)}
 function nearest(){if(pos.z>4.9)return 'exit';if(pos.z< -4.3)return 'board';if(desks.some(q=>Math.abs(pos.x-q.x)<q.w/2+.65&&Math.abs(pos.z-q.z-.3)<q.d/2+.65))return 'desk';return null}
 window.addEventListener('keydown',e=>{if(enabled&&valid.has(e.key.toLowerCase())){keys.add(e.key.toLowerCase());e.preventDefault()}});window.addEventListener('keyup',e=>keys.delete(e.key.toLowerCase()));window.addEventListener('blur',()=>keys.clear());const dirs={up:'w',down:'s',left:'a',right:'d'};document.querySelectorAll('[data-move]').forEach(b=>{let k=dirs[b.dataset.move];b.addEventListener('pointerdown',e=>{if(enabled){e.preventDefault();keys.add(k);b.setPointerCapture(e.pointerId)}});['pointerup','pointercancel','lostpointercapture'].forEach(t=>b.addEventListener(t,()=>keys.delete(k)))});
 function resize(){let w=host.clientWidth,h=host.clientHeight;if(!w||!h)return;renderer.setSize(w,h,false);let a=w/h,half=a<1?10:8;camera.left=-half*a;camera.right=half*a;camera.top=half;camera.bottom=-half;camera.updateProjectionMatrix()}new ResizeObserver(resize).observe(host);resize();
 function frame(now){requestAnimationFrame(frame);let dt=Math.min(.05,(now-last)/1000);last=now;if(!enabled)return;let h=(keys.has('d')||keys.has('arrowright')?1:0)-(keys.has('a')||keys.has('arrowleft')?1:0),v=(keys.has('s')||keys.has('arrowdown')?1:0)-(keys.has('w')||keys.has('arrowup')?1:0),e=camera.matrixWorld.elements,d=screenToWorld(h,v,e[0],e[2],e[8],e[10]),n=Math.hypot(d.x,d.z);if(n){let x=pos.x+d.x/n*dt*3.2,z=pos.z+d.z/n*dt*3.2,old={...pos};if(open(x,pos.z))pos.x=x;if(open(pos.x,z))pos.z=z;if(Math.hypot(pos.x-old.x,pos.z-old.z)>.001){walk+=dt*10;let pose=avatarPose(pos.x-old.x,pos.z-old.z,e[0],e[2],e[8],e[10],walk);face=pose.facing;tex.offset.set(pose.frame/4,(3-face)/4)}}else tex.offset.set(.25,(3-face)/4);player.position.set(pos.x,.85,pos.z);near=nearest();if(near!==previous){previous=near;onNear(near)}orbit.update();frontWall.visible=camera.position.z-orbit.target.z>-3;leftWall.visible=camera.position.x-orbit.target.x>-3;rightWall.visible=camera.position.x-orbit.target.x<3;renderer.render(scene,camera)}requestAnimationFrame(frame);
 return {setEnabled(v){enabled=v;if(!v)keys.clear();else resize()},getNear(){return near},reset(){pos={x:0,z:5.2};near=null;previous=''}};
}
