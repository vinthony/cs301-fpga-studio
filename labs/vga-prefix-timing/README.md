# VGA扫描 + 六个十位前缀比较器

本工程将网页中可展开的Compare10/CompareBit接入完整的纯色扫描判断路径。直接手写Verilog，六个比较器均复用已验证的`Compare10.v`原文件，不用行为级小于运算替代内部级联。

## 从整机到一位门

```
VGAPrefixTiming
├─ horizontal / vertical：共同像素时钟下的十位计数器
├─ visible_x：X < 640  ─┐
├─ visible_y：Y < 480  ─┴─ AND → ACTIVE
├─ hs_lower：X < 656  ─┐
├─ hs_upper：X < 752  ─┴─ lower OR NOT upper → HS
├─ vs_lower：Y < 490  ─┐
└─ vs_upper：Y < 492  ─┴─ lower OR NOT upper → VS
   └─ stage[9]…stage[0].unit：EQ/LT前缀与NOT/XOR/AND/OR
```

十位前缀比较的60个逻辑级是源码实例数，不是FPGA LUT、Slice或物理门数量。综合工具可能重写结构。

X计0…799，Y计0…520；Y只在**旧X=799且enable=1**的共同上升沿推进。同步reset优先清零。上电状态未指定，先提交reset边沿。输入clk已经是像素时钟，不含PLL或分频。

可见640×480，采用既有网页的800×521总扫描参数。HS低区间[656,752)，VS低区间[490,492)。可见区RGB=color，消隐RGB=0；地址无效时address=0且address_valid=0，不能当作首像素读取。组合color变化在计数暂停时也可改变RGB。

模式来源见[Digilent手册第14页图14](https://digilent.com/reference/_media/basys3%3A%20basys3_rm.pdf)。这是其中25MHz像素时钟示例的参数，不与525行模式混用。

## 完整功能复验

需要Python 3.11+、Icarus Verilog（iverilog/vvp）：

```sh
python3 verification/check.py
```

参考只保存一个线性扫描索引，以整数除法/取余计算X/Y，再直接计算区间谓词；RTL则使用两计数器和六套前缀门逻辑。

覆盖全部416800个合法坐标×CE/RESET四组合，四个可见/消隐坐标处的全部4096种RGB，以及两帧连续扫描与20000次固定种子控制。共2537185个向量；每条核对边沿前17个量（包括全部六个内部比较结果）及边沿后X/Y。穷举阶段用测试台建立任意合法初态；连续阶段承接上次真实Q，不逐拍注入。

有网页源码时：

```sh
python3 verification/check.py --web-root /absolute/path/to/芯片细胞实验室
```

网页同批检查扫描请求和HS/VS/可见区三层的六个实际比较谓词。reset=0时执行真实网页advance；网页没有同步reset口，reset向量只初始化下一步来源。证据分列真实推进与初始化，不能把两者混称为硬件复位对照。网页源码哈希表示验证当时的版本；不提供网页目录时不会刷新旧web证据。

## 波形逐层观察

`evidence/sample.vcd`包含2501个实际边沿，从X=638/Y=489附近开始并经过HS、VS边界及暂停。对应期望保存在sample-vectors.txt。

先看`dut.x/y`、`line_enable`，再看六个`*_lt_*`结果和HS/VS/ACTIVE。展开例如`dut.hs_lower.stage[9].unit`，可以继续看该级`eq_in/lt_in`、`not_a/different/same/bit_less/take_less`及输出。这与网页从同步判断进入十位比较、再进入单级门电路的层级一致。

测试台2ns周期用于组织仿真，不代表实体频率；门赋值是理想数字逻辑，未设置物理传播延迟。逐层讲解动画不是VCD的真实时间缩放。

## 尚未证明

没有帧缓冲同步读与输出控制流水、图像初始化、PLL、完整板卡引脚XDC、综合资源、布局布线、STA、模拟电平或实体显示器验证；也没有验证非法坐标的恢复。保留基础VGA参考包，当前包提供显式前缀比较结构，两个版本不冒充完整硬件板仿真。
