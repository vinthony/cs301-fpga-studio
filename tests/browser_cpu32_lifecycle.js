async()=>{
 const saved=anatomyCPU32Step;let calls=0,checks=0;anatomyCPU32Step=function(s){calls++;return saved(s)};
 try{for(const entry of ['cpu32','board']){calls=0;openArchitecture(entry,entry==='board'?{boardSource:'cpu32',cpuDemo:'io'}:{});for(let i=0;i<250;i++){const d=document.querySelector('.anatomy-dialog[open]');if(d?.querySelector('.an-scene')?.dataset.render==='ready')break;await new Promise(r=>setTimeout(r,15))}const d=document.querySelector('.anatomy-dialog[open]');d.querySelector('[data-cpu32-run]').click();d.querySelector('[data-an-close]').click();await new Promise(r=>setTimeout(r,700));if(calls!==0)throw Error('关闭后仍调用CPU推进 '+entry);checks++;if(document.querySelector('.anatomy-dialog[open]'))throw Error('弹窗未关闭 '+entry);checks++}return {checks,status:'passed'};
 }finally{anatomyCPU32Step=saved}
}
