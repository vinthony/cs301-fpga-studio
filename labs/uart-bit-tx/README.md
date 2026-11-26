# UART逐位发送器硬件参考 · 8N1

本包提供UARTBitTX的Chisel源码、生成Verilog、波形与独立Python/Icarus复验，不依赖网页运行。

## 运行

需要JDK17/21；Scala2.13.12、Chisel6.1.0、chiseltest6.0.0与sbt1.10.7固定。run.sh仅在项目.tools下载并校验启动器，不修改全局安装。

```sh
./run.sh test 'Test / runMain cs301.EmitUARTBitTX'
python3 verification/check_generated.py
```

第一条先测试，再通过JVM FIRRTL后端生成Verilog。第二条需要iverilog/vvp，重新生成向量并仿真实际生成RTL。

## 接口与约定

- `step`是外部给定的位周期使能，不是波特率分频器。step=0保存phase/captured/done。
- `phase=15`表示空闲，TX=1。只有空闲且send=1、step=1时接受请求，捕获data并进入phase0 START=0。
- phase1…8分别发送d0…d7，低位先发；phase9发送STOP=1，保持完整一个有效step间隔，再回空闲并done=1。
- 忙时改变data或send不会覆盖当前帧。若send一直保持1，将在回空闲后的下一个step接受新的帧；没有隐式请求队列。
- clear/reset在时钟边沿同步清零并回空闲，优先于step；clear/reset有效时accepted为0。
- `accepted`是当前边沿的组合候选，边沿后根据新状态重算，不是保存的完成事件。
- `done`在最后STOP结束的有效step后置1，在下一次有效step或clear/reset清除；step=0期间保持。它不是固定一个主时钟周期的脉冲。
- 未实现RX、校验、FIFO、波特率计数、过采样、异步采样、物理引脚约束、流控或时序收敛。

## 验证证据

两项Chisel测试实际通过，遍历全部256字节并在帧内修改data，检查停止位保持、暂停、done保持与暂停时清零。生成RTL与独立Python编码帧列表参考比较14817个边沿后和14816个边沿前16位快照（捕获字节、阶段、TX、busy、done、accepted），包含11阶段×16控制组合、全部字节及10000随机控制。

网页发送模型用同一独立向量核对捕获字节、阶段、TX、busy共29634项。适配：send=0且空闲时不发网页推进；step=0不推进；clear/reset映射重新开始，并把硬件初始化捕获字节0带入。网页没有accepted/done输出，所以没有声称网页与硬件在这些接口上已对齐。详细证据见evidence。

这是逐位功能电路，不证明真实波特率误差、输出时序、实体板串口或FPGA资源映射。它不是第14讲流水线工程。
