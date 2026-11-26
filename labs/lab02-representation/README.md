# Lab02 · 四位数据的不同解释

对应原讲义Week02、Lab02的4位解释器部分。网页实验：http://127.0.0.1:8766/learn.html?inside=repr4 。浮点观察另见float32页，不包含在此硬件模块中。

## 接口

`bits`为同一组4位输入。输出unsigned为UInt4；signMagnitude和onesComplement为SInt5，负零另外用signMagnitudeNegativeZero和onesComplementNegativeZero标记；twosComplement为SInt4。原始开关位不因数值解释改变。所有输出为组合逻辑，不需要有效时钟边沿。

1000→无符号8、原码负零、反码-7、补码-8。1111→无符号15、原码-7、反码负零、补码-1。有符号整数端口本身不能区分+0/-0，因此保留单独标记，而不是悄悄丢弃编码差异。

## 运行与产物

使用JDK17或21、sbt1.10.7；固定Scala2.13.12/Chisel6.1.0/chiseltest6.0.0。

```sh
sbt test
sbt 'Test / runMain cs301.EmitRepresentation4'
python3 verification/check_generated.py
```

导出基于测试实际展开的低层FIRRTL，以JVM后端生成Verilog，不依赖旧版Intel firtool；先运行测试。独立RTL复验需要iverilog/vvp。generated/保留实际生成文件，evidence/保留日志、VCD与结果。

当前验证：Chisel测试穷举16种输入，检查6个输出，在clock.step之前断言，证明组合关系；生成Verilog再用Icarus在完全不产生时钟边沿的条件下，对照独立列举的16种期望模式，全部匹配。

## 学生任务

1. 写出16种模式的四类解释，再运行网页与代码核对；找出两类负零。
2. 解释4位补码的最高位权重和为何1000没有可表示的正8对偶。
3. 改成8位参数化版本，先设计边界测试再实现；处理有符号端口位宽。
4. 设计数码管/串口显示适配，明确正负号、负零标记与数字编码；这一板级适配当前未交付。
5. 另在float32页完成0.1+0.2观察，说明它不是此整数解释器的功能。

提交源码、测试、关键日志/波形与简短报告。当前包是教师参考实现，不能替代学生个人设计或真实板验证。未提供实体引脚约束、完整数值显示适配、浮点Chisel实现。

依赖参考：https://github.com/ucb-bar/chiseltest 与 https://github.com/chipsalliance/chisel 。本工程沿用课程指定chiseltest的固定兼容组合。
