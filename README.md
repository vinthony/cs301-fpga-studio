# CS301 FPGA Studio · 从电路到程序的交互教学实验室

面向计算机系统设计课程的本地教学原型，将可视化理解、真实 RTL 仿真和游戏化任务连接起来。

## 三部分内容

| 部分 | 内容 | 入口 |
| --- | --- | --- |
| ① 教学板与器件解剖 | 从板上组件深入逻辑门、寄存器、ALU、存储和 CPU，进行预测、观察与历史回看 | `learn.html?inside=board` |
| ② RTL 仿真工作台 | 编辑 Verilog/SystemVerilog，由 Icarus Verilog 执行，观察真实 VCD、板卡输出、测试与 CPU 状态 | `index.html` |
| ③ 游戏化课程与校园冒险 | 芯片细胞关卡、校园任务、15 讲课程映射与综合作品任务 | `game.html`、`gbu-game/`、`course.html`、`capstone.html` |

三个部分共用本地服务、教学模型和实验资源，保留同一目录以保证互相跳转和仿真接口可用。

## 快速开始

需要 Python 3 和现代桌面浏览器。运行真实 RTL 仿真还需安装 Icarus Verilog，确保 `iverilog`、`vvp` 在 PATH 中。

```sh
git clone https://github.com/vinthony/cs301-fpga-studio.git
cd cs301-fpga-studio
# macOS：brew install icarus-verilog
# Ubuntu/Debian：sudo apt install iverilog
python3 launcher.py --page anatomy
```

- `python3 launcher.py --page learn`：组件学习。
- `python3 launcher.py --page workbench`：RTL 工作台。
- `python3 launcher.py --page game`：校园冒险。
- 默认地址：`http://127.0.0.1:8766`；Ctrl+C 停止本次服务。
- Windows 可使用 `start-windows.bat`，Linux 可使用 `./start-linux.sh`。这些平台的启动脚本尚未实机验证。

不要直接打开 HTML 文件运行 RTL；需要本地 Python 服务。基础网页运行无需 npm 或云服务。Chisel 实验位于 `labs/`，使用各实验说明中的 Java/sbt 环境生成 Verilog，网页没有内置完整 Chisel 编译环境。

## 文档与源码

- [工作台完整说明](工作台完整说明.md)：详细功能、接口与教学边界。该文档保留开发历史，历史检查数量不代表当前发行版重新验证结果。
- [15 讲课程映射](15讲课程映射.md) / [游戏化实验设计](15周游戏化实验设计.md)。
- [器件解剖教师说明](器件解剖_教师使用说明.md)。
- [校园游戏说明](gbu-game/README.md)。
- `anatomy-*.js`、`learn*`：解剖、功能模型与可视化。
- `server.py`、`app.js`、`wave.js`、`examples/`：真实 RTL 工作台。
- `labs/`、`hardware/`：Chisel/RTL 实验、参考实现、引脚与复验资料。
- `tests/`：模型、RTL、启动器和浏览器检查。

## 检查

```sh
python3 tests/test_system.py
python3 tests/launcher_check.py
node tests/anatomy_content.cjs
node tests/anatomy_models.cjs
node tests/anatomy_rtl.cjs
```

浏览器检查脚本的运行方式见完整说明。历史 evidence 文件记录特定开发快照；完整 Chisel 实验复验需要额外工具，并不包含在基础 CI 中。

## 当前边界

这是可运行的教学原型。器件解剖和 CPU32 页面包含明确标注的功能模型；RTL 工作台运行真实 Verilog，二者的验证范围不同。尚无完整实体 FPGA 板验证、Vivado 综合布局布线/时序结论或真实学生效果评估。校园模型是教学演绎，并非学校官方游戏或测绘地图。

服务仅供本机运行可信工程，执行用户提供的 RTL，尚无多租户隔离。

## 许可证与素材

项目原创代码使用 [MIT License](LICENSE)。第三方 Ace、Three.js 保留原许可证，详见 [第三方与素材说明](THIRD_PARTY_NOTICES.md)。发行版未包含原始校园参考图片；游戏美术包含 AI 生成素材，自绘导览只作教学示意。
