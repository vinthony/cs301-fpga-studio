# Lab13 · 完整单周期RV32I教学功能CPU

在Lab12算术路径上接入数据存储器、写回选择和分支跳转。对应讲义P597–600：教学子集add/sub/addi/lw/sw/beq/jal及循环/访存程序、数据通路图、控制信号表和日志。本包实际解码40种基础RV32I指令名；ECALL/EBREAK按教学环境精确暂停，不执行操作系统或调试服务。

## 运行

JDK17/21、Scala2.13.12、Chisel6.1.0、chiseltest6.0.0、sbt1.10.7。启动器只缓存在工程.tools并核对SHA256；首次下载需要网络。

```sh
./run.sh test 'Test / runMain cs301.EmitSingleCycle'
python3 verification/check_generated.py
```

先测试，再从真实测试产生的低层FIRRTL导出generated/SingleCycleCPU.v。独立RTL对照还需要iverilog/vvp。可直接用已有生成文件运行第二条命令。

## 接口与地址

clock为唯一时钟；Bool reset与clear均同步清空PC、寄存器、RAM和板输出。step=0时保持体系结构状态。外部组合指令口instruction/Valid由测试平台按pc驱动；它与内部256字节数据RAM分离，不能把本模块称为统一地址SoC。

RAM地址0..255，小端序。访问必须自然对齐且完整位于范围内。教学MMIO只接受对齐LW/SW：FFFF0000读switches[15:0]；FFFF0004读写LED低16位；FFFF0008读写display32位；FFFF000C读buttons[4:0]。开关/按键口只读；字节/半字MMIO访问拒绝。外部输入引脚不因clear清零。

输出registers和memory是完整教学观察口，方便逐状态对照；它们不是处理器额外架构读口。candidate/nextPC/commit为当前组合预览，不是上一条指令的完成标志。具体路径见数据通路说明.md和数据通路.svg。

## 暂停原因

reason：0运行、1EBREAK、2非法指令、3取指访问失败、4取指/已选目标对齐错误、5读对齐错误、6写对齐错误、7读范围错误、8写范围错误、9ECALL。halted后所有体系结构状态保持，直到reset/clear。faultValue提供对应地址或非法编码，ECALL/EBREAK为0。错误的load即使rd=x0也会暂停；错误的跳转不保存链接寄存器。FENCE只顺序退休，本模型无缓存排序事务。

## 验证证据

4项Chisel测试通过：循环求和15并store/load、字节/半字符号扩展与高地址边界、小端数据、教学I/O、暂停保持、清零及错误store不写内存。

独立Python解释器不读取网页代码或DecoderTable。实际生成RTL通过199组程序的3504个边沿后快照与3503个边沿前保持快照；每个快照核对PC、退休计数、暂停状态/原因/faultValue、LED/display、全部32个寄存器与256字节RAM。覆盖全部暂停原因0..9、六种分支、JAL/JALR、各粒度访存、MMIO读写/拒绝、非法编码与随机算术程序。evidence/包含日志、循环VCD和JSON对照报告。测试不是形式证明；未覆盖所有32位编码/所有程序。

## 教学与实体边界

这是功能级单周期CPU工程，不把布局布线、Fmax、建立保持时间、片上资源映射或实体FPGA运行宣称已验证。PC/退休计数为32位；网页退休计数是JavaScript数值，在超过本次验证范围的极长运行中不保证计数一致。没有CSR/特权态、M/C扩展、流水线、缓存、操作系统、真实总线或板卡引脚约束。

学生可从循环程序开始，修改分支条件、访问粒度和地址，先预测提交清单，再核对波形。提交源代码、独立测试结果、图、控制表与对每种错误如何避免部分提交的解释。
