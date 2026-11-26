async () => {
 let checks=[];const check=(ok,n)=>{if(!ok)throw Error(n);checks.push(n)};
 const load=async id=>{loadLesson(LESSONS.find(l=>l.id===id));await queue};
 const masks=()=>[...$('sevenseg').children].map(svg=>[...svg.querySelectorAll('polygon')].reduce((n,p,i)=>n+(p.classList.contains('lit')?1<<i:0),0));
 await load('adder');sw=0x35;await sample(0);check(bitsNumber(samples.at(-1).led)===8n&&bitsNumber(samples.at(-1).display)===8n,'0035 的 LED 与 DISPLAY 均为 8');check(masks().join(',')==='63,63,63,127','数码管段形确为 0008');check($('ioSummary').textContent.includes('A=5')&&$('ioSummary').textContent.includes('B=3'),'操作数解释与 SW 位域一致');
 sw=0xff;await sample(0);check(bitsNumber(samples.at(-1).display)===30n&&masks().join(',')==='63,63,6,121','最大四位和 30 与 001E 段形');
 let data=await apiSim(activeCode,[{sw:0x35}],activeProfile,'',['sum']);check(testValue(data.samples[0],'sum')==='01000','内部组合连线可以断言');
 await load('signed');sw=15;await sample(0);check(bitsNumber(samples.at(-1).led)===15n&&bitsNumber(samples.at(-1).display)===0xffffffffn,'补码解释器保留原始位与符号扩展');check(masks().every(n=>n===113)&&$('ioSummary').textContent.includes('补码=-1'),'负一呈现 FFFF 并说明有符号含义');
 await load('alu');check(bitsNumber(samples.at(-1).display)===0n,'全零输入启动的 ALU 已确定');await runTests();check(lastTestReport.cases[0].pass&&lastTestReport.cases[0].assertions.length===4096,'ALU 2048 组输入、4096 项输出断言');
 await load('led');for(let i=0;i<16;i++){if(sw)sw=0;await sample(0);$('s'+i).click();await queue;check(sw===(1<<i)&&[...$('leds').querySelectorAll('.led.on')].length===1&&$('l'+i).classList.contains('on'),'SW'+i+' 到 LD'+i+' 不反序')}
 await load('counter');sw=1;await advance(2);observeSample(2);$('testExample').click();let generated=JSON.parse($('testsCode').value).at(-1);check(generated.steps.length===3&&BigInt(generated.steps.at(-1).expect.display)===1n,'历史测试使用对应输入前缀与实际采样值');await runTests();check(lastTestReport.cases.every(c=>c.pass),'从历史生成的测试真实通过');returnLive();
 let previous=events.length;$('hex').value='ZZ';await compileDesign().catch(()=>{});check(ready&&events.length===previous,'无效 SW 不悄悄当零或清空运行');$('hex').value='0001';
 $('speed').value='200';let run=continuous();await new Promise(r=>setTimeout(r,30));$('code').value+='\n// pending edit';await run;check(!running,'连续运行遇到未编译修改会停止');
 await load('basys');for(let n=0;n<16;n++){sw=n*0x1111;await sample(0);for(let d=0;d<4;d++){let sample=samples.at(-1),an=Number(bitsNumber(sample.an)),idx=[3,2,1,0].findIndex(bit=>!(an&(1<<bit))),actual=masks(),want=segmentMasks[n];check(actual.every((v,i)=>v===(i===idx?want:0)),'低有效译码 '+n.toString(16)+' / 扫描 '+d);await advance(1)}}
 $('code').value=`module basys_top(input clk,input [15:0] sw,input btnC,btnU,btnL,btnR,btnD,output [15:0] led,output [6:0] seg,output [3:0] an,output dp);assign led=sw;assign seg=7'b1111001;assign an=4'b1100;assign dp=1'b0;endmodule`;
 await compileDesign();check(masks().join(',')==='0,0,6,6'&&$('sevenseg').querySelectorAll('circle.lit').length===2,'多位同时选通和低有效小数点');
 await load('adder');sw=0x35;await sample(0);check($('ioSummary').textContent.includes('DISPLAY=0x00000008'),'最终加法器显示一致');
 return {passed:checks.length,checks};
}
