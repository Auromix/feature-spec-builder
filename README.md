# feature-spec-builder

> Turn a one-line feature request into an engineering-ready feature spec. Works for **any SDK / platform product** — you plug in your own product profile; the robot examples in the docs are just *one* worked domain.
>
> 把一句话的功能诉求，细化成研发可以直接接手的特性需求文档。**适用于任何 SDK / 平台型产品** —— 你接入自己的「产品档案」即可；文档里的机器人只是**其中一个示例领域**。

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Skill: Claude](https://img.shields.io/badge/Claude-Skill-d97757.svg)](https://docs.claude.com/en/docs/claude-code/skills)
[![Language: 中文](https://img.shields.io/badge/lang-中文-red.svg)](#中文)

`feature-spec-builder` is a [Claude](https://claude.com) skill — a **methodology packaged as instructions an agent follows**, not a program you run. The methodology itself is **domain-neutral**: it decomposes *any* feature request across your product's own capability tiers, implementation layers, and departments. To make it concrete for *your* product, you feed it **two local, private config files** (described below). Everything shipped in this repo is generic and de-sensitized — **no real company names, no people, no internal info**.

---

## English

### What it is

A one-liner like *"I need a welcome-and-guide feature"*, *"can you support single sign-on?"*, or *"can you support beam steering?"* usually omits **80% of what engineering needs**: roles, scenarios, scope boundaries, capability tier, interfaces, dependencies, acceptance criteria.

This skill systematically **interrogates and fills those gaps** through a *fixed-dimension scan + interactive, one-question-at-a-time clarification*, producing a feature spec that **passes engineering review** — including interface-contract drafts and verifiable acceptance criteria. It deliberately **stops at the feature spec** (no task breakdown — that's left to the engineering team).

It is built for **SDK / platform products with a layered capability model** — and it is **product-agnostic**. A robotics SDK, a SaaS platform, a chip SDK, a cloud platform, an audio/video SDK: all of them fit, because the parts that *are* product-specific (your capability tiers, your implementation layers, your naming conventions, your integrator tiers, your product principles) are **not hard-coded into the skill** — they come from **your product profile**. The robotics material you'll see throughout the docs (firmware / algorithm / hardware layers, beam steering, ROS samples, end-effector mods) is a **worked example domain**, not a prerequisite.

Crucially, it handles requirements that don't live in a single layer. A customer ask may require changes across **multiple implementation layers that are owned by different departments** — for a robotics product that might be *SDK / firmware / algorithm / hardware*; for a SaaS product it might be *frontend / backend / data / infrastructure*; a chip SDK or cloud platform draws its own layers. Whatever your layers are, the skill decomposes a need across them, routes each piece to an owner, surfaces cross-team dependencies and handoff contracts, orders them, and flags when something **cannot be delivered by the top (SDK) layer alone**.

### The two things you provide (both local, private, product-agnostic)

The skill's method is generic. **You** make it specific to your world by providing two local config files. Both are **generated locally, kept private, and git-ignored** — they never enter the skill or any public output. Both can be created three ways: **(a)** describe your product/company in chat and let the skill generate the file, **(b)** paste/drop your existing materials and let the skill map them in, or **(c)** run the init script to scaffold a template and fill it by hand.

| | **Product profile** `product-profile.local.md` | **Org & process** `org-process.local.md` |
| --- | --- | --- |
| **Answers** | *What does your product look like?* | *How does your company collaborate?* |
| **Contents** | Capability tiers (your L1/L2/L3 or your own scheme), capability domains, **your implementation layers** (SaaS may be frontend/backend/data/infra; a chip SDK or cloud platform differs — **not** forced into robot firmware/algorithm/hardware), interface & naming conventions, delivery form, integrator tiers, API budget, product-principle trade-offs | Role map, delivery gates, version cadence & pipeline capacity, CCB (change control board), branch/merge rules, N-version maintenance policy |
| **Generates from** | "here's what our product looks like" / a product datasheet, SDK reference, capability catalog | "here's how our company works" / an org chart, responsibility matrix, release-process doc, branch spec |
| **Template + generator** | `references/product-profile-config.md` + `scripts/init-product-profile.sh` | `references/org-process-config.md` + `scripts/init-org-config.sh` |
| **Used by the skill to** | classify the feature onto *your* tiers/domains, decompose it across *your* implementation layers, apply *your* interface budget & naming, run *your* product-principle gate | route each owner to a real person, list the delivery gates & artifacts the feature must pass, tie it to a target version & pipeline capacity, flag post-lock changes as needing CCB |
| **If absent** | the skill uses generic placeholders, marks inferred tiers/layers/owners as `[待确认]`, and offers to generate one — it **never invents** a layer or department name | the skill uses generic role placeholders (e.g. `[产品经理·待指派]`) and offers to generate one |

> **Privacy red line.** Real company names, people, internal URLs, and sensitive info live **only** in the `*.local.md` files (local, git-ignored, never committed). They must never appear in the skill itself or in any spec meant to be shared publicly or cross-company. In shared output, owners are written as **role names or placeholders**.

### For the agent — the mechanics, stated unambiguously

- **When to trigger.** Activate when the user pastes a rough, one-line, not-yet-thought-through feature request and wants it turned into an engineering-ready spec — even if they don't say the words "feature spec" (e.g. *"flesh this out for engineering"*, *"how do we define this feature"*, *"the customer wants X"*). **Also** activate when the user provides their **product** materials ("here's what our product looks like") or their **company org/process** materials ("here are our company docs") and wants specs to fit their world — that is the signal to **generate the corresponding local config**, not just read it as background.
- **Two local configs to read/generate.** `product-profile.local.md` (what your product is) and `org-process.local.md` (how your company collaborates). Both are product-agnostic, locally generated, git-ignored, and generable from a description or from dropped materials. Map dropped materials **incrementally** (never overwrite what the user already filled), then **read the extracted structure back for confirmation**.
- **Where output lands.** Each finished feature spec is written to **`feature-specs/<feature-name>/<feature-name>.md`** — an actual file on disk, not just pasted into chat. One feature = one file (even a cross-layer feature stays a single md, split into per-reader sections internally). Multiple requirements found in one blob each get **their own separate document** — never mixed into one file.
- **Never decide trade-offs silently.** One question at a time, each carrying *why it's asked* + candidate answers. Unresolved items are marked `[待确认]` rather than filled with a plausible-looking guess.

### Key features

- **Three orthogonal axes**, combined per feature: feature archetype (A–J probes) × **your implementation layers** (defined by your product profile) × product-principles + NFR.
- **7-step workflow**: receive → split requirements → classify → **cross-layer routing** → positioning clarification → behavioral clarification → produce doc (through a product-principles gate).
- **Cross-layer / cross-department**: feasibility falsification, a "not deliverable by the top layer alone" flag, conclusion-write-back to kill *false readiness*, cross-team to-confirm triplets, layer handoff contracts, and a *master spec + per-reader sub-sections* output form.
- **Product-principles gate**: default principles for platform/SDK products (from your product profile, or the built-in defaults), run as a hard gate before output.
- **Interactive by design**: one question at a time, and the skill **never decides trade-offs for you**.
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

**Then, before your first real spec, set up your two local configs** (see [The two things you provide](#the-two-things-you-provide-both-local-private-product-agnostic)):

```bash
./scripts/init-product-profile.sh   # scaffolds ./product-profile.local.md   (what your product is)
./scripts/init-org-config.sh        # scaffolds ./org-process.local.md        (how your company works)
```

Or skip the scripts entirely: in your Claude session, just **describe your product and company** (or paste your datasheet / org chart / process docs) and ask the skill to build the configs for you. Both files are **git-ignored** and stay on your machine.

Now paste the raw feature request. The skill will restate its understanding, split out any hidden sub-features, classify onto *your* tiers, run cross-layer routing across *your* layers, then clarify one question at a time — and finally write the spec to `feature-specs/<feature-name>/<feature-name>.md`.

> The skill works even with **no** config — but it will mark inferred tiers, layers, and owners as `[待确认]` rather than guess.

### Configuration at a glance

Two layers of configuration, both product-agnostic:

1. **Product profile** — the coordinate system the skill classifies and decomposes against. Generalizes what used to be the inline "config-zone A–E" into one generatable file: capability tiers & domains, your implementation layers (**yours**, not robot-specific), interface/naming conventions, delivery form, integrator tiers, API budget, and product-principle trade-offs. Template: `references/product-profile-config.md`.
2. **Org & process** — the collaboration overlay: role map, delivery gates, version cadence & pipeline capacity, CCB, and maintenance policy. Template: `references/org-process-config.md`.

Both are filled once per team, kept local, and git-ignored.

### Repository layout

```
.
├── skill/
│   └── feature-spec-builder/
│       ├── SKILL.md                          # the skill: workflow, dimensions, output template
│       └── references/
│           ├── detail-probes.md              # archetype-specific second-layer probes (A–J)
│           ├── product-principles.md         # default principles + self-check gate + NFR list
│           ├── cross-layer-routing.md        # layered model, feasibility gate, per-reader sub-sections
│           ├── product-profile-config.md     # product-profile template + mechanism (product-agnostic)
│           ├── org-process-config.md         # org/process template + mechanism (de-sensitized)
│           ├── example.md                    # end-to-end single-layer worked example
│           ├── example-ros-integration.md    # example domain: multi-deliverable (code + docs) feature
│           ├── example-offline-install.md    # example domain: distribution/packaging feature
│           └── example-hardware-mod.md       # example domain: cross-layer, physically-bottomed feature
├── scripts/
│   ├── build-skill.sh                        # package skill/ into a .skill archive
│   ├── init-product-profile.sh               # scaffold a local, gitignored product-profile.local.md
│   └── init-org-config.sh                    # scaffold a local, gitignored org-process.local.md
├── LICENSE                                   # Apache-2.0
├── NOTICE
├── CHANGELOG.md
└── CONTRIBUTING.md
```

> The `example-*` references use a **robotics** product as their worked domain. They are illustrations of the method, not a statement that the skill is robotics-only — swap in your own product profile and the same workflow applies.

### Contributing

Issues and PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md). Because this is a prompt/methodology, the most valuable contributions are real-world cases where the skill missed a gap, plus the fix to the relevant dimension/probe/section. Worked examples from **non-robotics** products (SaaS, chip SDK, cloud, media SDK) are especially welcome — they help keep the skill visibly product-agnostic.

### License

[Apache License 2.0](LICENSE) © 2026 Auromix.

---

## 中文

### 这是什么

一句"我需要一个迎宾导览功能""能不能支持单点登录""能不能支持波束设置"这样的诉求，通常**缺失研发所需 80% 的信息**：角色、场景、边界、能力归属、接口、依赖、验收。

本技能用"**固定维度扫描 + 交互式逐问澄清**"的方式，**系统性地把这些缺口挖出来、补完整**，最终产出一份**过得了研发评审**的特性需求 —— 含接口契约草案与可验证验收标准。它**止于特性需求**（不做任务拆分，交给研发团队）。

它面向**带分层能力模型的 SDK / 平台型产品**，而且**产品无关**。机器人 SDK、SaaS 平台、芯片 SDK、云平台、音视频 SDK…… 全都能用——因为真正**产品特定**的那些东西（你的能力层级、你的实现层、你的命名约定、你的集成商分级、你的产品原则）**不写死在技能里**，而是来自**你自己的产品档案**。你在文档里看到的机器人内容（固件/算法/硬件层、波束成形、ROS 示例、末端硬件改装）是**一个示例领域**，不是前提。

关键在于：很多客户需求**不只落在一层**——一个诉求可能要同时动**多个由不同部门负责的实现层**：机器人产品可能是 *SDK / 固件 / 算法 / 硬件*；SaaS 产品可能是 *前端 / 后端 / 数据 / 基础设施*；芯片 SDK、云平台各有各的分层。无论你的层是什么，本技能都能把需求按层分解、给每层指派 owner、排出跨层依赖顺序、钉死层间交接契约，并在"**这事光靠最上层（SDK 层）交付不了**"时明确打标。

### 你要提供的两样东西（都产品无关、都本地私有）

技能方法是通用的。**你**通过提供两份本地配置文件，把它落到你自己的场景。两份都**本地生成、本地私有、加入 `.gitignore`**——绝不进技能本体、绝不进任何公开产出。两份都有三种生成方式：**(a)** 在对话里**描述你的产品/公司**，让技能生成；**(b)** **丢来已有资料**（数据手册、SDK 参考、组织架构、流程文档），让技能映射进去；**(c)** 跑 init 脚本生成模板再手填。

| | **产品档案** `product-profile.local.md` | **组织与流程** `org-process.local.md` |
| --- | --- | --- |
| **回答** | *你的产品长什么样？* | *你公司怎么协作？* |
| **内容** | 能力层级（你的 L1/L2/L3 或你自己的分层）、能力域、**你产品自己的实现层**（SaaS 可能是 前端/后端/数据/基础设施；芯片 SDK、云平台各不同——**不硬套**机器人的固件/算法/硬件）、接口/命名约定、交付形态、集成商分级、API 预算、产品原则取舍 | 角色地图、交付 gate、版本节奏与管道容量、CCB（变更决策组）、分支/合入规范、N 版本维护策略 |
| **从什么生成** | "我们产品长这样" / 产品数据手册、SDK 参考、能力清单 | "我们公司这么协作" / 组织架构图、责任矩阵、发版流程文档、分支规范 |
| **模板 + 生成脚本** | `references/product-profile-config.md` + `scripts/init-product-profile.sh` | `references/org-process-config.md` + `scripts/init-org-config.sh` |
| **技能拿它来** | 把特性归到**你的**层级/域、按**你的**实现层做跨层分解、套**你的**接口预算与命名、跑**你的**产品原则 gate | 把 owner 落到真实责任人、列出该特性必过的交付 gate 与交付件、挂到目标版本与管道容量、需求锁定后变更提示走 CCB |
| **不填时** | 技能用通用占位、把推断的层级/实现层/owner 打 `[待确认]`、并提示可生成一份——**绝不臆造**层名或部门名 | 技能用通用角色占位（如 `[产品经理·待指派]`）、并提示可生成一份 |

> **隐私红线。** 真实公司名、人名、内部链接、敏感信息**只**进 `*.local.md`（本地、gitignore、绝不提交），绝不进技能本体、绝不进任何要公开或跨公司传阅的产出。公开产出里的 owner 一律用**角色名或占位**。

### 给 agent —— 关键机制，无歧义地说清

- **何时触发。** 当用户粘进一段零散、口语化、还没想清楚的功能诉求，希望把它变成研发能接手的规格时触发——哪怕没说"特性需求文档"（如"把这个细化下""这个 feature 怎么定义""客户想要 XX 功能"）。**另外**，当用户提供**产品**资料（"我们产品长这样"）或**公司组织/流程**资料（"这是我们公司的资料"）、希望产出贴合自己场景时——**这就是"生成对应本地配置"的信号**，不要只当背景读过就算。
- **两类本地配置要读/要生成。** `product-profile.local.md`（你的产品长什么样）与 `org-process.local.md`（你公司怎么协作）。两份都产品无关、本地生成、加 `.gitignore`，都可由"描述"或"丢资料"触发生成。映射丢来的资料时**增量更新、绝不覆盖用户已填**，抽取后**向用户复述结构请其确认**。
- **产出落盘位置。** 每份成品特性需求写入 **`feature-specs/<特性名>/<特性名>.md`**——是磁盘上真实的文件，不是只贴在对话里。一个特性 = 一份文件（跨层特性也只出一份 md，内部分阅读对象成节）。一段话里发现的多个需求**各自独立成文**——绝不混写进同一份。
- **绝不替用户偷偷拍板取舍。** 一次一个问题，每问都带"为什么问 + 候选答案"。未定项打 `[待确认]`，不填一个看似合理的猜测值。

### 核心特性

- **三条正交轴叠加**：特性原型(AâJ 探针) × **你的实现层**（由产品档案定义）× 产品原则+NFR。
- **7 步工作流**：接收 → 需求分流 → 自动归类 → **跨层分解与路由** → 第一层澄清(定位) → 第二层澄清(功能细节) → 产出文档(过产品原则自检 gate)。
- **跨层 / 跨部门**：可行性证伪、"非最上层可独立交付"打标、结论回写堵"假就绪"、跨部门待确认三元组、层间 handoff 契约、"**主档案 + 分阅读对象成节**"产出形态。
- **产品原则 gate**：平台/SDK 产品的产品原则（来自你的产品档案，或内置默认），产出前作为硬 gate 逐条自检。
- **交互式**：一次一个问题，**绝不替你拍板**取舍。
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

**随后，在正式写第一份需求前，先建好两类本地配置**（见 [你要提供的两样东西](#你要提供的两样东西都产品无关都本地私有)）：

```bash
./scripts/init-product-profile.sh   # 生成 ./product-profile.local.md   （你的产品长什么样）
./scripts/init-org-config.sh        # 生成 ./org-process.local.md        （你公司怎么协作）
```

或者完全跳过脚本：在 Claude 会话里直接**描述你的产品和公司**（或把数据手册 / 组织架构图 / 流程文档粘进来），让技能替你生成这两份配置。两份文件都**已在 `.gitignore`**，只留在你本机。

然后把客户原话粘进去即可。技能会先复述理解、把藏着的多个子特性分流出来、按**你的**层级归类、在**你的**实现层上跑跨层路由，再一次一个问题地澄清——最后把需求写入 `feature-specs/<特性名>/<特性名>.md`。

> 一份配置都不填也能跑——但技能会把推断的层级、实现层、owner 打上 `[待确认]`，绝不臆造。

### 配置一览

两层配置，都产品无关：

1. **产品档案** —— 技能归类与分解所依据的坐标系。把原先内联的"配置区 A~E"一般化成一份可生成的文件：能力层级与能力域、你产品自己的实现层（**你的**，不是机器人专属）、接口/命名约定、交付形态、集成商分级、API 预算、产品原则取舍。模板：`references/product-profile-config.md`。
2. **组织与流程** —— 协作叠加层：角色地图、交付 gate、版本节奏与管道容量、CCB、维护策略。模板：`references/org-process-config.md`。

两份都是团队填一次、留在本地、加入 `.gitignore`。

### 仓库结构

```
.
├── skill/
│   └── feature-spec-builder/
│       ├── SKILL.md                          # 技能本体：工作流、维度、输出模板
│       └── references/
│           ├── detail-probes.md              # 分原型的第二层探针（AâJ）
│           ├── product-principles.md         # 默认产品原则 + 自检 gate + NFR 清单
│           ├── cross-layer-routing.md        # 分层模型、可行性 gate、分阅读对象节模板
│           ├── product-profile-config.md     # 产品档案模板 + 机制（产品无关）
│           ├── org-process-config.md         # 组织/流程模板 + 机制（脱敏）
│           ├── example.md                    # 端到端单层范例
│           ├── example-ros-integration.md    # 示例领域：多交付物（代码 + 文档）特性
│           ├── example-offline-install.md    # 示例领域：分发/打包特性
│           └── example-hardware-mod.md       # 示例领域：跨层、触底物理限制的特性
├── scripts/
│   ├── build-skill.sh                        # 把 skill/ 打包成 .skill
│   ├── init-product-profile.sh               # 生成本地、gitignore 的 product-profile.local.md
│   └── init-org-config.sh                    # 生成本地、gitignore 的 org-process.local.md
├── LICENSE                                   # Apache-2.0
├── NOTICE
├── CHANGELOG.md
└── CONTRIBUTING.md
```

> 这些 `example-*` 参考用**机器人**产品当示例领域，是对方法的演示，**不代表**技能只能用于机器人——换上你自己的产品档案，同一套工作流照样跑。

### 贡献

欢迎提 Issue / PR，见 [CONTRIBUTING.md](CONTRIBUTING.md)。因为这是一套提示词/方法论，最有价值的贡献是**真实案例里技能漏掉的缺口**，以及对应维度/探针/章节的补法。尤其欢迎来自**非机器人**产品（SaaS、芯片 SDK、云、媒体 SDK）的范例——它们能让技能的"产品无关"看得见、摸得着。

### 许可

[Apache License 2.0](LICENSE) © 2026 Auromix。

