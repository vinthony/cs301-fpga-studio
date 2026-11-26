async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},d=()=>document.querySelector('.anatomy-dialog[open]');
 for(const id of ['compare10','comparebit']){d()?.querySelector('[data-an-close]').click();openArchitecture(id);await new Promise(r=>setTimeout(r,200));ok(!!d().querySelector('a[href="labs/compare10-prefix.zip"][download]'),'reference at matching level '+id)}
 const r=await fetch('labs/compare10-prefix.zip');ok(r.ok,'HTTP download');const data=await r.arrayBuffer(),sha=[...new Uint8Array(await crypto.subtle.digest('SHA-256',data))].map(b=>b.toString(16).padStart(2,'0')).join('');ok(data.byteLength===10408&&sha==='69fc3211a5c04b244451e32450861dfa977b72e350e1ab68cfa74a733993eb46','release bytes');
 const rtl=await(await fetch('labs/compare10-prefix/evidence/verification.json')).json(),web=await(await fetch('labs/compare10-prefix/evidence/web.json')).json();ok(rtl.status==='passed'&&rtl.allWordPairs===1048576&&rtl.prefixBitsPerWordPair===22,'actual RTL prefix coverage');ok(web.status==='passed'&&web.allWordPairs===1048576&&web.singleBitCases===16,'matching web vectors');
 return {status:'passed',checks,bytes:data.byteLength,sha};
}
