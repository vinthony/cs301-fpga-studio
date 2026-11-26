async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=()=>new Promise(r=>setTimeout(r,50)),d=()=>document.querySelector('.anatomy-dialog[open]');
 for(const id of ['vga','vgacore','pixelcounter','videotiming','framebuffer']){
  d()?.querySelector('[data-an-close]').click();openArchitecture(id);await wait();const input=d().querySelector('[data-field="rgb"]');input.value=2748;input.dispatchEvent(new Event('change',{bubbles:true}));
  for(const [x,y]of [[639,0],[640,0],[656,0],[752,0],[799,479],[0,480],[0,490],[0,492],[799,520]]){
   d().querySelector('[data-vga-start="'+(y*800+x)+'"]').click();let lens=d().querySelector('.an-vga-lens');ok(+lens.dataset.vgaPixel===y*800+x&&+lens.dataset.vgaTicks===0,'start explicit position');ok(+lens.querySelector('[data-vga-hs]').textContent===+(x<656||x>=752),'HS boundary');ok(+lens.querySelector('[data-vga-vs]').textContent===+(y<490||y>=492),'VS boundary');ok(+lens.querySelector('[data-vga-active]').textContent===+(x<640&&y<480),'DE boundary');ok(lens.querySelector('[data-vga-rgb]').textContent===(x<640&&y<480?'0xabc':'0x000'),'actual RGB');ok(+d().querySelector('[data-observation-range]').max===0,'position starts new observation experiment');d().querySelector('[data-tick]').click();lens=d().querySelector('.an-vga-lens');ok(+lens.dataset.vgaPixel===(y*800+x+1)%416800&&+lens.dataset.vgaTicks===1,'actual pixel tick redraws');
  }
  d().querySelector('[data-vga-start="639"]').click();d().querySelector('[data-vga-advance="line"]').click();ok(+d().querySelector('.an-vga-lens').dataset.vgaPixel===800&&+d().querySelector('.an-vga-lens').dataset.vgaTicks===161,'next line includes blanking');d().querySelector('[data-vga-advance="frame"]').click();ok(+d().querySelector('.an-vga-lens').dataset.vgaPixel===0&&+d().querySelector('.an-vga-lens').dataset.vgaTicks===416161,'next frame count');ok(+d().querySelector('[data-observation-range]').max===2,'only batch endpoints recorded');ok(d().querySelector('.an-vga-lens').scrollWidth<=d().querySelector('.an-vga-lens').clientWidth,'no sidebar overflow');
 }
 return {status:'passed',views:5,checks};
}
