#!/bin/bash
# write-guard.sh
# 校验 Claude Code 的 Write/Edit 工具调用是否写入了允许的路径范围内。
# 作为 PreToolUse(Edit|Write) hook 运行，在工具执行前拦截越界写入。
#
# 自洽设计（不依赖任何需要外部设置的环境变量）：
#   - 项目根：取 Claude Code 注入 hook 进程的 CLAUDE_PROJECT_DIR；拿不到时放行（休眠，避免误伤）。
#   - 允许写入：
#       <项目根>/run-*/        —— 工作流产物（input/state/intermediate/outputs/logs）
#       $HOME/.claude/         —— Claude 的 memory / 全局配置等元写入
#       <项目根>/.claude/      —— 本项目的 settings / hooks 等配置（允许自我维护）
#   - 其余路径（如误写 <项目根>/projects/ 代码仓库、知识库目录）→ exit 2 拦截。
#
# stdin 接收 JSON：{"tool_name": "Write", "tool_input": {"file_path": "..."}, ...}
# 阻止方式：exit 2（Claude Code 约定的阻止退出码）

set -euo pipefail

# 读取 stdin（hook 接收到的 JSON 输入）
INPUT=$(cat)

# 提取 file_path 字段（jq 缺失或解析失败时不阻塞，放行）
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# 未提取到路径，放行（格式不匹配）
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# 项目根：取 Claude Code 注入 hook 环境的 CLAUDE_PROJECT_DIR
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-}"

# 无法确定项目根，放行（休眠，不误伤非工作流场景）
if [ -z "$PROJECT_ROOT" ]; then
  exit 0
fi

# 规范化目标路径为绝对路径（目录不存在时回退为原始 file_path；本工具链恒传绝对路径）
RESOLVED_PATH=$(cd "$(dirname "$FILE_PATH")" 2>/dev/null && echo "$(pwd)/$(basename "$FILE_PATH")" || echo "$FILE_PATH")

# 允许范围校验
if [[ "$RESOLVED_PATH" == "$PROJECT_ROOT"/run-*/* ]] \
  || [[ "$RESOLVED_PATH" == "$HOME/.claude/"* ]] \
  || [[ "$RESOLVED_PATH" == "$PROJECT_ROOT/.claude/"* ]]; then
  exit 0
fi

echo "BLOCKED: 写入路径 '$FILE_PATH' 不在允许范围内。允许：<项目根>/run-*/、\$HOME/.claude/、<项目根>/.claude/。当前项目根=$PROJECT_ROOT" >&2
exit 2
