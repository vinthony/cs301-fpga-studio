# Lab03 · 逻辑门、选择器与比较器

对应原讲义Week03/Lab03。网页AND/OR/NOT/XOR/NAND/NOR、MUX和compare页用于观察输入输出；真值表可直接点击。该工程为数字逻辑参考，不是CMOS器件、电压或电流仿真。

## 运行

安装JDK17或21，macOS/Linux使用`./run.sh test`；首次需网络下载固定版本启动器与依赖，SHA-256校验后缓存于本工程.tools。版本固定Scala2.13.12/Chisel6.1.0/chiseltest6.0.0/sbt1.10.7，不改全局配置。

```sh
./run.sh test
./run.sh 'Test / runMain cs301.EmitLogic'
python3 verification/check_generated.py
```

已有sbt可用相同命令替换脚本。先测试，导出使用实际展开的低层FIRRTL与JVM后端。独立生成RTL复验需iverilog/vvp。generated/为实际生成Verilog，evidence/有日志、VCD和JSON结果。

## 模块接口

- BasicGates：两个单比特输入A/B，六种门独立输出；NOT只使用A。
- SelectBit：select=0选A，select=1选B。
- UnsignedCompare4：两个四位无符号输入，输出lt/eq/gt，恰有一个有效。
- LogicTop：a/b低位送门和MUX，完整四位送比较器。gates位0到5依次为AND、OR、NOT(A)、XOR、NAND、NOR。没有寄存器和计数，不需时钟更新输出。

## 已验证

Chisel测试遍历16×16×2=512组输入，在时钟步进之前检查门、选择器和比较器；真值表单独列举为参考。生成LogicTop.v另由Icarus在无时钟边沿下与独立Python布尔/算术参考对照全部512组输入，全部匹配。

## 学生任务

1. 先写六种门的完整真值表，再点击网页逐行核对。
2. 用与/或/非实现MUX，与Chisel的Mux构造结果作比较；描述依赖关系而非软件调用顺序。
3. 根据德摩根律构造等价实现，测试所有单比特输入。
4. 修改比较器为有符号比较，先预测1000与0111的关系，再重写预期。
5. 故意交换MUX选择方向，观察原测试失败并解释接口约定。
6. 板级适配需明确定义开关/按键/输出映射和真实引脚约束。当前包没有上板工程，不能把此测试适配顶层当作实体板接口。

提交源码、chiseltest、生成RTL、关键波形/日志及报告。数字测试不证明具体FPGA资源、门延迟或晶体管实现；真实板证据需另行提交。
