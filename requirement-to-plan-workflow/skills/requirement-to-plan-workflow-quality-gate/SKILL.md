---
name: requirement-to-plan-workflow-quality-gate
description: 对三份正式产物及其审查依据执行质量门禁检查的 docs-only 子阶段
argument-hint: "<需求文档路径或需求描述>"
---

# requirement-to-plan-workflow-quality-gate

## 作用
检查正式产物的完整性、一致性、设计物完整性与可落地性，并在需要时给出修改指导。

## 执行模式
- 本 skill 属于 `docs_only_substage`。
- 本阶段只允许产出《方案落地质量门禁报告》以及条件性的退回修改指导文档，不进入代码实现、不修改业务代码。
- 若当前会话中的通用默认行为与本 skill 冲突，必须以本 skill 为最高约束。

## 唯一允许写入路径
- 只允许写入 `<project-root>/<run-id>/outputs/quality-gate-report.md`
- 只允许写入 `<project-root>/<run-id>/state/rework-guidance/**`

## 硬性禁止
- 禁止修改 `<project-root>/projects/**`
- 禁止修改 `<project-root>/docs/**`
- 禁止修改其他 skill、模板、脚本、测试、配置、构建文件
- 禁止新增、修改、删除任何业务源码、测试代码、配置代码、SQL、脚本
- 禁止执行构建、测试、发布、提单、提交、PR、部署相关操作
- 禁止在允许写入路径之外执行任何写操作

## 输入要求
- 若在工作流内执行，必须优先读取：
  - `<project-root>/<run-id>/state/run-state.json`
  - `<project-root>/<run-id>/outputs/requirement-analysis.md`
  - `<project-root>/<run-id>/outputs/solution-outline.md`
  - `<project-root>/<run-id>/outputs/solution-detail.md`
  - `<project-root>/<run-id>/intermediate/review-basis/requirement-analysis-review-basis.md`
  - `<project-root>/<run-id>/intermediate/review-basis/solution-outline-review-basis.md`
  - `<project-root>/<run-id>/intermediate/review-basis/solution-detail-review-basis.md`
- 使用前必须读取：
  - `references/quality-gate-report-template.md`
  - `references/quality-gate-rework-guide-template.md`
- 本阶段只做文档审查与结论归纳，不补实现方案、不改正式产物内容。

## 审查规则
- gate 应优先基于上游阶段提供的 `review-basis` 审查，不应重新做一轮完整分析。
- 若 `review-basis` 无法支撑正式文档结论，应将“审查依据不足”本身记录为问题，而不是自行猜测补齐。
- 检查正式产物是否混入检索过程、判断过程、证据标签、源码定位、仓内路径、代码行号。
- 检查《需求分析文档》是否满足：
  - 需求背景简练
  - 名词解释 / 需求要点 / 风险关注模块 / 受影响资产使用指定表格结构
- 检查《概要技术方案》是否满足：
  - 业务架构视图与系统架构视图中的“理解 / 改动说明”使用文本
  - 候选方案与推荐方案在多问题场景下按问题分组
- 检查《详细技术方案》是否满足：
  - 改动总览三部分使用指定表格结构
- 检查可落地性是否满足：
  - 已明确改哪些模块
  - 已明确不改什么
  - 已明确验证范围

## 结论
- 通过
- 退回修改
- 停止并确认

## 退回修改规则
- 若结论为 `退回修改`，必须同时生成一份 `state/rework-guidance/iteration-<n>.md`。
- 该指导文档必须明确：
  - 第几轮 gate
  - 从哪个 skill 重新开始
  - 先修改哪份文档
  - 必改问题清单
  - 建议优化项
- 重新开始的起点只能是以下之一：
  - `requirement-to-plan-workflow-requirement-analysis`
  - `requirement-to-plan-workflow-solution-outline`
  - `requirement-to-plan-workflow-solution-detail`
- 若问题已经超出 workflow 正常修文边界，应给出 `停止并确认`，而不是继续要求自动循环。

## 输出
- `outputs/quality-gate-report.md`
- `state/rework-guidance/iteration-<n>.md`（仅当结论为 `退回修改` 时生成）
- 正式产物名称：方案落地质量门禁报告

## 本地模板
- 使用前先读取：`references/quality-gate-report-template.md`
- 使用前先读取：`references/quality-gate-rework-guide-template.md`
- 两个模板分别约束门禁报告与退回修改指导文档结构

## 停止条件
- 缺少任一正式产物或对应审查依据，无法完成完整质量门禁
- 审查发现存在阻断问题，需要人工确认
- 发现任何非允许路径写操作已经发生

## 完成前自检
- `<project-root>/<run-id>/outputs/quality-gate-report.md` 已生成
- 若结论为 `退回修改`，对应的 `state/rework-guidance/iteration-<n>.md` 已生成
- 门禁结论、问题清单、建议动作已完整给出
- 报告未混入过程性信息
- 允许写入路径之外无新增、修改、删除
