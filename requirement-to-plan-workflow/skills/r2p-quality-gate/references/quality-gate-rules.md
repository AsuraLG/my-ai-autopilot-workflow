# 质量门禁规则

## 1. 门禁目标
保证正式产物：
- 结构完整
- 前后一致
- 不伪装确定性
- 能指导后续实现规划

同时保证 gate 结论：
- 尽量基于上游阶段提供的 `review-basis`
- 不重复做一轮完整分析
- 不仅凭正式文档的简写结果做猜测

## 2. 门禁输入
质量门禁应至少读取：
- `outputs/requirement-analysis.md`
- `outputs/solution-outline.md`
- `outputs/solution-detail.md`
- `intermediate/review-basis/requirement-analysis-review-basis.md`
- `intermediate/review-basis/solution-outline-review-basis.md`
- `intermediate/review-basis/solution-detail-review-basis.md`

## 3. 门禁结论
- 通过
- 退回修改
- 停止并确认

## 4. 检查维度
- 文档完整性
- 结构一致性
- 图表与设计物完整性
- 可落地性
- 风险与待确认问题是否暴露充分
- 正式文档与 `review-basis` 是否相互支撑

## 5. 正式文档要求
正式文档应展示：
- 稳定结论
- 风险
- 边界说明
- 待确认问题
- 需人工确认事项

正式文档不应直接展示：
- Evidence / Inference 这类编写过程标签
- 过程化推理痕迹
- 工作流元信息

## 6. 审查依据要求
`review-basis` 文档用于辅助质量门禁，可包含：
- 关键事实依据
- 主要判断与取舍
- 未写入正式文档的审查说明
- 待确认问题与边界说明

`review-basis` 文档不应退化为：
- 大段源码摘抄
- 无筛选的检索日志
- 与正式文档无对应关系的事实堆砌

## 7. 退回修改规则
- 若结论为 `退回修改`，质量门禁必须同步产出一份修改指导文档。
- 修改指导文档必须明确：
  - 从哪个 skill 重新开始（r2p-requirement-analysis / r2p-solution-outline / r2p-solution-detail）
  - 先修改哪份文档
  - 必改问题与建议优化项
- 顶层 workflow 根据该文档重跑后续阶段。
- 质量门禁最多执行 3 轮；若达到上限仍未通过，则工作流停止并要求人工确认。
