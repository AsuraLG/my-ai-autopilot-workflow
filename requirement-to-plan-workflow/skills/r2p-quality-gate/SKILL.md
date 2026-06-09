---
name: r2p-quality-gate
description: 对三份正式产物及审查依据执行质量门禁检查，由 subagent 执行
argument-hint: "<需求文档路径或需求描述>"
---

# r2p-quality-gate

## 作用
检查正式产物的完整性、一致性、设计物完整性与可落地性，给出门禁结论。

## 执行模式
- 本 skill 由 subagent 执行，属于 `docs_only_substage`。
- 只允许产出质量门禁报告和条件性的退回修改指导文档。
- 作为独立审查者，不受前序产出阶段的思维惯性影响。

## 唯一允许写入路径
- `<project-root>/<run-id>/outputs/quality-gate-report.md`
- `<project-root>/<run-id>/state/rework-guidance/**`

## 硬性禁止
- 禁止修改代码仓库目录下的任何文件
- 禁止修改知识库目录下的任何文件
- 禁止修改其他 skill、模板、脚本、测试、配置、构建文件
- 禁止修改正式产物（只审查，不改）
- 禁止执行构建、测试、发布、提单、提交、PR、部署相关操作
- 禁止在允许写入路径之外执行任何写操作

## 输入要求
- 必须读取：`<run-dir>/state/run-state.json`
- 必须读取：`<run-dir>/outputs/requirement-analysis.md`
- 必须读取：`<run-dir>/outputs/solution-outline.md`
- 必须读取：`<run-dir>/outputs/solution-detail.md`
- 必须读取：`<run-dir>/intermediate/review-basis/requirement-analysis-review-basis.md`
- 必须读取：`<run-dir>/intermediate/review-basis/solution-outline-review-basis.md`
- 必须读取：`<run-dir>/intermediate/review-basis/solution-detail-review-basis.md`
- 必须读取：`references/quality-gate-report-template.md`
- 必须读取：`references/quality-gate-rework-guide-template.md`
- 必须读取：`references/quality-gate-rules.md`

## 审查规则
- 优先基于 review-basis 审查，不重新做完整分析
- 若 review-basis 无法支撑正式文档结论，记录"审查依据不足"为问题
- 检查正式产物是否混入过程性信息
- 检查需求分析文档表格规范
- 检查概要技术方案文本/分组规范
- 检查详细技术方案改动总览表格规范
- 检查可落地性（改哪些模块、不改什么、验证范围）

## 结论
- 通过
- 退回修改
- 停止并确认

## 退回修改规则
- 必须同时生成 `state/rework-guidance/iteration-<n>.md`
- 该文档必须明确：第几轮 gate、从哪个 skill 重新开始、先修改哪份文档、必改问题清单、建议优化项
- 重新开始起点只能是：r2p-requirement-analysis、r2p-solution-outline、r2p-solution-detail
- 若问题超出 workflow 修文边界，应给出"停止并确认"

## 停止条件
- 缺少任一正式产物或审查依据
- 审查发现存在阻断问题，需要人工确认

## 重试指导
- 若收到用户反馈（通过运行时上下文注入），必须优先针对反馈内容调整产出
- 非反馈涉及的部分，若上次产出无问题则保持稳定，不做无谓改动
- 门禁报告中必须说明：本次针对哪些反馈调整了审查重点

## 完成前自检
- `quality-gate-report.md` 已生成
- 若结论为退回修改，rework-guidance 已生成
- 门禁结论、问题清单、建议动作完整给出
- 允许写入路径之外无新增、修改、删除
