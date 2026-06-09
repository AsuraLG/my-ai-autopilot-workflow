---
name: r2p-requirement-analysis
description: 基于 scope-pack 产出需求分析文档与审查依据，由 subagent 执行
argument-hint: "<需求文档路径或需求描述>"
---

# r2p-requirement-analysis

## 作用
产出：
- 正式《需求分析文档》
- 供 gate 使用的《需求分析审查依据》

## 执行模式
- 本 skill 由 subagent 执行，属于 `docs_only_substage`。
- 只允许产出需求分析文档及审查依据，不进入代码实现、不修改业务代码。

## 唯一允许写入路径
- `<project-root>/<run-id>/outputs/requirement-analysis.md`
- `<project-root>/<run-id>/intermediate/review-basis/requirement-analysis-review-basis.md`

## 硬性禁止
- 禁止修改代码仓库目录下的任何文件
- 禁止修改知识库目录下的任何文件
- 禁止修改其他 skill、模板、脚本、测试、配置、构建文件
- 禁止执行构建、测试、发布、提单、提交、PR、部署相关操作
- 禁止在允许写入路径之外执行任何写操作

## 输入要求
- 必须读取：`<run-dir>/input/requirement.md`
- 必须读取：`<run-dir>/intermediate/scope-pack.json`
- 必须读取：`references/requirement-analysis-template.md`
- 必须读取：`references/requirement-analysis-review-basis-template.md`
- 允许只读查看知识库和代码仓库目录，用于补充分析结论

## 知识库使用
- 根据主编排提供的知识库导航信息和 scope-pack 中的 docsToRead，按需读取相关文档
- 重点关注业务域、术语、业务链路相关内容

## scope-pack 关键字段使用
- `openQuestions`：必须在正式文档的"待确认问题"章节中体现，不可遗漏
- `confirmedFacts`：作为分析的前提约束，正式文档中的结论不得与已确认事实矛盾
- `riskSignals`：必须在"系统影响初判"章节中体现对应的风险关注

## 写作规则
- `outputs/requirement-analysis.md` 是正式产物，不暴露检索过程、证据标签、源码定位
- `1.1 需求背景` 必须简练，聚焦"当前现状 + 当前缺口 + 本次需求触发点"
- `1.2 名词解释` 必须使用 Markdown 表格，列为 `名词` | `说明`
- `1.3 需求要点` 必须使用 Markdown 表格，列为 `需求点` | `描述`
- `4.1.3 风险关注模块` 必须使用 Markdown 表格，列为 `模块` | `说明`
- `4.2 受影响资产初判` 必须使用 Markdown 表格，列为 `资产类型` | `名称` | `说明`
- `2.1 需求摘要` 使用 1-3 句话概括，不超过 100 字
- `2.4 功能点识别` 必须使用 Markdown 表格，列为 `功能点` | `描述` | `优先级`
- `3.1 本次需求范围` 使用有序列表
- `3.2 非本次需求范围` 使用有序列表
- `4.1.1 可能改动的服务` 必须使用 Markdown 表格，列为 `服务` | `改动角色` | `说明`
- `4.1.2 需要补充理解的服务` 必须使用 Markdown 表格，列为 `服务` | `需要理解的内容`

## 审查依据规则
- 审查依据只供 gate 使用，不属于正式产物
- 必须与正式文档内容一一对应
- 至少说明：关键输入材料、主要事实依据、业务域/链路判断理由、范围纳入与排除理由、候选服务/模块判断理由、待确认问题与风险
- 不允许退化为完整检索日志或无筛选的源码摘抄

## 停止条件
- 缺少 scope-pack.json 或输入需求
- 识别到需求关键歧义、结构性改造或需人工选边的问题

## 重试指导
- 若收到用户反馈（通过运行时上下文注入），必须优先针对反馈内容调整产出
- 非反馈涉及的部分，若上次产出无问题则保持稳定，不做无谓改动
- 审查依据中必须说明：本次针对哪些反馈做了调整、做了哪些改变

## 完成前自检
- 两份文档均已生成
- 正式文档满足表格与结构模板要求
- 审查依据满足模板要求且与正式文档一致
- 正式文档未混入过程性信息
- 允许写入路径之外无新增、修改、删除
