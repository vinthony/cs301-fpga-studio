/* Local Ace integration; hardware colors are shared with basys.css. */
const hardwareSignals={sw:{label:'拨码开关',color:'#54d6ee',target:'#switches'},btn:{label:'五向按键',color:'#c39aff',target:'#boardKeys'},led:{label:'LED',color:'#b5ed67',target:'#leds'},display:{label:'数码管',color:'#ff7779',target:'#sevenseg'},clk:{label:'时钟',color:'#f3cd72',target:'.clock-controls'},reset:{label:'复位',color:'#ffa66c',target:'#reset'},seg:{label:'段选 a–g',color:'#ff7779',target:'#sevenseg'},an:{label:'位选 AN',color:'#ef9ccf',target:'.segment-label'},dp:{label:'小数点',color:'#ffb5b8',target:'#sevenseg'}};
ace.config.set('basePath','vendor/ace');
ace.define('ace/mode/board_verilog',['require','exports','module','ace/lib/oop','ace/mode/verilog','ace/mode/verilog_highlight_rules'],function(require,exports){
 const oop=require('ace/lib/oop'),Base=require('ace/mode/verilog').Mode,Rules=require('ace/mode/verilog_highlight_rules').VerilogHighlightRules;
 const BoardRules=function(){Rules.call(this);this.$rules.start.unshift(
 {token:'constant.numeric',regex:"(?:[0-9][0-9_]*)?'[sS]?[bBoOdDhH][0-9a-fA-F_xXzZ?]+|'[01xXzZ]"},
 {token:'preprocessor',regex:'`[a-zA-Z_][a-zA-Z0-9_$]*'},
 {token:'identifier',regex:'\\\\[^\\s]+'},
 {token:v=>'hardware.'+(/^btn[CURDL]$/.test(v)?'btn':v),regex:'(?:sw|btn|btnC|btnU|btnL|btnR|btnD|led|display|clk|reset|seg|an|dp)\\b'},
 {token:'keyword',regex:'(?:logic|always_ff|always_comb|always_latch|typedef|enum|struct|union|bit|int|byte|shortint|longint|interface|endinterface|modport|package|endpackage|import|assert|property|endproperty|unique|priority|return|void)\\b'}
 );this.normalizeRules()};oop.inherits(BoardRules,Rules);
 const Mode=function(){Base.call(this);this.HighlightRules=BoardRules};oop.inherits(Mode,Base);exports.Mode=Mode;
});
const codeSource=$('code');const initialCode=codeSource.value;codeSource.hidden=true;
const editor=ace.edit('ide');window.fpgaEditor=editor;
editor.setTheme('ace/theme/tomorrow_night');editor.session.setMode('ace/mode/board_verilog');editor.session.setUseWorker(false);
editor.setOptions({fontSize:14,fontFamily:'Menlo,Monaco,Consolas,monospace',showPrintMargin:false,tabSize:2,useSoftTabs:true,enableBasicAutocompletion:true,enableLiveAutocompletion:true,highlightActiveLine:true,showLineNumbers:true,wrap:false,scrollPastEnd:.3,behavioursEnabled:true});
editor.setValue(initialCode,-1);
Object.defineProperty(codeSource,'value',{configurable:true,get:()=>editor.getValue(),set:v=>{editor.setValue(v,-1);editor.session.clearAnnotations()}});
ace.require('ace/ext/language_tools').addCompleter({getCompletions(_editor,_session,_pos,_prefix,callback){callback(null,[...Object.entries(hardwareSignals).map(([name,s])=>({caption:name,value:name,meta:s.label,score:1000})),...['module','endmodule','input','output','wire','reg','logic','assign','always','always_ff','always_comb','posedge','negedge','begin','end','if','else','case','endcase','default','parameter'].map(value=>({caption:value,value,meta:'Verilog',score:500}))])}});
$('signalLegend').innerHTML=Object.entries(hardwareSignals).map(([name,s])=>`<button class="signal-chip signal-${name}" data-signal="${name}" title="定位 ${name}"><i></i><b>${name}</b> ${s.label}</button>`).join('');
let highlighted=null;
function highlightHardware(name){if(/^btn[CURDL]$/.test(name||''))name='btn';window.onHardwareFocus?.(name);document.querySelectorAll('.signal-focus').forEach(e=>e.classList.remove('signal-focus'));document.querySelectorAll('.signal-chip').forEach(e=>e.classList.toggle('active',e.dataset.signal===name));highlighted=name;if(!hardwareSignals[name])return;let target=document.querySelector(hardwareSignals[name].target);if(target){target.style.setProperty('--focus-color',hardwareSignals[name].color);target.classList.add('signal-focus')}}
$('signalLegend').querySelectorAll('button').forEach(b=>b.onclick=()=>{let name=b.dataset.signal;editor.find(name,{wholeWord:true,caseSensitive:true,wrap:true});editor.focus();highlightHardware(name)});
editor.selection.on('changeCursor',()=>{let p=editor.getCursorPosition(),token=editor.session.getTokenAt(p.row,p.column);highlightHardware(token?.type?.startsWith('hardware.')?token.value:null);$('idePosition').textContent=`行 ${p.row+1}，列 ${p.column+1}`});
editor.session.on('change',()=>{$('ideState').textContent=editor.getValue()===activeCode?'已编译':'已修改 · 需编译';$('ideState').classList.toggle('dirty',editor.getValue()!==activeCode)});
editor.commands.addCommand({name:'compileBoard',bindKey:{win:'Ctrl-Enter',mac:'Command-Enter'},exec:()=>$('compile').click()});
editor.commands.addCommand({name:'saveDesign',bindKey:{win:'Ctrl-S',mac:'Command-S'},exec:()=>$('save').click()});
$('ideSearch').onclick=()=>editor.execCommand('find');$('ideUndo').onclick=()=>editor.undo();$('ideRedo').onclick=()=>editor.redo();$('ideFont').onchange=()=>editor.setFontSize(Number($('ideFont').value));
function showCompilerFeedback(error){editor.session.clearAnnotations();if(!error){let dirty=editor.getValue()!==activeCode;$('ideState').textContent=dirty?'已修改 · 需编译':'已编译';$('ideState').classList.toggle('dirty',dirty);return}let annotations=[];for(let line of String(error).split('\n')){let m=line.match(/design\.sv:(\d+):\s*(.*)/);if(m)annotations.push({row:Number(m[1])-1,column:0,text:m[2],type:'error'})}editor.session.setAnnotations(annotations);$('ideState').textContent='编译失败';$('ideState').classList.add('dirty');if(annotations.length)editor.gotoLine(annotations[0].row+1,0,false)}
new ResizeObserver(()=>editor.resize()).observe($('ide'));

window.hardwareColor=name=>{let leaf=name.split('.').at(-1);if(/^btn[CURDL]$/.test(leaf))leaf='btn';return hardwareSignals[leaf]?.color};
