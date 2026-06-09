# requirement-to-plan-workflow

## 1. 工作流定位

面向 **需求分析、技术方案设计、质量门禁、实现任务拆解** 的工作流。

完整流程包含 7 个阶段：
1. 范围分诊
2. 需求分析
3. 概要技术方案
4. 详细技术方案
5. 质量门禁
6. 实现任务拆解
7. 任务拆解门禁

**不包含**：业务代码实现、PR 生成。

## 2. 平台
当前版本专注 Claude Code 平台，充分利用 subagent、hook、AskUserQuestion 等能力。

## 3. 安装

### 3.1 skill 安装
将 `skills/r2p-*/` 复制到目标项目的 `.claude/skills/` 下：

```bash
cp -r skills/r2p-* <project-root>/.claude/skills/
```

### 3.2 hook 安装
```bash
cp hooks/write-guard.sh <project-root>/.claude/hooks/write-guard.sh
chmod +x <project-root>/.claude/hooks/write-guard.sh
```

在 `.claude/settings.json` 中添加 hook 配置（参见 `hooks/README.md`）。

## 4. 使用

```
$r2p-starter <需求文档路径或需求描述>
```

工作流会依次：
1. 确认输入（代码仓库目录、知识库目录）
2. 了解知识库结构
3. 逐阶段执行，每阶段完成后请求用户审查
4. 质量门禁通过后进入任务拆解
5. 任务拆解门禁通过后完成工作流

## 5. 输入

| 输入 | 默认值 | 说明 |
|------|--------|------|
| 需求来源 | 无 | 必须提供 |
| 代码仓库目录 | `<project-root>/projects/` | 若不存在则询问 |
| 知识库目录 | `<project-root>/knowledge-base/` | 若不存在则询问 |

知识库目录下需有 README 类文件说明其结构和使用方式。

## 6. 产物

### 正式产物
- `outputs/requirement-analysis.md`
- `outputs/solution-outline.md`
- `outputs/solution-detail.md`
- `outputs/quality-gate-report.md`
- `outputs/task-breakdown.json`
- `outputs/task-breakdown.md`
- `outputs/task-gate-report.md`

### 运行时产物
- `state/run-state.json`
- `intermediate/scope-pack.json`
- `intermediate/review-basis/*.md`
- `logs/workflow.log`

## 7. 断点恢复

- 同一会话内：任何阶段可要求重新执行
- 跨会话：下次调用 r2p-starter 时自动检测未完成的 run，询问是否恢复

## 8. 推荐目录形态

```text
<project-root>/
├── projects/                      # 代码仓库
├── knowledge-base/                # 知识库
│   └── README.md                  # 知识库入口说明
├── run-<id>/                      # 运行产物（自动生成）
└── .claude/
    ├── skills/r2p-*/
    ├── hooks/write-guard.sh
    └── settings.json
```
