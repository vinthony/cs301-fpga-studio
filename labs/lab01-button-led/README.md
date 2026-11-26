# Lab01 · 从按键到四个LED

对应原讲义Week01/Lab01。网页入口：http://127.0.0.1:8766/learn.html?inside=board&source=buttons 。

## 第一次运行

需JDK17或21、网络、curl及shasum或sha256sum；macOS/Linux可用。启动脚本只在当前工程的.tools目录缓存固定版本sbt启动器并校验SHA-256，不安装系统软件或改全局配置。依赖第一次需联网下载。

```sh
./run.sh test
./run.sh 'Test / runMain cs301.EmitButtonLeds'
python3 verification/check_generated.py
```

已有sbt也可直接使用`sbt test`和`sbt 'Test / runMain cs301.EmitButtonLeds'`。工程固定Scala2.13.12/Chisel6.1.0/chiseltest6.0.0/sbt1.10.7。RTL独立复验需iverilog/vvp；仅运行Chisel测试不需它们。

## 你正在构造什么

ButtonLeds核心只有四路组合连接：buttons[3:0]→leds[3:0]，没有计数、采样或状态。输入改变后输出立即按组合模型重算，不需要时钟。

TeachingButtonTop把教学板C/U/L/R/D映射为buttons[0…4]。前四位分别驱动LD0/1/2/3，D与switches未使用；LD15…4关闭。数码管接口明确假定低有效，seg=1111111、an=1111、dp=1，保持关闭。这个顶层是与网页一致的教学接口，不是GBU-CS301实体引脚文件；真实板需核对极性和引脚约束。Module默认clock/reset在此组合设计中不使用。

## 建议任务

1. 网页只按C，再同时按C和R；先预测，再观察LD0/LD3。
2. 切到加法或CPU来源，保持相同按键，解释为何输出可以不同。
3. 阅读核心的io.leds赋值，运行全部16种输入测试。
4. 读教学顶层，解释D/SW未使用、上方LED与数码管关闭的原因。
5. 故意把C和R映射交换，先运行原测试观察失败，再恢复或修改接口约定和测试。
6. 在教师提供正确引脚约束后生成板级工程；不要把网页品牌名称当作引脚规格。

提交源码、测试、生成Verilog、关键日志/波形与简短接口说明。实际板运行另附真实证据。

## 已验证

两项Chisel测试通过：核心16模式；教学顶层32种五按键组合×3种开关模式，检查LED、段线、位选与小数点。生成的TeachingButtonTop.v再次用独立Icarus仿真验证96组向量，全程没有时钟边沿。实际启动脚本也已下载并校验启动器、执行测试通过。evidence/保存日志、结果与VCD。

导出使用测试实际展开的低层FIRRTL及JVM后端，须先运行测试，不依赖旧版Intel firtool。当前未交付实体引脚约束、去抖模块、综合性能和实体板验证；其他实验中的同步/消抖仅是独立原理页。此包为教师参考，不替代学生个人作品。
