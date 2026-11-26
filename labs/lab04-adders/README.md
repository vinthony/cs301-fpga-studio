# Lab04 · 全加器、行波与先行进位

对应原讲义Week04/Lab04。网页入口：http://127.0.0.1:8766/learn.html?inside=adder ，全加器为fulladder。网页四位加法示例固定Cin=0；本工程额外支持外部Cin，覆盖更一般的加法。

## 结构与接口

FullAdder用传播项p=a xor b和产生项g=a and b计算和与进位。RippleAdder(width)逐级连接全加器，carries保存C0…Cwidth（最低位为Cin）。LookaheadAdder4以展开的P/G表达式直接计算每一级进位，不递归引用前一级C。CompareAdders4给两个结构完全相同的输入，并输出含进位的完整五位结果及两组进位链。

这些是组合电路，输出不等待时钟。图解中的逐位阅读与波形中的测试节奏都不是门延迟。

## 运行

JDK17或21、sbt1.10.7；固定Scala2.13.12/Chisel6.1.0/chiseltest6.0.0。

```sh
sbt test
sbt 'Test / runMain cs301.EmitAdders'
python3 verification/check_generated.py
```

先测试，再从实际测试展开的低层FIRRTL导出生成Verilog。生成使用JVM后端，不依赖旧版Intel firtool。独立复验需iverilog/vvp。测试先检查输出再步进时钟；生成RTL复验全程无时钟边沿。

## 当前证据

Chisel两项测试通过：512种四位A/B/Cin穷举，比较两路完整和、五位进位及相等标志；参数化行波的1/8位边界测试。实际生成Verilog再用Icarus与独立Python算术/低位前缀进位参考复验全部512种组合。evidence/有日志、VCD和JSON结果，generated/为实际生成文件。

## 学生任务

1. 手写全加器8行真值表，画出四位级联并解释每一级Cin来自哪里。
2. 在网页修改0035、00FF，解释四位低位和与整板完整和的区别。
3. 比较两种代码对C1…C4的依赖；用至少5组边界输入先预测再测试。
4. 扩展参数化行波位宽，测试零、最大值、纯进位和连锁进位。
5. 使用同一目标器件与约束进行综合及静态时序分析，比较延迟和面积；检查综合后是否被映射为相同原语。

尚无综合/布局布线/实体板时序和资源结果；不能以功能测试通过或动画速度宣称CLA在指定FPGA上更快。实际FPGA可能把两种描述映射为类似专用进位资源。板级引脚和显示适配未包含。提交源码、测试、VCD、预期对照表及报告；性能结论需附对应工具报告。
