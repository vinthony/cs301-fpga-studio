# FIFO硬件参考 · CS301附加实验

默认4项×8位，单时钟，采用与网页FIFO相同的接受规则。深度可设为不小于2的2次幂，数据位宽可参数化。生成的Verilog为默认4×8版本。

## 运行

需要JDK17/21；启动器会校验并下载固定sbt1.10.7，不修改全局环境。Scala2.13.12、Chisel6.1.0、chiseltest6.0.0已固定。

```sh
./run.sh test 'Test / runMain cs301.EmitFIFO'
python3 verification/check_generated.py
```

第一条运行测试并把测试生成的低级FIRRTL用JVM后端导出为Verilog，避免依赖外部firtool二进制。第二条需要Icarus Verilog（iverilog/vvp），重新生成独立Python向量并核对实际Verilog。默认运行`./run.sh`仅测试，导出需要先完成测试。

## 接口与边沿规则

- `step=1`才接受请求；`clear`和`reset`在时钟边沿同步清零数组、指针、占用，优先于step。clear/reset有效时两个accepted均为0。
- `popAccepted`：非空且读请求有效；外部在该边沿采集边沿前`head`。
- `pushAccepted`：写请求有效，且未满或本边沿成功pop。满时同时读写，读旧队首后写新值，占用不变。
- 空时同时读写只接受push，不把新字节旁路给pop。
- `head`是组合队首；`valid=0`时输出0占位，该0不是有效读取。网页对此显示X/无有效数据。原始数组中的旧值也不是有效队列内容。
- 指针模depth绕回，占用区分指针相等时的满/空。saved输出用于教学观察，不是必须暴露的产品接口。
- accepted是组合候选，边沿后会根据新状态重新计算；不是上一拍是否成功的保存标志。

## 当前验证证据

两项Chisel测试：默认参数的4096步确定性随机操作和定向满空/同拍/暂停/清零；另验depth=8,width=4的填满与排空。默认4×8生成RTL再与独立Python deque对照20641个边沿后快照、20640个边沿前快照，每个52位包含全部4字节、指针、占用、队首、满空有效位及接受信号。包含全部5种占用×32组请求/step/clear/reset组合及20000步随机控制。

网页另以同一独立Python向量核对41282项；step=0映射为不发网页边沿，clear/reset映射网页重新开始，不能把这个适配说成网页有真实时钟引脚。详见evidence目录。

## 边界

这是可仿真的FIFO模块，不包含UART发送/接收RTL、跨时钟FIFO、Gray码同步、实体FPGA引脚或时序约束。网页集成收发链目前是功能模型。没有证明Fmax、资源映射、亚稳态安全性或实体板运行，也不承诺映射为块RAM。此包是附加缓冲实验，不替代第14讲流水线工程。
