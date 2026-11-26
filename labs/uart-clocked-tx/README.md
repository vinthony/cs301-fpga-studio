# 主时钟分频＋UART发送 · 单时钟硬件参考

组合BaudUARTTX复用本项目UARTBitTX。终值比较作为同步使能，所有寄存器仍使用同一个输入clock，未构造新时钟。

## 运行

JDK17/21；Scala2.13.12、Chisel6.1.0、chiseltest6.0.0、sbt1.10.7固定。启动器在项目.tools下载并校验。

```sh
./run.sh test 'Test / runMain cs301.EmitBaudUARTTX'
python3 verification/check_generated.py
```

第二条需要Icarus Verilog。导出通过测试产生的FIRRTL与JVM后端完成，不依赖外部firtool二进制。

## 时间与接口

默认divisor=868；若输入clock为100MHz，实际位速率约115207.373bit/s，不是精确115200。counter保存0…867；enable=1且count=867时tick为组合候选，下一主时钟边沿把counter归零并推进UART。没有消费tick的计数边沿只改变计数，TX保持。

- enable=0时计数与发送状态保持；主时钟本身仍可运行。
- clear/reset在边沿同步清零，优先于enable；计数归零、发送器回空闲。
- 空闲且send=1时，只在下一tick接受data。data须保持到accepted边沿。忙时send/data变化不覆盖捕获字节。
- START=0，d0…d7低位先发，STOP=1保持完整位周期。STOP结束才done并回空闲。
- send持续为1会在下一次空闲tick接受另一帧；无请求队列。网页“准备一帧”是一次请求适配，不能当成所有send序列都已与网页逐拍等价。
- accepted/tick为组合候选，边沿后重算。done保持到下一个tick或清零，不是单主时钟脉冲。
- divisor为编译参数，生成RTL和独立脚本固定868。另在Chisel测试divisor7；其他参数需重新导出并扩展验证。

## 证据范围

两项Chisel测试通过：实际868分频的字节65/85，和divisor7全部256字节。检查终值前保持、有效边沿捕获、STOP时长、暂停、done保持与暂停清零。

实际生成的默认868 RTL与独立Python计数器＋编码帧列表对照110965个边沿后、110964个边沿前27位快照，包含完整计数、捕获字节、阶段、TX、busy、done、accepted、tick。覆盖7种字节、连续请求、多帧、终值处16种控制组合、暂停以及10000随机控制。

网页对同一参考中7组稳定请求帧核对134176项，范围为计数/捕获/阶段/TX/busy；禁用主时钟使能映射为不推进网页虚拟时钟，不比较暂停期间的墙钟经过时间，也不比较网页缺少的accepted/done。剩余原始控制流未声称与网页等价。

## 边界

只集成分频和TX，不含RX、FIFO、引脚约束、完整SoC或实体板运行。没有证明实际输入频率精度、Fmax、资源使用或时序收敛。为教学参考电路，不替代目标开发板的综合与约束检查。
