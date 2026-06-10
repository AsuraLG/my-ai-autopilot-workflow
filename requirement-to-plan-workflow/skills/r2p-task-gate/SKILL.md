---
name: r2p-task-gate
description: 检查任务拆解与详细方案的一致性，由 subagent 执行
argument-hint: "<需求文档路径或需求描述>"
model: sonnet
---

# r2p-task-gate

## 作用
检查任务拆解产物的覆盖性、一致性、完整性、依赖合理性、粒度合理性和验证覆盖情况，给出门禁结论。

## 执行模式
- 本 skill 由 subagent 执行，属于 `docs_only_substage`。
- 只允许产出任务拆解质量报告。
- 作为独立审查者，不受 task-breakdown 阶段的思维惯性影响。

## 唯一允许写入路径
- `<project-root>/<run-id>/outputs/task-gate-report.md`

## 硬性禁止
- 禁止修改代码仓库目录下的任何文件
- 禁止修改知识库目录下的任何文件
- 禁止修改其他 skill、模板、脚本、测试、配置、构建文件
- 禁止修改任务拆解产物（只审查，不改）
- 禁止执行构建、测试、发布、提单、提交、PR、部署相关操作
- 禁止在允许写入路径之外执行任何写操作

## 输入要求
- 必须读取：`<run-dir>/state/run-state.json`
- 必须读取：`<run-dir>/outputs/task-breakdown.json`
- 必须读取：`<run-dir>/outputs/task-breakdown.md`
- 必须读取：`<run-dir>/intermediate/review-basis/task-breakdown-review-basis.md`
- 必须读取：`<run-dir>/outputs/solution-detail.md`
- 必须读取：`<run-dir>/outputs/requirement-analysis.md`
- 必须读取：`references/task-gate-report-template.md`
- 必须只读查看代码仓库目录（验证文件路径存在性）

## 审查维度
### 覆盖性
- 详细方案中的每个改动点是否都有对应任务
- 对照 review-basis 中的覆盖性自检表，交叉验证

### 一致性
- 任务描述是否与方案设计一致
- changeType 是否与实际改动性质匹配
- 任务的 service/module 是否与方案中的服务/模块对应

### 完整性
- 每个任务的 location 信息是否完整
- modify 类型任务的文件路径是否在代码仓库中实际存在
- 新建文件路径是否符合项目包结构约定

### 依赖合理性
- 任务依赖关系是否合理（如 DDL 先于数据层、数据层先于业务层）
- 是否存在循环依赖
- 是否存在遗漏的隐式依赖

### 粒度合理性
- 单个任务是否足够原子化（可独立提交）
- 单个任务是否过大（涉及多个不相关改动）
- 是否存在过度拆分（本应一起改的被拆开）

### 验证覆盖
- 关键改动是否有对应的验证计划
- 单测覆盖是否合理
- 集成测试是否覆盖核心流程

## 结论
- 通过
- 退回修改（从 r2p-task-breakdown 重做）
- 停止并确认

## 退回修改规则
- 退回时，结论必须明确指出具体问题和修改要求
- 退回只能要求从 r2p-task-breakdown 重做
- 若问题源于详细方案本身不完整，应给出"停止并确认"

## 停止条件
- 缺少任务拆解产物或审查依据
- 发现详细方案存在根本性遗漏，任务拆解无法弥补
- 代码仓库路径无法访问

## 重试指导
- 若收到用户反馈（通过运行时上下文注入），必须优先针对反馈内容调整产出
- 非反馈涉及的部分，若上次产出无问题则保持稳定，不做无谓改动
- 门禁报告中必须说明：本次针对哪些反馈调整了审查重点

## 完成前自检
- `task-gate-report.md` 已生成
- 六个审查维度均有明确结论
- 若退回，问题清单和修改要求完整
- 允许写入路径之外无新增、修改、删除
