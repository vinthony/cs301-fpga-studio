const fs=require('fs'),vm=require('vm'),os=require('os'),path=require('path'),cp=require('child_process'),assert=require('assert');
let c=vm.createContext({});for(const f of ['architecture.js','anatomy-catalog.js'])vm.runInContext(fs.readFileSync(path.join(__dirname,'..',f),'utf8'),c);let atlas=JSON.parse(vm.runInContext('JSON.stringify(ANATOMY)',c));
const ids=['and','or','xor','nand','nor','cmos','mux','halfadder','fulladder'],pin=p=>p.replace(/\W/g,'_');let rtl='';
for(const id of ids){let b=atlas[id],pins=new Set(['Y.i','CO.i','A.o','B.o','C.o','S.o','V.o','GND.i']);for(const n of b.nets){pins.add(n.from);pins.add(n.to)}for(const p of b.parts)for(const x of ['a','b','o','s','d','g'])pins.add(p.id+'.'+x);
 rtl+=`module ${id}_c(input A,B,C, output Y,CO);\nwire ${[...pins].map(pin).join(',')};\nassign A_o=A;assign B_o=B;assign C_o=C;assign S_o=C;assign V_o=1'b1;assign GND_i=1'b0;\n`;
 for(const n of b.nets)rtl+=['nand','nor','cmos'].includes(id)?`tran(${pin(n.to)},${pin(n.from)});\n`:`assign ${pin(n.to)}=${pin(n.from)};\n`;
 for(const p of b.parts){let k=p.type;if(['and','or','xor','nand','nor'].includes(k))rtl+=`assign ${p.id}_o=${['nand','nor'].includes(k)?'~':''}(${p.id}_a ${['and','nand'].includes(k)?'&':['or','nor'].includes(k)?'|':'^'} ${p.id}_b);\n`;if(['not','inverter'].includes(k))rtl+=`assign ${p.id}_o=~${p.id}_a;\n`;if(k==='nmos'||k==='pmos')rtl+=`tranif${k==='nmos'?'1':'0'} (${p.id}_s,${p.id}_d,${p.id}_g);\n`;}
 rtl+=`assign Y=Y_i;assign CO=${['halfadder','fulladder'].includes(id)?'CO_i':"1'b0"};endmodule\n`;
}
rtl+='module tb;reg A,B,C;integer i;';for(const id of ids)rtl+=`wire ${id}_y,${id}_co;${id}_c u_${id}(A,B,C,${id}_y,${id}_co);\n`;
rtl+=`initial begin for(i=0;i<8;i=i+1)begin {A,B,C}=i;#1;\n`;
const formulas={and:'A&B',or:'A|B',xor:'A^B',nand:'~(A&B)',nor:'~(A|B)',cmos:'~A',mux:'C?B:A',halfadder:'A^B',fulladder:'A^B^C'};
for(const id of ids)rtl+=`if(${id}_y !== (${formulas[id]})) $fatal(1,"${id} mismatch %b%b%b",A,B,C);\n`;
rtl+=`if(fulladder_co !== ((A&B)|((A^B)&C)))$fatal(1,"carry");if(halfadder_co !== (A&B))$fatal(1,"halfcarry");end $display("PASS: 88 gate-level output checks, generated from teaching topology");$finish;end endmodule\n`;
let dir=fs.mkdtempSync(path.join(os.tmpdir(),'cs301-anatomy-'));try{let src=path.join(dir,'topology.v'),out=path.join(dir,'run');fs.writeFileSync(src,rtl);cp.execFileSync('iverilog',['-g2012','-s','tb','-o',out,src]);console.log(cp.execFileSync('vvp',[out],{encoding:'utf8'}).trim())}finally{fs.rmSync(dir,{recursive:true,force:true})}
