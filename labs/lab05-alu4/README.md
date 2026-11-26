# Lab05 · 四位十操作ALU

网页入口：http://127.0.0.1:8766/learn.html?inside=alu 。对应原讲义Week05/Lab05。

JDK17/21下运行 `./run.sh test`，再运行 `./run.sh 'Test / runMain cs301.EmitALU4'` 生成RTL。独立复验用 `python3 verification/check_generated.py`（需iverilog/vvp）。启动脚本及固定版本与其他课程参考包相同，只在本工程.tools缓存校验后的sbt启动器；先测试再从实际低层FIRRTL导出Verilog。

## 接口约定

A/B为4位原始模式，操作码0…9依次ADD、SUB、AND、OR、XOR、SHL、SHR、SRA、SLT、SLTU。SHL/SHR分别对应通常的SLL/SRL命名；移位量只取B低2位。SRA复制A的最高位；SLT将A/B按4位补码解释，SLTU按0…15解释。

result保留低4位。Zero表示result=0，Sign表示result最高位。Carry与Overflow仅在ADD/SUB有效，flagsValid指示有效性。ADD的Carry表示无符号进位；SUB的Carry表示无借位（A>=B），不是“有借位”。Overflow表示有符号算术结果超出−8…7。

未定义操作码10…15：operationValid=false、result=0、Zero=true、Sign=false、Carry/Overflow=false、flagsValid=false。不要在flagsValid=false时把C/V的零当成有效算术结论。模块无寄存器，不需要时钟输出。

## 证据

Chisel穷举全部16×16×16=4096组，包含非法操作码，检查结果和各标志；生成Verilog再次由Icarus与独立Python算术参考核对4096向量，全程没有时钟边沿。网页十操作模型另与独立Python参考核对2560组、12800项结果/标志断言。evidence/有日志、VCD与JSON，generated/保留实际生成RTL。

## 学生任务

1. 先预测7+1、15+1、8−1的四位结果、C与V，再网页/代码验证。
2. 比较1000右移1位的SHR与SRA；比较1000与0001的SLT/SLTU。
3. 改操作码映射并同步更新接口表和测试，理解选择器而不是软件调用。
4. 构造边界与非法码断言，说明哪些标志有效。
5. 参数化位宽并保留一致的移位/标志契约；针对真实器件做性能资源比较需另外提供综合与时序报告。

网页四位层的右移/比较可进入独立32位原理模块，按四位语义扩展输入，不是同一物理实例或持续绑定。包内没有实体引脚、上板适配或实际频率/资源证据，也不替代32位ALU工程。
