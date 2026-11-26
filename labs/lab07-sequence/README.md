# Lab07 · 1011重叠序列检测

对应讲义 Week07、Lab7，正文P387–P390（包含表格的XML段落编号）。网页实验：`http://127.0.0.1:8766/learn.html?inside=seq1011`。

## 接口和行为

时钟上升沿且 enable=1 时消费 bitIn。state=0/1/2/3 分别表示最长匹配前缀为空/1/10/101；candidate 是当前状态及输入的 Mealy 组合候选；hit 是候选在采样边沿后的保存值。匹配后保留前缀1，允许重叠。count 是32位无符号累计计数，溢出按模2^32回绕。reset 为同步复位，优先于 enable；enable=0 保持状态、hit和count，hit不会仅因停采样而自动清零。

网页动作相当于 enable=1 的有效采样；空闲时没有新增采样。网页累计数为教学JS计数，不模拟32位回绕。此工程不是实体板引脚约束或去抖电路。

## 运行

JDK 17或21，sbt 1.10.7；工程固定Scala 2.13.12、Chisel 6.1.0和chiseltest 6.0.0（版本来自发布POM的依赖组合）。

```sh
sbt test
sbt 'Test / runMain cs301.EmitSequence1011'
```

生成的SystemVerilog位于generated/。首次运行需下载Scala依赖。导出使用chiseltest实际生成的低层FIRRTL与JVM后端，不依赖firtool；必须先运行测试。不要把手写参考Verilog标为Chisel生成结果。

## 实验任务

1. 手工画出四前缀状态图及八条转移，解释1011011的两次匹配。
2. 运行测试并保留日志；用字符串后缀作为参考，避免复用同一张转移表作为“独立参考”。
3. 查看重叠匹配的VCD，标出采入末位1、hit保存、下一次采样以及同步复位。
4. 修改为Moore实现，比较状态数和脉冲出现位置；先写预期，再改测试。
5. 进阶：支持可配置模式，并说明长模式下状态编码和组合路径的代价。

提交源码、测试、日志/VCD、状态图及简短报告。说明两次匹配位置、同步复位、enable暂停以及当前实现边界。

chiseltest原项目已归档，本实验为匹配课程要求保留固定版本；新工程选型可另评估当前Chisel的测试工具。参考：https://github.com/ucb-bar/chiseltest 与 https://github.com/chipsalliance/chisel 。

## 当前验证结果

2项chiseltest测试通过：4096条12位输入流的独立字符串参考对照，以及enable保持、同步复位优先和重叠检测波形。生成后的Verilog另用Icarus仿真，53248个采样向量与独立Python参考匹配。证据位于evidence/，波形为overlap-reset.vcd。可运行 `python3 verification/check_generated.py` 复现生成RTL对照（需要iverilog/vvp）。

仍未验证实体板引脚、频率、资源与板上效果；未将本参考实现等同于学生个人作品。
