#!/bin/sh
set -eu  # -o pipefail omitted for dash compatibility

SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "$0")" && pwd)}"
# helpers.sh is sourced by the entry point (bin/project-init) before this file

ask_project_name() {
  default="${1:-}"
  if [ -n "$default" ]; then
    printf '  项目名称 [%s]: ' "${default}"
  else
    printf "  项目名称: "
  fi
  read -r name
  echo "${name:-$default}"
}

ask_project_type() {
  echo "  项目类型:"
  echo "    1) cli-tool      — CLI 工具 (Python/Bash/Go/Rust)"
  echo "    2) shell-script  — Shell 脚本 (bash/zsh, CRON, 运维)"
  echo "    3) web-app       — 前端/小程序/Web 应用"
  echo "    4) ts-lib        — TypeScript 库"
  echo "    5) next-app      — Next.js 应用"
  printf "  请选择 [1]: "
  read -r choice
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
  printf "  项目简介: "
  read -r desc
  echo "$desc"
}

ask_tech_stack() {
  printf "  技术栈 (例如 Python 3.11+, pytest): "
  read -r stack
  echo "$stack"
}

ask_custom_rules() {
  echo "  特殊规则 (输入空行结束):"
  rules=""
  while true; do
    printf "    > "
    read -r line
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
