# UART逐位接收器硬件参考 · 理想8N1采样

本包提供UARTBitRX的Chisel源码、默认生成Verilog、波形与独立Python/Icarus检查。

## 运行

需要JDK17/21；固定Scala2.13.12、Chisel6.1.0、chiseltest6.0.0、sbt1.10.7。run.sh在项目.tools下载并校验启动器。

```sh
./run.sh test 'Test / runMain cs301.EmitUARTBitRX'
python3 verification/check_generated.py
```

第一条完成测试并由JVM FIRRTL后端导出Verilog；第二条需要iverilog/vvp，重新生成向量并核对实际生成电路。

## 输入、阶段与事件

- `step`是外部理想位采样使能；rx必须在有效采样边沿稳定。这里没有同步器、起始半位定位、过采样或波特率计数。
- phase15为空闲；空闲时高电平保持，低电平识别START并清零组装数据，phase变0。
- phase0…7分别采样d0…d7，低位先收；phase8检查STOP。STOP=1置valid，STOP=0置error，随后回phase15。
- data是当前组装寄存器，可在完整帧有效前变化；必须检查valid，不能仅看数值。错误帧也保留其组装值供调试，但valid=0。
- step=0保持data/phase/valid/error。事件标志保持到下一个有效step或clear/reset，不是单主时钟脉冲；下游不能每个主时钟重复消费它，需要一次性接受约定。
- clear/reset在时钟边沿同步清零，优先于step，可以中断未完成帧。

## 验证

两项Chisel测试实际通过：全部256字节分别配正确/错误停止位，检查每步组装值、valid/error、暂停与清零。生成RTL与独立Python“收到位的列表”参考通过18209个边沿后、18208个边沿前15位快照（data、phase、busy、valid、error）。覆盖10阶段×16控制组合、512个定向字节帧及10000步随机控制。

网页接收模型以同一独立向量对照36418项，step=0对应不发网页采样，clear/reset对应重新开始，phase15映射网页-1。详见evidence目录。

## 边界

这是理想逐位接收电路，不可直接冒充完整异步UART引脚接收器。无输入同步、亚稳态防护、频率偏差处理、过采样多数表决、线路噪声、break检测、FIFO、流控、实体引脚与时序约束。网页FIFO收发链仍为功能模型，不能把此独立模块验证扩大成完整硬件链验证。
