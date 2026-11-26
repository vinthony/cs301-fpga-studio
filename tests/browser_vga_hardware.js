async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]');
 for(const id of ['vga','vgacore','pixelcounter','videotiming','framebuffer']){
  d()?.querySelector('[data-an-close]').click();openArchitecture(id);await new Promise(r=>setTimeout(r,150));
  ok(!!d().querySelector('a[href="labs/vga-raster-timing.zip"]')===(id!=='framebuffer'),'scope '+id);
 }
 const r=await fetch('labs/vga-raster-timing.zip');ok(r.ok,'download HTTP');const data=await r.arrayBuffer(),sha=[...new Uint8Array(await crypto.subtle.digest('SHA-256',data))].map(b=>b.toString(16).padStart(2,'0')).join('');ok(data.byteLength===83523&&sha==='6547ca5b1e79a6ede0c133a74270bc8626f4ca42c510d6c397b982d02b9219c8','release bytes');
 const evidence=await(await fetch('labs/vga-raster-timing/evidence/verification.json')).json(),web=await(await fetch('labs/vga-raster-timing/evidence/web.json')).json();ok(evidence.status==='passed'&&evidence.totalEdges===2537185,'RTL evidence');ok(web.realWebAdvanceEdges===1703421&&web.resetInitializations===833764,'web reset not counted as advance');
 d().querySelector('[data-an-close]').click();openArchitecture('vga');await new Promise(r=>setTimeout(r,150));d().querySelector('a[href="labs/vga-raster-timing.zip"]').scrollIntoView({block:'center'});
 return {status:'passed',checks,bytes:data.byteLength,sha};
}
