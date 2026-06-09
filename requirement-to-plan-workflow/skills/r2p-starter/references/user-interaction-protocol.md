# 用户交互协议

## 1. 交互工具优先级

所有用户交互优先使用 AskUserQuestion 工具（结构化选项）。
若 AskUserQuestion 不可用，降级为普通文本询问。

## 2. 启动阶段交互

### 2.1 检测未完成 run

扫描 `<project-root>/` 下 `run-*/state/run-state.json`，若存在 status 非 completed 的记录：

AskUserQuestion 选项：
- 继续上次运行（从中断点恢复）
- 放弃上次运行，开始新的运行

### 2.2 确认输入

依次确认三个输入：
1. 需求来源：用户必须提供
2. 代码仓库目录：检查 `<project-root>/projects/` 是否存在，不存在则 AskUserQuestion 要求用户输入路径
3. 知识库目录：检查 `<project-root>/knowledge-base/` 是否存在，不存在则 AskUserQuestion 要求用户输入路径

### 2.3 了解知识库

扫描知识库根目录下 README 类文件（README.md、readme.md、README.txt、README、readme.rst、README.rst）。

若找到：读取获取导航信息。
若未找到：AskUserQuestion 询问用户：
- 选项 A：指定一个入口文件路径供 AI 读取
- 选项 B：由 AI 自行探索知识库结构

## 3. 阶段审查交互

每个阶段 subagent 完成后，主编排执行：

### 3.1 正常完成

AskUserQuestion 展示阶段名称、产出文件路径、产出摘要（2-3 句），选项：
- 确认通过，继续下一阶段
- 需要重新执行本阶段
- 暂停工作流（稍后恢复）

### 3.2 用户选择重新执行

AskUserQuestion 追问：请说明重新执行的原因和你的诉求。

然后：
1. 记录反馈到 run-state.json 对应 stage 的 userReview.feedback
2. 将 stage status 置为 rejected
3. 重新派发 subagent，prompt 中注入用户反馈
4. 再次产出后重新进入审查流程

### 3.3 遇到阻断问题

subagent 返回阻断信息后，主编排向用户说明问题并暂停，等待用户指示。

## 4. 任务门禁后交互

task-gate 结论=通过时：
- 更新 `state/run-state.json` 为 completed
- 汇报最终产物路径与任务拆解门禁结论

## 5. 暂停恢复交互

当工作流从暂停状态恢复时，读取 run-state.json 中的 pauseContext，根据 reason 决定恢复逻辑：
- user_paused / session_interrupted：从 stageToResume 继续
