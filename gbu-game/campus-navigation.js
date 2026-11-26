// Route to the nearest walkable position when a landmark is inside a building
// or water. The displayed campus is illustrative, so this is game navigation.
export function courtyardFootprints(x,z,w,d){
 const wing=w*.225,back=d*.3;
 return [{x:x-w/2+wing/2,z,w:wing,d},{x:x+w/2-wing/2,z,w:wing,d},{x,z:z-d/2+back/2,w:w-2*wing,d:back}];
}
// Approximate angled return on the research building in the activity guide.
// Rendering and collision share this footprint; proportions are not surveyed.
export function researchFootprints(x,z,w,d){return [{x,z,w,d},{x:x-w*.39,z:z+d*.66,w:w*.22,d:d*.90}]}
// Interpreted footprint of the central bay building, shared by the model and walking collision.
export const baySegments=72;
export function bayPoint(i){let t=i/baySegments,a=-2.6+3.1*t;return {x:Math.cos(a)*6.6-5,z:Math.sin(a)*4.4-3,t}}
// The aerial shows one distinctly broad, rising wing tapering into the long
// curved body. These proportions are an artistic estimate, not measurements.
export function bayWidth(t){return .88+.90*Math.exp(-(((t-.08)/.17)**2))+.40*Math.exp(-(((t-.78)/.16)**2))}
export function bayElevation(t){return 1.00*Math.exp(-(((t-.08)/.19)**2))+.20*Math.exp(-(((t-.78)/.19)**2))}
export function touchesBay(x,z){for(let i=1;i<=baySegments;i++){let a=bayPoint(i-1),b=bayPoint(i),dx=b.x-a.x,dz=b.z-a.z,q=Math.max(0,Math.min(1,((x-a.x)*dx+(z-a.z)*dz)/(dx*dx+dz*dz))),t=a.t+(b.t-a.t)*q;if(Math.hypot(x-a.x-q*dx,z-a.z-q*dz)<bayWidth(t)+.35)return true}return false}
// Approximate decorative plantings. The model and navigation share these
// positions so the visible trunks cannot be walked through.
function segmentDistance(x,z,a,b){let dx=b[0]-a[0],dz=b[1]-a[1],t=Math.max(0,Math.min(1,((x-a[0])*dx+(z-a[1])*dz)/(dx*dx+dz*dz)));return Math.hypot(x-a[0]-t*dx,z-a[1]-t*dz)}
const gardenLines=[
 [[-10.1,-4.6],[-9.4,-5.9],[-7.5,-6.3],[-5.2,-5.8],[-4.2,-4.4],[-4.9,-2.7],[-7.1,-2.1],[-9.3,-2.6],[-10.1,-4.6]],
 [[-10.8,-1.3],[-9.8,-2],[-8.7,-2.4],[-7.2,-2.6],[-5.5,-2.1],[-4.7,-1.2]],
 [[-9.8,-.8],[-9,-1.5],[-7.7,-1.8],[-6.5,-1.5],[-5.7,-.9]],
 [[-10.6,1.1],[-9.5,.55],[-8.4,.4],[-7.2,.58],[-6.15,.25],[-5.1,-.55]],
 [[-7.2,-4.1],[-7.35,-3.4],[-7.2,-2.6]]
];
function nearGardenPath(x,z){return gardenLines.some(line=>line.slice(1).some((p,i)=>segmentDistance(x,z,line[i],p)<.55))}
function makeCampusTrees(){let trees=[],seed=137;const rand=()=>{seed=(seed*1664525+1013904223)>>>0;return seed/4294967296};
 // Spread the grove across the available pockets instead of stacking many
 // sprites at the same point. Keep the paths and clearing open; positions and
 // species are still a game interpretation, not a tree inventory.
 for(let i=0;i<1400&&trees.length<32;i++){let x=-12+rand()*11,z=-8+rand()*8,size=.50+rand()*.26;if((x+5)**2/43+(z+3)**2/23<1&&x<-3&&!nearGardenPath(x,z)&&Math.hypot(x+7.2,z+4.1)>1.25&&!touchesBay(x,z)&&!(((x+2.3)/2.6)**2+((z-1.5)/1.7)**2<1)&&trees.every(p=>Math.hypot(x-p.x,z-p.z)>.68))trees.push({x,z,size})}for(let x=-27;x<=27;x+=3.1)if(Math.abs(x+7)>2&&Math.abs(x+22)>2)trees.push({x,z:14,size:.52+rand()*.12});for(let x=-27;x<27;x+=4)trees.push({x,z:-17,size:.5+rand()*.12});
 // The user's campus map depicts a planted eastern edge beside the living
 // and sports area. Counts, species and exact positions are illustrative.
 for(let z=-13.7;z<13;z+=3.2)trees.push({x:26.55,z,size:.55+rand()*.11});
 // The western research precinct also contains planted green space in the
 // supplied guide. Keep the points shared with collision and pathfinding.
 for(const [x,z] of [[-25.2,6.5],[-23.2,4.5],[-21,6.5],[-25,.7],[-22.3,1.4],[-22,-1.3]])trees.push({x,z,size:.50+rand()*.12});
 return trees}
export const campusTrees=makeCampusTrees();
export function touchesTree(x,z){return campusTrees.some(p=>Math.hypot(x-p.x,z-p.z)<.30)}
// A small pavilion shown on the supplied guide; placement and footprint are
// illustrative. Shared with the renderer and route collision checks.
export const academicCenter={x:-12.2,z:1.3,w:1.55,d:1.55};
// Approximate entry objects, aligned to the visible gate model.
export const entranceObstacles=[{x:-14.35,z:14.7,w:3.3,d:.12},{x:-10.3,z:14.7,w:4.5,d:.34},{x:-3.8,z:14.3,w:1.55,d:1.2}];
export function touchesEntrance(x,z){return entranceObstacles.some(b=>Math.abs(x-b.x)<b.w/2+.25&&Math.abs(z-b.z)<b.d/2+.25)}
// A longitudinal row beside the entrance lawn follows the relationship
// visible in the entrance photo; exact species, count and coordinates are
// illustrative. Rendering and collision use the same positions.
export const entrancePalms=Array.from({length:6},(_,i)=>({x:3.6,z:6.8+i*1.15,height:2.4+(i%2)*.16,phase:i*.7}));
export function touchesPalm(x,z){return entrancePalms.some(p=>Math.hypot(x-p.x,z-p.z)<.32)}
// Visible paving rectangles, shared by the renderer and route preference.
// These are an approximate game layout, not surveyed campus paths.
export const campusWalkways=[
 [-6,9.7,2.5,13.7],[-.5,3.7,30,2.2],[8,9.2,2.4,11],[-18,1.8,2.3,17],
 [20,-3.05,12.2,1.05],[16,-3.82,.9,.55],[24,-3.82,.9,.55],[20,-4.58,.9,2.05],
 [13.7,2.1,1.1,11.35],[18.35,2.2,9.4,1.05],[23,3.28,1.15,1.20],[14.6,7.8,2,1.05],
 [-22,11.05,1.25,2.6],[-22.65,9.8,9.35,1.2],[-27.1,-1.85,1.2,22.1]
];
// Approximate landscaped links inspired by the user's campus guide; the
// control points are shared with the renderer, not surveyed coordinates.
export const researchGardenPaths=[
 [[-27.1,8],[-25.8,7.8],[-24.5,7.8],[-23,7.6],[-21.8,7.8],[-20.4,7.8],[-18,7.8]],
 [[-23,7.6],[-24,6.1],[-24.5,4.5],[-24.5,3],[-24,2.2],[-23,1.5],[-22.7,2.6],[-21.6,3.7],[-20,4.2],[-18,3.7]]
];
export function onCampusWalkway(x,z){return campusWalkways.some(([cx,cz,w,d])=>Math.abs(x-cx)<=w/2+.35&&Math.abs(z-cz)<=d/2+.35)||researchGardenPaths.some(line=>line.slice(1).some((p,i)=>segmentDistance(x,z,line[i],p)<.60))}
export function findCampusPath(start,end,isOpen,maxDistance=4){
 const ox=-29,oz=-18,width=59,height=34,key=(x,z)=>z*width+x;
 const clear=(a,b)=>{let n=Math.max(1,Math.ceil(Math.hypot(b.x-a.x,b.z-a.z)/.15));for(let i=0;i<=n;i++){let t=i/n;if(!isOpen(a.x+(b.x-a.x)*t,a.z+(b.z-a.z)*t))return false}return true};
 let sx=Math.round(start.x-ox),sz=Math.round(start.z-oz),starts=[];
 for(let dz=-2;dz<=2;dz++)for(let dx=-2;dx<=2;dx++){let x=sx+dx,z=sz+dz,p={x:x+ox,z:z+oz};if(x>=0&&x<width&&z>=0&&z<height&&clear(start,p))starts.push({x,z})}
 starts.sort((a,b)=>Math.hypot(a.x+ox-start.x,a.z+oz-start.z)-Math.hypot(b.x+ox-start.x,b.z+oz-start.z));
 if(!starts.length)return null;
 // Prefer paving but retain a grass fallback where the approximate paths do
 // not reach a destination. Dijkstra preserves the closest reachable endpoint.
 const s=starts[0],queue=[{...s,cost:0}],costs=new Map([[key(s.x,s.z),0]]),parent=new Map();let best=null,bestDistance=Infinity;
 function push(item){queue.push(item);let i=queue.length-1;while(i){let p=(i-1)>>1;if(queue[p].cost<=item.cost)break;queue[i]=queue[p];i=p}queue[i]=item}
 function pop(){let first=queue[0],last=queue.pop();if(queue.length){let i=0;while(true){let l=i*2+1,r=l+1;if(l>=queue.length)break;let c=r<queue.length&&queue[r].cost<queue[l].cost?r:l;if(queue[c].cost>=last.cost)break;queue[i]=queue[c];i=c}queue[i]=last}return first}
 while(queue.length){
  let p=pop(),pk=key(p.x,p.z);if(p.cost!==costs.get(pk))continue;
  let point={x:p.x+ox,z:p.z+oz},distance=Math.hypot(point.x-end.x,point.z-end.z);
  if(distance<bestDistance){best=p;bestDistance=distance;if(distance<.01)break}
  for(let [dx,dz] of [[1,0],[-1,0],[0,1],[0,-1]]){let x=p.x+dx,z=p.z+dz,k=key(x,z),next={x:x+ox,z:z+oz};if(x<0||x>=width||z<0||z>=height||!clear(point,next))continue;let nextCost=p.cost+(onCampusWalkway((point.x+next.x)/2,(point.z+next.z)/2)?1:2.5);if(nextCost>=(costs.get(k)??Infinity))continue;costs.set(k,nextCost);parent.set(k,p);push({x,z,cost:nextCost})}
 }
 if(!best||bestDistance>maxDistance)return null;
 let path=[];while(best){path.push({x:best.x+ox,z:best.z+oz});if(best.x===s.x&&best.z===s.z)break;best=parent.get(key(best.x,best.z))}path.reverse();
 return path;
}
