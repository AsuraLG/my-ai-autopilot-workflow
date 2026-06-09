---
name: r2p-solution-outline
description: 基于需求分析产出概要技术方案与审查依据，由 subagent 执行
argument-hint: "<需求文档路径或需求描述>"
---

# r2p-solution-outline

## 作用
产出：
- 正式《概要技术方案》
- 供 gate 使用的《概要技术方案审查依据》

## 执行模式
- 本 skill 由 subagent 执行，属于 `docs_only_substage`。
- 只允许产出概要技术方案及审查依据，不进入代码实现、不修改业务代码。

## 唯一允许写入路径
- `<project-root>/<run-id>/outputs/solution-outline.md`
- `<project-root>/<run-id>/intermediate/review-basis/solution-outline-review-basis.md`

## 硬性禁止
- 禁止修改代码仓库目录下的任何文件
- 禁止修改知识库目录下的任何文件
- 禁止修改其他 skill、模板、脚本、测试、配置、构建文件
- 禁止执行构建、测试、发布、提单、提交、PR、部署相关操作
- 禁止在允许写入路径之外执行任何写操作

## 输入要求
- 必须读取：`<run-dir>/input/requirement.md`
- 必须读取：`<run-dir>/intermediate/scope-pack.json`
- 必须读取：`<run-dir>/outputs/requirement-analysis.md`
- 必须读取：`<run-dir>/intermediate/review-basis/requirement-analysis-review-basis.md`
- 必须读取：`references/solution-outline-template.md`
- 必须读取：`references/solution-outline-review-basis-template.md`
- 允许只读查看知识库和代码仓库目录

## 写作规则
- 正式产物不暴露检索过程、证据标签、源码定位
- `4.1 当前业务架构理解` 与 `4.2 本次业务架构改动说明` 必须使用文本简述
- `5.1 当前系统架构理解` 与 `5.2 本次系统架构改动说明` 必须使用文本简述
- 候选方案分析必须围绕同一问题或决策点展开比较
- 若有多个独立问题，必须按问题分组展开候选方案
- 推荐方案必须与候选方案的分组方式一致

## 审查依据规则
- 必须至少说明：方案目标与边界判断依据、业务架构/系统架构理解依据、候选方案与推荐方案取舍依据、关键 tradeoff、仍待确认问题
- 不允许退化为完整检索日志或无筛选的源码摘抄

## 停止条件
- 缺少需求分析文档或范围包
- 存在明显 tradeoff 需要人工选边

## 重试指导
- 若收到用户反馈（通过运行时上下文注入），必须优先针对反馈内容调整产出
- 非反馈涉及的部分，若上次产出无问题则保持稳定，不做无谓改动
- 审查依据中必须说明：本次针对哪些反馈做了调整、做了哪些改变

## 完成前自检
- 两份文档均已生成
- 满足文本段落、候选方案分组与模板结构要求
- 正式文档未混入过程性信息
- 允许写入路径之外无新增、修改、删除