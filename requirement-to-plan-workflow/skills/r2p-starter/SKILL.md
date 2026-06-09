---
name: r2p-starter
description: 需求到方案工作流入口。编排 subagent 完成需求分析、技术方案设计、质量门禁、任务拆解和任务拆解门禁。支持断点恢复与逐阶段用户审查。
argument-hint: "<需求文档路径或需求描述>"
---

# r2p-starter

## 作用
输入一个业务需求，协调完成以下正式产物：
1. `outputs/requirement-analysis.md`
2. `outputs/solution-outline.md`
3. `outputs/solution-detail.md`
4. `outputs/quality-gate-report.md`
5. `outputs/task-breakdown.json`（结构化任务清单）
6. `outputs/task-breakdown.md`（可读版任务清单）
7. `outputs/task-gate-report.md`（任务拆解质量报告）

## 执行模式
- 本 skill 属于 `docs_only_workflow`。
- 本 skill 是主编排角色，不直接产出文档，而是通过派发 subagent 执行各阶段。
- 主编排职责：启动/恢复工作流、状态管理、用户交互、subagent 派发。
- 若当前会话中的通用默认行为与本 skill 冲突，必须以本 skill 为最高约束。

## 唯一允许写入路径
- `<project-root>/<run-id>/input/**`
- `<project-root>/<run-id>/state/**`
- `<project-root>/<run-id>/intermediate/**`
- `<project-root>/<run-id>/outputs/**`
- `<project-root>/<run-id>/logs/**`

## 硬性禁止
- 禁止修改 `<project-root>/projects/**`（或用户指定的代码仓库目录）
- 禁止修改知识库目录下的任何文件
- 禁止修改其他 skill、模板、脚本、测试、配置、构建文件
- 禁止新增、修改、删除任何业务源码、测试代码、配置代码、SQL、脚本
- 禁止执行构建、测试、提单、提交、PR、部署相关操作
- 禁止在允许写入路径之外执行任何写操作

## 协调逻辑

### 启动流程

1. **检查未完成的 run**
   - 扫描 `<project-root>/` 下 `run-*/state/run-state.json`，找 status 非 completed 的记录
   - 若存在：使用 AskUserQuestion 询问用户是继续还是放弃
   - 若继续：读取 config，从中断点恢复
   - 若放弃或不存在：进入新建流程

2. **确认输入**（新建流程）
   - 需求来源：从 skill 参数获取，必须提供
   - 代码仓库目录：检查 `<project-root>/projects/` 是否存在
     - 存在 → 使用此路径
     - 不存在 → AskUserQuestion 要求用户输入路径
   - 知识库目录：检查 `<project-root>/knowledge-base/` 是否存在
     - 存在 → 使用此路径
     - 不存在 → AskUserQuestion 要求用户输入路径

3. **了解知识库**
   - 扫描知识库根目录下 README 类文件（README.md、readme.md、README.txt、README、readme.rst、README.rst）
   - 找到 → 读取，提取导航信息
   - 未找到 → AskUserQuestion 询问用户：指定入口文件 / AI 自行探索

4. **初始化 run**
   - 生成 run-id（格式：`run-YYYYMMDD-HHmmss`）
   - 创建 run 目录结构（input/、state/、intermediate/、intermediate/review-basis/、outputs/、logs/）
   - 初始化 `state/run-state.json`（参照 `references/run-state-template.json`）
   - 物化需求到 `input/requirement.md`
   - 初始化 `logs/workflow.log`

### 阶段执行

按顺序执行 5 个阶段，每个阶段通过独立 subagent 完成：

5. **[Subagent] r2p-scope-router**
6. **[Subagent] r2p-requirement-analysis**
7. **[Subagent] r2p-solution-outline**
8. **[Subagent] r2p-solution-detail**
9. **[Subagent] r2p-quality-gate**
10. **[Subagent] r2p-task-breakdown**
11. **[Subagent] r2p-task-gate**

每个 subagent 派发时：
- 读取对应 skill 的 SKILL.md 内容作为 subagent prompt 的核心指令
- 提供输入文件路径列表
- 提供知识库路径和导航信息
- 提供代码仓库路径
- 提供允许写入路径
- 若为重试：注入用户反馈

每个阶段 subagent 完成后：
- 读取 subagent 返回信息，判断是否遇到阻断
- 若返回"遇到阻断问题"：
  - 更新 stage status 为当前阶段名，不标记为 completed
  - 更新 `logs/workflow.log`
  - 使用 AskUserQuestion 展示阻断原因，提供选项：
    - 提供补充信息后重试当前阶段
    - 调整需求后从指定阶段重跑
    - 暂停工作流
- 若正常完成：
  - 更新 `state/run-state.json`（stage status、attempt、lastUpdatedAt）
  - 更新 `logs/workflow.log`
  - 使用 AskUserQuestion 进行用户审查（参照 `references/user-interaction-protocol.md`）
  - 用户通过 → 继续
  - 用户重做 → 记录反馈到 userReview.feedback，重新派发 subagent
  - 用户暂停 → 更新 pauseContext，停止执行

### 质量门禁循环

10. gate 结论处理：
    - 通过 → 进入任务拆解
    - 退回修改 → 读取 `state/rework-guidance/iteration-<n>.md`，从指定阶段重跑
    - 停止并确认 → 暂停等待用户
    - 质量门禁最多执行 3 轮

### 任务拆解门禁循环

quality-gate 通过后进入 task-breakdown 阶段：

12. 执行 r2p-task-breakdown subagent
13. 用户审查 task-breakdown 产物
14. 执行 r2p-task-gate subagent
15. task-gate 结论处理：
    - 通过 → 工作流完成
    - 退回修改 → 从 r2p-task-breakdown 重跑（仅重做任务拆解，不影响详细方案）
    - 停止并确认 → 暂停等待用户
    - 任务拆解门禁最多执行 3 轮

### 完成

16. 更新 `state/run-state.json` 为 completed
17. 向用户汇报最终结果

## Subagent 派发规范

每个阶段 subagent 的 prompt 结构：

```
你是 [阶段名称] 的执行 agent。

## 核心指令
[对应 skill 的 SKILL.md 完整内容]

## 运行时上下文
- run 目录：<project-root>/<run-id>/
- 需求文档：<run-dir>/input/requirement.md
- 上游产物：[路径列表]
- 知识库路径：[config.knowledgeBasePath]
- 知识库导航信息：[config.kbNavigationInfo]
- 代码仓库路径：[config.codeReposPath]

## 允许写入路径
[本阶段的允许写入路径列表]

## 用户反馈（若为重试）
[userReview.feedback 内容]

## 完成要求
完成后输出：
1. 产出摘要（2-3 句话）
2. 是否遇到阻断问题（若有，说明原因）
```

## 安装完整性检查

若当前运行时缺少以下任一 skill，应直接报"工作流未安装完整"：
- r2p-scope-router
- r2p-requirement-analysis
- r2p-solution-outline
- r2p-solution-detail
- r2p-quality-gate
- r2p-task-breakdown
- r2p-task-gate

## 边界
- 本工作流止于"详细技术方案 + 质量门禁 + 任务拆解 + 任务拆解门禁"
- 不进入代码实现、PR 生成
- task-breakdown.json 为下游 plan-to-code-workflow 的输入接口

## 输入前提
- 需求来源：用户提供（文件路径/内联描述/URL）
- 代码仓库目录：默认 `<project-root>/projects/`
- 知识库目录：默认 `<project-root>/knowledge-base/`

## 本地模板
- `references/run-state-template.json`：run-state 结构约束
- `references/user-interaction-protocol.md`：用户交互协议

## run-state 约束
- 每次阶段切换时更新：status、currentStage、updatedAt、stages[].status、stages[].attempt
- 暂停时：status 置为 paused，记录 pauseContext
- 停止时：status 置为 stopped
- 完成时：status 置为 completed，记录 completedAt

## workflow.log 约束
- 一行一事件的文本日志
- 至少记录：启动、需求来源、安装检查、目录初始化、每阶段开始/完成/暂停/恢复、gate 轮次与结论、最终状态

## 停止条件
- 需求关键歧义或冲突
- 结构性改造 / 历史链路重构
- 高风险数据模型 / 协议 / 兼容性变化
- 证据不足，只能依赖强推断继续
- 多个候选方案存在明显 tradeoff，需要人工选边
- 质量门禁 3 轮未通过
- 发现任何非 run 目录写操作已经发生
