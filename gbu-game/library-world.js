// A playable illustrative room based on one 2025 library corridor photograph.
// This is a concept interpretation, not a measured model or verified 7# interior.
export function createLibraryWorld(host,onNear){
 const canvas=document.createElement('canvas');canvas.className='pixel-world-canvas';canvas.setAttribute('aria-label','图书馆阅读走廊参考场景');host.appendChild(canvas);const c=canvas.getContext('2d');c.imageSmoothingEnabled=false;
 const bg=new Image();bg.src='assets/library-room.png';const sheet=new Image();sheet.src='assets/student-walk-atlas.png';
 const points=[{id:'shelf',x:1010,y:600},{id:'table',x:780,y:390},{id:'map',x:480,y:600},{id:'exit',x:760,y:915}];
 let keys=new Set(),enabled=false,pos={x:760,y:835},facing=3,walk=0,near=null,previous='',last=performance.now();
 const valid=new Set(['w','a','s','d','arrowup','arrowdown','arrowleft','arrowright']);
 window.addEventListener('keydown',e=>{if(enabled&&valid.has(e.key.toLowerCase())){keys.add(e.key.toLowerCase());e.preventDefault()}});window.addEventListener('keyup',e=>keys.delete(e.key.toLowerCase()));window.addEventListener('blur',()=>keys.clear());
 const dirs={up:'w',down:'s',left:'a',right:'d'};document.querySelectorAll('[data-move]').forEach(b=>{let k=dirs[b.dataset.move];b.addEventListener('pointerdown',()=>{if(enabled)keys.add(k)});['pointerup','pointercancel','lostpointercapture'].forEach(t=>b.addEventListener(t,()=>keys.delete(k)))});
 // Stylized floor bounds: enough to prevent walking over the shelves and exterior.
 function allowed(x,y){if(y<350||y>940)return false;let left=570-(y-350)*.37,right=935+(y-350)*.34;return x>left&&x<right}
 function resize(){let w=host.clientWidth,h=host.clientHeight;if(!w||!h)return;canvas.width=Math.max(1,Math.floor(w/2));canvas.height=Math.max(1,Math.floor(h/2));c.imageSmoothingEnabled=false}new ResizeObserver(resize).observe(host);resize();
 function frame(now){requestAnimationFrame(frame);let dt=Math.min(.05,(now-last)/1000);last=now;let dx=0,dy=0;if(enabled){dx=(keys.has('d')||keys.has('arrowright')?1:0)-(keys.has('a')||keys.has('arrowleft')?1:0);dy=(keys.has('s')||keys.has('arrowdown')?1:0)-(keys.has('w')||keys.has('arrowup')?1:0)}let moving=Math.hypot(dx,dy)>0;if(moving){facing=Math.abs(dx)>Math.abs(dy)?(dx<0?1:2):(dy<0?3:0);let length=Math.hypot(dx,dy),x=pos.x+dx/length*220*dt,y=pos.y+dy/length*220*dt;if(allowed(x,pos.y))pos.x=x;if(allowed(pos.x,y))pos.y=y;walk+=dt*10}
  let p=points.map(q=>({...q,d:Math.hypot(q.x-pos.x,q.y-pos.y)})).sort((a,b)=>a.d-b.d)[0];near=p.d<110?p.id:null;if(near!==previous){previous=near;onNear(near)}
  const w=canvas.width,h=canvas.height;c.clearRect(0,0,w,h);c.fillStyle='#344f45';c.fillRect(0,0,w,h);let scale=Math.min(w/1536,h/1024)*.97,tx=(w-1536*scale)/2,ty=(h-1024*scale)/2;c.save();c.translate(Math.round(tx),Math.round(ty));c.scale(scale,scale);if(bg.complete&&bg.naturalWidth)c.drawImage(bg,0,0,1536,1024);
  for(const point of points){let bob=Math.sin(now/450+point.x)*4;c.fillStyle=point.id==='exit'?'#b3dbc0':'#f2c46e';c.fillRect(point.x-3,point.y-44+bob,6,15);c.fillRect(point.x-8,point.y-39+bob,16,5)}
  c.fillStyle='rgba(44,54,42,.30)';c.beginPath();c.ellipse(pos.x,pos.y+5,22,8,0,0,Math.PI*2);c.fill();if(sheet.complete&&sheet.naturalWidth){let col=moving?Math.floor(walk/2)%4:1,cw=sheet.naturalWidth/4,ch=sheet.naturalHeight/4;c.drawImage(sheet,col*cw,facing*ch,cw,ch,pos.x-48,pos.y-96,96,96)}c.restore();
 }requestAnimationFrame(frame);
 return {setEnabled(v){enabled=v;if(!v)keys.clear()},getNear(){return near},reset(){pos={x:760,y:835};near=null;previous=''}};
}
