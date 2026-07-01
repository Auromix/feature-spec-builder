#!/usr/bin/env bash
#
# Generate a LOCAL, private org/process config for feature-spec-builder.
# The skill reads this file to route owners, list delivery gates, and tie a
# feature to your version pipeline — but it must NEVER be committed (real names
# / internal process). It is gitignored by default.
#
# Usage: ./scripts/init-org-config.sh [target-path]
#   default target: ./org-process.local.md (in the current directory)

set -euo pipefail
TARGET="${1:-./org-process.local.md}"

if [[ -e "$TARGET" ]]; then
  echo "refusing to overwrite existing $TARGET (edit it directly, or pass another path)" >&2
  exit 1
fi

cat > "$TARGET" <<'TEMPLATE'
# 组织与流程 · 本地配置（私有 —— 勿提交）
# 按你公司实际情况填写 <…> 处；用不到的行删掉，缺的自行增补。
# 完整字段说明与 skill 如何使用见 references/org-process-config.md。

## A. 角色地图（谁负责什么）
| 角色 | 你的责任人 |
| --- | --- |
| 业务产品经理（按业务线） | <填> |
| 系统 / 整机产品经理 | <填> |
| 硬件产品经理（按型号） | <填> |
| 二次开发产品经理 | <填> |
| 项目经理 | <填> |
| 质量经理（CQE / DQE） | <填> |
| 研发领域代表（按模块 / 领域） | <填> |
| 组件 Maintainer（按组件） | <填> |
| 测试 owner（场景 / 嵌入式 / 集成） | <填> |
| 运维 / FAE | <填> |
| 优先级裁决人 | <填> |
| CCB（变更决策 / 例会） | <填> |

## B. 交付流程与关键 gate（填你公司实际的评审节点与交付件）
1. 需求规划与澄清：收集 → 澄清(PRD) → 评估(人天) → 需求锁定 → 创建
2. 需求设计与开发：设计评审(设计文档+测试用例) → 变更走 CCB → 合入(Maintainer 审 MR) → 开发+自测(自测报告=提测入口)
3. 测试验证：分支拉取+自验编译 → RC 构建 → 冒烟/集成/场景/压测(测试报告)
4. 版本验收与发布：需求验收 → 发版评审 → 说明会 → 总结
5. 版本生命周期：导产 → 运维 → Hotfix(严重问题评审后增发) → EOS

## C. 版本节奏与管道容量
- 版本周期：<N 周>；管道容量：<M 人天>
- 大版本容量：<… 人天>（功能迭代）；小版本容量：<… 人天>（质量/DFX/可维可测）
- 需求评估单位：人天；需求锁定时点：<上个版本发版时>

## D. 变更控制
- CCB 例会：<如每周四>；需求增删改需申报 CCB 议题决策

## E. 分支与合入
- 保护分支：<develop / release>；合入需 Maintainer 审 MR；提测入口：自测报告

## F. 版本维护策略
- 最多维护最新 <N> 个版本；更老版本 EOS；Hotfix 条件：<严重且影响场景使用>
TEMPLATE

echo "created $TARGET"
echo "→ fill in your company's roles/process, and keep it private (it is gitignored)."
