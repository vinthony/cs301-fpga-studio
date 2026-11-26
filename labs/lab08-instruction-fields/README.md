# Lab08 · 指令字段观察与编码练习

对应Week08/Lab08。网页入口为decoder32；立即数拼接见immgen32，执行程序见cpu32。此参考工程只做原始切片与课堂opcode格式映射，不把切片当作执行或合法性解码。

## 运行

JDK17/21下执行`./run.sh test`，再执行`./run.sh 'Test / runMain cs301.EmitFields'`。独立RTL复验为`python3 verification/check_generated.py`，需iverilog/vvp。固定Scala2.13.12/Chisel6.1.0/chiseltest6.0.0/sbt1.10.7；启动器在工程内校验缓存，导出基于实际测试低层FIRRTL与JVM后端。

## 原始切片与语义

opcode=inst[6:0]；rdSlice=inst[11:7]；funct3Slice=inst[14:12]；rs1Slice=inst[19:15]；rs2Slice=inst[24:20]；funct7Slice=inst[31:25]。这些名字强调“切片”，不保证当前格式真的使用该寄存器或功能字段。

S/B没有rd目的字段，相关位置包含立即数；I型的rs2Slice经常属于立即数。U/J中多数原始切片也不是源寄存器。比如SW的rdSlice=12不代表写x12，ADDI的rs2Slice=28不代表读取x28。

format仅按选定课堂opcode归类：0未归类、1R、2I、3S、4B、5U、6J。即使funct非法或属于M扩展，opcode=0x33仍会归为R；这不是合法性判断。SYSTEM/FENCE等也未纳入本小映射。完整控制与合法性请看后续Lab11/网页decoder32。

## 练习

先完成worksheet.md，再看教师答案。手工拆解add/addi/lw/sw/beq/jal及LUI，画出32位格式并解释字段位置。将答案输入网页，改变某一位后预测哪些原始字段变化；不要把变更解释成已执行指令。B/J偏移编码最低位隐含0；具体执行对齐要求另看CPU，不把可编码偏移当作一定可执行的目标。

## 已验证与边界

Chisel测试包括7条固定编码、32个单置位模式、零/全1与4096随机字，原始字段与格式对照通过。实际生成RTL再由Icarus对照独立Python二进制字符串切片，8361向量通过，含全部128种opcode。evidence/保存日志、VCD与结果。

这里不生成立即数、不判断全部RV32I合法性、不执行指令、不提供实体板约束；这些不能由本测试代替。参考：[RISC-V官方RV32I格式](https://docs.riscv.org/reference/isa/v20260120/unpriv/rv32.html)。提交切片源码、测试、字段表、手工编码过程及解释报告。
