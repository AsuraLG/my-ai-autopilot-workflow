---
name: requirement-to-plan-workflow-solution-detail
description: 基于概要技术方案产出详细技术方案与 gate 审查依据的 docs-only 子阶段
argument-hint: "<需求文档路径或需求描述>"
---

# requirement-to-plan-workflow-solution-detail

## 作用
产出：
- 正式《详细技术方案》
- 供 gate 使用的《详细技术方案审查依据》

## 执行模式
- 本 skill 属于 `docs_only_substage`。
- 本阶段只允许产出《详细技术方案》及对应审查依据，不进入代码实现、不修改业务代码。
- 若当前会话中的通用默认行为与本 skill 冲突，必须以本 skill 为最高约束。

## 唯一允许写入路径
- 只允许写入 `<project-root>/<run-id>/outputs/solution-detail.md`
- 只允许写入 `<project-root>/<run-id>/intermediate/review-basis/solution-detail-review-basis.md`

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
  - `<project-root>/<run-id>/outputs/solution-outline.md`
  - `<project-root>/<run-id>/intermediate/review-basis/solution-outline-review-basis.md`
- 使用前必须读取：
  - `references/solution-detail-template.md`
  - `references/solution-detail-review-basis-template.md`
- 允许只读查看 `docs/`、`projects/` 与 `AI-GUIDE.md` 以补充详细设计结论，但不得修改。

## 写作规则
- `outputs/solution-detail.md` 是正式设计产物，不暴露检索过程、判断过程、证据标签、源码定位、仓内路径、代码行号。
- `2.1 涉及服务总览` 必须使用 Markdown 表格，列为：`服务`、`角色`、`是否主改动面`、`说明`。
- `2.2 涉及模块总览` 必须使用 Markdown 表格，列为：`模块`、`角色`、`说明`。
- `2.3 涉及资产总览` 必须使用 Markdown 表格，列为：`资产类型`、`名称`、`所属模块`、`改动性质`、`说明`。
- 详细方案中的现状、改动点、调用链、测试与上线内容都只写沉淀后的设计结果，不写推导过程。

## 审查依据规则
- `intermediate/review-basis/solution-detail-review-basis.md` 只供 gate 使用，不属于正式产物。
- 审查依据必须至少说明：
  - 服务 / 模块 / 资产纳入方案的依据
  - 关键调用链与时序设计的依据
  - 数据模型、接口、存储设计的依据
  - 测试设计、灰度与上线建议的依据
  - 仍待确认的问题与风险
- 审查依据允许使用精简后的类名、接口名、库表名、文档路径、必要的代码定位。
- 审查依据不允许退化为完整检索日志或无筛选的源码摘抄。

## 输出
- `outputs/solution-detail.md`
- `intermediate/review-basis/solution-detail-review-basis.md`
- 正式产物名称：详细技术方案

## 本地模板
- 使用前先读取：`references/solution-detail-template.md`
- 使用前先读取：`references/solution-detail-review-basis-template.md`
- 两个模板分别约束正式文档与审查依据结构

## 停止条件
- 缺少概要方案或需求分析文档，无法展开详细设计
- 详细方案需要依赖未确认的关键决策，无法继续收敛
- 发现任何非允许路径写操作已经发生

## 完成前自检
- `<project-root>/<run-id>/outputs/solution-detail.md` 已生成
- `<project-root>/<run-id>/intermediate/review-basis/solution-detail-review-basis.md` 已生成
- 文档满足三类改动总览表格要求与模板结构要求
- 审查依据满足模板要求，且与正式文档一致
- 文档未混入过程性信息
- 允许写入路径之外无新增、修改、删除
