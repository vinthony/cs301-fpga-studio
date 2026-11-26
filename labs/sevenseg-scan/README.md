# GBU-CS301 三阶段四位数码管扫描

与网页“数码管/扫描”实验对应的独立可综合Verilog参考模块，含自动验证和真实Icarus波形。不是完整板级工程，也不代替课程Chisel作业。

## 运行

需要Icarus Verilog（iverilog/vvp）；网页对照另需Node.js。

```sh
chmod +x run.sh
./run.sh
# 可选：使用本机教学网页模型进行对照，参数为包含anatomy-model.js的目录绝对路径
./run.sh "/absolute/path/to/芯片细胞实验室"
```

脚本在工程内工作，不依赖调用者当前目录。输出到out/与evidence/。每次重新运行会移除旧的网页对照结果；未提供网页目录时不生成新的网页对照。首次下载包自带的是交付时的证据快照。

## 接口与阶段

- clk：单一参考时钟；reset：同步高有效，优先于step。
- step：时钟使能，1才推进一个观察阶段；不要把按钮当作FPGA时钟。
- word[15:0]：四个十六进制数字，AN0在最右，取word[3:0]。
- digit[1:0]：当前编号；phase：0消隐、1准备、2点亮。
- an[3:0]：低有效位选；seg[6:0]：低有效g…a；dp固定1关闭。
- 复位后digit=0、phase=2，与网页初始状态对应。
- phase2→0时编号加一并关闭四个位；0→1保持全关；1→2打开目标位。

段码为当前word和digit的组合函数：关闭step仅冻结扫描状态，不冻结word输入。消隐第一步就可能改变段码，准备步保留一个观察间隔。这不是段码寄存器，也不保证任意word异步变化时无毛刺。若要实体使用，需同步输入、稳定显示字并按器件时序设计驱动。

## 文件和证据

- rtl/SevenSegmentScan.v：可综合设计，无仿真延时。
- verification/tb.sv：独立低有效段码表作oracle；检查65536显示字×4位×3阶段，另检查step关闭、复位优先级。
- evidence/rtl-check.json：786432状态、786432保持边沿通过；总断言2359779。
- evidence/scan-trace.csv：真实RTL的240个状态，覆盖16种重复数字字样和1234/ABCD/0035/805F混合字样。
- evidence/scan.vcd：上述20个字样各一轮的真实RTL波形（之后停止记录，避免大文件）。
- verification/compare_web.cjs：依次推进网页模型，检查相位、编号、位选、段码/dp及四位实际亮段。
- evidence/web-check.json：240状态、1920检查一致，并记录RTL、CSV及网页源码SHA-256。
- evidence/source.sha256：本工程源文件校验值。可用 `shasum -a 256 -c evidence/source.sha256` 复核交付源文件；源码改变后须重新测试，旧结果不能证明新版本。

## 观察建议

1. 打开VCD，关注word、digit、phase、an、seg。
2. 找1234：AN0显示4，消隐两阶段后AN1显示3。
3. 看an=1111时seg仍可有点亮请求，但所有位关闭。
4. 关闭step：phase/digit保持；再改变word，seg组合输出仍变化。

## 未完成的板级工作

没有厂商IP、引脚XDC、分频器、综合资源/STA或实体板验证；没有计算LED电流、亮度、刷新频率或视觉暂留。上板应使用已确认的板卡原理图和引脚/电平规范。本模块按当前教学接口，不宣称复刻完整厂商板卡。
