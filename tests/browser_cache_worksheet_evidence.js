async()=>{
 let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},key='gbu-cs301-cache-classroom-v1',previous=localStorage.getItem(key),values=[...document.querySelectorAll('[data-save]')].map(n=>[n,n.value,n.checked]),frame=document.createElement('iframe');
 frame.style.cssText='position:fixed;left:-10000px;width:1400px;height:900px';frame.src='learn.html';document.body.append(frame);
 try{
  await new Promise(r=>frame.onload=r);const w=frame.contentWindow,doc=frame.contentDocument;let blob;
  w.URL.createObjectURL=b=>{blob=b;return 'blob:test'};w.HTMLAnchorElement.prototype.click=function(){};
  for(const [task,view]of [[1,'memorySystem'],[2,'tageq5'],[3,'and']]){
   doc.querySelector('.anatomy-dialog[open] [data-an-close]')?.click();w.openArchitecture(view);await new Promise(r=>setTimeout(r,120));
   if(view==='memorySystem'){const f=doc.querySelector('[data-field="data"]');f.value=99;f.dispatchEvent(new w.Event('change',{bubbles:true}));doc.querySelector('[data-experiment-action="write"]').click();doc.querySelector('[data-experiment-action="access"]').click()}
   doc.querySelector('[data-export-report]').click();const html=await blob.text(),summary=reportEvidence(html,task,'真实报告.html');ok(summary.includes('层级：'+view+'（符合本任务建议层级）')&&summary.includes('路径：'),'actual report parses');
   if(task===1)ok(summary.includes('memoryLastRead = {"address":0,"value":99'),'actual saved read source');
   const input=document.querySelector('#report'+task),files=new DataTransfer();files.items.add(new File([html],'真实报告.html',{type:'text/html'}));input.files=files.files;input.dispatchEvent(new Event('change',{bubbles:true}));await new Promise(r=>setTimeout(r,60));
   ok(document.querySelector('#evidence'+task).value===summary,'native file input reads report');ok(notes().includes(summary),'task export includes source summary');
   ok(reportEvidence(html,task===1?2:1,'错层级.html').includes('与本任务建议层级不同'),'wrong view identified without grading');
  }
  let rejected=false;try{reportEvidence('<html>普通文件<script>window.invalidReportExecuted=true</script></html>',1,'无状态.html')}catch{rejected=true}ok(rejected&&!window.invalidReportExecuted,'invalid report rejected without running content');
  return {status:'passed',checks,actualReports:3};
 }finally{
  frame.remove();if(previous===null)localStorage.removeItem(key);else localStorage.setItem(key,previous);for(const [node,value,checked]of values){node.value=value;node.checked=checked}for(const input of document.querySelectorAll('[data-report-task]'))input.value='';
 }
}
