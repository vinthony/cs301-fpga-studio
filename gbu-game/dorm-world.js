import * as THREE from 'three';
import {OrbitControls} from '../vendor/three/examples/jsm/controls/OrbitControls.js';
import {avatarPose,screenToWorld} from './avatar-motion.js';

// Interprets the official four-person-room photographs, without claiming a
// particular building, surveyed dimensions or complete room layout.
export function createDormWorld(host,onNear){
 const renderer=new THREE.WebGLRenderer({antialias:true});renderer.setPixelRatio(Math.min(devicePixelRatio,1.5));renderer.outputColorSpace=THREE.SRGBColorSpace;renderer.shadowMap.enabled=true;host.appendChild(renderer.domElement);
 const scene=new THREE.Scene();scene.background=new THREE.Color(0xc8dacc);const camera=new THREE.OrthographicCamera(-10,10,7,-7,.1,100);camera.position.set(11,15,19);const orbit=new OrbitControls(camera,renderer.domElement);orbit.target.set(0,0,0);orbit.enablePan=false;orbit.enableDamping=true;orbit.minPolarAngle=.5;orbit.maxPolarAngle=1.1;orbit.minZoom=.8;orbit.maxZoom=2.4;orbit.update();
 scene.add(new THREE.HemisphereLight(0xfff5de,0x819587,2));let sun=new THREE.DirectionalLight(0xffe8c5,2);sun.position.set(-7,15,10);sun.castShadow=true;scene.add(sun);
 const mat=c=>new THREE.MeshStandardMaterial({color:c,roughness:.86}),white=mat(0xf3f0e7),wood=mat(0xd2ad84),floor=mat(0xb88e6a),edge=mat(0x866d58),dark=mat(0x52635e),bed=mat(0xe8dfcc),soft=mat(0xd2e1d1),glass=new THREE.MeshStandardMaterial({color:0xa9d0c9,transparent:true,opacity:.5});
 function box(x,y,z,w,h,d,m){let mesh=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),m);mesh.position.set(x,y,z);mesh.castShadow=true;mesh.receiveShadow=true;scene.add(mesh);return mesh}
 box(0,-.12,0,10,.24,15,floor);for(let z=-7.2;z<7.3;z+=.56)box(0,.01,z,9.9,.01,.018,edge);
 // The outer walls/roof are cut away for play. Balcony doors remain visible.
 box(0,2.3,-7.4,10,4.6,.16,white);box(0,2.25,-7.3,3.4,3.7,.05,glass);for(let x of [-1.7,0,1.7])box(x,2.25,-7.23,.10,3.7,.08,dark);box(0,.35,-8.15,4.4,.7,1.4,white);
 // Two pairs of upper beds with desk, wardrobe and staircase beneath.
 for(let side of [-1,1])for(let z of [-3,2.5]){let x=side*3.4;box(x,2.7,z,2.7,.18,4.4,white);box(x,2.86,z,2.45,.16,4.05,bed);box(x,3.06,z-1.4,1.9,.22,.65,white);box(x+side*1.25,3.08,z,.12,.54,4.4,white);
  for(let dz of [-2.05,2.05])box(x-side*1.2,1.36,z+dz,.13,2.65,.13,white);
  box(x,.93,z-.20,2.45,.14,2.7,wood);box(x,1.64,z-1.47,2.4,.1,.1,white);box(x,2.05,z-1.47,2.4,.12,.1,white);
  box(x+side*1.12,1.18,z+1.20,.52,2.35,.80,white);box(x+side*.84,1.15,z+1.20,.045,.15,.08,wood);
  box(x+side*.8,.45,z+.20,.55,.9,.75,white);for(let j=0;j<3;j++)box(x+side*.8,.25+j*.27,z+.59,.35,.03,.02,wood);
  box(x-side*.65,.53,z+.35,.65,.10,.70,white);box(x-side*.9,.83,z+.35,.09,.65,.70,white);for(let dz of [-.25,.25])box(x-side*.65,.25,z+.35+dz,.06,.5,.06,dark);
  let ladderX=x-side*1.18;for(let dz of [1.45,1.95])box(ladderX,1.37,z+dz,.1,2.6,.1,white);for(let y=.35;y<2.6;y+=.42)box(ladderX,y,z+1.7,.12,.08,.58,wood);
 }
 const tex=new THREE.TextureLoader().load('assets/student-walk-atlas.png');tex.colorSpace=THREE.SRGBColorSpace;tex.magFilter=THREE.NearestFilter;tex.minFilter=THREE.NearestFilter;tex.repeat.set(.25,.25);tex.offset.set(.25,.75);const player=new THREE.Sprite(new THREE.SpriteMaterial({map:tex,transparent:true,alphaTest:.08}));player.scale.set(1.6,1.6,1);scene.add(player);
 let enabled=false,pos={x:0,z:6},near=null,previous='',walk=0,face=3,last=performance.now();const keys=new Set(),valid=new Set(['w','a','s','d','arrowup','arrowdown','arrowleft','arrowright']);
 function open(x,z){return x>-1.85&&x<1.85&&z>-6.75&&z<7.1}function nearest(){if(pos.z>5.8)return 'exit';if(pos.z< -5.65)return 'window';if(Math.abs(pos.x)>1.15&&Math.abs(pos.z)<5.2)return 'desk';return null}
 window.addEventListener('keydown',e=>{if(enabled&&valid.has(e.key.toLowerCase())){keys.add(e.key.toLowerCase());e.preventDefault()}});window.addEventListener('keyup',e=>keys.delete(e.key.toLowerCase()));window.addEventListener('blur',()=>keys.clear());const dirs={up:'w',down:'s',left:'a',right:'d'};document.querySelectorAll('[data-move]').forEach(b=>{let k=dirs[b.dataset.move];b.addEventListener('pointerdown',e=>{if(enabled){e.preventDefault();keys.add(k);b.setPointerCapture(e.pointerId)}});['pointerup','pointercancel','lostpointercapture'].forEach(t=>b.addEventListener(t,()=>keys.delete(k)))});
 function resize(){let w=host.clientWidth,h=host.clientHeight;if(!w||!h)return;renderer.setSize(w,h,false);let a=w/h,half=a<1?11:8;camera.left=-half*a;camera.right=half*a;camera.top=half;camera.bottom=-half;camera.updateProjectionMatrix()}new ResizeObserver(resize).observe(host);resize();
 function frame(now){requestAnimationFrame(frame);let dt=Math.min(.05,(now-last)/1000);last=now;if(!enabled)return;let h=(keys.has('d')||keys.has('arrowright')?1:0)-(keys.has('a')||keys.has('arrowleft')?1:0),v=(keys.has('s')||keys.has('arrowdown')?1:0)-(keys.has('w')||keys.has('arrowup')?1:0),e=camera.matrixWorld.elements,d=screenToWorld(h,v,e[0],e[2],e[8],e[10]),n=Math.hypot(d.x,d.z);if(n){let x=pos.x+d.x/n*dt*3.2,z=pos.z+d.z/n*dt*3.2,old={...pos};if(open(x,pos.z))pos.x=x;if(open(pos.x,z))pos.z=z;if(Math.hypot(pos.x-old.x,pos.z-old.z)>.001){walk+=dt*10;let pose=avatarPose(pos.x-old.x,pos.z-old.z,e[0],e[2],e[8],e[10],walk);face=pose.facing;tex.offset.set(pose.frame/4,(3-face)/4)}}else tex.offset.set(.25,(3-face)/4);player.position.set(pos.x,.85,pos.z);near=nearest();if(near!==previous){previous=near;onNear(near)}orbit.update();renderer.render(scene,camera)}requestAnimationFrame(frame);
 return {setEnabled(v){enabled=v;if(!v)keys.clear();else resize()},getNear(){return near},reset(){pos={x:0,z:6};near=null;previous=''}};
}
