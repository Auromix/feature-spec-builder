# feature-spec-builder

> Turn a one-line feature request into an engineering-ready feature spec — for SDK / platform products, with cross-layer & cross-department decomposition.
>
> 把客户一句话的功能诉求，细化成研发可以直接接手的特性需求文档 —— 面向 SDK / 平台型产品，支持跨实现层、跨部门的需求分解。

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Skill: Claude](https://img.shields.io/badge/Claude-Skill-d97757.svg)](https://docs.claude.com/en/docs/claude-code/skills)
[![Language: 中文](https://img.shields.io/badge/lang-中文-red.svg)](#中文)

`feature-spec-builder` is a [Claude](https://claude.com) skill. It is a methodology packaged as instructions an agent follows — not a program you run.

---

## English

### What it is

A one-liner like *"I need a welcome-and-guide feature"* or *"can you support beam steering?"* usually omits **80% of what engineering needs**: roles, scenarios, scope boundaries, capability tier, interfaces, dependencies, acceptance criteria.

This skill systematically **interrogates and fills those gaps** through a *fixed-dimension scan + interactive, one-question-at-a-time clarification*, producing a feature spec that **passes engineering review** — including interface-contract drafts and verifiable acceptance criteria. It deliberately **stops at the feature spec** (no task breakdown — that's left to the engineering team).

It is designed for **SDK / platform products** with a layered capability model. Crucially, it handles requirements that don't live in a single layer: a customer ask may require changes across the **secondary-development SDK / low-level software (firmware · middleware) / algorithm services / hardware** — layers that are usually owned by **different departments**. The skill decomposes a need across layers, routes each piece to an owner, surfaces cross-team dependencies and handoff contracts, orders them, and flags when something **cannot be delivered by the SDK layer alone**.

### Key features

- **Three orthogonal axes**, combined per feature: feature archetype (A–G probes) × implementation layer (SDK / firmware / algorithm / hardware) × product-principles + NFR.
- **7-step workflow**: receive → split requirements → classify → **cross-layer routing** → positioning clarification → behavioral clarification → produce doc (through a product-principles gate).
- **Cross-layer / cross-department**: feasibility falsification, a "not deliverable by SDK alone" flag, conclusion-write-back to kill *false readiness*, cross-team to-confirm triplets, layer handoff contracts, and a *master spec + per-layer sub-spec* output form.
- **Product-principles gate**: 10 built-in default principles for platform/SDK products (configurable), run as a hard gate before output.
- **Interactive by design**: one question at a time, every question carries *why it's asked* + candidate answers, and the skill **never decides trade-offs for you** — open items are marked `[待确认]` rather than silently filled.
- **Definition of Ready** baked into the output template, so "done" means "engineering can pick it up."

### Workflow

```
receive  →  split requirements  →  classify  →  cross-layer routing  →  positioning (coarse)  →  behavioral detail (fine)  →  produce doc (principles gate)
 接收片段  →  需求分流          →  自动归类  →  跨层分解与路由        →  第一层澄清(定位·粗)   →  第二层澄清(功能细节·细)  →  产出文档(过原则自检 gate)
```

### Install & use

This is a Claude skill (a `SKILL.md` plus reference files). Use it with any Claude surface that supports skills — e.g. [Claude Code](https://docs.claude.com/en/docs/claude-code/skills).

**Option A — drop the skill into your skills directory:**

```bash
git clone https://github.com/auromix/feature-spec-builder.git
cp -R feature-spec-builder/skill/feature-spec-builder ~/.claude/skills/
```

**Option B — build a distributable `.skill` package:**

```bash
./scripts/build-skill.sh          # produces dist/feature-spec-builder.skill
```

Then, in your Claude session, invoke the skill and paste the raw feature request. The skill will restate its understanding, split out any hidden sub-features, classify, run cross-layer routing, then clarify one question at a time.

> **Before first use, fill the configuration block** at the top of `SKILL.md` (see below). The skill works without it but will mark inferred values as `[待确认]`.

### Configuration

`SKILL.md` opens with a configuration block your team fills once (groups **A–E**):

| Group | What it sets |
| --- | --- |
| **A. Capability coordinates** | L1/L2/L3 tier definitions + your five capability domains |
| **B. Interface conventions** | API budget, language / binding convention |
| **C. Integrators & form** | integrator tiers, simulation / real-robot |
| **D. Product principles** | use built-in defaults or your own; conflict priority; breaking-change sign-off |
| **E. Implementation-layer × department map** | which department owns each layer, sign-off, escalation path |

### Repository layout

```
.
├── skill/
│   └── feature-spec-builder/
│       ├── SKILL.md                          # the skill: workflow, dimensions, output template
│       └── references/
│           ├── detail-probes.md              # archetype-specific second-layer probes (A–G)
│           ├── product-principles.md         # 10 default principles + self-check gate + NFR list
│           ├── cross-layer-routing.md        # 4-layer model, feasibility gate, sub-spec template
│           └── example.md                    # end-to-end single-layer worked example
├── scripts/
│   └── build-skill.sh                        # package skill/ into a .skill archive
├── LICENSE                                   # Apache-2.0
├── NOTICE
├── CHANGELOG.md
└── CONTRIBUTING.md
```

### Contributing

Issues and PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md). Because this is a prompt/methodology, the most valuable contributions are real-world cases where the skill missed a gap, plus the fix to the relevant dimension/probe/section.

### License

[Apache License 2.0](LICENSE) © 2026 Auromix.

---

## 中文

### 这是什么

一句"我需要一个迎宾导览功能""能不能支持波束设置"这样的诉求，通常**缺失研发所需 80% 的信息**：角色、场景、边界、能力归属、接口、依赖、验收。

本技能用"**固定维度扫描 + 交互式逐问澄清**"的方式，**系统性地把这些缺口挖出来、补完整**，最终产出一份**过得了研发评审**的特性需求 —— 含接口契约草案与可验证验收标准。它**止于特性需求**（不做任务拆分，交给研发团队）。

它面向**带分层能力模型的 SDK / 平台型产品**。关键在于：很多客户需求**不只落在一层**——一个诉求可能要同时动**二开 SDK / 底层软件(固件·中间件) / 算法服务 / 硬件**，而这些层往往归**不同部门**。本技能能把需求按层分解、给每层指派 owner、排出跨层依赖顺序、钉死层间交接契约，并在"**这事光靠二开层交付不了**"时明确打标。

### 核心特性

- **三条正交轴叠加**：特性原型(A~G 探针) × 实现层(二开/固件/算法/硬件) × 产品原则+NFR。
- **7 步工作流**：接收 → 需求分流 → 自动归类 → **跨层分解与路由** → 第一层澄清(定位) → 第二层澄清(功能细节) → 产出文档(过产品原则自检 gate)。
- **跨层 / 跨部门**：可行性证伪、"非二开层可独立交付"打标、结论回写堵"假就绪"、跨部门待确认三元组、层间 handoff 契约、"**主档案 + 各层子需求档**"产出形态。
- **产品原则 gate**：内置 10 条平台/SDK 产品原则（可在配置区替换为团队自有），产出前作为硬 gate 逐条自检。
- **交互式**：一次一个问题、每问都带"为什么问 + 候选答案"，**绝不替你拍板**取舍——未定项打 `[待确认]`，不偷偷填一个看似合理的值。
- 输出模板内置 **Definition of Ready**，"做完"意味着"研发能接手"。

### 工作流

```
接收片段 → 需求分流 → 自动归类 → 跨层分解与路由 → 第一层澄清(定位·粗) → 第二层澄清(功能细节·细) → 产出文档(过原则自检 gate)
```

### 安装与使用

这是一个 Claude 技能（一个 `SKILL.md` + 参考文件），可用于任何支持技能的 Claude 入口，例如 [Claude Code](https://docs.claude.com/en/docs/claude-code/skills)。

**方式 A —— 放进技能目录：**

```bash
git clone https://github.com/auromix/feature-spec-builder.git
cp -R feature-spec-builder/skill/feature-spec-builder ~/.claude/skills/
```

**方式 B —— 打包成可分发的 `.skill`：**

```bash
./scripts/build-skill.sh          # 产出 dist/feature-spec-builder.skill
```

随后在 Claude 会话里调用本技能、把客户原话粘进去即可。技能会先复述理解、把藏着的多个子特性分流出来、归类、跑跨层路由，再一次一个问题地澄清。

> **首次使用前请先填 `SKILL.md` 顶部的配置区**（见下）。不填也能跑，但推断值会被打上 `[待确认]`。

### 配置区

`SKILL.md` 开头是一段团队填一次的配置区（A~E 组）：

| 组 | 决定什么 |
| --- | --- |
| **A. 能力坐标系** | L1/L2/L3 层级定义 + 五域名称 |
| **B. 接口约定** | API 预算、语言/绑定约定 |
| **C. 集成商与形态** | 集成商分级、仿真/真机 |
| **D. 产品原则** | 用内置默认还是团队自有、冲突优先级、破坏性变更签字人 |
| **E. 实现层 × 部门映射** | 每层归哪个部门 owner、签字人、升级路径 |

### 贡献

欢迎提 Issue / PR，见 [CONTRIBUTING.md](CONTRIBUTING.md)。因为这是一套提示词/方法论，最有价值的贡献是**真实案例里技能漏掉的缺口**，以及对应维度/探针/章节的补法。

### 许可

[Apache License 2.0](LICENSE) © 2026 Auromix。
