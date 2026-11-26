# 十位无符号比较器 · 可展开的前缀门级参考

本工程对应网页的 `compare10` 和 `comparebit`，直接手写Verilog，包含十个CompareBit实例及每一级的EQ/LT输出。不包含时钟、寄存器或软件迭代。

## 从最高位到最低位

初始 `prefix_eq[10]=1`、`prefix_lt[10]=0`。第i位接收第i+1级的前缀，输出到下标i：

- 当前位相等：`NOT (A XOR B)`。
- 当前位小于：`NOT A AND B`。
- EQout：`EQin AND 当前位相等`。
- LTout：`LTin OR (EQin AND 当前位小于)`。

`stage[9]`是最高位，`stage[0]`是最低位。最终`eq/lt`来自前缀下标0。generate循环只是在描述十个硬件实例，不是在每个时钟执行一次循环。

例如A=511、B=512，bit9已经以0<1决定结果。A的低九位都是1，也不能推翻高位判断。合法前缀EQ/LT只有1/0、0/1、0/0；单级手动输入1/1仍有门真值输出，但不代表合法比较历史。

## 独立复验

需要Python 3.11+和Icarus Verilog（iverilog、vvp）。运行：

```sh
python3 verification/check.py
```

Python参考不复制EQ/LT递推：它直接用整数除法抽取每个高位前缀，分别作数值比较，生成期望。RTL实际运行独立的门逻辑级联。

覆盖全部1024×1024=1048576对输入。每对核对22个前缀位（包含两条种子位）和两个最终输出位；同时穷举单级四个一位输入的全部16种组合，包括非法比较前缀下的门真值。大向量写入临时目录，验证后删除。

有网页源码时可额外运行：

```sh
python3 verification/check.py --web-root /absolute/path/to/芯片细胞实验室
```

网页读取同一批Python参考向量，对比每级前缀、最终EQ/LT及16种单级门结果。`web-source-sha256.json`记录验证时的源码版本；未传入网页目录时，不刷新旧web证据。

## 波形观察

打开`evidence/sample.vcd`，包含16对实际RTL输入、最终结果及全部级内节点。对应输入/期望在`sample-vectors.txt`。

建议先观察`a/b`和`prefix_eq/prefix_lt`；再展开`stage[9].unit`等层级中的`different/same/bit_less/take_less`。网页进入某个bit级时显示的EQin/LTin，分别对应`prefix_eq[bit+1]`、`prefix_lt[bit+1]`。

波形每组输入间隔1ns只是测试台采样节奏，**不是**门传播延迟、时钟频率或实体性能证明。网页逐级动画同样是阅读顺序，不能据此推断10个时钟或10ns。

## 证据与边界

`evidence/rtl.log`、`verification.json`保存实际验证结果；`web.json`和源码哈希是打包时的网页对照证据。重新解压后可完整复验RTL。

此结构是可实现的教学分解，不声称是厂商比较器内部网表。综合工具可能改写逻辑。没有验证综合/资源、布局布线、STA、实体引脚、模拟延迟，未将此模块替换进现有VGA硬件包。功能一致性不等于实体FPGA全一致。
