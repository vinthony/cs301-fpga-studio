import * as THREE from 'three';
import {OrbitControls} from './vendor/three/examples/jsm/controls/OrbitControls.js';
export function mountArchitecture3D(host,{id,units,select,enter,values={}}){
 let renderer;try{renderer=new THREE.WebGLRenderer({antialias:true,alpha:false});}catch{return {dispose(){},select(){},supported:false}}
 renderer.setPixelRatio(Math.min(devicePixelRatio,2));renderer.outputColorSpace=THREE.SRGBColorSpace;host.append(renderer.domElement);renderer.domElement.setAttribute('aria-label','可旋转的内部结构三维视图；下方按钮提供相同导航');
 const scene=new THREE.Scene();scene.background=new THREE.Color(0x0c1c2c);
 const camera=new THREE.PerspectiveCamera(42,1,.1,200),controls=new OrbitControls(camera,renderer.domElement);controls.enableDamping=true;controls.minDistance=5;controls.maxDistance=40;controls.maxPolarAngle=Math.PI*.49;controls.target.set(0,.5,0);
 scene.add(new THREE.HemisphereLight(0xd9fff4,0x182c4d,2.5));let sun=new THREE.DirectionalLight(0xffeac6,3);sun.position.set(4,12,7);scene.add(sun);
 const world=new THREE.Group();scene.add(world);const pickables=[],groups=[],textures=[];
 const material=c=>new THREE.MeshStandardMaterial({color:c,roughness:.48,metalness:.18});
 const board=material(0x145259),gold=material(0xc0a85b),dark=material(0x172938),trace=material(0x4aada5);
 function box(w,h,d,m,x,y,z,parent=world){let o=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),m);o.position.set(x,y,z);parent.add(o);return o}
 function wire(points,color=0x4aada5,parent=world){let curve=new THREE.CatmullRomCurve3(points.map(p=>new THREE.Vector3(...p)),false,'catmullrom',0);let o=new THREE.Mesh(new THREE.TubeGeometry(curve,24,.025,6,false),material(color));parent.add(o);return o}
 function label(text,x,y,z,parent=world,size=2.7){let c=document.createElement('canvas');c.width=512;c.height=128;let ctx=c.getContext('2d');ctx.fillStyle='rgba(10,28,43,.94)';ctx.fillRect(0,0,512,128);ctx.strokeStyle='#558e9c';ctx.strokeRect(2,2,508,124);ctx.fillStyle='#e2fff8';ctx.textAlign='center';ctx.textBaseline='middle';ctx.font='bold 48px sans-serif';ctx.fillText(text,256,64,490);let t=new THREE.CanvasTexture(c);t.colorSpace=THREE.SRGBColorSpace;textures.push(t);let s=new THREE.Sprite(new THREE.SpriteMaterial({map:t,depthTest:false}));s.position.set(x,y,z);s.scale.set(size,size/6,1);parent.add(s);return s}
 const entry=units[id],children=entry.children.length?entry.children:[id];const cols=Math.min(3,children.length),rows=Math.ceil(children.length/cols),width=Math.max(9,cols*4.3),depth=Math.max(6,rows*3.9);
 box(width,.32,depth,board,0,-.3,0);box(width+.15,.18,depth+.15,dark,0,-.55,0);
 for(let x of [-width/2+.35,width/2-.35])for(let z of [-depth/2+.35,depth/2-.35]){let screw=new THREE.Mesh(new THREE.CylinderGeometry(.16,.16,.1,20),gold);screw.position.set(x,-.1,z);world.add(screw)}
 function chip(g,kind,color){let m=material(color),o;
 if(['and','nand','or','nor','xor','not','mux'].includes(kind)){
 let shape=new THREE.Shape();if(kind==='not'){shape.moveTo(-1,-.7);shape.lineTo(1,0);shape.lineTo(-1,.7)}else if(kind==='mux'){shape.moveTo(-1,-.8);shape.lineTo(.8,-.5);shape.lineTo(.8,.5);shape.lineTo(-1,.8)}else if(['or','nor','xor'].includes(kind)){shape.moveTo(-1,-.7);shape.quadraticCurveTo(.3,-.9,1.2,0);shape.quadraticCurveTo(.3,.9,-1,.7);shape.quadraticCurveTo(-.4,0,-1,-.7)}else{shape.moveTo(-1,-.7);shape.lineTo(.1,-.7);shape.quadraticCurveTo(1.6,0,.1,.7);shape.lineTo(-1,.7)}shape.closePath();o=new THREE.Mesh(new THREE.ExtrudeGeometry(shape,{depth:.48,bevelEnabled:true,bevelSize:.06,bevelThickness:.06,bevelSegments:2,steps:1}),m);o.rotation.x=-Math.PI/2;o.position.y=.35;g.add(o);
 if(kind==='xor')wire([[-1.2,.62,-.7],[-.95,.62,0],[-1.2,.62,.7]],0xd0d0ff,g);
 if(['not','nand','nor'].includes(kind)){let bubble=new THREE.Mesh(new THREE.SphereGeometry(.13,14,12),gold);bubble.position.set(1.1,.6,0);g.add(bubble)}
 }else if(kind==='nmos'||kind==='pmos'){
 box(2,.2,1.5,m,0,.25,0,g);box(.45,.12,1.4,material(0x8fcfcb),0,.43,0,g);box(.14,.35,1.4,gold,0,.66,0,g);for(let x of [-.72,.72])box(.4,.2,1.1,material(0xb990db),x,.43,0,g);label('G',0,1.15,0,g,.65);label('S',-.8,.85,.8,g,.65);label('D',.8,.85,.8,g,.65);
 }else{
 o=box(2.3,.65,1.65,m,0,.45,0,g);box(1.8,.04,1.2,dark,0,.8,0,g);
 if(['sram','sramcell','regfile','register','cache','dram','flash','memorySystem','lut'].includes(kind)||/存储|寄存|缓存|RAM|LUT/.test(kind))for(let x=-.65;x<=.7;x+=.43)for(let z=-.4;z<=.45;z+=.4)box(.23,.15,.23,gold,x,.92,z,g);
 }
 for(let z of [-.95,.95])for(let x=-.8;x<=.9;x+=.4)box(.13,.12,.38,gold,x,.2,z,g);
 return m;
 }
 children.forEach((key,i)=>{let u=units[key],g=new THREE.Group();g.position.set((i%cols-(cols-1)/2)*4.1,0,(Math.floor(i/cols)-(rows-1)/2)*3.7);g.userData.key=key;world.add(g);let kind=['nmos','pmos'].includes(u.kind)?u.kind:/存储|寄存|缓存|RAM|LUT/.test(u.name)?u.name:u.kind;let color=['and','or','xor','nand','nor','not','mux'].includes(u.kind)?0x6c6baf:u.kind==='dff'?0xbe9957:0x277c8d;let mat=chip(g,kind,color);g.userData.material=mat;g.userData.baseColor=color;g.userData.baseY=0;g.userData.index=i;groups.push(g);g.traverse(o=>{if(o.isMesh){o.userData.key=key;pickables.push(o)}});let name=label(u.name,0,1.6,0,g,3.5);name.userData.key=key;pickables.push(name);
 wire([[g.position.x,-.08,-depth/2+.3],[g.position.x,-.08,g.position.z-1.2],[g.position.x,.15,g.position.z-.95]]);wire([[g.position.x,.15,g.position.z+.95],[g.position.x,-.08,g.position.z+1.2],[g.position.x,-.08,depth/2-.3]]);
 });
 // The HTML heading names the current layer; avoid duplicate floating labels.
 const {a=0,b=0,cin=0,q=0}=values,k=entry.kind;
 const outputs={and:a&b,or:a|b,xor:a^b,nand:1-(a&b),nor:1-(a|b),not:1-a,cmos:1-a,nmos:a,pmos:1-a,mux:cin?b:a,dff:q,fulladder:a^b^cin,halfadder:a^b};
 if(Object.hasOwn(outputs,k)){
  let y=outputs[k];label(k==='dff'?`D=${a} · Q=${q}`:k==='nmos'||k==='pmos'?`G=${a} · ${y?'导通':'断开'}`:`A=${a} B=${b} · ${k==='fulladder'?'Cin='+cin+' · S':'Y'}=${y}`,0,1.2,depth/2-.15,world,4.8);
  let bulb=new THREE.Mesh(new THREE.SphereGeometry(.22,20,14),new THREE.MeshStandardMaterial({color:y?0x8effa8:0x40515b,emissive:y?0x2ba353:0x000000,emissiveIntensity:.7}));bulb.position.set(width/2-.6,.35,depth/2-.5);world.add(bulb);host.dataset.output=String(y);
 }

 // Shared buses denote functional grouping, not an electrical netlist.
 wire([[-width/2+.4,-.07,-depth/2+.3],[width/2-.4,-.07,-depth/2+.3]]);wire([[-width/2+.4,-.07,depth/2-.3],[width/2-.4,-.07,depth/2-.3]]);
 const ray=new THREE.Raycaster(),pointer=new THREE.Vector2();let down=null,disposed=false,frame,chosen=null;
 function hit(e){let r=renderer.domElement.getBoundingClientRect();pointer.set((e.clientX-r.left)/r.width*2-1,-(e.clientY-r.top)/r.height*2+1);ray.setFromCamera(pointer,camera);return ray.intersectObjects(pickables,false)[0]?.object.userData.key}
 function highlight(key){chosen=key;groups.forEach(g=>{let active=g.userData.key===key;g.userData.material.emissive.set(active?0x287b65:0x000000);g.userData.material.emissiveIntensity=active?.7:0})}
 const pd=e=>{down={x:e.clientX,y:e.clientY}},pu=e=>{if(down&&Math.hypot(e.clientX-down.x,e.clientY-down.y)<6){let key=hit(e);if(key){highlight(key);select(key)}}down=null},dbl=e=>{let key=hit(e);if(key&&entry.children.length)enter(key)},move=e=>{renderer.domElement.style.cursor=hit(e)?'pointer':'grab'};
 renderer.domElement.addEventListener('pointerdown',pd);renderer.domElement.addEventListener('pointerup',pu);renderer.domElement.addEventListener('dblclick',dbl);renderer.domElement.addEventListener('pointermove',move);
 let toolbar=document.createElement('div');toolbar.className='arch-3d-tools';toolbar.innerHTML='<button data-view-reset>重置视角</button><label>拆解 <input data-explode type="range" min="0" max="100" value="0"></label><label><input data-auto type="checkbox"> 自动旋转</label><span>拖动旋转 · 滚轮缩放 · 点击选择 · 双击进入</span>';host.before(toolbar);
 const reset=()=>{camera.position.set(width*.45,Math.max(width,depth)*.9,depth*1.0);controls.target.set(0,.5,0);controls.update()};reset();
 toolbar.querySelector('[data-view-reset]').onclick=reset;
 toolbar.querySelector('[data-explode]').oninput=e=>{let amount=Number(e.target.value)/100;groups.forEach((g,i)=>{g.position.y=amount*(1.3+(i%3)*.8)});host.dataset.explode=String(amount)};
 toolbar.querySelector('[data-auto]').onchange=e=>{controls.autoRotate=e.target.checked;controls.autoRotateSpeed=.8};
 const resize=()=>{let w=host.clientWidth,h=host.clientHeight;if(!w||!h)return;renderer.setSize(w,h,false);camera.aspect=w/h;camera.updateProjectionMatrix()};let ro=new ResizeObserver(resize);ro.observe(host);resize();
 host.dataset.webgl='ready';host.dataset.unitCount=groups.length;host.dataset.level=id;
 function animate(){if(disposed)return;frame=requestAnimationFrame(animate);controls.update();renderer.render(scene,camera)}animate();
 return {supported:true,select:highlight,dispose(){if(disposed)return;disposed=true;cancelAnimationFrame(frame);ro.disconnect();controls.dispose();renderer.domElement.removeEventListener('pointerdown',pd);renderer.domElement.removeEventListener('pointerup',pu);renderer.domElement.removeEventListener('dblclick',dbl);renderer.domElement.removeEventListener('pointermove',move);scene.traverse(o=>{o.geometry?.dispose();if(o.material){for(let m of Array.isArray(o.material)?o.material:[o.material])m.dispose()}});textures.forEach(t=>t.dispose());renderer.dispose();renderer.forceContextLoss();renderer.domElement.remove();toolbar.remove()}};
}
