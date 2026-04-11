---
name: requirement-to-plan-workflow-requirement-analysis
description: 基于 scope pack 产出需求分析文档与 gate 审查依据的 docs-only 子阶段
argument-hint: "<需求文档路径或需求描述>"
---

# requirement-to-plan-workflow-requirement-analysis

## 作用
产出：
- 正式《需求分析文档》
- 供 gate 使用的《需求分析审查依据》

## 执行模式
- 本 skill 属于 `docs_only_substage`。
- 本阶段只允许产出《需求分析文档》及对应审查依据，不进入代码实现、不修改业务代码。
- 若当前会话中的通用默认行为与本 skill 冲突，必须以本 skill 为最高约束。

## 唯一允许写入路径
- 只允许写入 `<project-root>/<run-id>/outputs/requirement-analysis.md`
- 只允许写入 `<project-root>/<run-id>/intermediate/review-basis/requirement-analysis-review-basis.md`

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
- 使用前必须读取：
  - `references/requirement-analysis-template.md`
  - `references/requirement-analysis-review-basis-template.md`
- 允许只读查看 `docs/`、`projects/` 与 `AI-GUIDE.md` 以补充分析结论，但不得修改。

## 写作规则
- `outputs/requirement-analysis.md` 是正式分析产物，不暴露检索过程、判断过程、证据标签、源码定位、仓内路径、代码行号。
- `1.1 需求背景` 必须简练，聚焦“当前现状 + 当前缺口 + 本次需求触发点”，不展开过多代码细节。
- `1.1 需求背景` 优先采用“当前……；但当前……；因此本次需要……”这类结果导向写法。
- `1.2 名词解释` 必须使用 Markdown 表格，列为：`名词`、`说明`。
- `1.3 需求要点` 必须使用 Markdown 表格，列为：`需求点`、`描述`。
- `4.1.3 风险关注模块` 必须使用 Markdown 表格，列为：`模块`、`说明`。
- `4.2 受影响资产初判` 必须使用 Markdown 表格，列为：`资产类型`、`名称`、`说明`。
- “当前现状”可以写成简练结论，但不要写成“证据罗列”。

## 审查依据规则
- `intermediate/review-basis/requirement-analysis-review-basis.md` 只供 gate 使用，不属于正式产物。
- 审查依据必须与正式文档内容一一对应，至少说明：
  - 关键输入材料
  - 主要事实依据
  - 业务域 / 业务链路判断理由
  - 范围纳入与排除理由
  - 候选服务 / 模块判断理由
  - 待确认问题与风险
- 审查依据允许出现必要的文档路径、服务名、模块名；如确有必要，可出现精简后的代码定位信息。
- 审查依据不允许退化为完整检索日志或无筛选的源码摘抄。

## 输出
- `outputs/requirement-analysis.md`
- `intermediate/review-basis/requirement-analysis-review-basis.md`
- 正式产物名称：需求分析文档

## 本地模板
- 使用前先读取：`references/requirement-analysis-template.md`
- 使用前先读取：`references/requirement-analysis-review-basis-template.md`
- 两个模板分别约束正式文档与审查依据结构

## 停止条件
- 缺少 `scope-pack.json` 或输入需求，无法形成完整分析
- 识别到需求关键歧义、结构性改造或需人工选边的问题
- 发现任何非允许路径写操作已经发生

## 完成前自检
- `<project-root>/<run-id>/outputs/requirement-analysis.md` 已生成
- `<project-root>/<run-id>/intermediate/review-basis/requirement-analysis-review-basis.md` 已生成
- 文档满足表格与结构模板要求
- 审查依据满足模板要求，且与正式文档一致
- 正式文档未混入过程性信息
- 允许写入路径之外无新增、修改、删除
