# 五位TAG相等与缓存命中：门级参考

运行 `sh run.sh`，需要 Icarus Verilog 与 Python 3。
随后可运行 `node verification/compare_web.cjs /教学应用绝对路径` 对照网页模型。

TagEqual5 用五个 XOR 找出不同位，五个 NOT 转为相同位，四个 AND 合并五位条件。CacheTagHit 再将 equal 与 valid 相与。实例名对应网页的 X0…X4、N0…N4 与 E01/E23/E03/E04（RTL重复位使用 BIT[i].X/N）。这是八位地址、四行、每块两字节示例的五位 TAG；不包含完整缓存数据阵列、回填控制或地址拆分。

全部32×32×2输入组合均经过实际Verilog仿真，并用独立整数比较核对逐位、树形中间值、EQ和HIT。网页对照也逐项核对门级内部结果。VCD含所有门级信号，可展开 BIT、EQ与VALID_AND。

TAG相等但VALID=0仍不命中；TAG=0与16虽低四位相同也不相等。此电路是并行组合逻辑，没有时钟。波形中1ns为测试输入间隔，不是物理传播延迟或实际FPGA性能；尚无综合时序、引脚约束或实体板验证。
