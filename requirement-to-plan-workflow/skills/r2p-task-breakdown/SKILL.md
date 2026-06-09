---
name: r2p-task-breakdown
description: 基于详细技术方案产出面向 AI 编码的结构化实现任务清单，由 subagent 执行
argument-hint: "<需求文档路径或需求描述>"
---

# r2p-task-breakdown

## 作用
产出：
- 结构化实现任务清单（`outputs/task-breakdown.json`）— 面向下游 plan-to-code-workflow 消费
- 可读版任务清单（`outputs/task-breakdown.md`）— 供人审查
- 审查依据（`intermediate/review-basis/task-breakdown-review-basis.md`）

## 执行模式
- 本 skill 由 subagent 执行，属于 `docs_only_substage`。
- 只允许产出任务清单及审查依据，不进入代码实现。

## 唯一允许写入路径
- `<project-root>/<run-id>/outputs/task-breakdown.json`
- `<project-root>/<run-id>/outputs/task-breakdown.md`
- `<project-root>/<run-id>/intermediate/review-basis/task-breakdown-review-basis.md`

## 硬性禁止
- 禁止修改代码仓库目录下的任何文件
- 禁止修改知识库目录下的任何文件
- 禁止修改其他 skill、模板、脚本、测试、配置、构建文件
- 禁止执行构建、测试、发布、提单、提交、PR、部署相关操作
- 禁止在允许写入路径之外执行任何写操作

## 输入要求
- 必须读取：`<run-dir>/state/run-state.json`
- 必须读取：`<run-dir>/outputs/solution-detail.md`
- 必须读取：`<run-dir>/outputs/requirement-analysis.md`
- 必须读取：`<run-dir>/intermediate/scope-pack.json`
- 必须读取：`references/task-breakdown-template.json`
- 必须读取：`references/task-breakdown-md-template.md`
- 必须读取：`references/task-breakdown-review-basis-template.md`
- 必须只读查看代码仓库目录（验证文件路径、理解包结构）

## 任务拆解原则
- 每个任务对应一个原子改动，可独立提交
- 任务之间的依赖关系必须明确，禁止循环依赖
- 按实施阶段分组：DDL → 数据层 → 业务层 → 接口层 → 测试
- location 中的文件路径必须基于代码仓库的实际结构
- 对于 modify 类型的 changeType，目标文件必须在代码仓库中实际存在
- 新建文件的路径必须符合项目的包结构约定
- changeType 必须从枚举值中选择：new_class | modify_method | new_config | ddl_change | new_interface | modify_interface | new_mq_consumer | new_mq_producer | test
- 必须确保详细方案中的所有改动点都被覆盖到任务中

## 产物格式约束
- `task-breakdown.json` 必须严格遵循 `references/task-breakdown-template.json` 结构
- `task-breakdown.md` 按 executionPhases 分组展示，每个任务含：ID、标题、changeType、location、描述、验收条件、依赖
- 审查依据必须说明：拆解策略、阶段划分依据、粒度选择依据、覆盖性自检结果

## 停止条件
- 详细方案缺失或质量门禁未通过
- 代码仓库路径无法访问
- 详细方案中存在歧义，无法确定改动范围

## 重试指导
- 若收到用户反馈（通过运行时上下文注入），必须优先针对反馈内容调整产出
- 非反馈涉及的部分，若上次产出无问题则保持稳定，不做无谓改动
- 审查依据中必须说明：本次针对哪些反馈做了调整、做了哪些改变

## 完成前自检
- 三份文档均已生成
- JSON 格式合法（可被 JSON parser 正确解析）
- 所有 modify 类型任务的 location.filePath 在代码仓库中存在
- 任务依赖关系无环
- 详细方案中的所有改动点均有对应任务覆盖
- 允许写入路径之外无新增、修改、删除
