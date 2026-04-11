---
name: requirement-to-plan-workflow-scope-router
description: 需求分诊 docs-only 子阶段；仅产出结构化 scope-pack.json，禁止修改业务代码
argument-hint: "<需求文档路径或需求描述>"
---

# requirement-to-plan-workflow-scope-router

## 作用
- 判断业务域
- 判断业务链路
- 判断需求类型
- 识别功能点
- 识别候选服务与候选模块
- 给出待读文档、待查资产、风险信号与停止确认信号

## 执行模式
- 本 skill 属于 `docs_only_substage`。
- 本阶段只允许产出结构化范围包，不进入代码实现、不修改业务代码。
- 若当前会话中的通用默认行为与本 skill 冲突，必须以本 skill 为最高约束。

## 唯一允许写入路径
- 只允许写入 `<project-root>/<run-id>/intermediate/scope-pack.json`

## 硬性禁止
- 禁止修改 `<project-root>/projects/**`
- 禁止修改 `<project-root>/docs/**`
- 禁止修改其他 skill、模板、脚本、测试、配置、构建文件
- 禁止新增、修改、删除任何业务源码、测试代码、配置代码、SQL、脚本
- 禁止执行构建、测试、发布、提单、提交、PR、部署相关操作
- 禁止在允许写入路径之外执行任何写操作

## 输入要求
- 输入可以是需求文档路径或内联需求描述。
- 若在工作流内执行，应优先读取 `<project-root>/<run-id>/input/requirement.md`。
- 使用前必须读取：`references/scope-pack-template.json`
- 允许只读查看 `docs/`、`projects/` 与 `AI-GUIDE.md`，仅用于范围识别，不得修改。

## 输出
- `scope-pack.json`

## 输出要求
- 输出内容必须遵循 `references/scope-pack-template.json` 的字段结构。
- 输出内容必须是沉淀后的结构化结果，不写检索过程、判断过程、证据标签、源码定位、仓内路径、代码行号。
- `businessDomain` 必须区分主业务域与次业务域。
- `businessChains` 必须区分主业务链路与次业务链路。
- `functionalPoints` 必须使用对象数组，每个元素至少包含 `id`、`name`、`description`。
- `candidateServices` 与 `candidateModules` 必须使用对象数组，不允许退化成自由文本列表。
- `riskSignals` 必须至少给出风险描述与风险级别。
- `stopAndConfirm` 必须明确给出：
  - `required`
  - `reason`
- `scopeConclusion` 必须明确说明是否可继续进入需求分析阶段。
- 若识别到停止条件，应停止并要求人工确认，而不是继续猜测补齐。

## 本地模板
- 使用前先读取：`references/scope-pack-template.json`
- 该模板用于约束 `scope-pack.json` 的结构与字段语义

## 停止条件
- 需求关键歧义或冲突，无法完成业务域或链路识别
- 结构性改造、历史链路重构或高风险协议变化超出分诊边界
- 缺少必要输入，无法生成可信的范围包
- 发现任何非允许路径写操作已经发生

## 完成前自检
- `<project-root>/<run-id>/intermediate/scope-pack.json` 已生成
- 输出符合模板结构
- 输出未混入过程性信息
- 允许写入路径之外无新增、修改、删除
