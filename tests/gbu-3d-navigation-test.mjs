import assert from 'node:assert/strict';
import fs from 'node:fs';
const src=fs.readFileSync(new URL('../gbu-game/campus-navigation.js',import.meta.url),'utf8');
const {findCampusPath,onCampusWalkway,researchGardenPaths,courtyardFootprints,researchFootprints,entrancePalms,touchesPalm,baySegments,bayPoint,bayWidth,bayElevation,touchesBay,campusTrees,touchesTree,entranceObstacles,touchesEntrance,academicCenter}=await import('data:text/javascript;base64,'+Buffer.from(src).toString('base64'));
const world=fs.readFileSync(new URL('../gbu-game/world.js',import.meta.url),'utf8');
const specs=[...world.matchAll(/building\('([^']+)',\s*(-?[\d.]+),\s*(-?[\d.]+),\s*([\d.]+),\s*([\d.]+),\s*\d+/g)];
assert.equal(specs.length,14,'test picks up the current building footprints');
const buildings=specs.flatMap(m=>{let x=+m[2],z=+m[3],w=+m[4],d=+m[5];return (m[1]==='1号实验楼'?courtyardFootprints(x,z,w,d):m[1]==='8号产研楼'?researchFootprints(x,z,w,d):[{x,z,w,d}]).map(b=>({...b,w:b.w+.6,d:b.d+.6}))});
buildings.push({...academicCenter,w:academicCenter.w+.6,d:academicCenter.d+.6});
function open(x,z){return x>-29&&x<29&&z>-18&&z<15.5&&!buildings.some(b=>Math.abs(x-b.x)<b.w/2+.42&&Math.abs(z-b.z)<b.d/2+.42)&&!touchesPalm(x,z)&&!touchesTree(x,z)&&!touchesEntrance(x,z)&&!(((x+2.3)/2.35)**2+((z-1.5)/1.42)**2<1)&&!touchesBay(x,z)}
assert.ok(bayWidth(.08)>bayWidth(.4)+.7,'bay has a prominent broad wing and narrower centre');
assert.ok(bayElevation(.08)>bayElevation(.4)+.7,'the broad wing rises above the centre');
for(let i=0;i<=baySegments;i++){let p=bayPoint(i);assert.ok(touchesBay(p.x,p.z),'bay centreline blocks movement');assert.ok(bayWidth(p.t)>.8,'bay width stays positive')}
const destinations=[[-7,13],[-22,11],[0,3.5],[-3,1.5],[3,-3.5],[7,-4],[8,9],[-24,-3.8],[-20,-1.5],[-12,-5],[-25,-10.2],[-20,-11],[18,-3],[12,7.3],[19,6.8],[23,3.4],[-12.2,3]];
for(const p of entrancePalms){assert.ok(!open(p.x,p.z),'palm trunk blocks movement');assert.ok(open(p.x,p.z+.6),'space beyond trunk is walkable')}
for(const p of campusTrees)assert.ok(touchesTree(p.x,p.z),'every displayed tree trunk blocks movement');
for(const b of entranceObstacles)assert.ok(touchesEntrance(b.x,b.z),'entrance stone, fence and booth block movement');
assert.ok(open(8,4),'the open courtyard is walkable');
assert.ok(!open(4.9,4),'the left wing remains solid');
let researchWing=researchFootprints(-17,-3.8,7,2.4)[1];assert.ok(!open(researchWing.x,researchWing.z),'the research return wing blocks movement');
let preferred=findCampusPath({x:-8,z:10},{x:8,z:10},()=>true);
assert.deepEqual(preferred.at(-1),{x:8,z:10},'preferred route still reaches its destination');
assert.ok(preferred.some(p=>p.z<=5),'route makes a useful detour to the central path');
assert.ok(preferred.filter(p=>onCampusWalkway(p.x,p.z)).length>preferred.length*.7,'most of the route follows the shared paving');
let fallback=findCampusPath({x:28,z:-15},{x:28,z:-10},()=>true);
assert.deepEqual(fallback.at(-1),{x:28,z:-10},'routes remain available where there is no paving');
for(const line of researchGardenPaths)for(const [x,z] of line)assert.ok(onCampusWalkway(x,z),'western garden path contributes to the walking preference');
let western=findCampusPath({x:-27,z:8},{x:-18,z:4},open);
assert.ok(western?.length&&Math.hypot(western.at(-1).x+18,western.at(-1).z-4)<1,'western garden connects to the research route');
let clearing={x:-7.2,z:-4.1};assert.ok(open(clearing.x,clearing.z),'central clearing has no blocking tree');let gardenRoute=findCampusPath({x:0,z:3.5},clearing,open);assert.ok(gardenRoute?.length,'central clearing is reachable');assert.ok(Math.hypot(gardenRoute.at(-1).x-clearing.x,gardenRoute.at(-1).z-clearing.z)<1,'route reaches the clearing');
for(const [start,end] of [[{x:3,z:7},{x:8,z:7}],[{x:-11,z:5},{x:-17,z:6}]]){let route=findCampusPath(start,end,open);assert.ok(route?.length>1,'pedestrian route available');assert.ok(Math.hypot(route.at(-1).x-end.x,route.at(-1).z-end.z)<.01,'pedestrian reaches endpoint');for(const p of route)assert.ok(open(p.x,p.z),'pedestrian stays on navigable ground')}
let current={x:-8.1,z:12.5};
for(const [i,[x,z]] of destinations.entries()){
 let path=findCampusPath(current,{x,z},open);assert.ok(path?.length,`landmark ${i} reachable`);let last=path.at(-1);assert.ok(Math.hypot(last.x-x,last.z-z)<=4,`landmark ${i} nearby`);
 let nearest=destinations.map(([px,pz],j)=>({j,d:Math.hypot(last.x-px,last.z-pz)})).sort((a,b)=>a.d-b.d)[0];assert.equal(nearest.j,i,`3D transfer endpoint still identifies landmark ${i}`);
 for(const [j,p] of path.entries()){assert.ok(open(p.x,p.z),`landmark ${i} point ${j} walkable`);let prev=j?path[j-1]:current;for(let k=1;k<10;k++)assert.ok(open(prev.x+(p.x-prev.x)*k/10,prev.z+(p.z-prev.z)*k/10),`landmark ${i} edge ${j} walkable`)}current=last;
}
for(const [x,z] of [[-7,13],[0,3.5],[7,-4],[-17,4]]){let path=findCampusPath(current,{x,z},open);assert.ok(path?.length);let last=path.at(-1);assert.ok(Math.hypot(last.x-x,last.z-z)<2.2,`mission ${x},${z} can be opened`);current=last}
console.log('PASS: 17 3D landmark routes, continuous obstacle clearance, four reachable mission points');
