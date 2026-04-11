# requirement-to-plan-workflow

## 1. 工作流定位

这是一套面向 **需求分析、技术方案设计与质量门禁** 的正式工作流包。

完整流程包含 5 个阶段，由当前工作流包内的 5 个子 skill 承担：
1. 范围分诊
2. 需求分析
3. 概要技术方案
4. 详细技术方案
5. 质量门禁

**不包含**：
- 实现任务拆解
- 业务代码实现
- PR 生成

这些内容应由后续独立工作流承接。

## 2. 产物说明

### 2.1 正式产物
一次完整运行应至少产出以下正式产物：
- `outputs/requirement-analysis.md`
- `outputs/solution-outline.md`
- `outputs/solution-detail.md`
- `outputs/quality-gate-report.md`

### 2.2 运行时产物
工作流运行过程中还会产出以下运行时产物：
- `intermediate/scope-pack.json`
- `intermediate/review-basis/requirement-analysis-review-basis.md`
- `intermediate/review-basis/solution-outline-review-basis.md`
- `intermediate/review-basis/solution-detail-review-basis.md`
- `state/run-state.json`
- `logs/workflow.log`

条件性产物：
- `state/rework-guidance/iteration-<n>.md`
  - 仅当质量门禁结论为 `退回修改` 时生成

## 3. 目录结构

```text
requirement-to-plan-workflow/
  ├── README.md
  ├── docs/
  │   ├── workflow-overview.md
  │   └── quality-gate-rules.md
  └── skills/
      ├── requirement-to-plan-workflow-starter/
      │   ├── SKILL.md
      │   └── references/
      │       └── run-state-template.json
      ├── requirement-to-plan-workflow-scope-router/
      │   ├── SKILL.md
      │   └── references/
      │       └── scope-pack-template.json
      ├── requirement-to-plan-workflow-requirement-analysis/
      │   ├── SKILL.md
      │   └── references/
      │       ├── requirement-analysis-template.md
      │       └── requirement-analysis-review-basis-template.md
      ├── requirement-to-plan-workflow-solution-outline/
      │   ├── SKILL.md
      │   └── references/
      │       ├── solution-outline-template.md
      │       └── solution-outline-review-basis-template.md
      ├── requirement-to-plan-workflow-solution-detail/
      │   ├── SKILL.md
      │   └── references/
      │       ├── solution-detail-template.md
      │       └── solution-detail-review-basis-template.md
      └── requirement-to-plan-workflow-quality-gate/
          ├── SKILL.md
	          └── references/
	              ├── quality-gate-report-template.md
	              └── quality-gate-rework-guide-template.md
```

其中：
- `requirement-to-plan-workflow/docs/`：分发包内的**非运行时说明文档**，主要给人阅读，用于帮助理解工作流概览和门禁规则
- `requirement-to-plan-workflow/skills/`：运行时真正需要安装到目标项目里的 skill 与模板

## 4. 推荐的项目根目录形态

建议给 agent 使用的项目根目录形态如下：

### 4.1 使用 Codex CLI 时

```text
<project-root>/
  ├── docs/
  ├── projects/
  └── .codex/
      └── skills/
          ├── requirement-to-plan-workflow-starter/
          ├── requirement-to-plan-workflow-scope-router/
          ├── requirement-to-plan-workflow-requirement-analysis/
          ├── requirement-to-plan-workflow-solution-outline/
          ├── requirement-to-plan-workflow-solution-detail/
          └── equirement-to-plan-workflow-quality-gate/
```

### 4.2 使用 Claude Code 时

```text
<project-root>/
  ├── docs/
  ├── projects/
  └── .claude/
      └── skills/
          ├── requirement-to-plan-workflow-starter/
          ├── requirement-to-plan-workflow-scope-router/
          ├── requirement-to-plan-workflow-requirement-analysis/
          ├── requirement-to-plan-workflow-solution-outline/
          ├── requirement-to-plan-workflow-solution-detail/
          └── requirement-to-plan-workflow-quality-gate/
```

其中：
- `docs/`：放全局业务与系统文档
- `projects/`：放各个服务仓库
- `.codex/skills/` 或 `.claude/skills/`：放当前工作流所需的 skills

> 说明：当前仓库下的 `requirement-to-plan-workflow/` 是**工作流分发包**。
> 真正给 agent 使用的目标项目根目录里，不需要保留 `requirement-to-plan-workflow/` 目录；只需要把其中的 skills 安装到 `.codex/skills/` 或 `.claude/skills/` 。
> `requirement-to-plan-workflow/docs/` 下的两个文件是分发包内的非运行时文档，实际使用时不需要复制到目标项目目录。

服务自己的 `AI-GUIDE.md` 应随服务仓库一起维护，不需要复制到当前工作流包目录。

## 5. 文档固定目录与命名规范

### 5.1 全局文档固定目录
全局文档必须放在项目根目录下的 `docs/` 目录中。

workflow 对 `docs/` 的依赖是**内容依赖**，不是**格式依赖**。

这意味着：
- workflow 不要求 `docs/` 下必须存在某几份固定文件
- workflow 不要求 `docs/` 下文档遵循固定章节结构
- workflow 只关心这些文档能否提供可信、可消费的业务 / 系统 / 链路 / 边界信息

### 5.1.1 `docs/document-network.md` 的定位
若 `docs/document-network.md` 存在，应把它视为**优先导航入口**。

它的职责是：
- 记录 `docs/` 下其他全局文档之间的大致关系
- 指导 agent 如何选择阅读路径
- 帮助 agent 判断：遇到某类需求时，下一步应先看哪些文档

但 workflow 只依赖它的**导航能力**，不依赖它的**特定格式**。

换句话说：
- 它可以是关系图
- 可以是阅读路径说明
- 可以是分层索引
- 也可以是较自由的文字说明

只要能够帮助 agent 理解“其他全局文档怎么搭配读”，就满足要求。

### 5.1.2 其他全局文档的定位
`docs/` 下全部文档共同构成一份**自解释的全局文档体系**。

workflow 对这些文档的要求是内容覆盖，而不是固定格式。它们整体上应能覆盖：
- 业务架构信息
- 系统架构信息
- 业务域 / 业务链路信息
- 术语与名词解释
- 服务间关联与调用链
- 风险、红线与执行约束
- 复杂边界专题

这些内容可以分散在不同文档中，不要求必须按固定目录名、固定章节名或固定模板组织。

### 5.1.3 推荐的读取策略
更合理的读取策略是：

1. 若存在 `docs/document-network.md`，优先读取，用于理解 `docs/` 下其他全局文档之间的关系
2. 再根据 `document-network.md` 的指引选择相关全局文档
3. 若 `document-network.md` 缺失，或不足以指导阅读，则直接扫描 `docs/` 下其他全局文档

### 5.1.4 与 workflow 的边界
需要明确区分两类东西：

- workflow 自己产出的文件
  - 必须有严格格式与模板约束
  - 例如 `scope-pack.json`、`run-state.json`、`quality-gate-report.md`、`review-basis/*.md`
- workflow 读取的外部文档
  - 只做内容依赖，不做格式依赖
  - 例如 `docs/**`、`projects/**/AI-GUIDE.md`

建议补齐：
- 业务架构文档
- 系统架构文档
- 业务域 / 业务链路文档
- glossary / 名词解释文档
- 服务间关联与调用链文档
- 风险与红线文档
- 复杂边界专题文档

### 5.2 服务文档固定目录
服务必须放在项目根目录下的 `projects/` 目录中，例如：

```text
projects/<service>/
```

### 5.3 服务文档固定命名
服务级和模块级 AI 文档统一命名为：

```text
AI-GUIDE.md
```

推荐形态：

```text
projects/<service>/AI-GUIDE.md
projects/<service>/<module>/AI-GUIDE.md
```

### 5.4 服务级 AI 文档应包含的内容
服务根目录下的 `AI-GUIDE.md` 建议至少包含：
- 服务职责
- 不负责什么
- 在系统中的位置
- 模块结构概览
- 文档导航
- 渐进阅读路径
- 关键入口概览
- 关键资产概览
- 常见改动面概览
- 服务级验证方式
- 风险与红线
- 相关中央文档

### 5.5 模块级 AI 文档应包含的内容
模块目录下的 `AI-GUIDE.md` 建议至少包含：
- 模块职责
- 不负责什么
- 在服务中的位置
- 代码结构
- 关键类 / 关键入口
- 关键流程
- 关键资产
- 常见改动点
- 模块级验证方式
- 风险与坑点
- 相关文档

### 5.6 文风要求
无论是全局文档还是服务文档，正式文档都应：
- 使用中文标题
- 结构化表达
- 书面化、简练
- 展示稳定结论和阅读指导

正式文档不应直接展示：
- Evidence / Inference / Stop-and-confirm 这类编写过程标签
- 工作流元信息
- 口语化推理痕迹

供质量门禁使用的 `review-basis` 文档不属于正式产物，可保留审查所需的事实依据、假设、边界说明与未决问题。

## 6. 按运行时安装

### 6.1 Codex CLI
从本工作流包复制：
- `skills/<name>/...` -> `<project-root>/.codex/skills/<name>/...`

不需要复制：
- `docs/workflow-overview.md`
- `docs/quality-gate-rules.md`

然后使用 Codex CLI 打开项目根目录。

### 6.2 Claude Code
从本工作流包复制：
- `skills/<name>/...` -> `<project-root>/.claude/skills/<name>/...`

不需要复制：
- `docs/workflow-overview.md`
- `docs/quality-gate-rules.md`

然后使用 Claude Code 打开项目根目录。

## 7. templates 如何使用

当前工作流不在顶层维护统一 `templates/` 目录。
所有模板都被下沉到**各自使用它的 skill 目录下的 `references/`**，由对应 skill 就地引用。

对应关系如下：

| Skill | 本地模板路径 | 对应产物 |
|---|---|---|
| `requirement-to-plan-workflow-starter` | `references/run-state-template.json` | `state/run-state.json` |
| `requirement-to-plan-workflow-scope-router` | `references/scope-pack-template.json` | `intermediate/scope-pack.json` |
| `requirement-to-plan-workflow-requirement-analysis` | `references/requirement-analysis-template.md` | `outputs/requirement-analysis.md` |
| `requirement-to-plan-workflow-requirement-analysis` | `references/requirement-analysis-review-basis-template.md` | `intermediate/review-basis/requirement-analysis-review-basis.md` |
| `requirement-to-plan-workflow-solution-outline` | `references/solution-outline-template.md` | `outputs/solution-outline.md` |
| `requirement-to-plan-workflow-solution-outline` | `references/solution-outline-review-basis-template.md` | `intermediate/review-basis/solution-outline-review-basis.md` |
| `requirement-to-plan-workflow-solution-detail` | `references/solution-detail-template.md` | `outputs/solution-detail.md` |
| `requirement-to-plan-workflow-solution-detail` | `references/solution-detail-review-basis-template.md` | `intermediate/review-basis/solution-detail-review-basis.md` |
| `requirement-to-plan-workflow-quality-gate` | `references/quality-gate-report-template.md` | `outputs/quality-gate-report.md` |
| `requirement-to-plan-workflow-quality-gate` | `references/quality-gate-rework-guide-template.md` | `state/rework-guidance/iteration-<n>.md` |

使用原则：
1. 每个 skill 生成产物前，先读取自己目录下 `references/` 中的模板。
2. 模板用于约束结构与字段，不是给用户手工填写。
3. 质量门禁检查应同时参考正式产物和对应的 `review-basis`。
4. 若模板变化，应同步更新对应 skill 的说明与质量门禁规则。

## 8. 运行方式

推荐从顶层入口 skill 启动：

```text
$requirement-to-plan-workflow-starter <需求文档路径或需求描述>
```

### 8.1 顶层 skill 与内部阶段的关系
- 顶层 skill `requirement-to-plan-workflow-starter` 直接承担协调逻辑。
- 它内部顺序协调 5 个阶段，是当前工作流包内置子 skill：
  1. `requirement-to-plan-workflow-scope-router`
  2. `requirement-to-plan-workflow-requirement-analysis`
  3. `requirement-to-plan-workflow-solution-outline`
  4. `requirement-to-plan-workflow-solution-detail`
  5. `requirement-to-plan-workflow-quality-gate`

### 8.2 工作流安装完整性的判断
如果当前运行时缺少以下任一 skill，则顶层 skill 应直接报“工作流未安装完整”：
- `requirement-to-plan-workflow-scope-router`
- `requirement-to-plan-workflow-requirement-analysis`
- `requirement-to-plan-workflow-solution-outline`
- `requirement-to-plan-workflow-solution-detail`
- `requirement-to-plan-workflow-quality-gate`

### 8.3 审查依据机制
为了避免 gate 重新做一遍分析或仅依据正式文档做猜测：
- `requirement-analysis`
- `solution-outline`
- `solution-detail`

这 3 个子 skill 在生成正式文档时，必须同步生成一份 `review-basis` 文档，供质量门禁使用。

### 8.4 质量门禁退回后的循环规则
- gate 若给出 `退回修改`，必须同时生成一份 `state/rework-guidance/iteration-<n>.md`。
- 指导文档必须明确：
  - 从哪个 skill 重新开始
  - 先修改哪份文档
  - 必改问题是什么
- 顶层 skill 读取该指导文档后，从指定 skill 重新执行后续阶段。
- 质量门禁最多执行 3 轮；若第 3 轮后仍未通过，则停止并告知用户。

## 9. 何时停止

若命中以下任一条件，工作流应停止并要求人工确认：
- 需求关键歧义或冲突
- 结构性改造 / 历史链路重构
- 高风险数据模型 / 协议 / 兼容性变化
- 证据不足，只能依赖强推断继续
- 多个候选方案存在明显 tradeoff，需要人工选边
- 质量门禁在 3 轮后仍未通过

## 10. 当前状态

当前工作流包已经包含：
- 顶层 skill 草案
- 5 个内部 skill 草案
- 正式产物模板
- `scope-pack` 与 `run-state` 模板
- 质量门禁退回修改指导模板

建议先在少量真实需求和少量服务上试运行，再逐步扩展。
