'use strict';
(async()=>{
 const esc=v=>String(v).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
 try{const response=await fetch('course-map.json',{cache:'no-store'});if(!response.ok)throw Error('课程数据未能载入');const data=await response.json();
 document.querySelector('#weeks').innerHTML=data.weeks.map(w=>'<a href="#week-'+w.week+'">'+String(w.week).padStart(2,'0')+'</a>').join('');
 document.querySelector('#course').innerHTML=data.weeks.map(w=>'<article id="week-'+w.week+'" data-course-week="'+w.week+'"><span class="number">WEEK '+String(w.week).padStart(2,'0')+'</span><h2>'+esc(w.title)+'</h2><span class="status">'+esc(w.status)+'</span><h3>可以在这里观察</h3><p>'+esc(w.available)+'</p><div class="views">'+(w.week===15?'<a href="capstone.html">综合作品材料检查与答辩练习 →</a>':'')+(data.lab_packages?.[w.week]?'<a href="'+esc(data.lab_packages[w.week])+'" download>下载本讲参考工程、测试与波形 ↓</a>':'')+w.views.map(id=>'<a href="'+esc(data.entry_urls?.[w.week]?.[id]||('learn.html?inside='+encodeURIComponent(id)))+'">进入 '+esc(data.view_titles?.[id]||id)+' →</a>').join('')+'</div><h3>还需补齐</h3><p class="gap">'+esc(w.gap)+'</p><details><summary>'+esc(w.lab)+' · 查看原始任务</summary><ol>'+w.tasks.map(t=>'<li>'+esc(t.text)+' <small class="source">[P'+t.paragraph+']</small></li>').join('')+'</ol></details><p class="source">讲义正文 P'+w.source_start+'–P'+w.source_end+'；实验名称 P'+w.lab_paragraph+'。段落号含表格，不是页码。</p></article>').join('');
 document.querySelector('#source').textContent='来源：'+data.source+'；核对日期 '+data.review_date+'。原文件未修改。SHA-256：'+data.source_sha256;
 if(location.hash)document.getElementById(location.hash.slice(1))?.scrollIntoView();
 }catch(error){document.querySelector('#course').innerHTML='<p id="error">'+esc(error.message)+'，请刷新重试。</p>'}
})();
