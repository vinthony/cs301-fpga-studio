# Lab06 · 保存状态、使能与同步复位

对应原讲义Week06/Lab06。网页可观察dff、latch、register和clocking；透明锁存器页是独立原理实验，不把下面的边沿寄存器冒充锁存器。

## 运行

JDK17/21下执行`./run.sh test`，再执行`./run.sh 'Test / runMain cs301.EmitState'`。固定Scala2.13.12/Chisel6.1.0/chiseltest6.0.0/sbt1.10.7，启动脚本只在本工程缓存校验后的启动器。独立生成RTL复验为`python3 verification/check_generated.py`（需要iverilog/vvp）。导出使用实际测试低层FIRRTL与JVM后端，先运行测试。

## 模块与优先级

RegisterCompare(width)同时提供RegInit+显式条件与RegEnable两种组织。clear为同步复位，优先于enable；enable=0且不复位时保持。data改变本身不写Q。Module的reset也为同步复位。输入字与保存字不要混淆。

EnabledCounter(width)在允许的边沿加一，固定位宽回绕；clear优先。BlinkDivider(halfPeriod)每经过halfPeriod个允许的边沿翻转LED，暂停时相位与LED一起保持。只用原时钟下的使能，不把LED当作新时钟。OneHzBlink假定100MHz输入，半周期50,000,000个有效边沿，因此连续enable时完整周期1秒；这是配置约定，不是实体板时钟测量。

StateDemoTop为小周期可观察顶层：两路四位寄存器、四位计数器、halfPeriod=3的分频器，统一data/enable/clear。生成的StateDemoTop.v是此小周期演示，不是50,000,000周期版本，不能用它宣称实体1Hz闪灯已验证。

## 已验证

Chisel两项测试通过：1024步带使能/清零的状态流，逐步比较边沿前保持与边沿后保存；halfPeriod=1/2/3/5的分频边界和暂停。实际生成RTL再由Icarus对照独立Python状态参考，2049个边沿后结果与2048次边沿前保持全部匹配，覆盖同步reset、clear优先、使能暂停、计数回绕和分频相位。证据在evidence/，包含VCD与日志。

## 学生任务

1. 先预测data变化、enable关闭、clear与enable同时有效等情形的Q，再波形核对。
2. 对比RegInit和RegEnable实现，说明为何clear在enable=0时仍应生效。
3. 改变halfPeriod，预测第一次翻转和完整周期；区分周期、半周期与脉冲宽度。
4. 修改计数器位宽，测试最大值回绕；修改复位优先级，观察原测试为何失败。
5. 在网页比较透明锁存器与边沿触发器；解释本包没有实现透明锁存器RTL。
6. 建立/保持时间与时钟偏移需要器件、约束及静态时序分析；理想RTL不会产生真实亚稳态电压。

提交源码、测试、生成Verilog、波形与解释报告。当前无实体引脚约束、100MHz时钟实测、建立/保持违例电气仿真及真实板演示；这些不由逻辑测试替代。


## 新增：两级同步、消抖与按下事件（InputConditioner）

网页“外部输入”页的链路现有可运行Chisel练习。`InputConditioner(threshold=3,countWidth=32)`提供raw、sample、clear输入及sync1/sync2/candidate/consecutive/stable/previous/event观察口。所有观察口都是保存状态；组合候选在边沿前不会提前提交。

`sample=1`的有效边沿：FF1采原始输入，FF2采旧FF1，消抖器读取旧FF2；连续达到threshold才更新稳定值；新的稳定值从0变1时event置1。`sample=0`时全部状态保持，包括event：它表示一个**有效采样间隔**的事件，暂停采样时不按自由运行时钟清零。连续采样时event只持续一个周期。clear为同步清零且优先于sample；Module reset同样同步清零。真实板使用固定时钟与使能，不能把网页定时器当作硬件时钟。

consecutive使用固定位宽饱和计数，默认最大值4,294,967,295；网页展示计数目前可继续增长。功能对照在本次验证范围内计数完全一致，但不把未执行到的超长保持状态宣称一致。2位参数测试额外检查计数达到3后保持不回绕。同步器只是理想数字触发器链；本工程不仿真亚稳态电压，也未证明MTBF或设置厂商同步器属性与布局约束。

运行：

```sh
./run.sh test 'Test / runMain cs301.EmitInput'
python3 verification/check_generated_input.py
```

新生成文件是`generated/InputConditioner.v`；原来的`StateDemoTop.v`保持原练习。测试包含干净按下、抖动、短脉冲、再次按下、2048步随机采样/清零和短计数器饱和。整个包现有4项Chisel测试。

实际生成RTL通过独立Python有限状态参考：全部4096种12位输入序列，插入暂停操作，另有4096步随机控制；73729个边沿后快照与73728个边沿前保持快照全部匹配，每个快照对照7个输出。证据为`evidence/generated-input-rtl-check.json`、生成日志和`input-conditioner.vcd`。应用目录的`tests/input_chain_rtl_match.cjs`进一步使用这批独立向量核对网页链路；它不属于此独立Chisel工程的依赖。

新增学生任务：先预测脉冲会在第几个有效采样出现；改变阈值和采样使能，比较确认延迟与短脉冲过滤；解释第二级为何不能使用同一边沿更新后的FF1；检查清零与暂停同时发生时的优先级。实体板引脚、时钟约束及物理验证仍需另做。
