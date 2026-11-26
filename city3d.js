import * as THREE from 'three';
import { OrbitControls } from './vendor/three/examples/jsm/controls/OrbitControls.js';

const container=document.getElementById('threeView'), fallback=document.getElementById('sceneFallback');
let renderer;
try { renderer=new THREE.WebGLRenderer({antialias:true,alpha:true}); }
catch(e){ fallback.hidden=false; console.error('WebGL unavailable',e); }
if(renderer){
 renderer.setPixelRatio(Math.min(devicePixelRatio,2));renderer.outputColorSpace=THREE.SRGBColorSpace;renderer.shadowMap.enabled=true;renderer.shadowMap.type=THREE.PCFSoftShadowMap;container.appendChild(renderer.domElement);
 const scene=new THREE.Scene();scene.background=new THREE.Color(0xb7dfeb);scene.fog=new THREE.Fog(0xb7dfeb,23,40);
 const camera=new THREE.PerspectiveCamera(39,1,.1,100);camera.position.set(10,9,13);
 const controls=new OrbitControls(camera,renderer.domElement);controls.target.set(0,1,0);controls.enableDamping=true;controls.minDistance=7;controls.maxDistance=25;controls.maxPolarAngle=Math.PI*.46;controls.update();
 scene.add(new THREE.HemisphereLight(0xe6fff7,0x527971,2.4));const sun=new THREE.DirectionalLight(0xfff5df,3);sun.position.set(-6,12,8);sun.castShadow=true;sun.shadow.mapSize.set(1024,1024);Object.assign(sun.shadow.camera,{left:-12,right:12,top:12,bottom:-12});scene.add(sun);
 const mat=(c,extra={})=>new THREE.MeshStandardMaterial({color:c,roughness:.7,...extra});
 const mats={board:mat(0x196454),edge:mat(0x123f40),trace:mat(0x8fe2b4,{metalness:.45}),dark:mat(0x24464c),white:mat(0xf7f6e9),orange:mat(0xffaa70),red:mat(0xed7373),blue:mat(0x74c4e1),yellow:mat(0xffd873),black:mat(0x17333d),gray:mat(0x5b7c78)};
 function box(w,h,d,m,x,y,z,parent=scene){let o=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),m);o.position.set(x,y,z);o.castShadow=true;o.receiveShadow=true;parent.add(o);return o}
 function sphere(r,m,x,y,z,parent=scene){let o=new THREE.Mesh(new THREE.SphereGeometry(r,28,18),m);o.position.set(x,y,z);o.castShadow=true;parent.add(o);return o}
 function cyl(rt,rb,h,m,x,y,z,parent=scene){let o=new THREE.Mesh(new THREE.CylinderGeometry(rt,rb,h,24),m);o.position.set(x,y,z);o.castShadow=true;o.receiveShadow=true;parent.add(o);return o}
 function textSprite(text,color='#1f514d',scale=1){let c=document.createElement('canvas');c.width=512;c.height=128;let ctx=c.getContext('2d');ctx.fillStyle='rgba(249,255,249,.94)';ctx.beginPath();ctx.roundRect(5,12,502,104,30);ctx.fill();ctx.fillStyle=color;ctx.textAlign='center';ctx.textBaseline='middle';ctx.font='bold 44px sans-serif';ctx.fillText(text,256,66);let t=new THREE.CanvasTexture(c);t.colorSpace=THREE.SRGBColorSpace;let s=new THREE.Sprite(new THREE.SpriteMaterial({map:t,transparent:true,depthWrite:false}));s.scale.set(2.3*scale,.58*scale,1);return s}
 function label(text,x,y,z,scale=1,parent=scene){let s=textSprite(text,'#20524b',scale);s.position.set(x,y,z);parent.add(s);return s}
 function cell(x,z,body,hat,caption){let g=new THREE.Group();g.position.set(x,0,z);scene.add(g);sphere(.61,body,0,1.05,0,g);sphere(.20,mats.white,-.24,1.21,.51,g);sphere(.20,mats.white,.24,1.21,.51,g);sphere(.075,mats.black,-.24,1.21,.68,g);sphere(.075,mats.black,.24,1.21,.68,g);sphere(.065,mats.red,-.4,1.02,.51,g);sphere(.065,mats.red,.4,1.02,.51,g);cyl(.44,.5,.18,hat,0,1.59,0,g);box(.34,.09,.18,mats.white,0,1.7,.1,g);sphere(.19,body,-.61,.92,.02,g);sphere(.19,body,.61,.92,.02,g);cyl(.18,.2,.25,mats.dark,-.26,.39,.08,g);cyl(.18,.2,.25,mats.dark,.26,.39,.08,g);label(caption,0,2.25,0,.8,g);return g}
 // A tangible board: copper routes, pins and a central processor.
 box(15,.5,9,mats.edge,0,-.3,0);box(14.8,.18,8.8,mats.board,0,0,0);
 for(let x=-6.8;x<=6.8;x+=.55){box(.23,.13,.55,mats.trace,x,.02,-4.42);box(.23,.13,.55,mats.trace,x,.02,4.42)}
 for(let z=-3.5;z<=3.5;z+=.55){box(.55,.13,.23,mats.trace,-7.42,.02,z);box(.55,.13,.23,mats.trace,7.42,.02,z)}
 for(let z of [-2.6,-1.8,1.8,2.6]){box(12,.025,.035,mats.trace,0,.105,z);for(let x of [-5,-3,3,5])cyl(.07,.07,.04,mats.trace,x,.14,z)}
 box(2.3,.23,1.75,mats.dark,0,.24,-3.35);label('FPGA · 信号核心',0,.55,-3.35,.85);
 const leftCell=cell(-4.6,1.05,mats.red,mats.white,'输入细胞');const rightCell=cell(4.6,1.05,mats.blue,mats.white,'输出细胞');
 const route=box(8,.14,.8,mats.gray,0,.19,1.05);for(let x=-3.7;x<4;x+=.8)box(.35,.025,.06,mats.white,x,.275,1.05);
 const leds=[];for(let i=0;i<16;i++){let lm=mat(0x4a6462,{emissive:0x000000});let bulb=sphere(.13,lm,-5.65+i*.75,.38,3.6);leds.push(bulb)}label('LED 0 → 15 · 仿真输出',0,.8,3.65,1.05);
 const packet=sphere(.22,mat(0xffe27e,{emissive:0xf0a52a,emissiveIntensity:1}),-4,.57,1.05);packet.visible=false;
 const center=new THREE.Group();scene.add(center);let mission='gate',known=false,last=null,visual={},gateTarget=1.05;
 function clearCenter(){while(center.children.length){let o=center.children[0];center.remove(o);o.traverse(n=>{if(n.geometry)n.geometry.dispose();if(n.material){let a=Array.isArray(n.material)?n.material:[n.material];a.forEach(m=>{if(m.map)m.map.dispose();m.dispose()})}})}}
 // Scene-specific geometry uses its own materials so it can be disposed safely.
 function build(id){clearCenter();mission=id;known=false;last=null;visual={};gateTarget=1.05;packet.visible=false;leftCell.position.x=-4.6;
  if(id==='gate'){
   const stone=mat(0xdbe9d6),metal=mat(0x477c6e),signal=mat(0x66817b,{emissive:0x000000});
   box(.55,2.4,.7,stone,-1.35,1.3,1.05,center);box(.55,2.4,.7,stone,1.35,1.3,1.05,center);box(3.25,.5,.8,stone,0,2.55,1.05,center);
   visual.gate=box(2.1,1.55,.12,metal,0,1.05,1.05,center);for(let x of [-.65,0,.65])box(.055,1.5,.16,stone,x,0,0,visual.gate);
   visual.signal=sphere(.24,signal,0,2.57,1.51,center);label('认证城门',0,3.3,1,.95,center);
  }else if(id==='counter'){
   const base=mat(0x447f73);box(4.6,.4,2.15,base,0,.38,.5,center);label('能量仓 · LED 低四位',0,2.9,0,1,center);visual.bars=[];
   for(let i=0;i<16;i++){let m=mat(0x677d72,{emissive:0x000000});let b=box(.22,.5,.7,m,-1.95+(i%8)*.55,.82+Math.floor(i/8)*.66,.48,center);visual.bars.push(b)}
  }else{
   label('巡逻检测站 · DISPLAY',0,2.6,-.15,1,center);visual.nodes=[];
   for(let i=0;i<3;i++){let m=mat(0x758f87,{emissive:0x000000});cyl(.55,.65,.35,mat(0xd9e9d7),-2+i*2,.37,.3,center);let n=sphere(.34,m,-2+i*2,.93,.3,center);visual.nodes.push(n);label('显示值 '+i,-2+i*2,1.65,.3,.7,center)}
  }
  paint();
 }
 function paint(){for(let i=0;i<16;i++){let on=known&&last.led!==null&&!!(last.led&(1<<i));leds[i].material.color.setHex(on?0xb8ffd0:0x4a6462);leds[i].material.emissive.setHex(on?0x48d985:0x000000)}
  if(mission==='gate'){let on=known&&last.led!==null&&!!(last.led&1);gateTarget=on?2.6:1.05;visual.signal.material.color.setHex(known?(on?0x71ed9b:0xf08078):0x66817b);visual.signal.material.emissive.setHex(known?(on?0x2b9c52:0x992b29):0)}
  if(mission==='counter'){let n=known&&last.led!==null?(last.led&15):null;visual.bars.forEach((b,i)=>{let on=n!==null&&i<n;b.material.color.setHex(on?0xffd87a:0x677d72);b.material.emissive.setHex(on?0x8c5704:0)})}
  if(mission==='fsm')visual.nodes.forEach((b,i)=>{let on=known&&last.display!==null&&last.display===i;b.material.color.setHex(on?0x8bdfed:0x758f87);b.material.emissive.setHex(on?0x207b94:0)});
 }
 window.addEventListener('city-mission',e=>build(e.detail.id));window.addEventListener('city-dirty',()=>{known=false;last=null;paint()});window.addEventListener('city-sample',e=>{if(e.detail.id!==mission)build(e.detail.id);last=e.detail;known=true;paint()});
 document.getElementById('resetCamera').addEventListener('click',()=>{camera.position.set(10,9,13);controls.target.set(0,1,0);controls.update()});
 function resize(){let w=container.clientWidth,h=container.clientHeight;if(!w||!h)return;renderer.setSize(w,h,false);camera.aspect=w/h;camera.fov=Math.min(100,2*Math.atan(Math.tan(THREE.MathUtils.degToRad(39/2))/Math.min(camera.aspect,1))*180/Math.PI);camera.updateProjectionMatrix()}new ResizeObserver(resize).observe(container);resize();build('gate');
 let start=performance.now(),lastFrame=start;function animate(now){requestAnimationFrame(animate);let t=(now-start)/1000,dt=Math.min((now-lastFrame)/1000,.08);lastFrame=now;let live=known&&last&&last.led!==null, input=live&&!!(last.sw&1),output=live&&!!(last.led&1);
 // Motion illustrates the most recent sampled signal; it does not advance the circuit.
 leftCell.position.y=Math.abs(Math.sin(t*3))*(input?.18:.055);leftCell.rotation.z=Math.sin(t*2)*.045;rightCell.position.y=Math.abs(Math.sin(t*3.5))*(output?.18:.055);rightCell.rotation.z=Math.sin(t*2+1)*.045;
 if(mission==='gate'){visual.gate.position.y+=(gateTarget-visual.gate.position.y)*Math.min(1,dt*4);let target=input?(output?(-4.4+7.8*((t*.24)%1)):-2.4):-4.6;leftCell.position.x+=(target-leftCell.position.x)*Math.min(1,dt*2.5)}else leftCell.position.x+=(-4.6-leftCell.position.x)*Math.min(1,dt*3);
 packet.visible=!!input;if(packet.visible){let end=mission==='gate'&&!output?-1.8:3.8;packet.position.x=-4.1+(end+4.1)*((t*.55)%1);packet.position.y=.65+Math.abs(Math.sin(t*7))*.2;packet.scale.setScalar(.8+.18*Math.sin(t*8))}
 if(mission==='counter'&&visual.bars)visual.bars.forEach((b,i)=>{let on=live&&i<(last.led&15);let goal=on?1.15:.72;b.scale.y+=(goal-b.scale.y)*Math.min(1,dt*5)});
 if(mission==='fsm'&&visual.nodes)visual.nodes.forEach((b,i)=>{let active=live&&last.display===i;let goal=active?1.15+.12*Math.sin(t*5):1;b.scale.setScalar(goal)});
 controls.update();renderer.render(scene,camera)}requestAnimationFrame(animate);
}
