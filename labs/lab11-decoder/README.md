# Lab11 · Decoder + ImmGen + 控制请求

对应Week11/Lab11；网页decoder32和immgen32。涵盖基础RV32I教学集合40种编码，不支持M、CSR、FENCE.I、压缩等扩展。模块是组合解码，不执行指令或系统服务。

## 运行

JDK17/21使用`./run.sh test`，再`./run.sh 'Test / runMain cs301.EmitDecoder'`。生成RTL的独立复验为`python3 verification/check_generated.py`，需要iverilog/vvp。固定Scala2.13.12/Chisel6.1.0/chiseltest6.0.0/sbt1.10.7；导出使用实际测试低层FIRRTL与JVM后端。

## 接口编码

Decoder32接收32位instruction，输出原始opcode/rd/rs1/rs2/funct3/funct7，识别id、格式、ALU操作、立即数、读写/跳转等控制摘要以及独立loadUnsigned/shiftImmediate。原始字段不是当前指令一定使用的寄存器，需结合控制位。

格式：0R、1I、2S、3B、4U、5J、6无立即数、7未支持。ALU：0ADD/1SUB/2AND/3OR/4XOR/5SLL/6SRL/7SRA/8SLT/9SLTU，与Lab09一致。

control位：0 valid、1 useRS1、2 useRS2、3 regWrite、4 memRead、5 memWrite、6 branch、7 jump、8 useImm、9 usePC、10 trap、11 fence；13:12为写回选择（ALU/MEM/PC+4/IMM），15:14为访存粒度（字节/半字/字）。loadUnsigned和shiftImmediate另有输出，不藏在摘要未定义位中。

未支持编码：id63、format7、control0、alu0、其余请求关闭。effectiveRegWrite只在请求写且rd非0时为真，这是x0过滤，不是执行异常/访存故障的最终提交允许。branchKind在branch有效时为原始funct3；trapKind=1 ECALL、2 EBREAK、0其他。trap/fence只是请求，不实现陷阱入口或内存排序执行。

独立Immediate32的手选格式为0I/1S/2B/3U/4J，5…7输出0。Decoder内部已将自己的格式映射到它；不能把两组编号未经转换直接接线。I/S/B/J符号扩展，B/J最低位补0，U低12位补0。保留FENCE的忽略字段行为，但不将FENCE.I误识别为FENCE。

## 验证与独立性

Chisel控制表声明沿用网页的40项规范数据，保存在decoder-table.json与DecoderTable.scala；网页与Chisel共用声明不能单独算“独立等价证明”。验证使用另外手写的Verilog解码器/立即数参考（verification/reference），它们不读取该表。

Chisel测试覆盖17个固定控制/边界编码、x0请求过滤和8472个手选立即数格式案例。生成RTL另外对照所有128×8×128个opcode/funct3/funct7组合、40个合法集合样例、随机位模式等；并对每个字检查全部8种手选立即数格式。最终准确数量见evidence/generated-rtl-check.json。测试还验证所有40种识别ID确实出现，原始位切片和有效写请求的过滤正确。

## 学生任务

1. 手工写出至少12条指令的字段、立即数与控制请求，再运行固定编码断言。
2. 比较SW/BEQ的原始rd切片与regWrite；比较ADDI的rs2切片与useRS2。
3. 追踪B/J立即数输出每位来自哪一指令位，特别是inst[7]与隐含0。
4. 改ADD的funct7为SUB或M扩展，预测ALU操作与valid；检查非法编码没有写请求。
5. 区分请求、x0过滤、执行异常门控和真正边沿提交；此包只完成前两层。
6. 在完整CPU集成前明确ALU/格式/写回编号，给接口连接写断言。

没有完整CPU、陷阱/OS、流水线或实体板验证；资源和时序需另做综合报告。参考：[RISC-V官方RV32I](https://docs.riscv.org/reference/isa/v20260120/unpriv/rv32.html)。
