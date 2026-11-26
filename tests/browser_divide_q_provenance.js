async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++},wait=()=>new Promise(r=>setTimeout(r,200)),d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();openArchitecture('divide4');await wait();for(const [key,value]of [['av',13],['bv',3]]){const i=d().querySelector('[data-field="'+key+'"]');i.value=String(value);i.dispatchEvent(new Event('change',{bubbles:true}))}d().querySelector('[data-experiment-action="load"]').click();
for(let k=0;k<=4;k++){
 ok(d().querySelectorAll('.an-divide-q-cells .quotient').length===k,'computed width '+k);ok(d().querySelectorAll('.an-divide-q-cells .pending').length===4-k,'unprocessed width '+k);
 const record=d().querySelector('[data-observation-range]').max;
 for(let bit=0;bit<4;bit++){d().querySelector('[data-divide-qbit="'+bit+'"]').click();const detail=d().querySelector('[data-divide-q-detail]').textContent;ok(detail.includes(bit<k?'来自第'+(k-bit)+'轮':'原被除数bit'+(bit-k)),'actual source '+k+'/'+bit)}
 ok(d().querySelector('[data-observation-range]').max===record,'inspection no extra records');
 const prefix=[0,1,3,6,13][k],partial=[0,0,1,2,4][k];ok(d().querySelector('[data-divide-prefix-invariant]').textContent.includes('前缀 '+prefix+' = 除数 3 × 当前商段 '+partial),'actual invariant '+k);
 if(k<4)d().querySelector('[data-experiment-action="tick"]').click();
}
d().querySelector('[data-observation-prev]').click();ok(d().querySelectorAll('.an-divide-q-cells .quotient').length===3,'history exact split');ok([...d().querySelectorAll('[data-divide-qbit]')].every(n=>n.disabled),'history no edit');d().querySelector('[data-observation-live]').click();ok(d().querySelectorAll('.an-divide-q-cells .quotient').length===4,'return exact live split');return {status:'passed',checks};
}
