import * as THREE from 'three';
import {OrbitControls} from '../vendor/three/examples/jsm/controls/OrbitControls.js';
import {avatarPose,screenToWorld} from './avatar-motion.js';

// A navigable interpretation of GBU's 2026 canteen photos, not a surveyed floor plan.
export function createCanteenWorld(host,onNear){
 const renderer=new THREE.WebGLRenderer({antialias:true});renderer.setPixelRatio(Math.min(devicePixelRatio,1.5));renderer.outputColorSpace=THREE.SRGBColorSpace;renderer.shadowMap.enabled=true;host.appendChild(renderer.domElement);
 const scene=new THREE.Scene();scene.background=new THREE.Color(0xc9e1d0);
 const camera=new THREE.OrthographicCamera(-12,12,8,-8,.1,100);camera.position.set(13,16,19);
 const orbit=new OrbitControls(camera,renderer.domElement);orbit.target.set(0,0,0);orbit.enablePan=false;orbit.enableDamping=true;orbit.minPolarAngle=.55;orbit.maxPolarAngle=1.1;orbit.minZoom=.8;orbit.maxZoom=2.5;orbit.update();
 scene.add(new THREE.HemisphereLight(0xfff4da,0x839a86,2));const sun=new THREE.DirectionalLight(0xffeacb,2);sun.position.set(-9,18,12);sun.castShadow=true;sun.shadow.mapSize.set(1024,1024);Object.assign(sun.shadow.camera,{left:-16,right:16,top:16,bottom:-16});scene.add(sun);
 const mat=(c,opts={})=>new THREE.MeshStandardMaterial({color:c,roughness:.82,...opts});const wood=mat(0xb78f68),trim=mat(0x765a46),floor=mat(0xd0b394),white=mat(0xf4f2e7),dark=mat(0x40505a),blue=mat(0x7baebc),chair=mat(0xc2b9aa),glass=mat(0xb5e2dc,{transparent:true,opacity:.38}),wall=mat(0xe8e6d8),green=mat(0x779975);
 function box(x,y,z,w,h,d,m,shadow=true){let o=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),m);o.position.set(x,y,z);o.castShadow=shadow;o.receiveShadow=true;scene.add(o);return o}
 box(0,-.12,0,20,.24,15,floor);for(let z=-7;z<=7;z+=.58)box(0,.006,z,19.9,.012,.018,trim,false);
 // Cutaway window wall and a glimpse of the blue court in GBU's photograph.
 box(0,2.5,-7.4,20,5,.22,wall);box(-9.8,.26,0,.20,.55,15,white);
 box(-12,.04,0,4,.08,14,blue,false);for(let z of [-6,-3,0,3,6])box(-12,.10,z,3.8,.02,.06,white,false);
 for(let z=-6.5;z<7;z+=2.1){box(-9.64,2.7,z,.05,3.7,1.95,glass,false);box(-9.56,2.7,z-1,.12,3.8,.10,dark);box(-10.35,1,z,.10,2,.07,white,false)}
 box(-9.55,2.5,0,.12,.12,14.8,dark);box(-8.75,1.08,0,1.1,.15,14,wood);
 // Window bar: pale timber stools with backs and cross braces.
 for(let z=-6;z<7;z+=1.7){box(-8.1,.62,z,.48,.10,.48,wood);box(-7.89,.94,z,.08,.55,.48,wood);for(let dz of [-.18,.18]){box(-8.1,.30,z+dz,.07,.60,.07,wood);box(-8.1,.30,z,.08,.06,.44,wood)}}
 // The water-bar counter and vertical wooden screen are based on separate
 // official photographs; their relationship in this room is an approximation.
 box(-3,1,-6.45,6,2,1.45,white);box(-3,2.06,-6.45,6,.12,1.5,wall);box(3,1.55,-7.22,2,2.5,.24,glass);for(let x of [2,3,4])box(x,1.55,-7.04,.09,2.5,.08,dark);
 for(let x=5;x<9.4;x+=.32)box(x,2.55,-7.16,.13,4.5,.10,wood,false);
 const obstacles=[];
 // Two long shared tables and upholstered grey chairs echo the published view.
 for(let x of [-3,3]){box(x,.88,0,1.25,.13,7.2,white);for(let z of [-3,0,3])for(let dx of [-.42,.42])box(x+dx,.44,z,.08,.88,.08,dark);for(let side of [-1,1])for(let z of [-2.7,-.9,.9,2.7]){let cx=x+side*1.02;box(cx,.5,z,.57,.11,.68,chair);box(cx+side*.29,.84,z,.09,.58,.68,chair);for(let dz of [-.23,.23])box(cx,.25,z+dz,.06,.5,.06,dark)}obstacles.push({x,z:0,w:1.40,d:4.0})}
 // A small timber table hints at the separately photographed water-bar area.
 box(7,.88,1,1.6,.12,1.6,wood);for(let dx of [-.6,.6])for(let dz of [-.6,.6])box(7+dx,.44,1+dz,.08,.88,.08,wood);obstacles.push({x:7,z:1,w:1.15,d:1.15});
 // An open roof with short slats at the back preserves a view into the room.
 for(let x=-9;x<9;x+=.45)box(x,5.1,-6.7,.13,.12,1.4,wood,false);
 const tex=new THREE.TextureLoader().load('assets/student-walk-atlas.png');tex.colorSpace=THREE.SRGBColorSpace;tex.magFilter=THREE.NearestFilter;tex.minFilter=THREE.NearestFilter;tex.repeat.set(.25,.25);tex.offset.set(.25,.75);const player=new THREE.Sprite(new THREE.SpriteMaterial({map:tex,transparent:true,alphaTest:.08}));player.scale.set(1.6,1.6,1);scene.add(player);
 let enabled=false,near=null,previous='',walk=0,face=0,last=performance.now();const keys=new Set(),valid=new Set(['w','a','s','d','arrowup','arrowdown','arrowleft','arrowright']);let pos={x:0,z:6};
 function open(x,z){return x>-7.8&&x<9.3&&z>-5.38&&z<7.1&&!obstacles.some(o=>Math.abs(x-o.x)<o.w&&Math.abs(z-o.z)<o.d)}
 window.addEventListener('keydown',e=>{if(enabled&&valid.has(e.key.toLowerCase())){keys.add(e.key.toLowerCase());e.preventDefault()}});window.addEventListener('keyup',e=>keys.delete(e.key.toLowerCase()));window.addEventListener('blur',()=>keys.clear());
 const mobile={up:'w',down:'s',left:'a',right:'d'};document.querySelectorAll('[data-move]').forEach(b=>{let k=mobile[b.dataset.move];b.addEventListener('pointerdown',e=>{if(enabled){e.preventDefault();keys.add(k);b.setPointerCapture(e.pointerId)}});['pointerup','pointercancel','lostpointercapture'].forEach(t=>b.addEventListener(t,()=>keys.delete(k)))});
 function resize(){let w=host.clientWidth,h=host.clientHeight;if(!w||!h)return;renderer.setSize(w,h,false);let a=w/h,half=a<1?12:9;camera.left=-half*a;camera.right=half*a;camera.top=half;camera.bottom=-half;camera.updateProjectionMatrix()}new ResizeObserver(resize).observe(host);resize();
 function frame(now){requestAnimationFrame(frame);let dt=Math.min(.05,(now-last)/1000);last=now;if(!enabled)return;let h=(keys.has('d')||keys.has('arrowright')?1:0)-(keys.has('a')||keys.has('arrowleft')?1:0),v=(keys.has('s')||keys.has('arrowdown')?1:0)-(keys.has('w')||keys.has('arrowup')?1:0),e=camera.matrixWorld.elements,d=screenToWorld(h,v,e[0],e[2],e[8],e[10]),n=Math.hypot(d.x,d.z);if(n){let x=pos.x+d.x/n*dt*3.3,z=pos.z+d.z/n*dt*3.3,old={...pos};if(open(x,pos.z))pos.x=x;if(open(pos.x,z))pos.z=z;if(Math.hypot(pos.x-old.x,pos.z-old.z)>.001){walk+=dt*10;let pose=avatarPose(pos.x-old.x,pos.z-old.z,e[0],e[2],e[8],e[10],walk);face=pose.facing;tex.offset.set(pose.frame/4,(3-face)/4)}}else tex.offset.set(.25,(3-face)/4);player.position.set(pos.x,.85,pos.z);near=pos.z< -4.25?'counter':null;if(near!==previous){previous=near;onNear(near)}orbit.update();renderer.render(scene,camera)}requestAnimationFrame(frame);
 return {setEnabled(v){enabled=v;if(!v)keys.clear();else resize()},getNear(){return near},reset(){pos={x:0,z:6};near=null;previous=''}};
}
