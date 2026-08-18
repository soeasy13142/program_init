#!/bin/sh
set -eu  # -o pipefail omitted for dash compatibility

SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "$0")" && pwd)}"
# helpers.sh is sourced by the entry point (bin/project-init) before this file

# NOTE: 所有 UI 输出（提示符 / 菜单）一律走 stderr（>&2），
# 保证 stdout 只包含数据值 —— 调用方通过 $(...) 捕获时才不会把提示文本混进变量。

ask_project_name() {
  default="${1:-}"
  if [ -n "$default" ]; then
    printf '  项目名称 [%s]: ' "${default}" >&2
  else
    printf "  项目名称: " >&2
  fi
  read -r name || { printf "  输入已中断 (EOF)，已退出。\n" >&2; exit 1; }
  echo "${name:-$default}"
}

ask_project_type() {
  echo "  项目类型:" >&2
  echo "    1) cli-tool      — CLI 工具 (Python/Bash/Go/Rust)" >&2
  echo "    2) shell-script  — Shell 脚本 (bash/zsh, CRON, 运维)" >&2
  echo "    3) web-app       — 前端/小程序/Web 应用" >&2
  echo "    4) ts-lib        — TypeScript 库" >&2
  echo "    5) next-app      — Next.js 应用" >&2
  printf "  请选择 [1]: " >&2
  read -r choice || { printf "  输入已中断 (EOF)，已退出。\n" >&2; exit 1; }
  choice="${choice:-1}"
  case "$choice" in
    1) echo "cli-tool" ;;
    2) echo "shell-script" ;;
    3) echo "web-app" ;;
    4) echo "ts-lib" ;;
    5) echo "next-app" ;;
    *) echo "cli-tool" ;;
  esac
}

ask_description() {
  printf "  项目简介: " >&2
  read -r desc || { printf "  输入已中断 (EOF)，已退出。\n" >&2; exit 1; }
  echo "$desc"
}

ask_tech_stack() {
  printf "  技术栈 (例如 Python 3.11+, pytest): " >&2
  read -r stack || { printf "  输入已中断 (EOF)，已退出。\n" >&2; exit 1; }
  echo "$stack"
}

ask_custom_rules() {
  echo "  特殊规则 (输入空行结束):" >&2
  rules=""
  while true; do
    printf "    > " >&2
    read -r line || { printf "  输入已中断 (EOF)，已退出。\n" >&2; exit 1; }
    [ -z "$line" ] && break
    rules="${rules}- ${line}
"
  done
  echo "$rules"
}

collect_all() {
  default_name="${1:-}"
  name=$(ask_project_name "$default_name")
  type=$(ask_project_type)
  desc=$(ask_description)
  stack=$(ask_tech_stack)
  rules=$(ask_custom_rules)

  # Basic validation
  if [ -z "$name" ]; then
    log_error "项目名称不能为空"
    exit 1
  fi

  # Output as shell variables
  cat <<EOF
PROJECT_NAME="$name"
PROJECT_TYPE="$type"
PROJECT_DESCRIPTION="$desc"
TECH_STACK="$stack"
CUSTOM_RULES="$rules"
EOF
}
