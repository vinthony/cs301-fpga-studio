import * as THREE from '../vendor/three/build/three.module.min.js';

// A game-scale 3D gate model. State is supplied exclusively by RTL samples.
export function createGate3d(host){
 const renderer=new THREE.WebGLRenderer({antialias:true,alpha:true});renderer.setPixelRatio(Math.min(window.devicePixelRatio||1,1.5));renderer.outputColorSpace=THREE.SRGBColorSpace;renderer.shadowMap.enabled=true;host.appendChild(renderer.domElement);renderer.domElement.setAttribute('aria-label','门禁三维仿真场景');
 const scene=new THREE.Scene();scene.background=new THREE.Color(0xc8dfc4);const camera=new THREE.OrthographicCamera(-5,5,2.4,-2.4,.1,40);camera.position.set(7,7,10);camera.lookAt(0,.5,0);scene.add(new THREE.HemisphereLight(0xfff4d7,0x748f78,2.4));let light=new THREE.DirectionalLight(0xffeccd,2);light.position.set(-5,9,7);light.castShadow=true;scene.add(light);
 const materials=[];function mat(c){let m=new THREE.MeshStandardMaterial({color:c,roughness:.85});materials.push(m);return m}let grass=mat(0x98bc86),paving=mat(0xd6ceae),road=mat(0x718780),white=mat(0xf1ead7),red=mat(0xc77d69),dark=mat(0x3f5c56),glass=mat(0x89b4b0),orange=mat(0xd39163),wheel=mat(0x394945),yellow=mat(0xe9c776),green=mat(0x63bb78),unknown=mat(0xbaa16b);let geometries=[];
 function box(x,y,z,w,h,d,m,parent=scene){let geo=new THREE.BoxGeometry(w,h,d);geometries.push(geo);let o=new THREE.Mesh(geo,m);o.position.set(x,y,z);o.castShadow=true;o.receiveShadow=true;parent.add(o);return o}
 box(0,-.11,0,9,.2,5.3,grass);box(0,.03,0,9,.1,2.25,road);box(0,.04,-1.85,9,.1,1.1,paving);box(0,.04,1.85,9,.1,1.1,paving);
 for(let x=-4;x<4;x+=1.3)box(x,.095,0,.62,.018,.035,white);
 // Suggest the pale school sign and glass guard booth in the reference image.
 box(-1.65,.48,-1.85,2.2,.72,.25,white);box(2.35,.65,-1.72,1.25,1.14,.95,glass);box(2.35,1.27,-1.72,1.45,.14,1.1,dark);for(let x of [1.77,2.93])for(let z of [-2.13,-1.31])box(x,.65,z,.07,1.15,.07,white);
 box(.05,.50,-1.02,.28,.95,.32,dark);let pivot=new THREE.Group();pivot.position.set(.05,.91,-1.02);scene.add(pivot);box(0,0,1.05,.12,.12,2.1,white,pivot);for(let z=.20;z<2;z+=.46)box(0,.065,z,.14,.015,.22,red,pivot);
 const lamp=box(.05,1.12,-1.02,.20,.20,.20,red);let car=new THREE.Group();scene.add(car);box(0,.42,0,1.18,.48,.68,orange,car);box(.18,.75,0,.64,.28,.62,white,car);box(.23,.76,.32,.45,.17,.025,glass,car);for(let x of [-.38,.38])for(let z of [-.37,.37])box(x,.21,z,.25,.26,.10,wheel,car);box(.60,.44,0,.04,.13,.44,yellow,car);car.position.x=-2.4;
 let state=null,progress=0,alive=true,frameId=0,last=performance.now();
 function resize(){let w=host.clientWidth,h=host.clientHeight;if(!w||!h)return;renderer.setSize(w,h,false);let aspect=w/h,half=2.7;camera.left=-half*aspect;camera.right=half*aspect;camera.top=half;camera.bottom=-half;camera.updateProjectionMatrix()}const observer=new ResizeObserver(resize);observer.observe(host);resize();
 function frame(now){if(!alive)return;frameId=requestAnimationFrame(frame);let dt=Math.min(.05,(now-last)/1000);last=now;let goal=state===1?1:0;progress+=(goal-progress)*Math.min(1,dt*5);pivot.rotation.x=-1.22*progress;car.position.x=-2.4+4.1*progress;renderer.render(scene,camera)}frameId=requestAnimationFrame(frame);
 return {set(value){state=value;lamp.material=value===1?green:value===0?red:unknown},dispose(){alive=false;cancelAnimationFrame(frameId);observer.disconnect();for(const g of geometries)g.dispose();for(const m of materials)m.dispose();renderer.dispose();renderer.domElement.remove()}};
}
