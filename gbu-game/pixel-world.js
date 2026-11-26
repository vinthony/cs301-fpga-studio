// A 2.5D illustrated exploration view; architecture is an AI-assisted interpretation
// of the supplied guide, not surveyed measurements. The 3D model remains available.
const spots=[{x:800,y:630},{x:745,y:570},{x:1195,y:505},{x:350,y:365}];
const landmarkXY=[[800,630],[350,410],[745,570],[710,555],[840,520],[1195,505],[925,700],[255,355],[390,360],[515,370],[220,370],[400,365],[1430,590],[1170,745],[1475,856],[1500,680],[610,535]];
const blockRects=[[178,145,570,355],[543,270,900,503],[895,350,1215,493],[860,480,1175,681],[1210,340,1618,555],[1125,565,1350,706],[1235,715,1475,850]];
// Approximate silhouettes for a handful of trees beside the central avenue. These
// overlays are clipped from the existing illustrated background and depth-sorted
// against the character's feet. They do not claim surveyed tree positions.
const canopies=[
 {x:775,y:638,points:[[764,621],[764,613],[769,611],[771,605],[781,605],[784,610],[788,614],[787,624],[780,630],[771,630],[766,627]]},
 {x:700,y:673,points:[[687,648],[687,640],[692,637],[693,632],[705,632],[711,637],[714,644],[712,653],[706,658],[695,659],[689,655]]},
 {x:744,y:699,points:[[728,675],[729,666],[734,663],[737,656],[749,656],[755,661],[758,669],[757,678],[752,684],[739,686],[732,682]]},
 {x:798,y:725,points:[[780,699],[781,690],[787,685],[790,680],[803,680],[810,685],[814,693],[813,702],[808,708],[793,710],[783,705]]},
 {x:839,y:699,points:[[825,674],[825,666],[831,661],[834,655],[846,655],[852,660],[855,668],[853,678],[848,683],[836,684],[828,680]]}
];
export function createPixelWorld(host,onNear){
 let canvas=document.createElement('canvas');canvas.className='pixel-world-canvas';canvas.setAttribute('aria-label','松山湖像素校园游览场景');host.appendChild(canvas);let ctx=canvas.getContext('2d');ctx.imageSmoothingEnabled=false;
 const image=new Image();image.src='assets/songshanlake-pixel-art.png';const avatarImage=new Image();avatarImage.src='assets/student-walk-atlas.png';let facing=0;let enabled=true,position={x:800,y:630},target=[],keys=new Set(),near=null,prevNear='',last=performance.now(),walk=0,completed=0,view={x:position.x,y:position.y};let dpr=1;
 const blocked=(x,y)=>x<90||x>1650||y<200||y>875||blockRects.some(([a,b,c,d])=>x>a&&x<c&&y>b&&y<d)||canopies.some(t=>Math.hypot((x-t.x)/5,(y-t.y)/3)<1);
 // Check each full grid edge against tree-trunk ellipses, not only its end points.
 function treeEdgeBlocked(ax,ay,bx,by){return canopies.some(t=>{let x1=(ax-t.x)/5,y1=(ay-t.y)/3,x2=(bx-t.x)/5,y2=(by-t.y)/3,dx=x2-x1,dy=y2-y1,denom=dx*dx+dy*dy,u=denom?Math.max(0,Math.min(1,-(x1*dx+y1*dy)/denom)):0;return Math.hypot(x1+u*dx,y1+u*dy)<1})}
 // Use the same continuous collision test for routing and movement. Sampling
 // just the end of a step allows narrow tree trunks to be crossed at speed.
 function edgeBlocked(ax,ay,bx,by){
  if(blocked(ax,ay)||blocked(bx,by)||treeEdgeBlocked(ax,ay,bx,by))return true;
  return blockRects.some(([left,top,right,bottom])=>{
   let lo=0,hi=1;
   for(const [p,d,min,max] of [[ax,bx-ax,left,right],[ay,by-ay,top,bottom]]){
    if(Math.abs(d)<1e-9){if(p<=min||p>=max)return false;continue}
    let a=(min-p)/d,b=(max-p)/d;if(a>b)[a,b]=[b,a];lo=Math.max(lo,a);hi=Math.min(hi,b);if(lo>=hi)return false;
   }
   return true;
  });
 }
 const validKeys=new Set(['w','a','s','d','arrowup','arrowdown','arrowleft','arrowright']);
 window.addEventListener('keydown',e=>{if(enabled&&validKeys.has(e.key.toLowerCase())){keys.add(e.key.toLowerCase());target=[];e.preventDefault()}});window.addEventListener('keyup',e=>keys.delete(e.key.toLowerCase()));window.addEventListener('blur',()=>keys.clear());
 const directions={up:'w',down:'s',left:'a',right:'d'};document.querySelectorAll('[data-move]').forEach(b=>{let k=directions[b.dataset.move];b.addEventListener('pointerdown',()=>{if(enabled){keys.add(k);target=[]}});['pointerup','pointercancel','lostpointercapture'].forEach(type=>b.addEventListener(type,()=>keys.delete(k)))});
 function route(end){const unit=18,w=97,h=51,key=(x,y)=>y*w+x,cell=(x,y)=>({x:Math.round(x/unit),y:Math.round(y/unit)}),base=cell(position.x,position.y),e=cell(end.x,end.y);let candidates=[];for(let dy=-2;dy<=2;dy++)for(let dx=-2;dx<=2;dx++){let x=base.x+dx,y=base.y+dy;if(x>=0&&x<w&&y>=0&&y<h&&!edgeBlocked(position.x,position.y,x*unit,y*unit))candidates.push({x,y})}candidates.sort((a,b)=>Math.hypot(a.x*unit-position.x,a.y*unit-position.y)-Math.hypot(b.x*unit-position.x,b.y*unit-position.y));let s=candidates[0];if(!s)return [];let q=[s],seen=new Set([key(s.x,s.y)]),parent=new Map(),found=null;for(let n=0;n<q.length;n++){let p=q[n];if(Math.hypot(p.x*unit-end.x,p.y*unit-end.y)<13){found=p;break}for(let [dx,dy] of [[1,0],[-1,0],[0,1],[0,-1]]){let x=p.x+dx,y=p.y+dy,k=key(x,y);if(x<0||x>=w||y<0||y>=h||seen.has(k)||edgeBlocked(p.x*unit,p.y*unit,x*unit,y*unit))continue;seen.add(k);parent.set(k,p);q.push({x,y})}}if(!found)return [];let out=[];while(found){out.push({x:found.x*unit,y:found.y*unit});if(found.x===s.x&&found.y===s.y)break;found=parent.get(key(found.x,found.y))}out.reverse();let last=out.at(-1);if(last&&!edgeBlocked(last.x,last.y,end.x,end.y))out.push({x:end.x,y:end.y});return out}
 function size(){let w=host.clientWidth,h=host.clientHeight;if(!w||!h)return;canvas.width=Math.floor(w/2);canvas.height=Math.floor(h/2);dpr=canvas.width/Math.max(1,w);ctx.imageSmoothingEnabled=false}new ResizeObserver(size).observe(host);size();
 // Replace the concept image's invented swimming pool with a court area
 // inspired by the supplied campus guide. The foreground roof masks part of
 // the courts; geometry and the number of courts are still illustrative.
 function drawCourts(){
  ctx.save();ctx.beginPath();[[1445,547],[1520,574],[1515,582],[1591,606],[1552,654],[1530,647],[1530,636],[1399,592]].forEach(([x,y],i)=>i?ctx.lineTo(x,y):ctx.moveTo(x,y));ctx.closePath();ctx.clip();
  ctx.transform(50,18.33,-47,53,1445,547);ctx.fillStyle='#5193aa';ctx.fillRect(-.08,-.08,3.2,1.18);
  ctx.lineWidth=.014;ctx.strokeStyle='#f5e5c8';
  for(let i=0;i<3;i++){
   ctx.fillStyle=i%2?'#5ba5b5':'#65a8b3';ctx.fillRect(i+.035,.045,.93,.91);
   ctx.fillStyle='#d6c8a6';ctx.fillRect(i+.32,.045,.36,.23);ctx.fillRect(i+.32,.725,.36,.23);
   ctx.strokeRect(i+.035,.045,.93,.91);ctx.beginPath();ctx.moveTo(i+.035,.5);ctx.lineTo(i+.965,.5);ctx.stroke();
   ctx.fillStyle='#3d7699';ctx.beginPath();ctx.ellipse(i+.5,.5,.12,.12,0,0,Math.PI*2);ctx.fill();ctx.stroke();
   for(let y of [.05,.95]){ctx.strokeRect(i+.32,y<.5?y:.72,.36,.23)}
  }
  ctx.restore();
 }
 function draw(now){requestAnimationFrame(draw);let dt=Math.min(.05,(now-last)/1000);last=now;let dx=0,dy=0,following=false;if(enabled){if(target.length){following=true;let p=target[0];dx=p.x-position.x;dy=p.y-position.y;if(Math.hypot(dx,dy)<.01){target.shift();dx=dy=0}}else{dx=(keys.has('d')||keys.has('arrowright')?1:0)-(keys.has('a')||keys.has('arrowleft')?1:0);dy=(keys.has('s')||keys.has('arrowdown')?1:0)-(keys.has('w')||keys.has('arrowup')?1:0)}}let moving=Math.hypot(dx,dy)>.01;if(moving){facing=Math.abs(dx)>Math.abs(dy)?(dx<0?1:2):(dy<0?3:0);let n=Math.hypot(dx,dy),step=following?Math.min(n,180*dt):180*dt,nx=position.x+dx/n*step,ny=position.y+dy/n*step;if(following){if(!edgeBlocked(position.x,position.y,nx,ny)){position.x=nx;position.y=ny}else target=[]}else{if(!edgeBlocked(position.x,position.y,nx,position.y))position.x=nx;if(!edgeBlocked(position.x,position.y,position.x,ny))position.y=ny}walk+=dt*10}let best=spots.map((p,i)=>({i,d:Math.hypot(p.x-position.x,p.y-position.y)})).sort((a,b)=>a.d-b.d)[0];near=best.d<42?best.i:null;let n=near===null?'none':String(near);if(n!==prevNear){prevNear=n;onNear(near)}if(enabled){let bestLandmark=landmarkXY.map((p,i)=>({i,d:Math.hypot(p[0]-position.x,p[1]-position.y)})).sort((a,b)=>a.d-b.d)[0];if(bestLandmark.d<45)window.dispatchEvent(new CustomEvent('campus-landmark',{detail:{index:bestLandmark.i}}))}
  let w=canvas.width,h=canvas.height;ctx.clearRect(0,0,w,h);ctx.fillStyle='#9ebd95';ctx.fillRect(0,0,w,h);view.x+=(position.x-view.x)*Math.min(1,dt*4);view.y+=(position.y-view.y)*Math.min(1,dt*4);let scale=Math.max(w/780,h/500);let tx=w*.55-view.x*scale,ty=h*.55-view.y*scale;ctx.save();ctx.translate(Math.round(tx),Math.round(ty));ctx.scale(scale,scale);if(image.complete&&image.naturalWidth){ctx.drawImage(image,0,0,1733,907);drawCourts()}
  spots.forEach((p,i)=>{let bob=Math.sin(now/400+i)*2;ctx.fillStyle=i<completed?'#ffe28c':'#f9d797';ctx.fillRect(p.x-2,p.y-40+bob,4,12);ctx.fillRect(p.x-6,p.y-36+bob,12,4);ctx.fillStyle='#6b6049';ctx.fillRect(p.x-3,p.y-28+bob,6,3)});
  // A few walking classmates and ambient glints are ornamental; challenge state stays in RTL.
  [{x:700,y:650,p:0},{x:1050,y:790,p:2},{x:520,y:440,p:4}].forEach(c=>{let ox=Math.sin(now/2300+c.p)*13;ctx.fillStyle='#edb789';ctx.fillRect(c.x+ox,c.y-14,6,6);ctx.fillStyle='#446f6a';ctx.fillRect(c.x+ox-1,c.y-8,8,8);ctx.fillStyle='#34455a';ctx.fillRect(c.x+ox,c.y,6,5)});
  ctx.fillStyle='rgba(40,55,40,.32)';ctx.beginPath();ctx.ellipse(position.x,position.y+3,12,4,0,0,Math.PI*2);ctx.fill();if(avatarImage.complete&&avatarImage.naturalWidth){let frame=moving?Math.floor(walk/2)%4:1;let cellW=avatarImage.naturalWidth/4,cellH=avatarImage.naturalHeight/4;ctx.drawImage(avatarImage,frame*cellW,facing*cellH,cellW,cellH,position.x-20,position.y-40,40,40)}
  // Redraw the near tree canopy only when its base is in front of the player.
  if(image.complete&&image.naturalWidth){for(const tree of canopies){if(position.y<tree.y&&Math.abs(position.x-tree.x)<22&&position.y>tree.y-45){ctx.save();ctx.beginPath();tree.points.forEach(([x,y],i)=>i?ctx.lineTo(x,y):ctx.moveTo(x,y));ctx.closePath();ctx.clip();ctx.drawImage(image,0,0,1733,907);ctx.restore()}}}ctx.restore();
 }
 requestAnimationFrame(draw);
 return {getLandmark(){return landmarkXY.map(([x,y],i)=>({i,d:Math.hypot(x-position.x,y-position.y)})).sort((a,b)=>a.d-b.d)[0].i},setLandmark(i){let p=landmarkXY[i];if(!p)return false;let candidates=[];for(let radius=0;radius<=90;radius+=9){for(let j=0;j<(radius?16:1);j++){let a=j*Math.PI/8,x=p[0]+Math.cos(a)*radius,y=p[1]+Math.sin(a)*radius;if(!blocked(x,y))candidates.push({x,y})}if(candidates.length)break}if(!candidates.length)return false;position=candidates[0];view={...position};keys.clear();target=[];let best=spots.map((q,j)=>({j,d:Math.hypot(q.x-position.x,q.y-position.y)})).sort((a,b)=>a.d-b.d)[0];near=best.d<42?best.j:null;prevNear=near===null?'none':String(near);return true},goTo(i){keys.clear();target=route(spots[i])},goToPosition(x,z){let values=[[-7,13],[-22,11],[0,3.5],[-3,1.5],[3,-3.5],[7,-4],[8,9],[-24,-3.8],[-20,-1.5],[-12,-5],[-25,-10.2],[-20,-11],[18,-3],[12,7.3],[19,6.8],[23,3.4],[-12.2,3]];let index=values.findIndex(p=>p[0]===x&&p[1]===z);keys.clear();if(index<0)return false;target=route(landmarkXY[index]&&{x:landmarkXY[index][0],y:landmarkXY[index][1]});return target.length>0},setProgress(n){completed=n},setEnabled(v){enabled=v;if(!v){keys.clear();target=[]}},getNear(){return near},nearCanteen(){return Math.hypot(position.x-1500,position.y-680)<48},nearDorm(){return Math.hypot(position.x-1430,position.y-590)<48}};
}
