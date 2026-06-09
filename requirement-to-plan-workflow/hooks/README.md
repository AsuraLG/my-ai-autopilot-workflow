# Hook 安装说明

## write-guard.sh

写入路径合规性校验 hook。在工作流运行期间，拦截所有 Write/Edit 操作，确保只写入当前 工作流的run 目录 以及 claude公共的一些目录。

### 安装方式

1. 将 `write-guard.sh` 复制到目标项目的 `.claude/hooks/` 目录：

   ```bash
   cp hooks/write-guard.sh <project-root>/.claude/hooks/write-guard.sh
   chmod +x <project-root>/.claude/hooks/write-guard.sh
   ```

2. 在 `.claude/settings.json` 中添加 hook 配置：

   ```json
   {
     "hooks": {
       "PreToolUse": [
         {
           "matcher": "Edit|Write",
           "hooks": [
             {
               "type": "command",
               "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/write-guard.sh"
             }
           ]
         }
       ]
     }
   }
   ```

### 依赖

- `jq`：用于解析 stdin 中的 JSON 输入

### 行为说明

- Hook 事件：`PreToolUse`（工具执行前触发，可阻止执行）
- stdin 输入格式：`{"tool_name": "Write", "tool_input": {"file_path": "..."}, ...}`
- 违规写入时输出错误信息到 stderr 并返回 exit code 2（Claude Code 约定的阻止退出码）
- exit 0 = 放行，exit 2 = 阻止工具执行
