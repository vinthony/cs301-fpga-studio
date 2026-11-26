# Lab09 · 32位ALU与边界验证

对应Week09/Lab09。网页入口：http://127.0.0.1:8766/learn.html?inside=alu32 。

## 运行

JDK17/21下运行`./run.sh test`，再运行`./run.sh 'Test / runMain cs301.EmitALU32'`；独立RTL复验为`python3 verification/check_generated.py`（需要iverilog/vvp）。固定Scala2.13.12/Chisel6.1.0/chiseltest6.0.0/sbt1.10.7；本工程缓存校验后的启动器，不改全局配置。先测试，再从实际低层FIRRTL以JVM后端导出生成Verilog。

## 契约与网页对应

操作码0…9为ADD/SUB/AND/OR/XOR/SLL/SRL/SRA/SLT/SLTU，顺序与网页十操作一致；Lab05的SHL/SHR对应SLL/SRL。A/B/R为32位原始模式，结果模2^32。移位量为B[4:0]，所以B=32等价移0位。SRA复制符号位，SLT解释补码，SLTU解释无符号。

Zero为结果等于0，Sign为结果bit31；C/V为教学调试量，不是RV32I架构状态寄存器。ADD的C表示无符号进位，SUB的C表示无借位；V表示有符号结果超出−2^31…2^31−1。非ADD/SUB的C/V置零并flagsValid=false；不要把无效的零当成算术结论。网页同样说明非算术C/V置零。

未定义操作码10…15使operationValid=false、result=0、Zero=true、Sign/C/V=false、flagsValid=false。此有效标记只针对ALU操作码，不是指令合法性解码。

TeachingALU支持至少2位、且位宽为2的幂的参数化版本，移位量取相应log2(width)低位；ALU32固定32位。四位参数测试用于核对语义，不替代所有参数的证明。

## 已验证

Chisel两项测试实际通过：11种边界值全配对及1024随机对的16种操作码，共18320组合；另有四位SRA/SLT/SLTU参数检查。实际生成ALU32.v又由Icarus与独立Python任意精度算术对照67472向量，全程无时钟边沿。日志、VCD与JSON在evidence/。

## 学生任务

1. 预测7FFFFFFF+1、FFFFFFFF+1、80000000−1的R/C/V，先区分有符号和无符号问题。
2. 比较80000000右移1/31位时SRL与SRA；解释B=32/33。
3. 用FFFFFFFF与0比较SLT/SLTU；说明Sign不等于溢出。
4. 为非法操作码写断言，比较结果有效与标志有效。
5. 比较四位与32位边界策略：四位可穷举，32位需定向边界、随机与断言。
6. RCA/CLA实现及性能比较需独立结构、同一器件约束下综合/时序与资源报告；本包没有实际延迟/面积结论。

这是组合ALU参考模块，不执行指令、没有寄存器堆/内存、没有实体板引脚和真实频率验证。参考ISA语义：[RISC-V官方RV32I](https://docs.riscv.org/reference/isa/v20260120/unpriv/rv32.html)。
