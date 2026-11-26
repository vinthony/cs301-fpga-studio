async()=>{
 document.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();openArchitecture('rastercounter');await new Promise(r=>setTimeout(r,300));
 const a=document.querySelector('.anatomy-dialog[open] a[href="labs/raster-counter.zip"]');if(!a||!a.hasAttribute('download'))throw Error('hardware download absent');
 const r=await fetch(a.href);if(!r.ok)throw Error('HTTP '+r.status);const data=await r.arrayBuffer(),sha=[...new Uint8Array(await crypto.subtle.digest('SHA-256',data))].map(b=>b.toString(16).padStart(2,'0')).join('');
 if(sha!=='570177b2407c39a2a8e73b8acfdf30bef5d6be0fdfd692808466031a02b50ea6'||data.byteLength!==68435)throw Error('release mismatch');
 const evidence=await (await fetch('labs/raster-counter/evidence/verification.json')).json(),web=await(await fetch('labs/raster-counter/evidence/web.json')).json();if(evidence.totalEdges!==4227505||web.vectors!==4227505||web.status!=='passed')throw Error('evidence missing');
 return {status:'passed',bytes:data.byteLength,sha,rtlEdges:evidence.totalEdges,webVectors:web.vectors};
}
