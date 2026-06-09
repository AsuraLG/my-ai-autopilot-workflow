---
name: r2p-solution-detail
description: 基于概要技术方案产出详细技术方案与审查依据，由 subagent 执行
argument-hint: "<需求文档路径或需求描述>"
---

# r2p-solution-detail

## 作用
产出：
- 正式《详细技术方案》
- 供 gate 使用的《详细技术方案审查依据》

## 执行模式
- 本 skill 由 subagent 执行，属于 `docs_only_substage`。
- 只允许产出详细技术方案及审查依据，不进入代码实现、不修改业务代码。

## 唯一允许写入路径
- `<project-root>/<run-id>/outputs/solution-detail.md`
- `<project-root>/<run-id>/intermediate/review-basis/solution-detail-review-basis.md`

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
- 必须读取：`<run-dir>/outputs/solution-outline.md`
- 必须读取：`<run-dir>/intermediate/review-basis/solution-outline-review-basis.md`
- 必须读取：`references/solution-detail-template.md`
- 必须读取：`references/solution-detail-review-basis-template.md`
- 允许只读查看知识库和代码仓库目录

## 写作规则
- 正式产物不暴露检索过程、证据标签、源码定位
- `2.1 涉及服务总览` 使用表格：`服务` | `角色` | `是否主改动面` | `说明`
- `2.2 涉及模块总览` 使用表格：`模块` | `角色` | `说明`
- `2.3 涉及资产总览` 使用表格：`资产类型` | `名称` | `所属模块` | `改动性质` | `说明`
- 详细方案中的现状、改动点、调用链、测试与上线内容只写设计结果，不写推导过程
- `6.1 对外提供 RPC 接口` 使用结构化格式：每接口含服务名、方法名、入参结构（字段名/类型/必填/说明）、出参结构、异常码、幂等性说明
- `6.2 对外提供 HTTP 接口` 使用结构化格式：每接口含 path、method、request body、response body、状态码
- `6.3 外部依赖接口` 使用结构化格式：每依赖含服务名、方法名、关键入参、预期返回、超时重试策略
- `6.5 MQ 消息设计` 使用结构化格式：每消息含 topic、消息格式、生产/消费方、触发条件、幂等策略
- `5.3 库表设计` 若涉及库表变更，必须包含完整 DDL 语句
- `5.4 SQL 设计` 若涉及数据迁移，必须包含可执行的 DML 语句
- `5.5 索引设计` 若涉及索引变更，必须说明索引策略和预期影响

## 审查依据规则
- 必须至少说明：服务/模块/资产纳入依据、关键调用链与时序设计依据、数据模型/接口/存储设计依据、测试设计/灰度/上线建议依据、仍待确认问题
- 不允许退化为完整检索日志或无筛选的源码摘抄

## 停止条件
- 缺少概要方案或需求分析文档
- 详细方案需要依赖未确认的关键决策

## 重试指导
- 若收到用户反馈（通过运行时上下文注入），必须优先针对反馈内容调整产出
- 非反馈涉及的部分，若上次产出无问题则保持稳定，不做无谓改动
- 审查依据中必须说明：本次针对哪些反馈做了调整、做了哪些改变

## 完成前自检
- 两份文档均已生成
- 满足三类改动总览表格要求与模板结构
- 正式文档未混入过程性信息
- 允许写入路径之外无新增、修改、删除
