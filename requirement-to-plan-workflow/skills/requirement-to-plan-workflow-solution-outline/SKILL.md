---
name: requirement-to-plan-workflow-solution-outline
description: 基于需求分析产出概要技术方案与 gate 审查依据的 docs-only 子阶段
argument-hint: "<需求文档路径或需求描述>"
---

# requirement-to-plan-workflow-solution-outline

## 作用
产出：
- 正式《概要技术方案》
- 供 gate 使用的《概要技术方案审查依据》

## 执行模式
- 本 skill 属于 `docs_only_substage`。
- 本阶段只允许产出《概要技术方案》及对应审查依据，不进入代码实现、不修改业务代码。
- 若当前会话中的通用默认行为与本 skill 冲突，必须以本 skill 为最高约束。

## 唯一允许写入路径
- 只允许写入 `<project-root>/<run-id>/outputs/solution-outline.md`
- 只允许写入 `<project-root>/<run-id>/intermediate/review-basis/solution-outline-review-basis.md`

## 硬性禁止
- 禁止修改 `<project-root>/projects/**`
- 禁止修改 `<project-root>/docs/**`
- 禁止修改其他 skill、模板、脚本、测试、配置、构建文件
- 禁止新增、修改、删除任何业务源码、测试代码、配置代码、SQL、脚本
- 禁止执行构建、测试、发布、提单、提交、PR、部署相关操作
- 禁止在允许写入路径之外执行任何写操作

## 输入要求
- 若在工作流内执行，必须优先读取：
  - `<project-root>/<run-id>/input/requirement.md`
  - `<project-root>/<run-id>/intermediate/scope-pack.json`
  - `<project-root>/<run-id>/outputs/requirement-analysis.md`
  - `<project-root>/<run-id>/intermediate/review-basis/requirement-analysis-review-basis.md`
- 使用前必须读取：
  - `references/solution-outline-template.md`
  - `references/solution-outline-review-basis-template.md`
- 允许只读查看 `docs/`、`projects/` 与 `AI-GUIDE.md` 以补充方案判断，但不得修改。

## 写作规则
- `outputs/solution-outline.md` 是正式方案产物，不暴露检索过程、判断过程、证据标签、源码定位、仓内路径、代码行号。
- `4.1 当前业务架构理解` 与 `4.2 本次业务架构改动说明` 必须使用文本简述；`4.3 业务架构图` 负责展开细节。
- `5.1 当前系统架构理解` 与 `5.2 本次系统架构改动说明` 必须使用文本简述；`5.3 系统架构图` 负责展开细节。
- 候选方案分析必须围绕同一个问题或决策点展开比较；若文档内有多个独立问题，必须按问题分组展开候选方案。
- 推荐方案必须与候选方案的分组方式一致；若候选方案按问题分组，推荐方案也必须按问题分组给出结论。

## 审查依据规则
- `intermediate/review-basis/solution-outline-review-basis.md` 只供 gate 使用，不属于正式产物。
- 审查依据必须至少说明：
  - 方案目标与边界的判断依据
  - 业务架构 / 系统架构理解的主要依据
  - 候选方案与推荐方案的取舍依据
  - 关键 tradeoff
  - 仍待确认的问题
- 审查依据允许使用精简后的架构判断说明、服务路径、文档路径或必要的代码定位。
- 审查依据不允许退化为完整检索日志或无筛选的源码摘抄。

## 输出
- `outputs/solution-outline.md`
- `intermediate/review-basis/solution-outline-review-basis.md`
- 正式产物名称：概要技术方案

## 本地模板
- 使用前先读取：`references/solution-outline-template.md`
- 使用前先读取：`references/solution-outline-review-basis-template.md`
- 两个模板分别约束正式文档与审查依据结构

## 停止条件
- 缺少需求分析文档或范围包，无法形成完整概要方案
- 存在明显 tradeoff 需要人工选边
- 发现任何非允许路径写操作已经发生

## 完成前自检
- `<project-root>/<run-id>/outputs/solution-outline.md` 已生成
- `<project-root>/<run-id>/intermediate/review-basis/solution-outline-review-basis.md` 已生成
- 文档满足文本段落、候选方案分组与模板结构要求
- 审查依据满足模板要求，且与正式文档一致
- 文档未混入过程性信息
- 允许写入路径之外无新增、修改、删除
