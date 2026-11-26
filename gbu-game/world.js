import * as THREE from 'three';
import {OrbitControls} from '../vendor/three/examples/jsm/controls/OrbitControls.js';
import {avatarPose,screenToWorld} from './avatar-motion.js';
import {findCampusPath,campusWalkways,researchGardenPaths,courtyardFootprints,researchFootprints,entrancePalms,touchesPalm,baySegments,bayPoint,bayWidth,bayElevation,touchesBay,campusTrees,touchesTree,touchesEntrance,academicCenter} from './campus-navigation.js';
// Locations follow the public Songshan Lake campus guide's relative composition.
// Precise measurements and interiors are not represented by this model.
export const places=[{id:'gate',name:'北一门',x:-7,z:13},{id:'bridge',name:'图书馆 · 湾',x:0,z:3.5},{id:'tower',name:'教学楼',x:7,z:-4},{id:'core',name:'产研楼',x:-17,z:4}];
export function createWorld(element,onNear){
 const renderer=new THREE.WebGLRenderer({antialias:false});renderer.setPixelRatio(1);renderer.outputColorSpace=THREE.SRGBColorSpace;renderer.shadowMap.enabled=true;renderer.shadowMap.type=THREE.PCFShadowMap;renderer.setClearColor(0xb9d4cb);element.appendChild(renderer.domElement);renderer.domElement.style.imageRendering='pixelated';
 const scene=new THREE.Scene();scene.background=new THREE.Color(0xb9d4cb);scene.fog=new THREE.Fog(0xb9d4cb,60,110);
 const camera=new THREE.OrthographicCamera(-30,30,20,-20,.1,180);camera.position.set(0,48,55);const orbit=new OrbitControls(camera,renderer.domElement);orbit.target.set(0,0,0);orbit.enableDamping=true;orbit.enablePan=false;orbit.minZoom=.75;orbit.maxZoom=3;orbit.minPolarAngle=.45;orbit.maxPolarAngle=1.05;orbit.update();
 // Balanced daylight retains the colour of paving and foliage instead of
 // washing light surfaces almost white. The position is artistic, not a clock.
 scene.add(new THREE.HemisphereLight(0xfff2d4,0x506f68,1.3));const sun=new THREE.DirectionalLight(0xffe7bd,1.25);sun.position.set(-25,45,20);sun.castShadow=true;sun.shadow.mapSize.set(2048,2048);Object.assign(sun.shadow.camera,{left:-40,right:40,top:35,bottom:-35,near:1,far:110});sun.shadow.bias=-.0004;scene.add(sun);
 const mat=(color,extra={})=>new THREE.MeshStandardMaterial({color,roughness:.88,flatShading:true,...extra});
 const m={grass:mat(0x9dbd8a),grassDark:mat(0x719d75),forest:mat(0x587e61),road:mat(0x667d78),path:mat(0xe5d6ad),paving:mat(0xc8c7ae),white:mat(0xf0eada),shade:mat(0xc9d0c3),roof:mat(0x93a8a4),glass:mat(0x739c9a),deep:mat(0x486e72),frame:mat(0xd9dfd4),brown:mat(0x8a674b),trunk:mat(0x795d45),leaves:mat(0x689665),leaves2:mat(0x82aa70),bush:mat(0x5f8a63),water:mat(0x86c5bd),blue:mat(0x6dabc9),sports:mat(0x5d99ad),gold:mat(0xf3c66f,{emissive:0x734722,emissiveIntensity:.3}),red:mat(0xd68376),skin:mat(0xf9d1a9),dark:mat(0x314b4e)};
 // Repeating hand-authored pixel patterns add readable ground and paving detail.
 function tileTexture(kind){let c=document.createElement('canvas');c.width=c.height=128;let ctx=c.getContext('2d');ctx.imageSmoothingEnabled=false;let local=kind==='grass'?9123:2147;function r(){local=(local*1664525+1013904223)>>>0;return local/4294967296}ctx.fillStyle=kind==='grass'?'#a4be83':'#d9cba9';ctx.fillRect(0,0,128,128);if(kind==='grass'){for(let i=0;i<420;i++){let x=Math.floor(r()*128),y=Math.floor(r()*128);ctx.fillStyle=i%5===0?'#bacb8c':i%3===0?'#91ae76':'#9ab77d';ctx.fillRect(x,y,1+Math.floor(r()*3),1+Math.floor(r()*2))}for(let i=0;i<45;i++){let x=Math.floor(r()*128),y=Math.floor(r()*128);ctx.fillStyle='#789e6b';ctx.fillRect(x,y,1,3);ctx.fillRect(x-1,y-1,1,1)}}else{ctx.strokeStyle='#c0b99e';ctx.lineWidth=1;for(let y=0;y<128;y+=16){ctx.beginPath();ctx.moveTo(0,y);ctx.lineTo(128,y);ctx.stroke();for(let x=((y/16)%2)*8;x<128;x+=16){ctx.beginPath();ctx.moveTo(x,y);ctx.lineTo(x,y+16);ctx.stroke()}}}let tex=new THREE.CanvasTexture(c);tex.colorSpace=THREE.SRGBColorSpace;tex.wrapS=tex.wrapT=THREE.RepeatWrapping;tex.magFilter=THREE.NearestFilter;tex.minFilter=THREE.NearestFilter;tex.repeat.set(kind==='grass'?9:4,kind==='grass'?6:4);return tex}
 const groundMaterial=new THREE.MeshStandardMaterial({map:tileTexture('grass'),roughness:1});m.paving.map=tileTexture('paving');m.paving.color.setHex(0xffffff);
 let block=[];
 function box(x,y,z,w,h,d,material,parent=scene){let o=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),material);o.position.set(x,y,z);o.castShadow=true;o.receiveShadow=true;parent.add(o);return o}
 function sphere(x,y,z,r,material,parent=scene,detail=1){let o=new THREE.Mesh(new THREE.IcosahedronGeometry(r,detail),material);o.position.set(x,y,z);o.castShadow=true;parent.add(o);return o}
 function cylinder(x,y,z,rt,rb,h,material,parent=scene,n=16){let o=new THREE.Mesh(new THREE.CylinderGeometry(rt,rb,h,n),material);o.position.set(x,y,z);o.castShadow=true;o.receiveShadow=true;parent.add(o);return o}
 function textSprite(text,scale=1,color='#fdf6d7'){let c=document.createElement('canvas');c.width=512;c.height=128;let a=c.getContext('2d');a.imageSmoothingEnabled=false;a.fillStyle='#294f4b';a.fillRect(5,13,502,102);a.fillStyle='#cce2b2';a.fillRect(13,21,486,86);a.fillStyle='#284c49';a.fillRect(19,27,474,74);a.textAlign='center';a.textBaseline='middle';a.fillStyle=color;let fontSize=66;do{a.font=`bold ${fontSize}px sans-serif`;if(a.measureText(text).width<=440)break;fontSize-=2}while(fontSize>30);a.fillText(text,256,64);const tex=new THREE.CanvasTexture(c);tex.colorSpace=THREE.SRGBColorSpace;tex.magFilter=THREE.NearestFilter;let s=new THREE.Sprite(new THREE.SpriteMaterial({map:tex,transparent:true,depthWrite:false}));s.scale.set(3.6*scale,.9*scale,1);return s}
 const locationLabels=[];
 function label(t,x,y,z,scale=1,parent=scene){let s=textSprite(t,scale);s.position.set(x,y,z);parent.add(s);locationLabels.push(s);return s}
 // Site geometry uses hand-estimated proportions from the public campus guide.
 // Surrounding ground is decorative context rather than a model of nearby sites.
 box(0,-1.3,0,160,1,120,groundMaterial);box(0,-.6,0,61,1.1,39,m.grassDark);box(0,0,0,60,.2,38,groundMaterial);
 // North boundary road, gates and two campus axes.
 box(0,.12,16.5,60,.09,2.8,m.road);box(0,.18,14.95,60,.05,.65,m.paving);box(0,.12,-18,60,.09,1.7,m.road);box(28.4,.12,0,1.8,.09,34,m.road);label('大学路',-14,1.1,16.5,.62);label('月山路',1,1.1,-18,.62);label('石大路',28.4,1.1,0,.62);for(let x=-27;x<28;x+=2.5)box(x,.18,16.5,1.25,.03,.09,m.path);
 // The bay aerial shows a vivid blue strip beside the perimeter road. Its
 // function and alignment across the full campus are not established by the
 // photo, so this is a visual approximation of the visible boundary only.
 const boundaryBlue=mat(0x248cba),boundaryEdge=mat(0xd4e9dc);
 box(0,.185,15.58,60,.035,.55,boundaryBlue);
 box(0,.208,15.88,60,.012,.035,boundaryEdge);
 for(const [x,z,w,d] of campusWalkways.slice(0,4))box(x,.15,z,w,.13,d,m.paving);
 // The user-supplied guide depicts paved connections around the residences,
 // courts and canteen. These routes connect the game landmarks; their exact
 // alignment and width are estimates, not a surveyed plan.
 function lifeWalk(x,z,w,d){box(x,.145,z,w+.14,.055,d+.14,m.shade);box(x,.18,z,w,.06,d,m.paving)}
 // The completion aerial shows broad pale paved forecourts at the residence
 // bases. These small aprons connect to the existing walk and are illustrative:
 // neither the paving pattern nor the individual entrances are surveyed.
 for(let x of [16,20,24]){
  box(x,.135,-3.48,3.9,.05,2.05,m.shade);
  box(x,.167,-3.48,3.78,.025,1.93,m.paving);
  for(let dx of [-1.25,-.42,.42,1.25])box(x+dx,.183,-3.48,.018,.008,1.82,m.frame);
 }
 // Residence, sports and western research paths use the same coordinates as
 // the route planner, preventing visible paving and navigation from drifting.
 for(const [x,z,w,d] of campusWalkways.slice(4))lifeWalk(x,z,w,d);
 // The supplied campus map shows a curved, two-lobed pool near the bay.
 // Its location and outline are approximate; no water depth is represented.
 // Pixel-scale variation gives the planted hill and lawn a softer, living
 // surface. Colours and texture are interpretive, not surveyed vegetation.
 function gardenTexture(){let c=document.createElement('canvas');c.width=c.height=128;let a=c.getContext('2d'),seed=8337;a.imageSmoothingEnabled=false;a.fillStyle='#799d70';a.fillRect(0,0,128,128);function r(){seed=(seed*1664525+1013904223)>>>0;return seed/4294967296}for(let i=0;i<620;i++){let x=Math.floor(r()*128),y=Math.floor(r()*128);a.fillStyle=i%5===0?'#9bb985':i%3===0?'#668e64':'#87a97a';a.fillRect(x,y,1+Math.floor(r()*3),1+Math.floor(r()*2))}for(let i=0;i<60;i++){let x=Math.floor(r()*126)+1,y=Math.floor(r()*126)+1;a.fillStyle='#638760';a.fillRect(x,y,1,3);a.fillRect(x-1,y-1,1,2);a.fillStyle='#a6bc8a';a.fillRect(x+1,y-1,1,1)}let t=new THREE.CanvasTexture(c);t.colorSpace=THREE.SRGBColorSpace;t.wrapS=t.wrapT=THREE.RepeatWrapping;t.magFilter=THREE.NearestFilter;t.minFilter=THREE.NearestFilter;t.repeat.set(2,2);return t}
 const gardenMap=gardenTexture(),lawnMaterial=new THREE.MeshStandardMaterial({map:gardenMap,color:0xe3f1d4,roughness:1}),hillMaterial=new THREE.MeshStandardMaterial({map:gardenMap,color:0xc4ddbd,roughness:1,flatShading:true});
 // Rounded lawn is an approximate planted edge, not a surveyed boundary.
 let lawn=cylinder(-6,.2,1,1,1,.16,lawnMaterial,scene,64);lawn.scale.set(5.5,1,3.5);let hill=sphere(-7,.2,-4,3.5,hillMaterial,scene,2);hill.scale.set(1.55,.17,1.05);
 // Interpret the photographed blue loop and light winding paths around the
 // hill. The precise path geometry and terrain heights are not surveyed.
 hill.updateMatrixWorld(true);const groundRay=new THREE.Raycaster(),down=new THREE.Vector3(0,-1,0);
 function terrainHeight(x,z){groundRay.set(new THREE.Vector3(x,10,z),down);let hit=groundRay.intersectObject(hill,false)[0],lawn=((x+6)/5.5)**2+((z-1)/3.5)**2<1?.28:.1;return Math.max(lawn,hit?.point.y??lawn)}
 function hillHeight(x,z){return terrainHeight(x,z)+.025}
 const gardenRoutes=[];function gardenPath(points,width,material,closed=false){let curve=new THREE.CatmullRomCurve3(points.map(([x,z])=>new THREE.Vector3(x,0,z)),closed,'centripetal'),samples=curve.getPoints(100),vertices=[],indices=[];gardenRoutes.push(samples);for(let i=0;i<samples.length;i++){let p=samples[i],t=curve.getTangent(i/100),length=Math.hypot(t.x,t.z),nx=-t.z/length,nz=t.x/length;for(let s of [-1,1]){let x=p.x+nx*width*s/2,z=p.z+nz*width*s/2;vertices.push(x,hillHeight(x,z),z)}if(i<samples.length-1){let a=i*2,b=a+2;indices.push(a,a+1,b,b,a+1,b+1)}}let g=new THREE.BufferGeometry();g.setAttribute('position',new THREE.Float32BufferAttribute(vertices,3));g.setIndex(indices);g.computeVertexNormals();let path=new THREE.Mesh(g,material);path.receiveShadow=true;scene.add(path)}
 // Curved links through the western landscaped precinct are interpretive;
 // control points also inform navigation so the visible paths are usable.
 for(const points of researchGardenPaths)gardenPath(points,.65,m.path);
 gardenPath([[-10.1,-4.6],[-9.4,-5.9],[-7.5,-6.3],[-5.2,-5.8],[-4.2,-4.4],[-4.9,-2.7],[-7.1,-2.1],[-9.3,-2.6]],.27,mat(0x3089aa),true);
 gardenPath([[-10.8,-1.3],[-9.8,-2],[-8.7,-2.4],[-7.2,-2.6],[-5.5,-2.1],[-4.7,-1.2]],.24,m.path);
 gardenPath([[-9.8,-.8],[-9.0,-1.5],[-7.7,-1.8],[-6.5,-1.5],[-5.7,-.9]],.18,m.frame);
 // A pale meandering link echoes the paths through the photographed garden.
 gardenPath([[-10.6,1.1],[-9.5,.55],[-8.4,.40],[-7.2,.58],[-6.15,.25],[-5.1,-.55]],.25,m.path);
 // A small paved clearing and circular inset echo the sheltered space visible
 // among the central trees in the aerial photo. They follow the game's terrain;
 // their shape, position, size and paving material are not surveyed.
 gardenPath([[-7.2,-4.1],[-7.35,-3.4],[-7.2,-2.6]],.28,m.path);
 {let cx=-7.2,cz=-4.1,r=.88,verts=[cx,hillHeight(cx,cz)+.01,cz],idx=[];
  for(let i=0;i<=32;i++){let a=i*Math.PI*2/32,x=cx+Math.cos(a)*r,z=cz+Math.sin(a)*r;verts.push(x,hillHeight(x,z)+.01,z);if(i>0)idx.push(0,i+1,i)}
  let geo=new THREE.BufferGeometry();geo.setAttribute('position',new THREE.Float32BufferAttribute(verts,3));geo.setIndex(idx);geo.computeVertexNormals();let clearing=new THREE.Mesh(geo,m.paving);clearing.receiveShadow=true;scene.add(clearing);
  for(let i=0;i<12;i++){let a=i*Math.PI*2/12,x=cx+Math.cos(a)*.31,z=cz+Math.sin(a)*.31;let stone=box(x,hillHeight(x,z)+.055,z,.13,.05,.13,i%2?m.frame:m.shade);stone.rotation.y=-a}
 }
 // The entrance photo shows pale curved edges to the grass terraces. Use low
 // three-dimensional segments that follow the modelled terrain, rather than
 // flat painted lines. Heights, count and placement remain interpretations.
 for(let row=0;row<5;row++){
  let z=3.35-row*.43,curve=new THREE.CatmullRomCurve3([[-10.2,z+.30],[-9.3,z+.07],[-7.8,z-.10],[-6.3,z+.07],[-5.3,z+.30]].map(([x,pz])=>new THREE.Vector3(x,0,pz)),false,'centripetal');
  let points=curve.getPoints(24);
  for(let i=0;i<points.length-1;i++){
   let a=points[i],b=points[i+1],x=(a.x+b.x)/2,pz=(a.z+b.z)/2,dx=b.x-a.x,dz=b.z-a.z;
   let edge=box(x,terrainHeight(x,pz)+.065,pz,Math.hypot(dx,dz)+.012,.11,.14,m.frame);
   edge.rotation.y=-Math.atan2(dz,dx);
  }
 }
 const pond={x:-2.3,z:1.5};let pondShape=new THREE.Shape();pondShape.moveTo(-1.95,-.15);pondShape.bezierCurveTo(-1.95,-1.05,-.75,-1.25,-.15,-.74);pondShape.bezierCurveTo(.25,-1.12,1.55,-.93,1.88,-.3);pondShape.bezierCurveTo(2.14,.18,1.7,.93,.85,1.0);pondShape.bezierCurveTo(.42,1.06,.08,.82,-.18,.79);pondShape.bezierCurveTo(-.85,1.15,-1.94,.72,-1.95,-.15);let pondGeo=new THREE.ShapeGeometry(pondShape,24);
 // Pixel ripples drift across the approximate two-lobed pond; the pattern
 // and motion are artistic and do not imply observed water conditions.
 function waterTexture(){let c=document.createElement('canvas');c.width=c.height=64;let a=c.getContext('2d');a.imageSmoothingEnabled=false;a.fillStyle='#82beb7';a.fillRect(0,0,64,64);let seed=1289;const r=()=>{seed=(seed*1664525+1013904223)>>>0;return seed/4294967296};for(let i=0;i<46;i++){let x=Math.floor(r()*64),y=Math.floor(r()*64);a.fillStyle=i%3===0?'#a9d8ca':i%3===1?'#70ada9':'#96cbc0';a.fillRect(x,y,2+Math.floor(r()*6),1+Math.floor(r()*2))}let t=new THREE.CanvasTexture(c);t.colorSpace=THREE.SRGBColorSpace;t.wrapS=t.wrapT=THREE.RepeatWrapping;t.magFilter=t.minFilter=THREE.NearestFilter;t.repeat.set(.55,.55);return t}
 const waterMap=waterTexture(),pondWater=new THREE.MeshStandardMaterial({map:waterMap,roughness:.65});
 function pondSurface(material,y,scale){let o=new THREE.Mesh(pondGeo,material);o.rotation.x=-Math.PI/2;o.position.set(pond.x,y,pond.z);o.scale.set(scale,scale,1);scene.add(o)}pondSurface(m.frame,.32,1.08);pondSurface(pondWater,.34,1);
 const waterGlints=[];for(let [x,z,size,phase] of [[-3.1,1.2,.5,0],[-1.5,1.6,.35,1.9],[-2.5,2,.28,3.3],[-2.7,1.4,.25,4.1],[-1.95,1.15,.24,5.2]]){let glint=box(x,.36,z,size,.025,.035,m.white);waterGlints.push({glint,phase,x})}
 // Continuous curved bands approximate the white shell and dark glazed facade
 // visible in the supplied campus guide and 2024 completion aerial. This is
 // still an estimated footprint, not a survey or a model of the actual floors.
 let bay=new THREE.Group();bay.position.set(-5,0,-3);scene.add(bay);const segments=baySegments,bayPath=[];
 for(let i=0;i<=segments;i++){let p=bayPoint(i);bayPath.push([p.x+5,p.z+3])}
 function bayBand(inner,outer,bottom,top,material,cutout=false){
  const vertices=[],indices=[];
  for(let i=0;i<=segments;i++){let [x,z]=bayPath[i],prev=bayPath[Math.max(0,i-1)],next=bayPath[Math.min(segments,i+1)],dx=next[0]-prev[0],dz=next[1]-prev[1],len=Math.hypot(dx,dz),nx=-dz/len,nz=dx/len;
   let t=i/segments,width=bayWidth(t)/.94,lift=bayElevation(t),base=bottom===.22?bottom:bottom+lift;vertices.push(x+nx*inner*width,base,z+nz*inner*width,x+nx*outer*width,base,z+nz*outer*width,x+nx*inner*width,top+lift,z+nz*inner*width,x+nx*outer*width,top+lift,z+nz*outer*width)}
  for(let i=0;i<segments;i++){let a=i*4,b=(i+1)*4;indices.push(a,b,a+2,b,b+2,a+2,a+1,a+3,b+1,b+1,a+3,b+3);if(!cutout)indices.push(a+2,b+2,a+3,b+2,b+3,a+3)}
  indices.push(0,2,1,1,2,3);let j=segments*4;indices.push(j,j+1,j+2,j+1,j+3,j+2);for(let i=0;i<indices.length;i+=3)[indices[i+1],indices[i+2]]=[indices[i+2],indices[i+1]];
  let geo=new THREE.BufferGeometry();geo.setAttribute('position',new THREE.Float32BufferAttribute(vertices,3));geo.setIndex(indices);geo.computeVertexNormals();let mesh=new THREE.Mesh(geo,material);mesh.castShadow=true;mesh.receiveShadow=true;bay.add(mesh);
  if(cutout){let v=[],ix=[];for(let i=0;i<=segments;i++){let [x,z]=bayPath[i],prev=bayPath[Math.max(0,i-1)],next=bayPath[Math.min(segments,i+1)],dx=next[0]-prev[0],dz=next[1]-prev[1],len=Math.hypot(dx,dz),nx=-dz/len,nz=dx/len,profile=bayWidth(i/segments)/.94,half=i>=53&&i<=65?Math.sin(Math.PI*(i-53)/12)*.29:0,y=top+bayElevation(i/segments);for(let offset of [inner,.27-half,.27+half,outer])v.push(x+nx*offset*profile,y,z+nz*offset*profile);if(i<segments){let a=i*4,b=a+4;for(let k of [0,2])ix.push(a+k,a+k+1,b+k,b+k,a+k+1,b+k+1)}}let g=new THREE.BufferGeometry();g.setAttribute('position',new THREE.Float32BufferAttribute(v,3));g.setIndex(ix);g.computeVertexNormals();let surface=new THREE.Mesh(g,material);surface.castShadow=true;surface.receiveShadow=true;bay.add(surface)}return mesh
 }
 bayBand(-.76,.76,.22,1.17,m.deep);bayBand(-.82,.82,1.17,1.36,m.white);bayBand(-.76,.76,1.36,2.12,m.glass);bayBand(-.91,.91,2.12,2.36,m.white,true);bayBand(-.94,.94,2.36,2.44,m.frame,true);
 // The exterior photo shows several fine horizontal white bands in addition
 // to the major shell edges. Their heights and spacing are interpretive.
 for(let y of [.57,.86,1.60,1.87])bayBand(-.78,.78,y,y+.045,m.frame);
 // 2025 aerial photographs show long dark skylights and green insets on the
 // white roof. Their placement here is interpretive, not a measured roof plan.
 function roofInset(first,last,offset,width,material,height=2.455){let verts=[],idx=[],count=last-first;
  for(let i=first;i<=last;i++){let [x,z]=bayPath[i],prev=bayPath[Math.max(0,i-1)],next=bayPath[Math.min(segments,i+1)],dx=next[0]-prev[0],dz=next[1]-prev[1],len=Math.hypot(dx,dz),nx=-dz/len,nz=dx/len,t=(i-first)/count,half=Math.sin(Math.PI*t)*width/2;let profile=bayWidth(i/segments)/.94,y=height+bayElevation(i/segments);verts.push(x+nx*(offset-half)*profile,y,z+nz*(offset-half)*profile,x+nx*(offset+half)*profile,y,z+nz*(offset+half)*profile)}
  for(let i=0;i<count;i++){let a=i*2,b=a+2;idx.push(a,a+1,b,b,a+1,b+1)}let geo=new THREE.BufferGeometry();geo.setAttribute('position',new THREE.Float32BufferAttribute(verts,3));geo.setIndex(idx);geo.computeVertexNormals();let roof=new THREE.Mesh(geo,material);roof.receiveShadow=true;bay.add(roof)}
 roofInset(1,15,-.17,.36,m.deep);roofInset(19,37,.27,.25,m.deep);roofInset(39,57,-.20,.40,m.grassDark);roofInset(53,65,.27,.58,m.deep,2.125);roofInset(55,62,.27,.27,m.grassDark,2.13);roofInset(65,71,.19,.20,m.deep);
 // A shallow well gives this roof feature real depth. The bottom remains
 // closed: this is an artistic recess, not a verified through-opening.
 {let vertices=[],indices=[];for(let i=53;i<=65;i++){let [x,z]=bayPath[i],prev=bayPath[i-1],next=bayPath[i+1],dx=next[0]-prev[0],dz=next[1]-prev[1],length=Math.hypot(dx,dz),nx=-dz/length,nz=dx/length,profile=bayWidth(i/segments)/.94,half=Math.sin(Math.PI*(i-53)/12)*.29,lift=bayElevation(i/segments);for(let side of [-1,1])for(let y of [2.12,2.44])vertices.push(x+nx*(.27+side*half)*profile,y+lift,z+nz*(.27+side*half)*profile);if(i<65){let a=(i-53)*4,b=a+4;for(let k of [0,2])indices.push(a+k,b+k,a+k+1,b+k,b+k+1,a+k+1)}}let geo=new THREE.BufferGeometry();geo.setAttribute('position',new THREE.Float32BufferAttribute(vertices,3));geo.setIndex(indices);geo.computeVertexNormals();let wall=new THREE.Mesh(geo,mat(0x91aaa0,{side:THREE.DoubleSide}));wall.castShadow=true;bay.add(wall)}
 // A raised, tapered rim gives the roof inset depth, echoing the prominent
 // nested oval visible in the aerial. This remains an interpreted roof detail,
 // not a surveyed or accessible space.
 function roofInsetRim(first,last,offset,width){
  let points=[];
  for(const side of [-1,1])for(let step=0;step<=last-first;step++){
   let i=side<0?first+step:last-step,[x,z]=bayPath[i],prev=bayPath[Math.max(0,i-1)],next=bayPath[Math.min(segments,i+1)],dx=next[0]-prev[0],dz=next[1]-prev[1],length=Math.hypot(dx,dz),nx=-dz/length,nz=dx/length;
   let half=Math.sin(Math.PI*(i-first)/(last-first))*width/2,profile=bayWidth(i/segments)/.94;
   points.push(new THREE.Vector3(x+nx*(offset+side*half)*profile,2.49+bayElevation(i/segments),z+nz*(offset+side*half)*profile));
  }
  let curve=new THREE.CatmullRomCurve3(points,true,'centripetal');
  let rim=new THREE.Mesh(new THREE.TubeGeometry(curve,64,.035,6,true),m.white);rim.castShadow=true;bay.add(rim);
 }
 roofInsetRim(53,65,.27,.58);
 // Fine crossbars suggest the closely spaced ribs visible within the long
 // rooflights in the aerial image. Their count and exact placement are artistic.
 function rooflightRibs(first,last,offset,width,step=2){let vertices=[];
  for(let i=first+1;i<last;i+=step){let [x,z]=bayPath[i],prev=bayPath[i-1],next=bayPath[i+1],dx=next[0]-prev[0],dz=next[1]-prev[1],len=Math.hypot(dx,dz),nx=-dz/len,nz=dx/len,t=(i-first)/(last-first),half=Math.sin(Math.PI*t)*width*.43,profile=bayWidth(i/segments)/.94,y=2.47+bayElevation(i/segments);for(let s of [-1,1])vertices.push(x+nx*(offset+s*half)*profile,y,z+nz*(offset+s*half)*profile)}
  let geometry=new THREE.BufferGeometry();geometry.setAttribute('position',new THREE.Float32BufferAttribute(vertices,3));bay.add(new THREE.LineSegments(geometry,new THREE.LineBasicMaterial({color:0xb8d2ca})))
 }
 rooflightRibs(1,15,-.17,.36);rooflightRibs(19,37,.27,.25);rooflightRibs(65,71,.19,.20);
 // Thin light ridges echo the nested roof contours seen in the aerial image.
 roofInset(2,16,.55,.035,m.white);roofInset(3,14,-.57,.035,m.white);roofInset(40,57,.12,.025,m.frame);
 // Slim upright facade mullions follow the curve instead of disconnected boxes.
 for(let i=2;i<segments;i+=4){let [x,z]=bayPath[i],prev=bayPath[i-1],next=bayPath[i+1],dx=next[0]-prev[0],dz=next[1]-prev[1],len=Math.hypot(dx,dz),nx=-dz/len,nz=dx/len,width=bayWidth(i/segments)*.81,lift=bayElevation(i/segments);for(let side of [-1,1]){let post=box(x+nx*width,1.2+lift/2,z+nz*width,.055,1.78+lift,.055,m.frame,bay);post.castShadow=false}}
 label('图书馆 / 学生活动中心',-3,3.9,-2,1.15);
 // The supplied map marks a small academic activity centre near the central
 // landscape. Shape, location, glazing and roof are an interpretive model.
 {let {x,z,w,d}=academicCenter;let base=terrainHeight(x,z);cylinder(x,base+.12,z,.82,.86,.22,m.shade,scene,8);cylinder(x,base+.72,z,.69,.69,1.0,m.glass,scene,8);for(let i=0;i<8;i++){let a=i*Math.PI/4;box(x+Math.cos(a)*.67,base+.72,z+Math.sin(a)*.67,.07,1.0,.07,m.frame)}cylinder(x,base+1.30,z,.79,.79,.15,m.white,scene,8);cylinder(x,base+1.55,z,.05,.86,.38,m.white,scene,8);label('学术活动中心',x,base+2.25,z,.65);block.push({x,z,w:w+.6,d:d+.6})}

 function building(name,x,z,w,d,floors,opt={}){let g=new THREE.Group();g.position.set(x,0,z);scene.add(g);let h=floors*.7;
  if(opt.canteen){
   // The supplied guide and completion aerial show a low white building by
   // the sports area with a recessed upper terrace and a glazed inner wall.
   // Unseen elevations, orientation and dimensions remain illustrative.
   const bodyH=1.45;
   box(0,.25+bodyH/2,0,w,bodyH,d,m.white,g);
   for(let side of [-1,1]){
    for(let row=0;row<2;row++){
     const y=.60+row*.65;
     box(0,y,side*(d/2+.025),w-.18,.42,.05,m.deep,g);
     box(side*(w/2+.025),y,0,.05,.42,d-.15,m.deep,g);
     for(let i=1;i<11;i++)box(-w/2+i*w/11,y,side*(d/2+.055),.045,.42,.04,m.frame,g);
     for(let i=1;i<7;i++)box(side*(w/2+.055),y,-d/2+i*d/7,.04,.42,.045,m.frame,g);
     box(0,y+.25,side*(d/2+.065),w+.08,.09,.10,m.white,g);
     box(side*(w/2+.065),y+.25,0,.10,.09,d+.08,m.white,g);
    }
   }
   // Raised rear roof volume, an inset terrace, and pale parapets preserve
   // the recognisable hollow silhouette seen from above, without asserting
   // a surveyed floor plan or an accessible rooftop in the game.
   box(0,1.74,0,w+.18,.12,d+.18,m.frame,g);
   box(0,1.82,d*.12,w*.70,.035,d*.59,m.paving,g);
   box(0,2.14,-d*.33,w,.78,d*.34,m.white,g);
   box(0,2.10,-d*.15,w*.70,.53,.05,m.deep,g);
   for(let i=0;i<=12;i++)box(-w*.35+i*w*.70/12,2.10,-d*.12,.035,.53,.04,m.frame,g);
   box(0,2.57,-d*.33,w+.08,.12,d*.36,m.white,g);
   for(let side of [-1,1])box(side*w*.43,1.98,d*.16,w*.14,.42,d*.68,m.white,g);
   box(0,1.98,d*.46,w*.72,.36,.13,m.white,g);
   for(let xOff of [-w*.28,-w*.19,-w*.10]){box(xOff,2.66,-d*.34,.23,.12,.28,m.roof,g);box(xOff,2.73,-d*.34,.25,.025,.30,m.frame,g)}
   // A shallow entrance awning sits above the existing approximate entrance.
   box(0,1.14,-d/2-.10,w*.36,.09,.27,m.white,g);
   label(name,x,3.3,z,.9);block.push({x,z,w:w+.6,d:d+.6});return g;
  }
  if(opt.conference){
   // The event guide shows a slender glazed tower above a broad low podium.
   // Dimensions, entrance location and the unseen elevations are illustrative.
   const towerW=w*.72,towerD=d*.52,towerZ=-d*.20;
   box(0,.78,0,w,1.05,d,m.white,g);
   for(let side of [-1,1]){box(0,.72,side*(d/2+.015),w-.20,.45,.04,m.deep,g);for(let j=1;j<9;j++)box(-w/2+j*w/9,.72,side*(d/2+.04),.035,.45,.04,m.frame,g)}
   box(0,1.35,0,w+.05,.13,d+.05,m.frame,g);box(0,1.46,d*.22,w*.82,.09,d*.40,m.roof,g);
   box(0,h/2+.28,towerZ,towerW,h,towerD,m.glass,g);
   // Pale vertical fins and fine glazing strips distinguish it from dorms.
   for(let side of [-1,1]){
    box(0,h/2+.3,towerZ+side*(towerD/2+.02),towerW-.1,h-.14,.035,m.deep,g);
    for(let j=0;j<=10;j++)box(-towerW/2+j*towerW/10,h/2+.3,towerZ+side*(towerD/2+.05),.04,h,.045,m.frame,g);
    for(let row=1;row<floors;row++)box(0,.28+row*h/floors,towerZ+side*(towerD/2+.06),towerW,.045,.05,m.shade,g);
    box(side*(towerW/2+.03),h/2+.3,towerZ,.055,h,towerD+.1,m.frame,g);
   }
   box(0,h+.34,towerZ,towerW+.12,.16,towerD+.12,m.white,g);
   box(-towerW*.22,h+.49,towerZ,.36,.15,towerD*.38,m.roof,g);box(towerW*.20,h+.49,towerZ,.38,.15,towerD*.38,m.roof,g);
   label(name,x,h+1.35,z,1.02);block.push({x,z,w:w+.6,d:d+.6});return g;
  }
  if(opt.gym){
   // Broad, low sports hall with a pale roof and tall upper windows, as seen
   // in the supplied guide and completion aerial. Dimensions are estimated.
   const roof=mat(0xd4c8a9),roofEdge=mat(0xb4b09e);
   box(0,1.03,0,w,1.55,d,m.white,g);
   for(let side of [-1,1]){
    // The two elevations are stylised because only portions are visible.
    box(0,1.43,side*(d/2+.02),w-.25,.62,.045,m.deep,g);
    for(let j=1;j<15;j++)box(-w/2+j*w/15,1.43,side*(d/2+.055),.065,.64,.055,m.frame,g);
    box(side*(w/2+.02),1.43,0,.045,.62,d-.18,m.deep,g);
    for(let j=1;j<10;j++)box(side*(w/2+.055),1.43,-d/2+j*d/10,.055,.64,.065,m.frame,g);
    box(0,.38,side*(d/2+.05),w,.22,.1,m.shade,g);
   }
   box(0,1.92,0,w+.16,.22,d+.16,m.frame,g);
   box(0,2.06,0,w-.18,.08,d-.18,roof,g);
   for(let k=0;k<8;k++)box(0,2.105,-d*.36+k*d*.10,w-.38,.012,.018,roofEdge,g);
   // A narrow rooftop service strip is visible in the aerial image.
   box(0,2.18,-d*.35,w*.65,.18,.32,m.shade,g);
   for(let k=-4;k<=4;k++)box(k*w*.068,2.29,-d*.35,.07,.08,.19,m.roof,g);
   label(name,x,3.15,z,.9);block.push({x,z,w:w+.6,d:d+.6});return g;
  }
  if(opt.research){
   // Reference: the user's activity guide depicts a long, stepped low-rise
   // research building with continuous glazing and inset rooftop courts.
   // Shape and facade rhythm are interpreted; no surveyed heights available.
   const baseHeight=1.62;
   box(0,baseHeight/2+.25,0,w,baseHeight,d,m.white,g);
   for(let level=0;level<2;level++){
    let y=.64+level*.67;
    for(let side of [-1,1]){
     box(0,y,side*(d/2+.02),w-.18,.43,.045,m.deep,g);
     box(side*(w/2+.02),y,0,.045,.43,d-.1,m.deep,g);
     for(let col=1;col<14;col++)box(-w/2+col*w/14,y,side*(d/2+.05),.035,.43,.035,m.frame,g);
     box(0,y+.28,side*(d/2+.06),w+.05,.09,.08,m.white,g);
    }
   }
   // The guide depicts several recessed rooftop courts. Build perimeter
   // walls and cross-wings around three closed-bottom wells instead of using
   // raised roof blocks. Count, proportions and details remain illustrative.
   box(0,2.04,0,w-.35,.17,d-.25,m.frame,g);
   const upperY=2.40,upperH=.62,roofW=w-.45,sideD=.34,innerD=d-2*sideD,holeW=roofW*.235,rib=(roofW-3*holeW)/4;
   for(let side of [-1,1]){
    box(0,upperY,side*(d/2-sideD/2),roofW,upperH,sideD,m.white,g);
    box(0,2.77,side*(d/2-sideD/2),roofW+.08,.12,sideD+.08,m.frame,g);
   }
   for(let k=0;k<4;k++){
    let xx=-roofW/2+rib/2+k*(rib+holeW);
    box(xx,upperY,0,rib,upperH,innerD,m.white,g);
    box(xx,2.77,0,rib+.05,.12,innerD,m.frame,g);
   }
   for(let k=0;k<3;k++){
    let xx=-roofW/2+rib+holeW/2+k*(rib+holeW);
    box(xx,2.15,0,holeW-.08,.035,innerD-.08,m.deep,g);
    box(xx,2.18,0,holeW*.70,.025,innerD*.65,m.roof,g);
    for(let side of [-1,1])box(xx,2.4,side*(innerD/2-.025),holeW-.08,.34,.035,m.glass,g);
   }
   // The guide shows a short return at one end. It shares the same two
   // glazed facade bands; the shape and depth are an interpretation.
   {let wing=researchFootprints(x,z,w,d)[1],wx=wing.x-x,wz=wing.z-z;
    box(wx,baseHeight/2+.25,wz,wing.w,baseHeight,wing.d,m.white,g);
    for(let row=0;row<2;row++)for(let side of [-1,1]){let y=.64+row*.67;
     box(wx,y,wz+side*(wing.d/2+.025),wing.w-.10,.43,.05,m.deep,g);
     box(wx+side*(wing.w/2+.025),y,wz,.05,.43,wing.d-.10,m.deep,g);
     for(let j=1;j<4;j++)box(wx-wing.w/2+j*wing.w/4,y,wz+side*(wing.d/2+.055),.035,.43,.04,m.frame,g);
     for(let j=1;j<5;j++)box(wx+side*(wing.w/2+.055),y,wz-wing.d/2+j*wing.d/5,.04,.43,.035,m.frame,g);
     box(wx,y+.28,wz+side*(wing.d/2+.06),wing.w+.05,.09,.08,m.white,g);
     box(wx+side*(wing.w/2+.06),y+.28,wz,.08,.09,wing.d+.05,m.white,g);
    }
    box(wx,2.04,wz,wing.w+.08,.17,wing.d+.08,m.frame,g);
    box(wx,2.32,wz,wing.w-.16,.45,wing.d-.16,m.shade,g);
    box(wx,2.58,wz,wing.w-.10,.10,wing.d-.10,m.white,g);
   }
   label(name,x,3.75,z,1.02);for(const footprint of researchFootprints(x,z,w,d))block.push({...footprint,w:footprint.w+.6,d:footprint.d+.6});return g;
  }
  if(opt.science){
   // The supplied event guide shows 9号 as a broad low podium and offset
   // stacked upper volumes, distinct from the open-courtyard 1号 building.
   // The concealed elevations, dimensions and exact storeys are illustrative.
   function tier(cx,cy,cz,tw,th,td){
    box(cx,cy,cz,tw,th,td,m.white,g);
    for(let side of [-1,1]){
     box(cx,cy,cz+side*(td/2+.025),tw-.14,th*.42,.05,m.deep,g);
     box(cx+side*(tw/2+.025),cy,cz,.05,th*.42,td-.14,m.deep,g);
     for(let j=1;j<Math.max(2,Math.round(tw/.48));j++)box(cx-tw/2+j*tw/Math.max(2,Math.round(tw/.48)),cy,cz+side*(td/2+.055),.035,th*.42,.035,m.frame,g);
     for(let j=1;j<Math.max(2,Math.round(td/.48));j++)box(cx+side*(tw/2+.055),cy,cz-td/2+j*td/Math.max(2,Math.round(td/.48)),.035,th*.42,.035,m.frame,g);
    }
    box(cx,cy+th/2+.06,cz,tw+.12,.12,td+.12,m.frame,g);
   }
   tier(0,.72,0,w,1.0,d);
   tier(-w*.06,1.67,-d*.05,w*.86,.82,d*.79);
   tier(w*.12,2.46,-d*.10,w*.58,.70,d*.60);
   box(-w*.30,1.34,d*.30,w*.25,.055,d*.27,m.roof,g);
   box(w*.12,2.86,-d*.10,w*.47,.08,d*.48,m.white,g);
   box(w*.12,2.91,-d*.10,w*.31,.025,d*.27,m.shade,g);
   label(name,x,3.65,z,1.05);block.push({x,z,w:w+.6,d:d+.6});return g;
  }
  if(opt.courtyard){
   // Three wings around an open courtyard, inspired by the supplied aerial
   // guide. Orientation, floor count and openings still need field checking.
   const mullions=[],mullionGeometry=new THREE.BoxGeometry(1,1,1),instanceTransform=new THREE.Object3D();
   for(const wing of courtyardFootprints(x,z,w,d)){let wx=wing.x-x,wz=wing.z-z;box(wx,h/2+.25,wz,wing.w,h,wing.d,m.white,g);box(wx,h+.32,wz,wing.w+.10,.22,wing.d+.10,m.shade,g);box(wx,h+.48,wz,wing.w-.08,.12,wing.d-.08,m.white,g);
    // Continuous glazing with light vertical frames and projecting floor bands
    // makes the lab read as an articulated building from all four angles.
    const nx=Math.max(2,Math.round(wing.w/.42)),nz=Math.max(2,Math.round(wing.d/.42));
    for(let row=0;row<floors;row++){let y=.62+row*.7;for(let side of [-1,1]){
     box(wx,y,wz+side*(wing.d/2+.025),wing.w-.12,.43,.05,m.deep,g);
     box(wx+side*(wing.w/2+.025),y,wz,.05,.43,wing.d-.12,m.deep,g);
     box(wx,y+.26,wz+side*(wing.d/2+.06),wing.w+.05,.09,.09,m.white,g);
     box(wx+side*(wing.w/2+.06),y+.26,wz,.09,.09,wing.d+.05,m.white,g);
     for(let j=1;j<nx;j++)mullions.push([wx-wing.w/2+j*wing.w/nx,y,wz+side*(wing.d/2+.06),.035,.43,.04]);
     for(let j=1;j<nz;j++)mullions.push([wx+side*(wing.w/2+.06),y,wz-wing.d/2+j*wing.d/nz,.04,.43,.035]);
    }}
    // Shallow rooftop setbacks and dark roof panels are an interpretation of
    // the guide, not openings or a measured mechanical equipment layout.
    box(wx,h+.57,wz,wing.w*.72,.08,wing.d*.70,m.roof,g);
    box(wx,h+.63,wz,wing.w*.53,.035,wing.d*.47,m.deep,g);
    for(let k=-1;k<=1;k++)box(wx+k*wing.w*.13,h+.66,wz,.025,.025,wing.d*.47,m.frame,g);
    block.push({x:wing.x,z:wing.z,w:wing.w+.6,d:wing.d+.6});
   }
   const frames=new THREE.InstancedMesh(mullionGeometry,m.frame,mullions.length);mullions.forEach(([px,py,pz,pw,ph,pd],i)=>{instanceTransform.position.set(px,py,pz);instanceTransform.scale.set(pw,ph,pd);instanceTransform.updateMatrix();frames.setMatrixAt(i,instanceTransform.matrix)});frames.instanceMatrix.needsUpdate=true;g.add(frames);
   // Courtyard paving and inset bands suggest the landscaped open space in
   // the supplied illustration; they do not assert a precise floor plan.
   box(0,.20,d*.10,w*.54,.06,d*.65,m.paving,g);
   box(0,.24,d*.17,w*.36,.025,d*.35,m.shade,g);
   for(let s of [-1,1])box(s*w*.15,.26,d*.17,.035,.025,d*.35,m.white,g);
   label(name,x,h+1.35,z,1.05);return g;
  }
  if(opt.dorm){let wing=w*3/7;for(let side of [-1,1]){
   if(name==='宿舍 A'&&side===-1){
    // Split this wing around a shallow, open-front recess; the back remains
    // solid because the actual internal layout is unknown.
    let depth=.36,openingW=w*2/7,cx=-w*3/14,low=1.05,high=2.21;
    box(side*w*2/7,h/2+.25,-depth/2,wing,h,d-depth,m.white,g);
    box(-w*3/7,h/2+.25,d/2-depth/2,w/7,h,depth,m.white,g);
    box(cx,(.25+low)/2,d/2-depth/2,openingW,low-.25,depth,m.white,g);
    box(cx,(high+h+.25)/2,d/2-depth/2,openingW,h+.25-high,depth,m.white,g);
   }else box(side*w*2/7,h/2+.25,0,wing,h,d,m.white,g)
  }box(0,h/2+.25,0,w/7,h,d*.76,m.white,g)}else box(0,h/2+.25,0,w,h,d,m.white,g);
  box(0,h+.32,0,w+.25,.22,d+.25,m.shade,g);box(0,h+.48,0,w-.25,.12,d-.25,m.white,g);
  // Generic window bands cover all four sides when orbiting; exact fenestration
  // remains provisional until reference photos of each elevation are available.
  const panes=new Map();function pane(x,y,z,w,h,d,material){if(!panes.has(material))panes.set(material,[]);panes.get(material).push([x,y,z,w,h,d])}
  let cols=opt.dorm?7:Math.max(2,Math.floor(w/.68)),rows=floors;
  if(opt.bands||opt.wing){
   // The entrance photo shows long dark horizontal glazing in white facades;
   // the building identification and exact window pattern need confirmation.
   for(let row=0;row<rows;row++)for(let side of [1,-1]){pane(0,.62+row*.7,side*(d/2+.015),w-.15,.38,.05,m.deep);for(let col=1;col<cols;col++)pane(-w/2+col*w/cols,.62+row*.7,side*(d/2+.05),.035,.38,.035,m.frame)}
  }else for(let row=0;row<rows;row++)for(let col=0;col<cols;col++){let xx=-w/2+(col+.5)*w/cols;for(let side of [1,-1]){if(name==='宿舍 A'&&side===1&&(row===1||row===2)&&(col===1||col===2))continue;let warm=opt.dorm&&col===3,face=warm?d*.38:d/2;let pw=Math.max(.12,w/cols-.13);pane(xx,.62+row*.7,side*(face+.015),pw,.48,.045,warm?m.brown:opt.tower?m.deep:m.glass);if(opt.dorm&&!warm){pane(xx,.49+row*.7,side*(face+.045),Math.max(.1,w/cols-.2),.045,.035,m.shade);pane(xx,.72+row*.7,side*(face+.044),.025,.25,.025,m.frame)}if(warm){pane(xx,.68+row*.7,side*(face+.044),pw*.85,.16,.025,m.deep);pane(xx,.48+row*.7,side*(face+.052),pw*.9,.045,.035,m.frame)}}}
  for(let row=0;row<rows;row++){for(let side of [1,-1]){let y=.33+row*.7;if(opt.dorm){for(let wing of [-1,1]){if(name==='宿舍 A'&&side===1&&wing===-1&&row===2)box(-w*3/7,y,side*(d/2+.045),w/7,.07,.08,m.frame,g);else box(wing*w*2/7,y,side*(d/2+.045),w*3/7,.07,.08,m.frame,g)}box(0,y,side*(d*.38+.045),w/7,.07,.08,m.frame,g)}else box(0,y,side*(d/2+.045),w,.07,.08,m.frame,g)}}
  if(opt.dorm)for(let col=0;col<=cols;col++){let xx=-w/2+col*w/cols;for(let side of [1,-1]){if(name==='宿舍 A'&&side===1&&col===2){box(xx,(.25+1.05)/2,side*(d/2+.055),.065,.8,.08,m.white,g);box(xx,(2.21+h+.25)/2,side*(d/2+.055),.065,h+.25-2.21,.08,m.white,g)}else box(xx,h/2+.25,side*(d/2+.055),.065,h,.08,m.white,g)}}
  for(let i=0;i<Math.max(1,Math.floor(d/.8));i++){let zz=-d/2+(i+.5)*d/Math.max(1,Math.floor(d/.8));for(let row=0;row<rows;row++)for(let side of [1,-1])pane(side*(w/2+.02),.62+row*.7,zz,.04,.43,.54,opt.tower?m.deep:m.glass)}
  const paneGeometry=new THREE.BoxGeometry(1,1,1),transform=new THREE.Object3D();for(const [material,items] of panes){let mesh=new THREE.InstancedMesh(paneGeometry,material,items.length);items.forEach(([x,y,z,w,h,d],i)=>{transform.position.set(x,y,z);transform.scale.set(w,h,d);transform.updateMatrix();mesh.setMatrixAt(i,transform.matrix)});mesh.instanceMatrix.needsUpdate=true;mesh.receiveShadow=true;g.add(mesh)}
  if(opt.bands){
   // Long glazed facades and rooftop openings are suggested by the campus
   // guides; exact openings, floor heights and entrances are not surveyed.
   for(let side of [-1,1]){
    box(0,.75,side*(d/2+.075),w*.27,.95,.07,m.deep,g);
    for(let j=-2;j<=2;j++)box(j*w*.055,.75,side*(d/2+.12),.035,.95,.035,m.frame,g);
    box(0,1.32,side*(d/2+.17),w*.37,.10,.35,m.white,g);
   }
   for(let side of [-1,1])box(0,h+.58,side*(d/2-.18),w-.35,.16,.12,m.frame,g);
   for(let side of [-1,1])box(side*(w/2-.18),h+.58,0,.12,.16,d-.35,m.frame,g);
   for(let xx of [-w*.30,0,w*.30]){
    box(xx,h+.56,0,w*.22,.06,d*.48,m.deep,g);
    box(xx,h+.60,0,w*.17,.03,d*.39,m.roof,g);
    for(let zz of [-.33,0,.33])box(xx,h+.625,zz,w*.17,.018,.035,m.frame,g);
   }
  }
  if(opt.wing){
   // In the user's aerial guide the western research complex has low,
   // horizontally layered glazed wings with pale framing and roof setbacks.
   // The unobserved elevations and these dimensions remain approximate.
   for(let side of [-1,1]){
    box(side*(w/2-.12),h/2+.25,side*(d/2+.065),.18,h,.11,m.white,g);
    for(let row=0;row<rows;row++)box(0,.88+row*.7,side*(d/2+.075),w+.12,.08,.12,m.white,g);
   }
   box(0,h+.59,0,w*.72,.10,d*.65,m.shade,g);
   box(0,h+.65,0,w*.53,.035,d*.43,m.deep,g);
   for(let xx of [-.23,0,.23])box(xx*w,h+.68,0,.035,.02,d*.43,m.frame,g);
  }
  if(opt.dorm){
   // A pale structural grid, warm recessed central strip and rooftop equipment
   // are inspired by the completion aerial; exact floors and elevations are approximate.
   for(let side of [-1,1]){box(0,.28,side*(d/2+.07),w*.82,.18,.13,m.brown,g);box(0,.41,side*(d/2+.10),w*.82,.07,.20,m.white,g)}
   // Ground-floor glazed entrance and a shallow canopy animate the base.
   // Their placement is a game interpretation of the aerial, not a verified door.
   box(0,.78,d/2+.095,w*.28,.84,.07,m.deep,g);
   for(let xx of [-w*.12,0,w*.12])box(xx,.78,d/2+.14,.035,.85,.035,m.frame,g);
   box(0,1.28,d/2+.23,w*.42,.10,.42,m.white,g);
   box(0,.30,d/2+.30,w*.43,.08,.42,m.frame,g);
   // The completion aerial shows a large warm-edged recessed communal
   // opening low on one residence elevation. This shallow, closed-back recess is
   // applied to one game tower only; the actual A/B/C correspondence, floor
   // and dimensions are not established by the photograph.
   if(name==='宿舍 A'){
    let cx=-w*3/14,cz=d/2,openingW=w*2/7,openingH=1.16,cy=1.63;
    box(cx,cy,cz-.35,openingW,openingH,.025,m.deep,g);
    box(cx,cy-openingH/2+.07,cz-.08,openingW+.08,.14,.35,m.brown,g);
    box(cx,cy+openingH/2-.06,cz-.06,openingW+.08,.12,.25,m.white,g);
    for(let side of [-1,1])box(cx+side*(openingW/2+.02),cy,cz-.06,.08,openingH,.25,m.white,g);
    box(cx,cy-.20,cz+.03,openingW,.05,.06,m.frame,g);
    for(let xx of [-.28,0,.28])box(cx+xx*openingW,cy-.33,cz+.03,.025,.28,.04,m.frame,g);
   }
   // The aerial shows a central service volume, repeated sloping panels and
   // metallic roof equipment. Placement, counts and equipment type are an
   // artistic approximation, not an engineering inventory.
   box(0,h+.68,0,w*.54,.34,d*.38,m.shade,g);box(0,h+.88,0,w*.56,.08,d*.40,m.white,g);
   for(let side of [-1,1]){
    for(let j=0;j<7;j++){let xx=-w*.35+j*w*.70/6;let panel=box(xx,h+.65,side*d*.32,w*.075,.035,d*.23,m.roof,g);panel.rotation.x=side*.30}
    box(0,h+.75,side*d*.25,w*.77,.045,.04,m.frame,g);
    let tank=cylinder(side*w*.39,h+.78,0,.14,.14,.48,m.frame,g,12);tank.rotation.z=Math.PI/2;
    for(let zz of [-.13,.13])box(side*w*.39,h+.57,zz,.40,.07,.05,m.shade,g);
   }
  }
  if(opt.roof){box(-w*.22,h+.6,0,w*.28,.18,d*.35,m.roof,g);box(w*.22,h+.6,0,w*.23,.18,d*.3,m.roof,g)}
  label(name,x,h+1.35,z,Math.min(1.1,.55+w/15));block.push({x,z,w:w+.6,d:d+.6});return g}
 // The stepped low-rise research podium in the supplied event guide, joined to the western complex.
 building('8号产研楼',-17,-3.8,7,2.4,3,{research:true});
 // The supplied aerial guide shows low research wings and a taller conference
 // centre. Floor counts and footprints remain illustrative estimates.
 building('9号科研实验楼',-15,-8,7,4,4,{science:true});building('产研楼东塔',-24,-7,3.2,2.8,4,{wing:true});building('产研楼西塔',-20,-6,3.2,3,4,{wing:true});building('学术交流中心',-25,-13,3,2.8,10,{conference:true});building('教师周转房',-20,-14,3,3,11,{tower:true});
 building('行政楼',3,-6,6,3.5,4,{bands:true});building('教学楼',10,-7,6,3.2,5,{bands:true});building('1号实验楼',8,3,8,5,5,{courtyard:true});
 // Low open corridors link the shared buildings, as in the campus aerial guide.
 // An elevated glass connection suggests the continuous teaching/administration complex.
 box(6.5,2.1,-6.5,1.4,1.05,1.15,m.glass);box(6.5,2.68,-6.5,1.55,.12,1.3,m.white);for(let z of [-7,-6])box(6.5,2.1,z,1.45,.09,.08,m.frame);
 box(2.1,1.55,-2.3,6,.75,1.1,m.glass);box(2.1,2,-2.3,6,.12,1.2,m.white);for(let x of [0,2,4])box(x,.75,-2.3,.16,1.5,.18,m.white);
 box(-12,1.5,-4.8,4,.72,1.05,m.glass);box(-12,1.92,-4.8,4,.12,1.2,m.white);
 // In the user's aerial guide the middle residence sits behind its neighbours;
 // the offset and the A/B/C correspondence are approximate, not surveyed.
 building('宿舍 A',16,-5.5,3.2,2.6,10,{tower:true,dorm:true});building('宿舍 B',20,-7,3.2,2.6,10,{tower:true,dorm:true});building('宿舍 C',24,-5.5,3.2,2.6,10,{tower:true,dorm:true});
 building('体育馆',12,10.4,6,4.3,3,{gym:true});building('食堂',23,5.8,4.5,3,3,{canteen:true});
 // The 2024 completion aerial shows a blue, straight-sided track around a
 // striped rectangular football pitch. Dimensions remain illustrative.
 function capsulePoints(cx,cz,straight,r,n=24){let pts=[];for(let i=0;i<=n;i++){let a=-Math.PI/2+i*Math.PI/n;pts.push([cx+straight/2+Math.cos(a)*r,cz+Math.sin(a)*r])}for(let i=0;i<=n;i++){let a=Math.PI/2+i*Math.PI/n;pts.push([cx-straight/2+Math.cos(a)*r,cz+Math.sin(a)*r])}return pts}
 function surface(points,y,material){let s=new THREE.Shape();points.forEach(([x,z],i)=>i?s.lineTo(x,-z):s.moveTo(x,-z));s.closePath();let mesh=new THREE.Mesh(new THREE.ShapeGeometry(s),material);mesh.rotation.x=-Math.PI/2;mesh.position.y=y;mesh.receiveShadow=true;scene.add(mesh);return mesh}
 const lineMat=new THREE.LineBasicMaterial({color:0xf2f6ec});
 function marking(points,y=.39,closed=false){let pts=points.map(([x,z])=>new THREE.Vector3(x,y,z));scene.add(new (closed?THREE.LineLoop:THREE.Line)(new THREE.BufferGeometry().setFromPoints(pts),lineMat))}
 surface(capsulePoints(20,11,3.25,2.8),.22,m.sports);
 for(let r of [2.25,2.38,2.51,2.64])marking(capsulePoints(20,11,3.25,r),.25,true);
 box(20,.27,11,6.1,.06,3.1,m.grassDark);for(let i=0;i<6;i++)box(17.46+i*1.02,.31,11,.51,.015,3.08,m.grass);
 marking([[16.95,9.45],[23.05,9.45],[23.05,12.55],[16.95,12.55]],.33,true);marking([[20,9.45],[20,12.55]],.33);marking(Array.from({length:33},(_,i)=>[20+Math.cos(i*Math.PI*2/32)*.54,11+Math.sin(i*Math.PI*2/32)*.54]),.33);for(let side of [-1,1]){let x=20+side*3.05;marking([[x,10.15],[x-side*.8,10.15],[x-side*.8,11.85],[x,11.85]],.33);
  // Small goal frames are illustrative; dimensions are not surveyed.
  for(let z of [10.55,11.45])box(x,.65,z,.045,.68,.045,m.white);box(x,.99,11,.045,.045,.94,m.white);
 }label('运动场',20,1.5,11,.8);
 // The completion aerial shows a blue court with dark centre circles and
 // light markings. The guide informs the game layout; court count, orientation
 // and dimensions remain unverified.
 box(18,.2,-.5,6,.1,3,m.blue);const courtPaint=mat(0xd5c9a7),courtCentre=mat(0x3d7699);
 for(let cx of [16,18,20]){let left=cx-.9,right=cx+.9,near=.85,far=-1.85;
  marking([[left,far],[right,far],[right,near],[left,near]],.27,true);marking([[left,-.5],[right,-.5]],.27);
  let centre=Array.from({length:24},(_,i)=>[cx+Math.cos(i*Math.PI*2/24)*.23,-.5+Math.sin(i*Math.PI*2/24)*.23]);surface(centre,.255,courtCentre);marking(centre,.27,true);
  for(let side of [-1,1]){let end=side<0?far:near,arc=Array.from({length:17},(_,i)=>{let a=i*Math.PI/16;return [cx+Math.cos(a)*.70,end-side*Math.sin(a)*.70]});
   surface([[cx-.31,end],[cx+.31,end],[cx+.31,end-side*.55],[cx-.31,end-side*.55]],.255,courtPaint);marking(arc,.275);marking([[cx-.31,end],[cx-.31,end-side*.55],[cx+.31,end-side*.55],[cx+.31,end]],.28);
   box(cx,.72,end+side*.08,.07,.95,.07,m.dark);box(cx,1.15,end-side*.08,.07,.07,.30,m.dark);box(cx,1.27,end-side*.20,.55,.35,.06,m.white);
   let rim=new THREE.Mesh(new THREE.TorusGeometry(.12,.025,6,12),m.red);rim.rotation.x=Math.PI/2;rim.position.set(cx,1.12,end-side*.33);scene.add(rim);
  }
 }
 // A public entrance photograph shows a low pale school-name stone, dark
 // fence and a guard booth. Its exact correspondence to North Gate 1 remains
 // unverified, so the spacing and position here are interpretive.
 function nameStone(x,z){box(x,.55,z,4.5,.85,.34,m.frame);box(x,.14,z,4.9,.10,.65,m.grassDark);let c=document.createElement('canvas');c.width=512;c.height=128;let a=c.getContext('2d');a.fillStyle='#d9dfd4';a.fillRect(0,0,c.width,c.height);a.fillStyle='#233d39';a.textAlign='center';a.textBaseline='middle';a.font='bold 80px serif';a.fillText('大湾区大学',256,66);let tex=new THREE.CanvasTexture(c);tex.colorSpace=THREE.SRGBColorSpace;tex.magFilter=THREE.NearestFilter;let face=new THREE.Mesh(new THREE.PlaneGeometry(4.35,.75),new THREE.MeshBasicMaterial({map:tex}));face.position.set(x,.57,z+.20);scene.add(face)}
 function guardBooth(x,z){box(x,.77,z,1.55,1.25,1.2,m.glass);for(let dx of [-.71,.71])for(let dz of [-.55,.55])box(x+dx,.77,z+dz,.10,1.27,.10,m.frame);box(x,1.47,z,1.85,.16,1.48,m.deep);box(x,1.57,z,1.9,.05,1.53,m.frame)}
 nameStone(-10.3,14.7);guardBooth(-3.8,14.3);for(let x=-16;x<-12.7;x+=.28)box(x,.42,14.7,.035,.62,.045,m.dark);box(-14.4,.73,14.7,3.3,.06,.06,m.dark);box(-14.4,.16,14.7,3.3,.06,.06,m.dark);
 // Low planted strip at the sign is inspired by the entrance photo; the
 // species, exact alignment and the gate number remain unverified.
 for(let i=0;i<22;i++){let x=-12.5+i*.21;sphere(x,.20,15.01,.13,i%4?m.bush:m.leaves2,scene,0);if(i%4===1)box(x,.30,15.07,.055,.05,.055,m.red)}
 label('北一门',-7,2.2,15,.68);
 // Game gate at the entry: it replays actual RTL outputs after the mission.
 // Placement, gate mechanism and vehicle are illustrative, not surveyed details.
 const gateLampMat=mat(0x998e67,{emissive:0x000000});box(-4.85,.55,13.75,.20,1,.22,m.dark);let gateLamp=box(-4.85,1.17,13.75,.22,.22,.22,gateLampMat);let gateBoom=new THREE.Group();gateBoom.position.set(-4.85,1.03,13.75);scene.add(gateBoom);box(-1.13,0,0,2.26,.12,.15,m.white,gateBoom);for(let i=0;i<5;i++)box(-.25-i*.43,.075,0,.20,.025,.17,m.red,gateBoom);
 let gateVehicle=new THREE.Group();scene.add(gateVehicle);box(0,.39,0,.7,.45,1.05,m.red,gateVehicle);box(0,.70,.17,.62,.22,.50,m.white,gateVehicle);for(let x of [-.39,.39])for(let z of [-.31,.31])box(x,.22,z,.11,.25,.23,m.dark,gateVehicle);gateVehicle.position.set(-6.2,0,15.1);gateVehicle.visible=false;
 let gateDemo=null,gateLift=0;function cancelGateDemo(){if(!gateDemo)return;let done=gateDemo.finish;gateDemo=null;gateVehicle.visible=false;gateLampMat.color.setHex(0x998e67);done(false)}
 function playGateTrace(rows,onSample,finish){if(!Array.isArray(rows)||!rows.length)return false;cancelReplay();gateDemo={rows,onSample,finish,index:-1,elapsed:0};gateVehicle.visible=true;return true}
 function updateGateDemo(dt){if(!gateDemo){gateLift+=(0-gateLift)*Math.min(1,dt*5);gateBoom.rotation.z=-1.15*gateLift;return}let d=gateDemo;d.elapsed+=dt;let index=Math.min(d.rows.length-1,Math.floor(d.elapsed/1.35));if(index!==d.index){d.index=index;let r=d.rows[index];gateLampMat.color.setHex(r.actual===1?0x65d987:r.actual===0?0xd66f5c:0xd6b966);d.onSample(r)}let r=d.rows[index],goal=r.actual===1?1:0;gateLift+=(goal-gateLift)*Math.min(1,dt*5);gateBoom.rotation.z=-1.15*gateLift;gateVehicle.position.z=15.1-2.0*gateLift;if(d.elapsed>=d.rows.length*1.35){let done=d.finish;gateDemo=null;gateVehicle.visible=false;gateLampMat.color.setHex(0x998e67);done(true)}}

 // Data cargo beside the library is a game representation. Its label and
 // number of trips come from the actual adder samples, not preset animation.
 const cargo=new THREE.Group();scene.add(cargo);cargo.visible=false;box(0,.45,0,.9,.55,.65,m.brown,cargo);box(0,.76,0,.98,.10,.72,m.gold,cargo);for(let xx of [-.38,.38])for(let zz of [-.25,.25]){let wheel=cylinder(xx,.18,zz,.15,.15,.12,m.dark,cargo,12);wheel.rotation.z=Math.PI/2}
 let bridgeDemo=null,cargoLabel=null;
 function clearCargoLabel(){if(!cargoLabel)return;cargo.remove(cargoLabel);cargoLabel.material.map.dispose();cargoLabel.material.dispose();cargoLabel=null}
 function cancelBridgeDemo(){if(!bridgeDemo)return;let done=bridgeDemo.finish;bridgeDemo=null;cargo.visible=false;clearCargoLabel();done(false)}
 function cancelReplay(){cancelGateDemo();cancelBridgeDemo();cancelFSMDemo()}
 function playBridgeTrace(rows,onSample,finish){if(!Array.isArray(rows)||!rows.length||rows.some(r=>!Number.isInteger(r.actual)||r.actual<0||r.actual>31))return false;cancelReplay();bridgeDemo={rows,onSample,finish,index:-1,elapsed:0};cargo.position.set(-1.4,0,5.0);cargo.visible=true;return true}
 function updateBridgeDemo(dt){if(!bridgeDemo)return;let demo=bridgeDemo;demo.elapsed+=dt;let index=Math.min(demo.rows.length-1,Math.floor(demo.elapsed/1.8));if(index!==demo.index){demo.index=index;let r=demo.rows[index];clearCargoLabel();cargoLabel=textSprite(`${r.a}+${r.b}=${r.actual}`,.67);cargoLabel.position.set(0,1.45,0);cargo.add(cargoLabel);demo.onSample(r)}let phase=(demo.elapsed-index*1.8)/1.8;cargo.position.x=-1.4+3.4*Math.min(1,phase);cargo.position.y=.04+Math.abs(Math.sin(phase*Math.PI*4))*.05;if(demo.elapsed>=demo.rows.length*1.8){let done=demo.finish;bridgeDemo=null;cargo.visible=false;clearCargoLabel();done(true)}}

 // A temporary three-node display near the teaching station visualises the
 // actual state and alarm sampled after each RTL clock edge.
 const fsmScene=new THREE.Group();fsmScene.position.set(0,.1,7.5);scene.add(fsmScene);fsmScene.visible=false;const fsmNodes=[];
 // Compact teaching labels keep the two-character state large and readable.
 // They are screen-facing annotations, so nearby scenery cannot hide them.
 function stateLabel(text,x){let c=document.createElement('canvas');c.width=128;c.height=96;let a=c.getContext('2d');a.imageSmoothingEnabled=false;a.fillStyle='#294f4b';a.fillRect(2,5,124,86);a.fillStyle='#d6e8ba';a.fillRect(7,10,114,76);a.fillStyle='#284c49';a.fillRect(12,15,104,66);a.fillStyle='#fff5d5';a.font='bold 58px sans-serif';a.textAlign='center';a.textBaseline='middle';a.fillText(text,64,49);let texture=new THREE.CanvasTexture(c);texture.colorSpace=THREE.SRGBColorSpace;texture.magFilter=texture.minFilter=THREE.NearestFilter;let sprite=new THREE.Sprite(new THREE.SpriteMaterial({map:texture,transparent:true,depthTest:false,depthWrite:false}));sprite.position.set(x,1.48,0);sprite.scale.set(1.15,.86,1);sprite.renderOrder=100;fsmScene.add(sprite)}
 for(let i=0;i<3;i++){let x=(i-1)*1.7,material=mat(0x557b72,{emissive:0x000000});cylinder(x,.15,0,.48,.50,.20,m.deep,fsmScene,12);let node=sphere(x,.62,0,.34,material,fsmScene,1);stateLabel('S'+i,x);fsmNodes.push(node)}
 let fsmToken=sphere(0,1.08,0,.20,m.gold,fsmScene,1),fsmAlarmMaterial=mat(0x667a70,{emissive:0x000000});sphere(0,.45,.9,.23,fsmAlarmMaterial,fsmScene,1);let fsmDemo=null;
 function cancelFSMDemo(){if(!fsmDemo)return;let done=fsmDemo.finish;fsmDemo=null;fsmScene.visible=false;done(false)}
 function playFSMTrace(rows,onSample,finish){if(!Array.isArray(rows)||!rows.length)return false;cancelReplay();fsmDemo={rows,onSample,finish,index:-1,elapsed:0};fsmScene.visible=true;return true}
 function updateFSMDemo(dt){if(!fsmDemo)return;let demo=fsmDemo;demo.elapsed+=dt;let index=Math.min(demo.rows.length-1,Math.floor(demo.elapsed/1.4)),r=demo.rows[index];if(index!==demo.index){demo.index=index;fsmNodes.forEach((node,i)=>{let active=i===r.state;node.material.color.setHex(active?0xf5cc74:0x557b72);node.material.emissive.setHex(active?0x805014:0);node.material.emissiveIntensity=active?.8:0});fsmAlarmMaterial.color.setHex(r.alarm===1?0xd97862:0x667a70);fsmAlarmMaterial.emissive.setHex(r.alarm===1?0x923425:0);demo.onSample(r)}let phase=Math.min(1,(demo.elapsed-index*1.4)/.8);fsmToken.visible=r.state!==null;if(fsmToken.visible){let from=r.before===null?r.state:r.before;fsmToken.position.x=((from+(r.state-from)*phase)-1)*1.7;fsmToken.position.y=1.05+Math.sin(phase*Math.PI)*.25}if(demo.elapsed>=demo.rows.length*1.4){let done=demo.finish;fsmDemo=null;fsmScene.visible=false;done(true)}}

 // North Gate 2 is still a schematic marker; its real structure is unverified.
 function gate(x,z,name){box(x-1.4,.75,z,.32,1.4,.4,m.white);box(x+1.4,.75,z,.32,1.4,.4,m.white);box(x,1.52,z,3.1,.23,.45,m.white);label(name,x,2.4,z,.68)}gate(-22,12,'北二门');
 const treeTextures=['assets/tree.png','assets/tree-tall.png'].map(path=>{let tex=new THREE.TextureLoader().load(path);tex.colorSpace=THREE.SRGBColorSpace;tex.magFilter=THREE.NearestFilter;tex.minFilter=THREE.NearestFilter;return tex});
 const treeShades=treeTextures.map(map=>[0xffffff,0xd0e5c4,0xb8d4b9,0xe7e9bb,0xc2dbb3].map(color=>new THREE.SpriteMaterial({map,color,transparent:true,alphaTest:.15,depthWrite:true})));const treeShadow=mat(0x7e9f70);
 const swayingTrees=[];
 function tree(x,z,s=1){let level=terrainHeight(x,z);cylinder(x,level+.04,z,.48*s,.48*s,.025,treeShadow,scene,10);let variant=Math.abs(Math.floor(x*11-z*19))%treeShades.length,shade=Math.abs(Math.floor(x*17+z*29))%treeShades[variant].length,sprite=new THREE.Sprite(treeShades[variant][shade].clone());sprite.center.set(.5,.03);sprite.position.set(x,level-.1+.158*s,z);sprite.scale.set(2.6*s,2.6*s,1);scene.add(sprite);swayingTrees.push({sprite,phase:x*.41+z*.27})}
 // The entrance photograph shows a row of tall palms. These are stylised and
 // their precise species, count and positions are not verified.
 const palms=[],palmLeafMaterials=[mat(0x527c4d,{side:THREE.DoubleSide}),mat(0x76a265,{side:THREE.DoubleSide})];
 // Each tapered frond has a serrated silhouette and a gentle downward arc.
 // This is stylised geometry, not a botanical identification of the photo.
 const palmLeafGeometry=new THREE.BufferGeometry(),leafVertices=[],leafIndices=[];
 for(let i=0;i<=12;i++){let t=i/12,x=1.08*t,y=.15*Math.sin(t*Math.PI)-.30*t*t,width=.20*Math.sin(Math.PI*t)*(i%2?.52:1);leafVertices.push(x,y,-width,x,y,width);if(i<12){let a=i*2;leafIndices.push(a,a+1,a+2,a+2,a+1,a+3)}}
 palmLeafGeometry.setAttribute('position',new THREE.Float32BufferAttribute(leafVertices,3));palmLeafGeometry.setIndex(leafIndices);palmLeafGeometry.computeVertexNormals();
 function palm(x,z,height,phase){let level=terrainHeight(x,z);cylinder(x,level+height/2,z,.065,.12,height,m.trunk,scene,7);for(let i=1;i<7;i++)cylinder(x,level+height*i/7,z,.086,.095,.035,m.brown,scene,7);let crown=new THREE.Group();crown.position.set(x,level+height,z);scene.add(crown);for(let i=0;i<9;i++){let leaf=new THREE.Mesh(palmLeafGeometry,palmLeafMaterials[i%2]);leaf.rotation.y=i*Math.PI*2/9;leaf.rotation.z=(i%3-1)*.08;leaf.castShadow=true;crown.add(leaf)}palms.push({crown,phase})}
 for(const p of entrancePalms)palm(p.x,p.z,p.height,p.phase);
 // Deterministic trees; central grove and avenue plantings.
 for(const p of campusTrees)tree(p.x,p.z,p.size);
 let seed=137;function rand(){seed=(seed*1664525+1013904223)>>>0;return seed/4294967296}
 // Benches, lamps and tiny flowers bring the campus to life.
 for(let [x,z] of [[-10,7],[-3,7],[3,6],[11,6],[-17,6],[-12,-1],[13,12]]){box(x,.45,z,1,.12,.35,m.brown);box(x-.35,.24,z,.1,.4,.16,m.brown);box(x+.35,.24,z,.1,.4,.16,m.brown);cylinder(x+1.25,1,z,.055,.07,2,m.dark);sphere(x+1.25,2.1,z,.18,m.gold,scene,0)}
 for(let i=0;i<110;i++){let x=-28+rand()*56,z=-17+rand()*31;if(block.some(b=>Math.abs(x-b.x)<b.w/2+.4&&Math.abs(z-b.z)<b.d/2+.4)||Math.abs(z-16.5)<2)continue;box(x,.16,z,.12,.1,.12,i%3===0?m.red:i%3===1?m.gold:m.white)}
 const stationObjects=[];places.forEach((p,i)=>{let g=new THREE.Group();g.position.set(p.x,0,p.z);scene.add(g);let base=cylinder(0,.25,0,.72,.78,.25,m.deep,g,12);let lampMat=mat(0x64897c,{emissive:0x000000});let jewel=sphere(0,1.15,0,.28,lampMat,g,0);let ring=new THREE.Mesh(new THREE.TorusGeometry(.46,.045,8,16),mat(0xe8d498,{emissive:0x73572d,emissiveIntensity:.3}));ring.rotation.x=Math.PI/2;ring.position.y=1.15;g.add(ring);let sign=textSprite(['信号任务','数据任务','状态任务','处理器任务'][i],.6);sign.position.set(0,2.25,0);g.add(sign);let beam=new THREE.Mesh(new THREE.CylinderGeometry(.04,.35,2.2,8,1,true),new THREE.MeshBasicMaterial({color:0xffd784,transparent:true,opacity:.09,side:THREE.DoubleSide,depthWrite:false}));beam.position.y=1.6;g.add(beam);beam.visible=false;stationObjects.push({g,jewel,ring,beam})});
 // Student avatar and two campus pedestrians are decorative, not simulated hardware.
 function person(x,z,coat){let g=new THREE.Group();scene.add(g);let shirt=mat(coat);sphere(0,1.05,0,.27,m.skin,g,1);sphere(0,1.27,-.03,.24,m.dark,g,1);box(-.11,1.07,.245,.07,.07,.025,m.dark,g);box(.11,1.07,.245,.07,.07,.025,m.dark,g);box(0,.62,0,.48,.52,.32,shirt,g);let left=box(-.14,.21,0,.17,.37,.2,m.deep,g),right=box(.14,.21,0,.17,.37,.2,m.deep,g);box(0,.61,-.22,.3,.36,.15,m.brown,g);g.position.set(x,0,z);return {g,left,right}}
 const avatar=person(-8.1,12.5,0xe7956f);
 // The player is an illustrated billboard in the navigable 3D campus; movement is still driven by the world position.
 const guideTex=new THREE.TextureLoader().load('assets/student-walk-atlas.png');guideTex.colorSpace=THREE.SRGBColorSpace;guideTex.magFilter=THREE.NearestFilter;guideTex.minFilter=THREE.NearestFilter;guideTex.repeat.set(.25,.25);guideTex.offset.set(.25,.75);
 avatar.g.children.forEach(child=>child.visible=false);const playerSprite=new THREE.Sprite(new THREE.SpriteMaterial({map:guideTex,transparent:true,alphaTest:.08,depthWrite:true}));playerSprite.scale.set(1.8,1.8,1);playerSprite.position.set(0,.95,0);avatar.g.add(playerSprite);
 // Draw a faint copy only where geometry is nearer than the character. This
 // keeps the walking position legible behind a facade while retaining normal
 // depth and the same animation frame when the player is unobstructed.
 const occludedSprite=new THREE.Sprite(new THREE.SpriteMaterial({map:guideTex,color:0xffe6a5,transparent:true,opacity:.7,alphaTest:.08,depthTest:true,depthWrite:false,depthFunc:THREE.GreaterDepth}));occludedSprite.scale.copy(playerSprite.scale);occludedSprite.position.copy(playerSprite.position);occludedSprite.renderOrder=1000;avatar.g.add(occludedSprite);
 camera.position.x+=avatar.g.position.x;camera.position.z+=avatar.g.position.z;orbit.target.set(avatar.g.position.x,0,avatar.g.position.z);orbit.update();
 const halo=new THREE.Mesh(new THREE.RingGeometry(.4,.49,16),new THREE.MeshBasicMaterial({color:0xffe5a0,transparent:true,opacity:.85,side:THREE.DoubleSide}));halo.rotation.x=-Math.PI/2;halo.position.y=.16;avatar.g.add(halo);
 const landmarks3d=[[-7,13],[-22,11],[0,3.5],[-3,1.5],[3,-3.5],[7,-4],[8,9],[-24,-3.8],[-20,-1.5],[-12,-5],[-25,-10.2],[-20,-11],[18,-3],[12,7.3],[19,6.8],[23,3.4],[-12.2,3]];
 let keys=new Set(),target=null,path=[],travelLandmark=null,near=null,enabled=true,last=performance.now(),walk=0,face=0,prevNear='',inspectingBay=false,preInspectZoom=1;
 function setBayInspection(on){if(on===inspectingBay)return;if(on){cancelReplay();keys.clear();path=[];target=null;travelLandmark=null;preInspectZoom=camera.zoom;camera.zoom=1.1}else camera.zoom=preInspectZoom;camera.updateProjectionMatrix();inspectingBay=on}const validKeys=new Set(['w','a','s','d','arrowup','arrowdown','arrowleft','arrowright']);
 window.addEventListener('keydown',e=>{if(validKeys.has(e.key.toLowerCase())&&enabled){setBayInspection(false);cancelReplay();keys.add(e.key.toLowerCase());target=null;path=[];travelLandmark=null;e.preventDefault()}});window.addEventListener('keyup',e=>keys.delete(e.key.toLowerCase()));window.addEventListener('blur',()=>keys.clear());
 const mobile={up:'w',down:'s',left:'a',right:'d'};document.querySelectorAll('[data-move]').forEach(b=>{let k=mobile[b.dataset.move];b.addEventListener('pointerdown',e=>{if(!enabled)return;setBayInspection(false);cancelReplay();e.preventDefault();keys.add(k);target=null;path=[];travelLandmark=null;b.setPointerCapture(e.pointerId)});['pointerup','pointercancel','lostpointercapture'].forEach(t=>b.addEventListener(t,()=>keys.delete(k)))});
 function isOpen(x,z){if(!(x>-29&&x<29&&z>-18&&z<15.5)||block.some(b=>Math.abs(x-b.x)<b.w/2+.42&&Math.abs(z-b.z)<b.d/2+.42)||touchesPalm(x,z)||touchesTree(x,z)||touchesEntrance(x,z)||((x-pond.x)/2.35)**2+((z-pond.z)/1.42)**2<1)return false;if(touchesBay(x,z))return false;return true}
 function findPath(start,end){return findCampusPath(start,end,isOpen)}
 // Decorative pedestrians take actual walkable routes, pausing at either end.
 // These are fictional activity loops, not representations of real individuals.
 const walkers=[{...person(3,7,0x8da4c5),id:'blue',atlas:'assets/campus-student-blue-walk-atlas.png',ends:[{x:3,z:7},{x:8,z:7}],speed:1.35,pause:.4},{...person(-11,5,0xe7be78),id:'gold',atlas:'assets/campus-student-walk-atlas.png',ends:[{x:-11,z:5},{x:-17,z:6}],speed:1.15,pause:1.5}];
 for(const w of walkers){
  w.route=findPath(w.ends[0],w.ends[1])||[];w.reverse=false;w.i=0;w.cycle=0;w.face=0;
  w.g.children.forEach(child=>child.visible=false);
  w.texture=new THREE.TextureLoader().load(w.atlas);w.texture.colorSpace=THREE.SRGBColorSpace;w.texture.magFilter=THREE.NearestFilter;w.texture.minFilter=THREE.NearestFilter;w.texture.repeat.set(.25,.25);w.texture.offset.set(.25,.75);
  const sprite=new THREE.Sprite(new THREE.SpriteMaterial({map:w.texture,transparent:true,alphaTest:.08,depthWrite:true}));sprite.scale.set(1.8,1.8,1);sprite.position.set(0,.95,0);w.g.add(sprite);
 }
 function updateWalkers(dt){for(const w of walkers){if(!w.route.length)continue;if(Math.hypot(w.g.position.x-avatar.g.position.x,w.g.position.z-avatar.g.position.z)<1.7){w.texture.offset.set(.25,(3-w.face)/4);continue}if(w.pause>0){w.pause-=dt;w.texture.offset.set(.25,(3-w.face)/4);continue}let goal=w.route[w.i],dx=goal.x-w.g.position.x,dz=goal.z-w.g.position.z,dist=Math.hypot(dx,dz);if(dist<.015){w.i+=w.reverse?-1:1;if(w.i<0||w.i>=w.route.length){w.reverse=!w.reverse;w.i=w.reverse?w.route.length-2:1;w.pause=1.2}continue}let step=Math.min(dist,w.speed*dt),nx=w.g.position.x+dx/dist*step,nz=w.g.position.z+dz/dist*step;if(!isOpen(nx,nz)){w.pause=1;continue}w.g.position.x=nx;w.g.position.z=nz;w.g.position.y=terrainHeight(nx,nz)-.1;w.cycle+=dt*9;let e=camera.matrixWorld.elements,pose=avatarPose(dx,dz,e[0],e[2],e[8],e[10],w.cycle);w.face=pose.facing;w.texture.offset.set(pose.frame/4,(3-w.face)/4)}}
 function setProgress(n){stationObjects.forEach((s,i)=>{let done=i<n;s.jewel.material.color.setHex(done?0xffdd86:0x64897c);s.jewel.material.emissive.setHex(done?0xa65b16:0);s.jewel.material.emissiveIntensity=done?.8:0;s.beam.visible=done})}
 function update(now){requestAnimationFrame(update);let dt=Math.min(.05,(now-last)/1000);last=now;let t=now/1000;swayingTrees.forEach(({sprite,phase})=>{sprite.material.rotation=.035*Math.sin(t*.9+phase)});palms.forEach(({crown,phase})=>{crown.rotation.z=Math.sin(t*.8+phase)*.10;crown.rotation.x=Math.cos(t*.7+phase)*.07});waterMap.offset.x=(t*.035)%1;waterMap.offset.y=(t*.012)%1;waterGlints.forEach(({glint,phase,x})=>{glint.scale.x=.35+.65*(.5+.5*Math.sin(t*1.6+phase));glint.position.x=x+.10*Math.sin(t*.7+phase)});stationObjects.forEach((s,i)=>{s.ring.rotation.z+=dt*(i%2?1:-1);s.jewel.position.y=1.15+Math.sin(t*2+i)*.1});if(enabled){updateWalkers(dt);updateGateDemo(dt);updateBridgeDemo(dt);updateFSMDemo(dt)}let dx=0,dz=0;if(enabled){if(path.length){target=path[0];dx=target.x-avatar.g.position.x;dz=target.z-avatar.g.position.z;if(Math.hypot(dx,dz)<=.01){path.shift();dx=dz=0;if(!path.length&&travelLandmark!==null){window.dispatchEvent(new CustomEvent('campus-landmark',{detail:{index:travelLandmark}}));travelLandmark=null}}}else{target=null;let horizontal=(keys.has('d')||keys.has('arrowright')?1:0)-(keys.has('a')||keys.has('arrowleft')?1:0),toward=(keys.has('s')||keys.has('arrowdown')?1:0)-(keys.has('w')||keys.has('arrowup')?1:0),e=camera.matrixWorld.elements,direction=screenToWorld(horizontal,toward,e[0],e[2],e[8],e[10]);dx=direction.x;dz=direction.z}}let moving=false;if(Math.hypot(dx,dz)>.01){let length=Math.hypot(dx,dz),oldX=avatar.g.position.x,oldZ=avatar.g.position.z,step=path.length?Math.min(length,dt*4.2):dt*4.2,nx=oldX+dx/length*step,nz=oldZ+dz/length*step;if(path.length){if(isOpen(nx,nz)){avatar.g.position.x=nx;avatar.g.position.z=nz}else{path=[];travelLandmark=null}}else{if(isOpen(nx,oldZ))avatar.g.position.x=nx;if(isOpen(avatar.g.position.x,nz))avatar.g.position.z=nz}let movedX=avatar.g.position.x-oldX,movedZ=avatar.g.position.z-oldZ;moving=Math.hypot(movedX,movedZ)>1e-5;if(moving){walk+=dt*10;let e=camera.matrixWorld.elements,pose=avatarPose(movedX,movedZ,e[0],e[2],e[8],e[10],walk);face=pose.facing;guideTex.offset.set(pose.frame/4,(3-face)/4)}}if(!moving)guideTex.offset.set(.25,(3-face)/4);avatar.left.rotation.x=moving?Math.sin(walk)*.55:0;avatar.right.rotation.x=-avatar.left.rotation.x;avatar.g.position.y=terrainHeight(avatar.g.position.x,avatar.g.position.z)-.1+(moving?Math.abs(Math.sin(walk))*.07:0);halo.material.opacity=.6+.2*Math.sin(t*3);let best=places.map((p,i)=>({i,d:Math.hypot(p.x-avatar.g.position.x,p.z-avatar.g.position.z)})).sort((a,b)=>a.d-b.d)[0];near=best.d<2.2?best.i:null;let n=near===null?'none':String(near);if(n!==prevNear){prevNear=n;onNear(near)}if(enabled){let bestLandmark=landmarks3d.map((p,i)=>({i,d:Math.hypot(p[0]-avatar.g.position.x,p[1]-avatar.g.position.z)})).sort((a,b)=>a.d-b.d)[0];if(bestLandmark.d<2.3)window.dispatchEvent(new CustomEvent('campus-landmark',{detail:{index:bestLandmark.i}}))}let focusX=inspectingBay?-5:fsmDemo?(avatar.g.position.x+fsmScene.position.x)/2:avatar.g.position.x,focusZ=inspectingBay?-3:fsmDemo?(avatar.g.position.z+fsmScene.position.z)/2:avatar.g.position.z,followX=focusX-orbit.target.x,followZ=focusZ-orbit.target.z;orbit.target.x+=followX*Math.min(1,dt*5);orbit.target.z+=followZ*Math.min(1,dt*5);camera.position.x+=followX*Math.min(1,dt*5);camera.position.z+=followZ*Math.min(1,dt*5);orbit.update();renderer.render(scene,camera)}requestAnimationFrame(update);
 function resize(){let w=element.clientWidth,h=element.clientHeight;if(!w||!h)return;renderer.setSize(Math.max(1,Math.floor(w*.75)),Math.max(1,Math.floor(h*.75)),false);let aspect=w/h,half=aspect<1?12.5:10.5;camera.left=-half*aspect;camera.right=half*aspect;camera.top=half;camera.bottom=-half;camera.updateProjectionMatrix()}new ResizeObserver(resize).observe(element);resize();
 return {playGateTrace,playBridgeTrace,playFSMTrace,setLabelsVisible(v){locationLabels.forEach(label=>{label.visible=!!v})},inspectBay(){setBayInspection(!inspectingBay);return inspectingBay},isInspectingBay(){return inspectingBay},getLandmark(){let p=avatar.g.position;return landmarks3d.map(([x,z],i)=>({i,d:Math.hypot(x-p.x,z-p.z)})).sort((a,b)=>a.d-b.d)[0].i},setLandmark(i){let p=landmarks3d[i];if(!p)return false;let route=findPath(avatar.g.position,{x:p[0],z:p[1]});if(!route?.length)return false;let end=route.at(-1),dx=end.x-orbit.target.x,dz=end.z-orbit.target.z;avatar.g.position.set(end.x,terrainHeight(end.x,end.z)-.1,end.z);camera.position.x+=dx;camera.position.z+=dz;orbit.target.x=end.x;orbit.target.z=end.z;orbit.update();keys.clear();path=[];target=null;travelLandmark=null;let best=places.map((q,j)=>({j,d:Math.hypot(q.x-end.x,q.z-end.z)})).sort((a,b)=>a.d-b.d)[0];near=best.d<2.2?best.j:null;prevNear=near===null?'none':String(near);return true},goTo(i){if(places[i]){setBayInspection(false);cancelReplay();keys.clear();travelLandmark=null;let p=places[i];path=findPath(avatar.g.position,{x:p.x,z:p.z})||[];target=path[0]||null}},goToPosition(x,z){setBayInspection(false);cancelReplay();keys.clear();let index=landmarks3d.findIndex(p=>p[0]===x&&p[1]===z);path=findPath(avatar.g.position,{x,z})||[];travelLandmark=path.length&&index>=0?index:null;target=path[0]||null;return path.length>0},setProgress,setEnabled(v){enabled=v;if(!v){setBayInspection(false);cancelReplay();keys.clear();target=null;path=[];travelLandmark=null}},getNear(){return near},nearWalker(){let closest=walkers.map(w=>({id:w.id,d:Math.hypot(w.g.position.x-avatar.g.position.x,w.g.position.z-avatar.g.position.z)})).sort((a,b)=>a.d-b.d)[0];return closest.d<1.8?closest.id:null},nearCanteen(){return Math.hypot(avatar.g.position.x-23,avatar.g.position.z-3.4)<2.4},nearDorm(){return Math.hypot(avatar.g.position.x-18,avatar.g.position.z+3)<2.4}};
}
