# 端到端示例（原型 H）：SDK 的 ROS1/ROS2 适配

演示 **原型 H·生态集成/参考实现/开发者文档类** 特性怎么跑：它的核心不是"底层支不支持"（底层完全支持），而是**支持等级、版本矩阵、外部依赖 EOL、示例防腐、跨交付职能 owner**。示例中的配置区取值仅为占位演示。

---

## 输入

> 客户拿到 SDK 后，有的希望和 ROS1/ROS2 联合使用。要给示范例子（如何把 SDK 包成 ROS1/2 节点）、讲清环境怎么兼容、能上报状态和下达控制指令，并在官网单开一个和 api/quickstart 平级的"ROS 适配"板块。

## 澄清过程（要点，一次一问）

**第 1 步复述** → 我理解是"为客户提供与 ROS1/ROS2 联合使用的适配能力：把 SDK 包成节点的示例、环境兼容、状态上报+控制下达、官网 ROS 板块"。对吗？→ 对。

**第 2 步分流（异构交付物启发式命中）** → 一句话里有**可运行代码（示例包）+ 兼容矩阵 + 消息契约 + 官网板块**四种异构交付物，优先怀疑多特性：
- 特性 A『ROS 节点适配参考实现』= 示例包 + 环境矩阵 + 双向契约（共享同一真相源=示例仓代码，合为**一份 md、分阅读对象**）。
- 特性 B『官网 ROS 板块』= 文档 IA，owner 是 DevRel（独立成文，关联特性互指）。
- **前置元决策**：官方支持等级——最先拍板。

**第 3 步归类** → 推断 L2（把已有 SDK 接口包成 ROS 生态形态）`[待确认·配置区未填]`。官网板块落"文档门户层"，不在 L1/L2/L3。

**第 4 步跨层 + 外部依赖轴** → 技术触底=**纯二开**（复用已有 SDK 状态/控制接口）。但命中两条四层模型外的轴：① 跨交付职能（研发/构建/文档/支持）；② **外部依赖轴**：ROS distro/DDS/Ubuntu/CPython 有独立 EOL 时钟（Noetic 已 2025‑05 EOL）。唯一技术证伪点：要 publish 的每个状态、要接的每个控制指令，SDK 是否都有对应接口——本例假设"位姿/电量/任务态、移动/停止"皆有 → 维持纯二开。

**原型 H 六问（要点）**：
- ① 支持等级？→ **as-is 参考样例**（社区自维护、不随版本回归、带免责声明）。→ 连带：官网 B 因此**弱化为"社区资源"页，不做顶层平级**（否则"平级=官方背书"与 as-is 口径自相矛盾）。
- ② 版本矩阵 + EOL？→ MVP 单格：**ROS2 Humble × Ubuntu 22.04 × Py3.10**（Humble LTS 至 2027）；Noetic 明示 EOL、不支持；用 **Docker 锁环境**。
- ③ 交付物形态？→ 示例仓 + Dockerfile（非预编译包）。
- ④ 防腐？→ as-is：CI 只一次性冒烟，不随 SDK 每版回归；README 明示"仅在 Humble 验证过、其余自理"。
- ⑤ 我方维护 vs 客户自持？→ 我方保证 Humble 格编过；其余 distro 客户自持。
- 包成节点走哪条路？→ Python 节点走 pybind 绑定（Humble=Py3.10，须与该 Py 版本对齐的 .so，Docker 内锁死）。
- 控制原语？→ 移动=action（长任务带反馈/可取消）、停止=service（即时）、高频流=topic。消息优先标准 msg（geometry_msgs/sensor_msgs），自定义最小化。
- ⑥ 可仿照性？→ **第一设计目标**：用 `state_adapters[]/control_adapters[]` 注册表范式（客户加自己的接口=照抄一个单元+注册一行）+ README"如何加你自己的接口"小节 + 反过度封装；硬验收="生人照着 ~15 分钟能新增一个 topic"。参考价值 > 一次性能跑。
- 安全（控制面）？→ as-is：明示 ROS 控制 topic **无鉴权、仅内网 demo**，危险动作（解除急停/直控关节）**不桥接**，客户自加权限门。

## 产出（第 7 步·特性 A，as-is；一份 md、分阅读对象）

```markdown
# 特性需求：ROS 节点适配参考实现（as-is 社区样例）

> 状态：待评审　｜　提出方：多客户共性诉求　｜　日期：YYYY-MM-DD　｜　模板：完整（生态集成/原型 H，单文件·分阅读对象）
>
> ⚠ 支持等级 = **as-is 参考样例**：社区自维护、不随 SDK 版本回归、不承诺 distro/窗口、带免责声明。

## 阅读指引（分阅读对象）
| 阅读对象 | 重点读 | 负责什么 |
| --- | --- | --- |
| 产品 / 评审 | 一句话定义、名词解释、范围、支持等级、故事+验收、决策、遗留 | 确认 as-is 口径与 MVP |
| 二开 SDK 组 | 双向契约、行为规格、【二开 SDK 组】节 | 写示例节点、状态/控制映射 |
| 构建 / DevOps | 环境矩阵、【构建/分发基建层】节 | Docker + 一次性冒烟 CI |
| DevRel / 文档 | 关联特性 B、免责声明口径 | 官网"社区资源"页（非平级）|
| 测试 / QA | 版本矩阵、双向契约、DX 验收、【测试/QA】节 | 验矩阵覆盖、Docker 内 build + 冒烟、topic 契约可测 |

## 名词解释（术语）
| 术语 | 说明 |
| --- | --- |
| as-is / 官方支持 | as-is=按现状给、社区自维护、不承诺随版本回归/不背书，出问题客户自理；官方支持=我方正式维护、随版本回归、有承诺窗口。两者是两种责任等级，本特性明确取 as-is |
| EOL | End of Life，某个版本"到期停止维护"的时间点；过了 EOL 的版本官方不再修 bug/补安全，本例 Noetic 已 EOL 故不支持 |
| distro | ROS 的发行版（如 Noetic、Humble、Jazzy），每个 distro 绑定特定 Ubuntu/Python 版本、各有自己的 EOL 时钟 |
| DDS | ROS2 底层的数据分发中间件，负责节点间收发消息；ROS 的 topic/QoS 最终经 DDS 传输 |
| QoS | Quality of Service，收发消息的可靠性策略（如尽力而为 BestEffort vs 可靠 reliable）；状态流和控制指令对可靠性要求不同，需分别设 |
| pybind | pybind11，把 C++ 代码包成 Python 可调用模块的绑定库；本例用它把 SDK 暴露给 Python 版 ROS 节点 |
| ABI | 应用二进制接口；编译好的 .so 二进制与特定 Python/编译器版本绑定，版本不对齐就装不上/崩，故要锁 Py3.10 并用 Docker 锁死 |
| 双向契约 | 对外承诺的两个方向：状态上报（SDK→ROS topic）与控制下达（ROS→SDK），topic/action/service 的名字、消息类型、语义都算契约 |
| 注册表范式 | `state_adapters[]/control_adapters[]` 的写法：客户加自己的接口=照抄一个单元 + 注册一行，不用改框架 |

## 一句话定义
提供一个 **as-is 参考示例仓**：把 SDK 包成一个 **ROS2 Humble** 节点，示范状态上报（→topic）与控制下达（action/service），并用 Docker 锁定可编译环境。**不是官方支持的适配层**。

## 范围边界
- In：ROS2 Humble 单格示例节点（Python + pybind）、状态上报 3 项（位姿/电量/任务态）、控制 2 条（移动 action / 停止 service）、Dockerfile、README（含免责声明与环境矩阵）。
- Out：ROS1/Noetic（已 EOL）；Humble 以外 distro；官方支持/随版本回归；危险动作桥接；预编译包分发。
- 关联特性（各自独立成文）：**B 官网 ROS 社区资源页**（DevRel owner，as-is 故非顶层平级）；未来"官方支持适配层"另立项。

## 跨层实现与跨部门协同
> 技术触底=纯二开；重心在跨交付职能 + 外部依赖轴。

### 【阅读对象：二开 SDK 组】示例节点与双向契约
- 职责：写 ROS2 节点，映射 SDK↔ROS。**证伪已确认**：位姿/电量/任务态、移动/停止均有现成 SDK 接口（纯二开，不下探固件/算法）。
- 状态上报：`/robot/pose`(geometry_msgs/PoseStamped) | `/robot/battery`(sensor_msgs/BatteryState) | `/robot/task_state`(自定义 TaskState.msg，最小自定义) — 定义权归示例仓、随 SDK 版本化。
- 控制：`move_to`(action，反馈+可取消) | `stop`(service)。SDK 控制接口若为同步阻塞→在 action 执行线程内调用，避免卡节点。
- QoS：状态用 sensor_data(BestEffort)，控制用 reliable；命名空间支持多机器人 `[待确认]`。

### 【阅读对象：构建/分发基建层】环境与防腐
- 目标矩阵（MVP 单格）：ROS2 Humble / Ubuntu 22.04 / Py3.10 / gcc11。pybind `.so` 绑死 Py3.10（ABI 对齐），Docker 内锁死。
- 防腐（as-is）：示例仓 CI 只做一次性 `colcon build`+ 冒烟；**不**随 SDK 每版回归；README 明示"仅 Humble 验证"。
- owner：`[待确认·需指派]` 构建/DevOps（非二开 SDK 组默认承担）。

### 外部依赖轴（EOL 待确认）
- ROS Noetic 已 2025‑05 EOL → 明确不支持。Humble LTS 至 2027。
- 外部依赖待确认（外部社区不给私有排期，按保守假设）：Humble EOL 后是否迁 Jazzy？as-is 故**不承诺**，到期客户自理。

## 开发者/集成商故事
- **[P1]** 作为客户开发者，我希望 clone 示例仓、`docker compose up` 后能看到 SDK 状态发布到 ROS topic、能用 action 下发移动，以便快速验证 SDK 能接进我的 ROS2 图。
  - 验收（含 DX）：在给定 Docker 环境**零改动 colcon build 通过并跑起来**；`ros2 topic echo /robot/pose` 有数据；`ros2 action send_goal move_to ...` 能驱动。命名/topic 命名符合 ROS 惯例（snake_case+命名空间）。
  - DX 判据：新开发者照 README **10 分钟内**在 Docker 里跑通收发。
  - 优先级依据：客户共性硬需求（MVP 核心）。
- **[P2]** 停止 service、多机器人命名空间示范。

### MVP 最小切分
MVP = ROS2 Humble 单格 + 3 状态上报 + move_to/stop + Docker + README。ROS1、多 distro、官方支持全部分期/不做。

## 非功能性需求(NFR) 与上线就绪
- **支持等级与维护承诺**：**as-is**（社区自维护 + 免责声明；不随版本回归；不承诺 distro/窗口/EOL 跟随）。⚠ 官网口径必须一致（社区资源，非官方背书）。
- 安全与权限：ROS 控制 topic 默认无鉴权、同网可 publish；示例**仅内网 demo**，危险动作不桥接，README 警示客户自加权限门/审计。
- 数据与隐私：SDK 状态经 DDS publish 进客户 ROS 图/rosbag，出 SDK 边界；本特性不额外采集敏感数据，rosbag 存储责任归客户。
- 运营可观测：桥接节点 SDK 断连时发 `/diagnostics` 并安全退出；采纳度量（哪个 distro 客户在用）`[待确认]`。

## 接口契约草案（ROS 侧，非 SDK API）
- topics/actions/services 如上；自定义 `.msg/.srv/.action` 计入**第二套对外表面积**（撞 API 预算纪律）——已尽量复用标准 msg，仅 TaskState 自定义，需版本化。
- 命名：全小写下划线、ROS 命名空间惯例。

## 测试 / QA
> 测试对象是**版本矩阵是否真能编过跑通、对外双向契约是否可测、DX 验收是否达标**——as-is 只做一次性验证，不建长期回归。
- **矩阵覆盖**：本档只覆盖 **ROS2 Humble × Ubuntu 22.04 × Py3.10** 单格；Noetic/其它 distro 明示不在验收范围。验证"矩阵内这一格"确实是被测过的那一格（Docker 锁死的环境=被测环境）。
- **Docker 内 build + 冒烟**：在给定 Docker 环境**零改动** `colcon build` 通过；启动节点后 `ros2 topic echo /robot/pose`、`/robot/battery`、`/robot/task_state` 均有数据；`ros2 action send_goal move_to ...` 能驱动、可取消；`stop` service 能即时停。
- **topic 契约可测**：逐条核对对外双向契约——topic/action/service 的**名字、消息类型、QoS**与契约草案一致（状态 BestEffort、控制 reliable）；标准 msg 用对（geometry_msgs/PoseStamped、sensor_msgs/BatteryState），自定义 TaskState.msg 的 schema 与示例仓版本一致。
- **DX 验收**：新开发者照 README **10 分钟内**在 Docker 里跑通收发；"生人照着 ~15 分钟能新增一个 topic"（注册表范式的可仿照性硬验收）。
- **安全红线可见**：README 中"控制面无鉴权、仅内网 demo、危险动作不桥接"的警示**显著可见**；确认危险动作（解除急停/直控关节）确实**未**被桥接进来。
- **防腐边界**：确认 CI 只做一次性 `colcon build`+ 冒烟、**不**随 SDK 每版回归——回归缺失是 as-is 的刻意选择，不作为缺陷。

## 依赖与前置条件
- 依赖已有 SDK 状态查询/控制接口（已存在，纯二开）；外部：ROS2 Humble、DDS、Docker。

## 影响评估 · 兼容 · 发布策略
- 纯新增示例仓，不动 SDK 接口。**但** 示例工程结构/TaskState schema 一旦客户依赖即成事实契约——as-is 免责声明须讲明"结构可能变、不保证兼容"。
- 发布：GitHub 示例仓 + 官网社区资源页链接（非平级导航）。许可证 + 免责声明必备。

## 产品原则自检
| 原则 | 结论 | 说明 |
| --- | --- | --- |
| 5 最小惊讶/DX | ⚠ | 必须"零改动编过 + 10 分钟跑通"，topic/命名符合 ROS 惯例 |
| 6 安全默认 | ⚠ | 控制面无鉴权→仅内网 demo、危险动作不桥接、警示客户加门 |
| 8 范围纪律/MVP | ⚠ | 一句话裹了多交付物，已切至 Humble 单格 MVP，其余分期 |
| 4 向后兼容 | ⚠ | 示例结构/TaskState schema 会成事实契约，as-is 免责声明覆盖 |
| 支持等级 | ⚠ | as-is，已在 NFR + 官网口径钉死，防被当官方支持 |
| 其余 | ✓/— | — |

## 关键决策记录
| 决策点 | 结论 | 依据 | 涉及原则 |
| --- | --- | --- | --- |
| 支持等级 | as-is 社区样例 | 用户拍板 | 支持等级/范围 |
| 官网板块 | 弱化为社区资源页、非平级 | 对齐 as-is 口径 | 4/8 |
| 版本矩阵 | ROS2 Humble 单格，Noetic 不支持(EOL) | MVP + 外部依赖轴 | 8/9 |
| 包装路径 | Python+pybind，Docker 锁 Py3.10 | ABI/版本兼容 | 9 |
| 控制原语 | move_to=action、stop=service | 长任务/即时区分 | — |
| 控制面安全 | 不桥接危险动作、仅内网 demo | 安全默认 | 6 |

## 遗留待确认
- [ ] 各状态/控制项与 SDK 接口逐项核对（本例假设齐全）
- [ ] 构建/DevOps 与 DevRel 的 owner 指派（配置区 E 组）
- [ ] 多机器人命名空间是否纳入 MVP
- [ ] Humble EOL 后迁移口径（as-is 暂不承诺）
- [ ] 示例仓许可证与免责声明文本
```

> 关联特性 B『官网 ROS 社区资源页』另出一份独立 md（owner=DevRel），用"关联特性"指回本特性 A；真相源=本示例仓代码。
