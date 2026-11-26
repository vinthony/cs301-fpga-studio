# Lab10 · 双读单写寄存器堆

对应Week10/Lab10。网页入口：http://127.0.0.1:8766/learn.html?inside=regfile32 。

## 运行

JDK17/21运行`./run.sh test`，再运行`./run.sh 'Test / runMain cs301.EmitRegFile'`；独立生成RTL复验用`python3 verification/check_generated.py`（需iverilog/vvp）。固定Scala2.13.12/Chisel6.1.0/chiseltest6.0.0/sbt1.10.7；导出使用实际测试低层FIRRTL与JVM后端。

## 时序和接口

RegFile32固定32×32，TeachingRegFile提供位宽/深度参数，深度必须为2的幂。ra/rb/wa为5位地址，wd为32位待写值；we写使能、bypass同址旁路、clear同步清零。qa/qb为组合读口，rawA/rawB为未旁路的保存阵列读值，forwardA/B说明输出是否来自待写数据。

clear及Module同步reset优先于写入；无清零且we=1、wa非0时才在上升沿写入。x0永远读0，写入及旁路均忽略x0。同址旁路只在bypass、we有效且没有clear/reset请求时启用，不需要边沿即可看到wd，但rawA/B仍是旧保存值。clear/reset有效时先关闭旁路，阵列仍等到边沿才清零。

这些复位、读写与旁路选择是教学实现约定，不由RISC-V ISA规定；ISA要求x0恒零。不能把显示新值误认为已写入阵列，也不能把此寄存器堆当作CPU的同一实例。

## 已验证

两项Chisel测试通过：2048步带随机读写、同步reset/clear和旁路的状态流，逐次检查边沿前后保存值、两路输出及旁路来源；另先写满非零寄存器，再遍历32×32=1024读地址对，并专项检查x0写/旁路保护。

实际生成RTL由Icarus与独立Python保存阵列/旁路模型再核对5121个边沿、5120次边沿前快照，末尾遍历1024对读地址。evidence/保留日志、VCD与JSON，generated/是实际生成文件。参数化源码未对所有位宽/深度作证明，改参数需补相应测试。

## 学生任务

1. 不给边沿，修改wd；分别关闭和打开旁路，预测qa与rawA。
2. 同一周期让两个读地址匹配/不匹配wa，验证双读独立。
3. 向x0写FFFFFFFF并开启旁路，解释为什么仍读0。
4. 同时提出clear和写请求，先看边沿前，再看边沿后。
5. 改位宽/深度或旁路策略前先改接口说明与断言；不要让两种读后写约定混在一起。
6. 比较寄存器实现与同步读存储原语的接口差异，实体资源/频率结论需综合报告。

当前没有实体板引脚、资源/时序测量或BRAM原语映射证明。测试的初始化清零是实现选择，不证明真实上电的全部寄存器天然为零。
