# Lab 14：五级流水线与数据冒险

本工程对应课程讲义 P628–631：拆分五级数据通路、加入段寄存器、观察错误、实现暂停或前递。

`PipelineCPU.scala` 是可生成 RTL 的 Chisel 模块。IF、ID、EX、MEM、WB 通过四组真实段寄存器连接，支持项目解码表中的 40 种基础 RV32I 教学指令。独立单周期工程中的解码、ALU、寄存器堆沿用为部件；流水级、时序和冒险处理在本工程实现。

## 运行

已在 JDK 21、Scala 2.13.12、Chisel 6.1.0、chiseltest 6.0.0、sbt 1.10.7 验证。首次运行需联网获取固定版本启动器及依赖；启动器有 SHA-256 校验。

```sh
./run.sh test "Test / runMain cs301.EmitPipeline"
python3 verification/check_generated.py
```

第二条命令需要 Python 3 和 `iverilog` / `vvp`。它直接编译 **generated/PipelineCPU.v**，并用独立 Python 指令解释器逐次核对退休寄存器与最终完整状态。

可选：与教学网页的实际模型逐周期对照，需要 Node.js 和教学板目录：

```sh
node verification/compare_web.cjs /path/to/芯片细胞实验室
```

源码、构建设置或生成 RTL 改变后，旧校验清单会使验证拒绝运行。请重新执行 test 和 EmitPipeline；生成过程也会拒绝使用与当前源码不匹配的旧 FIRRTL。

## 三种策略

| io.mode | 策略 | ID / EX 行为 |
|---|---|---|
| 0 | 不处理 RAW | 保留错误，用于对照 |
| 1 | 只暂停 | 等待 ID/EX、EX/MEM 中的生产者写回 |
| 2 | 前递与 load-use 暂停 | EX/MEM 优先于 MEM/WB；紧随 load 的使用者暂停一次 |

三种策略都显式采用 WB→ID 写优先约定。x0 恒为零。无效流水包是气泡，不是有效的零指令。

## 先做四个实验

1. 用 `examples/forward-chain.hex`。关闭修复时 x3=0；暂停或前递后 x3=15，比较周期数。
2. 用 `examples/load-use.hex`。前递策略出现一个 load-use 气泡，x3=18；存储数据也需要前递。
3. 用 `examples/flush-store.hex`。EX 分支跳转后，错误路径 store 不改变 RAM。
4. 用 `examples/mem-fault.hex`。较老 load 地址不对齐时，较老已完成指令保留，年轻 store / ADDI 不留下副作用。

输入指令由外部组合 ROM 提供：地址接 `io.fetchPC`，指令接 `io.instruction`，是否可取接 `io.instructionValid`。`io.pc` 是退休的架构 PC，不能替代取指地址。

## 观察信号

- `stageValid[0..3]`、`stagePC[0..3]`：IF/ID、ID/EX、EX/MEM、MEM/WB 当前保存包。无效包的 PC 不作指令位置解释。
- `forwardA/B`：EX 两个操作数的来源，0 为 ID/EX 保存值或未使用，1 为 EX/MEM，2 为 MEM/WB。
- `stall`、`redirect`：当前组合候选；计数器 `stalls`、`redirects` 表示已经执行的事件。
- `pendingTrap`：停止接受年轻指令、排空较老指令；异常最终在 WB 停止。
- `io.step=0` 时，真实时钟可以继续，但 CPU 状态与流水段保持。它是教学执行使能，不是浏览器速度或 FPGA 时钟频率。

`evidence/PipelineCPU.vcd` 来自真实 Chisel 测试仿真。先查看 `io_cycles`、段有效位/PC、前递和暂停；图形时间来自测试时钟，不代表实体器件性能。

## 当前证据

- 六项 Chisel 仿真测试，包括不修复错误、前递、暂停、load-use、分支冲刷、精确停止、暂停保持与清除。
- 205 个程序，暂停/前递两策略共 410 次执行；独立解释器核对 3,880 次退休寄存器/PC，以及最终全部 32 个寄存器、256 RAM 字节、MMIO、异常原因和异常值。
- 7,304 个执行边沿与 7,304 个暂停保持边沿；网页对照另核对每一执行边沿的全部状态、段有效位/PC、前递来源、计数和异常排空。
- 数字结果与范围见 `evidence/generated-rtl-check.json`、`evidence/web-cycle-check.json`。网页对照不是第二份独立 ISA 规范；独立 Python 检查提供另一条证据。

## 实现边界

RAM 是 256 字节教学阵列；MMIO 与 Lab13 相同：0xffff0000 开关、0xffff0004 LED、0xffff0008 教学显示字、0xffff000c 按键。ECALL / EBREAK 在教学 EEI 中精确停止；不是完整特权异常处理。FENCE 对应本单核顺序存储模型，不模拟缓存一致性或总线乱序。

未实现 CSR、乘除扩展、中断、缓存/总线等待、分支预测、操作系统或厂商 IP。尚未提供实体板约束、综合资源、时序收敛和上板验证。生成与仿真通过不表示可以直接作为实体 FPGA 位流下载。
