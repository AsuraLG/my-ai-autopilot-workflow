---
name: r2p-scope-router
description: 需求分诊子阶段；产出结构化 scope-pack.json，由 subagent 执行
argument-hint: "<需求文档路径或需求描述>"
---

# r2p-scope-router

## 作用
- 判断业务域（主/次）
- 判断业务链路（主/次）
- 判断需求类型
- 识别功能点
- 识别候选服务与候选模块
- 给出待读文档、待查资产、风险信号与停止确认信号

## 执行模式
- 本 skill 由 subagent 执行，属于 `docs_only_substage`。
- 只允许产出结构化范围包，不进入代码实现、不修改业务代码。

## 唯一允许写入路径
- `<project-root>/<run-id>/intermediate/scope-pack.json`

## 硬性禁止
- 禁止修改代码仓库目录下的任何文件
- 禁止修改知识库目录下的任何文件
- 禁止修改其他 skill、模板、脚本、测试、配置、构建文件
- 禁止执行构建、测试、发布、提单、提交、PR、部署相关操作
- 禁止在允许写入路径之外执行任何写操作

## 输入要求
- 必须读取：`<run-dir>/input/requirement.md`
- 必须读取：`references/scope-pack-template.json`
- 允许只读查看知识库目录和代码仓库目录下的文件，仅用于范围识别

## 知识库使用
- 根据主编排提供的知识库导航信息，按需读取知识库中的相关文档
- 优先读取业务架构、系统架构、术语相关的文档

## 输出
- `intermediate/scope-pack.json`

## 输出要求
- 必须遵循 `references/scope-pack-template.json` 的字段结构
- 必须是沉淀后的结构化结果，不写检索过程、判断过程
- `businessDomain` 必须区分主业务域与次业务域
- `businessChains` 必须区分主业务链路与次业务链路
- `functionalPoints` 必须使用对象数组
- `candidateServices` 与 `candidateModules` 必须使用对象数组
- `riskSignals` 必须至少给出风险描述与风险级别
- `scopeConclusion` 必须明确说明是否可继续进入需求分析阶段

## 停止条件
- 需求关键歧义或冲突，无法完成业务域或链路识别
- 结构性改造、历史链路重构或高风险协议变化超出分诊边界
- 缺少必要输入，无法生成可信的范围包

## 重试指导
- 若收到用户反馈（通过运行时上下文注入），必须优先针对反馈内容调整产出
- 非反馈涉及的部分，若上次产出无问题则保持稳定，不做无谓改动

## 完成前自检
- `intermediate/scope-pack.json` 已生成
- 输出符合模板结构
- 输出未混入过程性信息
- 允许写入路径之外无新增、修改、删除
