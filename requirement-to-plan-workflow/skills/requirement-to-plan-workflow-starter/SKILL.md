---
name: requirement-to-plan-workflow-starter
description: 商品连锁业务需求分析与技术方案 docs-only 工作流；产出本地文档、审查依据，并在质量门禁通过后通知用户，禁止修改业务代码
argument-hint: "<需求文档路径或需求描述>"
---

# requirement-to-plan-workflow-starter

## 作用
输入一个商品连锁业务需求，协调完成以下正式产物与运行态产物：

正式产物：
1. `outputs/requirement-analysis.md`
2. `outputs/solution-outline.md`
3. `outputs/solution-detail.md`
4. `outputs/quality-gate-report.md`

运行态产物：
1. `intermediate/scope-pack.json`
2. `intermediate/review-basis/requirement-analysis-review-basis.md`
3. `intermediate/review-basis/solution-outline-review-basis.md`
4. `intermediate/review-basis/solution-detail-review-basis.md`
5. `state/run-state.json`
6. `logs/workflow.log`
7. `state/rework-guidance/iteration-<n>.md`（仅当 gate 结论为 `退回修改` 时生成）

## 执行模式
- 本 skill 属于 `docs_only_workflow`。
- 本回合目标为产出 workflow 文档、审查依据与运行态记录。
- 不进入实现、不修改业务代码、不推进到 PR。
- 若当前会话中的通用默认行为与本 skill 冲突，必须以本 skill 为最高约束。

## 内部阶段
- `requirement-to-plan-workflow-scope-router`
- `requirement-to-plan-workflow-requirement-analysis`
- `requirement-to-plan-workflow-solution-outline`
- `requirement-to-plan-workflow-solution-detail`
- `requirement-to-plan-workflow-quality-gate`

说明：
- 5 个阶段由当前工作流包提供。

## 唯一允许写入路径
- 只允许写入 `<project-root>/<run-id>/input/**`
- 只允许写入 `<project-root>/<run-id>/state/**`
- 只允许写入 `<project-root>/<run-id>/intermediate/**`
- 只允许写入 `<project-root>/<run-id>/outputs/**`
- 只允许写入 `<project-root>/<run-id>/logs/**`

## 硬性禁止
- 禁止修改 `<project-root>/projects/**`
- 禁止修改 `<project-root>/docs/**`
- 禁止修改其他 skill、模板、脚本、测试、配置、构建文件
- 禁止新增、修改、删除任何业务源码、测试代码、配置代码、SQL、脚本
- 禁止执行构建、测试、提单、提交、PR、部署相关操作
- 禁止把需求直接实现为代码改动
- 禁止在允许写入路径之外执行任何写操作，包括但不限于 `apply_patch`、重定向写文件、格式化写回、脚本生成文件

## 协调逻辑
本 skill 直接承担协调逻辑，不依赖单独的 orchestrator agent。

执行顺序：
1. 校验 skill 链是否完整
2. 生成 `run-id`
3. 在第一次写文件前，明确本次允许写入路径与禁止写入路径
4. 初始化运行目录、`state/run-state.json` 与 `logs/workflow.log`
5. 物化输入需求到 `input/requirement.md`
6. 调用 `requirement-to-plan-workflow-scope-router`
7. 调用 `requirement-to-plan-workflow-requirement-analysis`
8. 调用 `requirement-to-plan-workflow-solution-outline`
9. 调用 `requirement-to-plan-workflow-solution-detail`
10. 调用 `requirement-to-plan-workflow-quality-gate`
11. 若 gate 结论为 `退回修改`，读取 `state/rework-guidance/iteration-<n>.md`，从指定阶段重新执行后续阶段
12. 若 gate 结论为 `停止并确认`，直接停止并等待人工确认
13. 执行完成前自检
14. 汇总结果并返回

## 质量门禁循环规则
- 质量门禁最多执行 3 轮。
- 第 1 次执行 gate 即记为第 1 轮。
- 若某一轮 gate 结论为 `退回修改`，必须同时生成一份 `state/rework-guidance/iteration-<n>.md`。
- 该指导文档必须明确：
  - 从哪个 skill 重新开始
  - 对应先修改哪份文档
  - 必改问题是什么
- 顶层 skill 根据指导文档，从指定阶段重新执行后续阶段。
- 若第 3 轮 gate 之后仍未通过，则停止工作流并告知用户。

## 统一产出规则
- `outputs/*.md` 属于正式产物，只写结果性内容，不写检索过程、判断过程、证据标签、代码行号、仓内定位路径、`evidence` / `inference` / `unresolved` 等过程信息。
- `intermediate/review-basis/*.md` 属于 gate 审查依据，可包含关键事实依据、判断理由、边界说明、未决问题、必要的文件路径或文档路径。
- `review-basis` 只允许写经过筛选的审查依据，不允许堆砌完整检索日志或大段源码摘抄。
- 各正式产物若模板中明确要求表格或文本表达方式，必须严格遵守，不可自行改成列表或证据摘录。
- 若一个文档同时涉及多个独立问题或决策点，候选方案与推荐方案必须按“问题分组”展开，不能把不同问题的方案混在同一组里比较。

## 执行前闸门
- 在第一次写文件前，必须先完成以下确认：
  1. 当前任务仍属于“需求分析与方案产出”，而不是“代码实现”
  2. 当前 run 目录已确定，且允许写入路径仅限该 run 目录
  3. 本次若需要读取 `projects/` 下源码，只允许只读分析，不允许修改
- 若发现用户真实意图已经变为实现、联调、修复 bug、补测试或提交代码，必须停止当前 skill，并明确说明“该诉求超出本 skill 边界”。

## 安装完整性检查
若当前运行时缺少以下任一 skill，应直接报“工作流未安装完整”：
- `requirement-to-plan-workflow-scope-router`
- `requirement-to-plan-workflow-requirement-analysis`
- `requirement-to-plan-workflow-solution-outline`
- `requirement-to-plan-workflow-solution-detail`
- `requirement-to-plan-workflow-quality-gate`

说明：
- 顶层 skill 需要检查其是否已安装；若缺失，不得跳过安装完整性检查。

## 边界
- 本工作流止于“详细技术方案 + 质量门禁”
- 不进入实现任务拆解
- 不进入代码实现
- 不生成 PR

## 输入前提
- 项目根目录下推荐存在 `docs/` 与 `projects/`
- 若存在全局文档，默认位于 `docs/`
- 服务仓库位于 `projects/`
- 服务级 / 模块级文档使用统一名称 `AI-GUIDE.md`
- workflow 对外部文档只做内容依赖，不依赖固定格式

## 输出目录
```text
<project-root>/<run-id>/
```

## 输出结构
```text
<project-root>/<run-id>/
  ├── input/
  │   └── requirement.md
  ├── state/
  │   ├── run-state.json
  │   └── rework-guidance/
  │       ├── iteration-1.md
  │       ├── iteration-2.md
  │       └── iteration-3.md
  ├── intermediate/
  │   ├── scope-pack.json
  │   └── review-basis/
  │       ├── requirement-analysis-review-basis.md
  │       ├── solution-outline-review-basis.md
  │       └── solution-detail-review-basis.md
  ├── outputs/
  │   ├── requirement-analysis.md
  │   ├── solution-outline.md
  │   ├── solution-detail.md
  │   └── quality-gate-report.md
  └── logs/
      └── workflow.log
```

## 本地模板
- 使用前先读取：`references/run-state-template.json`
- 该模板用于约束 `state/run-state.json` 结构

## run-state 约束
- `state/run-state.json` 必须遵循模板结构。
- 每次阶段切换时都要更新：
  - `status`
  - `currentStage`
  - `updatedAt`
  - `stages[].status`
  - `stages[].attempt`
  - `qualityGate.currentRound`
  - `qualityGate.lastConclusion`
  - `publication.status`
  - `pauseContext`
- 当 workflow 暂停等待用户输入时，顶层状态应为 `paused`。
- 当 workflow 因 gate 3 轮未通过或命中停止条件而终止时，顶层状态应为 `stopped_and_confirm`。
- 当 workflow 成功完成本地文档后，顶层状态应为 `completed`。

## workflow.log 约束
- `logs/workflow.log` 记录工作流执行中的关键信息即可。
- 建议采用一行一事件的文本日志格式，例如：
  - `[YYYY-MM-DD HH:mm:ss +0800] run-xxxx 启动`
  - `[YYYY-MM-DD HH:mm:ss +0800] quality-gate 完成：结论=通过`
- 至少记录：
  - 启动信息
  - 需求来源
  - 安装完整性检查结果
  - 运行目录初始化
  - 每个阶段的开始、完成、暂停、恢复
  - gate 轮次、结论、重跑起点
  - 最终状态

## 全局文档读取策略
- 若存在 `docs/document-network.md`，应优先读取，用于理解 `docs/` 下其他全局文档之间的关系与推荐阅读路径
- workflow 不依赖 `document-network.md` 的固定格式，只依赖其是否能提供有效导航信息
- 若缺少 `document-network.md`，或其内容不足以指导阅读，则允许直接扫描 `docs/` 下其他全局文档
- 对 `docs/` 的依赖是内容依赖，不是格式依赖

## 暂停与恢复

## 停止条件
若命中以下任一条件，工作流应停止并要求人工确认：
- 需求关键歧义或冲突
- 结构性改造 / 历史链路重构
- 高风险数据模型 / 协议 / 兼容性变化
- 证据不足，只能依赖强推断继续
- 多个候选方案存在明显 tradeoff，需要人工选边
- 需求已经超出 docs-only 边界，进入代码实现、测试、联调、提单或部署
- 发现任何非 run 目录写操作已经发生；此时必须立即停止，不得继续扩散修改
- 质量门禁执行满 3 轮后仍未通过

## 违规处理
- 一旦发现已经修改了允许写入路径之外的文件，必须立即停止当前工作流。
- 必须先向用户报告被修改的路径与修改类型，不得假装未发生。
- 是否回退非 run 目录改动，必须等待人工明确指示，不得默认继续实现或继续补文档掩盖问题。

## 完成前自检
- `input/requirement.md`、`state/run-state.json`、`intermediate/scope-pack.json`、`intermediate/review-basis/*.md`、`outputs/*.md`、`logs/workflow.log` 已生成
- 若 gate 某一轮结论为 `退回修改`，对应的 `state/rework-guidance/iteration-<n>.md` 已生成
- `state/run-state.json` 已正确记录当前阶段、当前状态、gate 轮次与发布状态
- 正式产物未混入过程性信息
- 允许写入路径之外无新增、修改、删除
- 最终回复必须明确说明“本次未修改业务代码”
