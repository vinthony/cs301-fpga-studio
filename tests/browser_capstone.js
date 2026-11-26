async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},file=(name,content='abc')=>new File([content],name);
 const files=[file('Core.scala'),file('build.sbt'),file('tests.py'),file('Core.v'),file('board.png'),file('program.s'),file('README.md'),file('<img src=x onerror=alert(1)>.txt')];
 await capstoneSelect(files);ok(capstoneRecords.length===8,'all files read');ok(capstoneRecords.every(r=>r.sha256==='ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad'),'actual known SHA256');ok(capstoneClassify(capstoneRecords).every(r=>r.present),'all material categories');ok(!document.querySelector('#inventory img'),'filenames rendered as text');
 ok(!capstoneClassify([{path:'Core.scala'}]).find(r=>r.id==='source').present,'build file required with source');
 let rejected=false;try{await capstoneScan([file('same'),file('same')])}catch{rejected=true}ok(rejected,'duplicate paths rejected');
 rejected=false;try{await capstoneScan([{size:129*1024*1024,name:'huge'}])}catch{rejected=true}ok(rejected,'size limit before read');
 let finish;const pending=capstoneSelect([{name:'old.txt',size:3,arrayBuffer:()=>new Promise(r=>finish=r)}]);await capstoneSelect([file('new.txt')]);finish(new TextEncoder().encode('abc').buffer);await pending;ok(capstoneRecords[0].path==='new.txt','latest selection wins async race');
 await capstoneSelect(files);document.querySelector('#project').value='测试作品';
 const create=URL.createObjectURL,click=HTMLAnchorElement.prototype.click;let blob;URL.createObjectURL=b=>{blob=b;return create(b)};HTMLAnchorElement.prototype.click=function(){};
 try{document.querySelector('#export').click();const manifest=JSON.parse(await blob.text());ok(manifest.files.length===8&&manifest.project==='测试作品','export exact inventory and notes');ok(manifest.verification.includes('not verified'),'export evidence boundary');ok(!('content' in manifest.files[0]),'no file contents exported')}finally{URL.createObjectURL=create;HTMLAnchorElement.prototype.click=click}
 document.querySelector('#start').click();await new Promise(r=>setTimeout(r,1100));document.querySelector('#start').click();ok(document.querySelector('#clock').textContent==='00:01','timer advances and pauses');const time=document.querySelector('#clock').textContent;await new Promise(r=>setTimeout(r,250));ok(document.querySelector('#clock').textContent===time,'paused timer holds');document.querySelector('#reset').click();ok(document.querySelector('#clock').textContent==='00:00','timer reset');
 document.querySelector('#clear').click();ok(capstoneRecords.length===0&&document.querySelector('#export').disabled,'clear revokes export');ok(document.querySelector('#project').value==='测试作品','clear preserves written notes');
 return {status:'passed',checks};
}
