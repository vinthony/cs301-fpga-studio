"""Independent instruction interpreter for the teaching EEI, not hardware timing.
No imports from app helpers. Receives JSON cases, returns architectural traces.
"""
import json,sys
MASK=0xffffffff
def signed(v,bits=32):return v-(1<<bits) if v&(1<<(bits-1)) else v
def run(case):
 regs=list(case.get('regs',[0]*32));regs[0]=0;mem=list(case.get('memory',[0]*256));words=case['words'];pc=0;retired=0;halt=False;fault=None;led=0;display=0;trace=[]
 for _ in range(case.get('steps',64)):
  if halt:break
  old_pc=pc;next_pc=(pc+4)&MASK;write=None;store=None;io=None;taken=False;fault=None
  if pc%4:fault='INSTRUCTION_ADDRESS_MISALIGNED';word=0
  elif pc//4>=len(words):fault='INSTRUCTION_ACCESS_FAULT';word=0
  else:word=words[pc//4]
  op=word&127;rd=(word>>7)&31;f=(word>>12)&7;r1=(word>>15)&31;r2=(word>>20)&31;f7=word>>25;a=regs[r1];b=regs[r2];imm=signed(word>>20,12);value=0;valid=True;wb=False
  if not fault:
   if op==0x33:
    code=(f7,f);ops={(0,0):lambda:(a+b),(32,0):lambda:(a-b),(0,1):lambda:a<<(b&31),(0,2):lambda:int(signed(a)<signed(b)),(0,3):lambda:int(a<b),(0,4):lambda:a^b,(0,5):lambda:a>>(b&31),(32,5):lambda:signed(a)>>(b&31),(0,6):lambda:a|b,(0,7):lambda:a&b}
    if code not in ops:valid=False
    else:value=ops[code]();wb=True
   elif op==0x13:
    if f==0:value=a+imm
    elif f==2:value=int(signed(a)<imm)
    elif f==3:value=int(a<(imm&MASK))
    elif f==4:value=a^(imm&MASK)
    elif f==6:value=a|(imm&MASK)
    elif f==7:value=a&(imm&MASK)
    elif f==1 and f7==0:value=a<<r2
    elif f==5 and f7 in (0,32):value=(signed(a) if f7==32 else a)>>r2
    else:valid=False
    wb=valid
   elif op in (3,0x23):
    if op==3:
     sizes={0:(1,True),1:(2,True),2:(4,False),4:(1,False),5:(2,False)}
     if f not in sizes:valid=False
     else:size,sgn=sizes[f];address=(a+imm)&MASK
    else:
     if f not in (0,1,2):valid=False
     else:size=1<<f;imm=signed(((word>>25)<<5)|((word>>7)&31),12);address=(a+imm)&MASK
    if valid:
     kind='STORE' if op==0x23 else 'LOAD'
     if address%size:fault=kind+'_ADDRESS_MISALIGNED'
     elif address<=256-size:
      if op==3:
       value=int.from_bytes(bytes(mem[address:address+size]),'little');value=signed(value,size*8) if sgn else value;wb=True
      else:store=(address,size,b)
     elif size==4 and address in (0xffff0000,0xffff0004,0xffff0008,0xffff000c):
      if op==3:value={0xffff0000:case.get('switches',0x35)&65535,0xffff0004:led,0xffff0008:display,0xffff000c:case.get('buttons',0)&31}[address];wb=True
      elif address in (0xffff0004,0xffff0008):io=(address,b)
      else:fault='STORE_ACCESS_FAULT'
     else:fault=kind+'_ACCESS_FAULT'
   elif op==0x63:
    conditions={0:a==b,1:a!=b,4:signed(a)<signed(b),5:signed(a)>=signed(b),6:a<b,7:a>=b}
    if f not in conditions:valid=False
    else:
     offset=signed(((word>>31)<<12)|(((word>>7)&1)<<11)|(((word>>25)&63)<<5)|(((word>>8)&15)<<1),13);taken=conditions[f]
     if taken:next_pc=(pc+offset)&MASK
   elif op==0x6f:
    offset=signed(((word>>31)<<20)|(((word>>12)&255)<<12)|(((word>>20)&1)<<11)|(((word>>21)&1023)<<1),21);taken=True;next_pc=(pc+offset)&MASK;value=(pc+4)&MASK;wb=True
   elif op==0x67 and f==0:taken=True;next_pc=((a+imm)&MASK)&~1;value=(pc+4)&MASK;wb=True
   elif op==0x37:value=word&0xfffff000;wb=True
   elif op==0x17:value=(pc+(word&0xfffff000))&MASK;wb=True
   elif op==0xf and f==0:pass
   elif word==0x73:fault='ECALL'
   elif word==0x100073:fault='EBREAK'
   else:valid=False
   if not valid:fault='ILLEGAL_INSTRUCTION'
   if not fault and taken and next_pc%4:fault='INSTRUCTION_ADDRESS_MISALIGNED'
   if not fault and wb and rd:write=(rd,value&MASK)
  if fault:halt=True
  else:
   if write:regs[write[0]]=write[1]
   if store:
    address,size,v=store;mem[address:address+size]=list((v&((1<<(size*8))-1)).to_bytes(size,'little'))
   if io:
    if io[0]==0xffff0004:led=io[1]&65535
    else:display=io[1]&MASK
   pc=next_pc;retired+=1
  regs[0]=0;trace.append({'pc':pc,'regs':list(regs),'memory':list(mem),'retired':retired,'halted':halt,'fault':fault,'led':led,'display':display})
 return trace
print(json.dumps([run(c) for c in json.load(sys.stdin)]))
