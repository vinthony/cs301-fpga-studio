async()=>{
let checks=0;const ok=(v,n)=>{if(!v)throw Error(n);checks++};
for(const [text,bytes] of [['A',[65]],['中',[228,184,173]],['🙂',[240,159,153,130]],['A中🙂',[65,228,184,173,240,159,153,130]]]){
 const s=anatomyState();anatomyFIFOTextLoad(s,text);ok(String(s.fifoText.bytes)===String(bytes),'known encoding '+text);
 const before=s.ticks;for(let i=0;i<Math.min(4,bytes.length);i++)ok(anatomyFIFOTextFeed(s),'accepted input byte');
 if(bytes.length>4){const saved=JSON.stringify(s);ok(!anatomyFIFOTextFeed(s),'full blocks');ok(JSON.stringify(s)===saved,'blocked source preserves everything');}
 while(s.fifoText.index<bytes.length||s.fifoCount||s.fifoTX?.tx.uartIndex>=0){if(s.fifoText.index<bytes.length)anatomyFIFOTextFeed(s);anatomyFIFOTransmitStep(s);while(s.fifoTX?.rxFIFO?.fifoCount)anatomyFIFOReceiveRead(s)}
 ok(String(s.fifoTX.consumed)===String(bytes),'exact full wire transport');ok(anatomyFIFOTextResult(s.fifoTX.consumed)===JSON.stringify(text),'decoded text');ok(!s.fifoTX.rxOverflow,'no loss when consumer serviced');
}
const s=anatomyState();anatomyFIFOTextLoad(s,'OK');const previous=JSON.stringify(s.fifoText);for(const text of ['', '中'.repeat(22)]){let rejected=false;try{anatomyFIFOTextLoad(s,text)}catch{rejected=true}ok(rejected,'invalid load rejects');ok(JSON.stringify(s.fifoText)===previous,'failed load preserves pending source')}
ok(anatomyFIFOTextResult([228]).includes('尚不能解码'),'partial UTF8 explicit');
const wait=()=>new Promise(r=>setTimeout(r,180)),d=()=>document.querySelector('.anatomy-dialog[open]');d()?.querySelector('[data-an-close]').click();openArchitecture('fifo');await wait();
const input=d().querySelector('[data-fifo-text-draft]');input.value='中';input.dispatchEvent(new Event('input',{bubbles:true}));d().querySelector('[data-fifo-text-load]').click();ok(d().querySelector('.an-fifo-text-bytes').textContent.includes('E4'),'render actual bytes');
for(let i=0;i<3;i++)d().querySelector('[data-fifo-text-feed]').click();ok(d().querySelector('[data-fifo-text-progress]').textContent.includes('3 / 3'),'actual source progress');
d().querySelector('[data-observe-section="serial"]').click();for(let byte=0;byte<3;byte++){for(let i=0;i<11;i++)d().querySelector('[data-fifo-tx-step]').click();d().querySelector('[data-fifo-rx-read]').click()}
ok(d().querySelector('[data-fifo-rx-text]').textContent.includes('"中"'),'browser wire to actual application text');
d().querySelector('[data-observation-prev]').click();ok(d().querySelector('[data-fifo-text-load]').disabled,'historical input readonly');d().querySelector('[data-observation-live]').click();
return {status:'passed',checks};
}
