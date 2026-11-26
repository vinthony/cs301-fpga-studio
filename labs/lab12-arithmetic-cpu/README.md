# Lab12 · 单周期算术主链路

对应Week12/Lab12：连接PC、指令输入、Decoder、RegFile、ALU，优先跑通R/I算术。网页cpu32支持更大集合；本包只交付R/I算术主链路，不能据网页全功能宣称本包已有访存、分支、跳转或完整CPU。

## 运行

JDK17/21运行`./run.sh test`，再运行`./run.sh 'Test / runMain cs301.EmitArithmeticCPU'`。实际生成RTL的独立程序级复验：`python3 verification/check_generated.py`，需iverilog/vvp。固定Scala2.13.12/Chisel6.1.0/chiseltest6.0.0/sbt1.10.7；先测试，再从实际低层FIRRTL以JVM后端导出。

## 真正连接的模块

ArithmeticCPU连接Lab09 ALU32、Lab10寄存器堆与Lab11解码/立即数，复位PC=0。指令存储在顶层外部：外界根据io.pc组合提供instruction和instructionValid，后者表示取指可用，不代表指令编码合法。测试驱动确实按PC取程序，不在CPU内悄悄执行软件指令。

支持R型10种和I型9种算术/逻辑/移位/比较，共19种。step=1且未暂停、取指可用、编码属于该子集时，一个上升沿同时更新目的寄存器、PC+4与退休数。x0写入被丢弃，但合法指令仍退休。candidate/candidateRd是当前预览，不是已保存值。

CPU读rawA/rawB保存值，关闭寄存器旁路；当前ALU写回候选不能组合反馈为同一条指令的源操作数。32个寄存器的额外saved/registers端口仅为教学观察，不是新的架构读写口；真实综合可根据调试需求去除。

clear和Module的同步reset清空PC、退休数、寄存器与暂停状态。step=0时架构保持，允许外部输入改变。EBREAK精确停止且不退休；其他非算术指令包括合法LW在本讲也停止，不执行。没有数据RAM、教学I/O、分支跳转或陷阱服务。

## 停止原因与边界

reason：0运行、1 EBREAK、2未支持、3取指不可用、4 PC未4字节对齐。停止指令不更新PC/寄存器/退休数；停止后持续step也保持，需clear/reset重新开始。当前PC只从0加4，正常可达路径不会产生未对齐PC；该保护不算已通过跳转测试。

io.commit是当前组合提交条件，不是上一条指令的完成脉冲。外部若保持同一instruction不按PC更新，CPU会在后续有效边沿继续消费该字；这属于指令存储接口契约，不能将测试驱动与RTL混淆。

## 已验证

Chisel两项程序测试通过：addi/add/sub、暂停、EBREAK不退休、停止后保持、clear、合法但未支持LW、x0及取指不可用。

实际生成ArithmeticCPU.v另与独立Python RV32解释器对照12组程序，其中8组随机程序各含31条初始化和256条覆盖19种算术的随机指令；测试还插入暂停、停止后边沿、clear，以及单独的Lab12未支持LW策略断言。共3153个边沿、6305个有效边沿前后架构快照通过，逐次比较全部32寄存器、PC、退休数和停止原因。解释器不导入网页或Chisel助手，保存在verification/reference。

## 学生任务

1. 在纸上追踪5、7、add与sub程序，每条先预测新PC/寄存器，再看波形。
2. 禁用step，改变instruction，解释候选与保存值的区别。
3. 构造x0目标写、缺失取指及EBREAK，说明为何不应把停止算作退休。
4. 找出寄存器读口、ALU操作/立即数选择和写回使能的连接，给接口写断言。
5. 后续Lab13再加入数据存储、分支跳转、写回选择和执行异常门控，不把本包当作已完成全部RV32I执行。

无实体板引脚、统一SoC内存、流水线、频率或资源结论。单周期“一个边沿提交”也不等于硬件可在任意目标频率下收敛。
