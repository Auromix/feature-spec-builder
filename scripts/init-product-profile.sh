#!/usr/bin/env bash
#
# Generate a LOCAL, private product profile for feature-spec-builder.
# The skill reads this file to classify a requirement (capability tiers +
# domains), route implementation-layer owners, apply your naming convention,
# and check the API budget — but it must NEVER be committed (internal interface
# lists / team names / real budgets). It is gitignored by default.
#
# The skill's methodology is product-agnostic: robot / SaaS / chip-SDK / cloud /
# AV-SDK all work — you just fill THIS file with your own product's shape.
#
# Usage: ./scripts/init-product-profile.sh [target-path]
#   default target: ./product-profile.local.md (in the current directory)

set -euo pipefail
TARGET="${1:-./product-profile.local.md}"

if [[ -e "$TARGET" ]]; then
  echo "refusing to overwrite existing $TARGET (edit it directly, or pass another path)" >&2
  exit 1
fi

cat > "$TARGET" <<'TEMPLATE'
# 产品档案 · 本地配置（私有 —— 勿提交）
# 描述你的产品长什么样。方法论产品无关，示例只是示例——填你产品自己的。
# 按实际情况填写 <…> 处；用不到的行删掉，缺的层级/域/实现层自行增补。
# 完整字段说明、多领域示例与 skill 如何使用见 references/product-profile-config.md。

## A. 能力层级（对外抽象分几层，用你产品自己的分层名；层数不必是 3）
L1 = <最底层/原子能力>   # 机器人:原子接口 · SaaS:底层API · 芯片SDK:HAL原语 · 云:基础API
L2 = <组合/应用级能力>   # 机器人:应用包 · SaaS:业务组件 · 芯片SDK:驱动SDK · 云:托管服务
L3 = <完整方案/场景交付> # 机器人:场景方案 · SaaS:行业方案 · 芯片SDK:参考设计 · 云:蓝图

## B. 能力域（横向切成哪几个域，数量按你产品定，不必是 5）
域 = <域1> / <域2> / <域3> / <域4> / <域5>
#  机器人:运动/感知/交互/数据/标定 · SaaS:账号权限/计费/数据/集成/通知
#  芯片SDK:外设/电源时钟/通信/安全/调试 · 云:计算/存储/网络/可观测/身份

## C. 实现层 × 团队（对内由哪些层承接，各层归谁；别硬套机器人的固件/算法/硬件）
# 实现层 → 负责团队 owner → 跨层签字人
# 运行时层（填你产品自己的层）：
#   机器人示例: 二开SDK→<SDK组> · 固件·中间件→<固件组> · 算法服务→<算法组> · 硬件→<硬件组>
#   SaaS示例:   前端→<前端组> · 后端→<后端组> · 数据→<数据组> · 基础设施→<SRE组>
#   芯片SDK示例: 应用SDK→<SDK组> · 驱动/HAL→<驱动组> · 固件/RTOS→<固件组> · 硅片/IP→<硬件组>
#   云平台示例: 控制面API→<API组> · 数据面→<运行时组> · 控制台→<前端组> · 基础设施→<基础设施组>
<你的运行时实现层1> → <owner> → <签字人>
<你的运行时实现层2> → <owner> → <签字人>
# 非运行时层（生态/集成/文档/打包类特性会落这里，别硬塞给核心研发层）：
文档/开发者门户层 → <DevRel/文档/站点前端> → <签字人>
构建/分发基建层   → <构建/DevOps/发布工程>   → <签字人>
跨团队升级路径 = <层 owner → 部门负责人 → 架构评审会 → CTO>

## D. 接口与命名约定（对外契约怎么写）
命名风格 = <如 snake_case、词意完整、禁缩写(mic→microphone) / REST 复数名词 / gRPC verb_noun>
语言/绑定约定 = <如 C++ core+pybind11 / TypeScript SDK / REST+OpenAPI / gRPC+protobuf>
错误与返回约定 = <如 失败返回 bool / HTTP 状态码+错误体 / Result 类型>
物理接口约定[仅硬件类] = <机械 法兰/孔位/公差/承重/力矩；电气 连接器/pinout/供电/协议>

## E. 交付形态（产出成什么、跑在哪）
形态 = <仿真/真机/两者 · SaaS多租户/私有化 · SDK包/源码 · 芯片评估板/量产 · 云SaaS/on-prem>
支持平台/环境 = <如 x86+arm×Ubuntu18.04~24.04 / 浏览器矩阵 / MCU型号 / 云region>
产出输出目录 = <默认 feature-specs/；产出写到 <此目录>/<特性名>/<特性名>.md>

## F. 用户 / 集成商分级（对谁开放、按级门控）
分级 = <Associate/Professional/Expert · 免费/Pro/Enterprise · 只读/开发者/管理员 · 已购机/公开>
分级差异 = <各级能用哪些能力、封装/文档复杂度、危险/高权限动作对哪级开放>

## G. API 预算（接口规模纪律；无硬上限的产品写"无硬上限，新增需接口评审"）
API 预算 = <如 300 个方法上限 / REST 端点数上限 / 每模块接口数软上限>
占用判定 = <新增接口如何计入、超阈值触发什么评审>

## H. 产品原则取舍（产出前自检 gate 的尺子）
采用内置默认原则：是 / 否   # 默认=是，10 条均领域中立，全文见 references/product-principles.md
团队自定义/补充原则：<可留空；填了则与内置默认合并，冲突以团队为准>
冲突优先级：<安全默认、向后兼容均为红线相撞必须人工拍板；其余优先序在此填，留空则抛回用户>
破坏性变更签字人：<判定为 break 时需谁签字，如 平台架构负责人 / API 委员会>
TEMPLATE

echo "created $TARGET"
echo "→ fill in your product's tiers/domains/layers/naming/budget, and keep it private (it is gitignored)."

