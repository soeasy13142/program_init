# project-init v0.1 MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build CLI tool that one-commands `git init` + `.claude/` + CLAUDE.md generation for a new project.

**Architecture:** Pure Shell script with self-contained lib modules. Templates rendered via `envsubst`. Interactive questions via `read`. Presets selected by project type flag.

**Tech Stack:** POSIX-compatible shell scripting (`/bin/sh`), `envsubst` (part of GNU gettext, pre-installed on macOS and most Linux), `git`.

## Global Constraints

- Zero external dependencies beyond POSIX shell, git, and envsubst
- All templates under 150 lines each (official ≤200 recommendation with margin)
- CLAUDE.md output must follow official spec: advisory rules, no enforcements (that's hooks' job)
- Shell scripts must pass basic syntax check: `sh -n`
- `set -euo pipefail` in all lib scripts (but not in bin/ entry point which sources them)

---

## File Structure

```
.
├── bin/
│   └── project-init             # Entry point — orchestrates the flow
├── lib/
│   ├── helpers.sh               # log_* functions, check_dependencies
│   ├── questions.sh             # Interactive Q&A: ask_project_* functions
│   └── template.sh              # Template rendering via envsubst
├── templates/
│   ├── universal.md             # Shared DO/DON'T skeleton (~60 lines)
│   └── presets/
│       ├── cli-tool.md          # CLI tool preset (~30 lines)
│       └── web-app.md           # Web app preset (~30 lines)
├── install.sh                   # curl | bash install script
├── README.md
├── LICENSE                      # MIT
└── .gitignore
```

---

### Task 1: Project Scaffolding

**Files:**
- Create: `bin/.gitkeep`
- Create: `lib/.gitkeep`
- Create: `templates/presets/.gitkeep`
- Create: `.gitignore`

**Interfaces:**
- Consumes: nothing
- Produces: directory structure ready for task files

- [ ] **Step 1: Create directory structure**

```bash
mkdir -p bin lib templates/presets
touch bin/.gitkeep lib/.gitkeep templates/presets/.gitkeep
```

- [ ] **Step 2: Write .gitignore**

Write `.gitignore`:
```
# OS files
.DS_Store
Thumbs.db

# Editor
*.swp
*.swo
*~
.vscode/
.idea/

# Temp
*.tmp
```

- [ ] **Step 3: Commit**

```bash
git add bin/ lib/ templates/ .gitignore
git commit -m "chore: scaffold project directory structure"
```

---

### Task 2: universal.md Template

**Files:**
- Create: `templates/universal.md`

**Interfaces:**
- Consumes: nothing (static template file)
- Produces: template consumed by template.sh

- [ ] **Step 1: Write universal.md**

Write `templates/universal.md`:

```markdown
# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## 核心准则

### ✅ DO
- **Ask** — 不确定时 `AskUserQuestion`，不替用户做决定
- **Plan First** — 复杂任务（≥3步/≥2文件/涉架构）先写计划
- **TDD** — RED(测试) → GREEN(实现) → IMPROVE(重构)，覆盖率≥80%
- **小步提交** — 频繁本地提交，推送前 squash
- **Code Review** — 每次变更后做审查
- **错误处理** — 显式处理，不静默吞掉
- **不可变/幂等** — 创建新对象，重复执行安全
- **密钥管理** — 走环境变量/配置文件，不硬编码

### ❌ DON'T
- 不替用户做决定 | 不跳过测试 | 不私自推送
- 不写投机代码(YAGNI) | 不留调试输出 | 不静默吞错

## 技术栈
- 语言: {{LANGUAGE}}
- 框架: {{FRAMEWORK}}
- 测试框架: {{TEST_FRAMEWORK}}
- 运行时: {{RUNTIME}}

## 模块约定
以下内容由项目类型预设填充

{{PRESET_CONTENT}}
```

- [ ] **Step 2: Commit**

```bash
git add templates/universal.md
git commit -m "feat: add shared universal.md template"
```

---

### Task 3: cli-tool.md Preset

**Files:**
- Create: `templates/presets/cli-tool.md`

**Interfaces:**
- Consumes: nothing (static template file)
- Produces: preset consumed by template.sh for rendering into CLAUDE.md

- [ ] **Step 1: Write cli-tool.md preset**

Write `templates/presets/cli-tool.md`:

```markdown
### 入口与日志
- 入口脚本用 `#!/usr/bin/env {{SHEBANG}}` + `set -euo pipefail`
- 使用统一的日志输出（`log_info/success/warn/error`），不得用裸 `echo`
- 所有用户可见文本使用国际化变量（`MSG_*`）

### 幂等性
- 多次执行必须安全、无副作用
- 修改配置文件前先备份原始文件

### 模块边界
{{MODULE_BOUNDARIES}}

### 测试
- 新增函数/脚本必须有对应测试
- 修改安全模块后必须运行安全相关测试
```

- [ ] **Step 2: Commit**

```bash
git add templates/presets/cli-tool.md
git commit -m "feat: add cli-tool preset template"
```

---

### Task 4: web-app.md Preset

**Files:**
- Create: `templates/presets/web-app.md`

**Interfaces:**
- Consumes: nothing (static template file)
- Produces: preset consumed by template.sh for rendering into CLAUDE.md

- [ ] **Step 1: Write web-app.md preset**

Write `templates/presets/web-app.md`:

```markdown
### UI 规范
- {{UI_FRAMEWORK}} 组件化开发
- 设计风格遵循项目设计系统
- 响应式优先

### 数据流
- 本地状态管理: {{STATE_MANAGEMENT}}
- API 调用走统一封装层
- 错误状态必须在 UI 中显式展示

### 模块边界
{{MODULE_BOUNDARIES}}

### 测试
- 组件测试覆盖核心 UI 交互
- API mocking 用 {{MOCK_TOOL}}
```

- [ ] **Step 2: Commit**

```bash
git add templates/presets/web-app.md
git commit -m "feat: add web-app preset template"
```

---

### Task 5: helpers.sh

**Files:**
- Create: `lib/helpers.sh`
- Test: shell syntax check

**Interfaces:**
- Consumes: nothing (pure functions)
- Produces: `log_info`, `log_success`, `log_warn`, `log_error`, `check_dependencies`

- [ ] **Step 1: Write helpers.sh**

Write `lib/helpers.sh`:

```sh
#!/bin/sh
set -euo pipefail

# Colors (disabled if not terminal)
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  CYAN='\033[0;36m'
  NC='\033[0m' # No Color
else
  GREEN=''; YELLOW=''; RED=''; CYAN=''; NC=''
fi

log_info()   { printf "${CYAN}  ➜${NC} %s\n" "$*"; }
log_success() { printf "${GREEN}  ✅${NC} %s\n" "$*"; }
log_warn()   { printf "${YELLOW}  ⚠️${NC} %s\n" "$*"; }
log_error()  { printf "${RED}  ✗${NC} %s\n" "$*"; }

check_dependencies() {
  missing=0
  for cmd in "$@"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      log_error "Missing dependency: $cmd"
      missing=$((missing + 1))
    fi
  done
  [ "$missing" -eq 0 ] || exit 1
}
```

- [ ] **Step 2: Verify syntax**

Run: `sh -n lib/helpers.sh`
Expected: silent exit (no errors)

- [ ] **Step 3: Commit**

```bash
git add lib/helpers.sh
git commit -m "feat: add helpers.sh with log functions and dependency check"
```

---

### Task 6: template.sh

**Files:**
- Create: `lib/template.sh`
- Test: shell syntax check + manual dry run

**Interfaces:**
- Consumes: helpers.sh (log_*)
- Produces: `render_template template_file output_file [vars...]`

- [ ] **Step 1: Write template.sh**

Write `lib/template.sh`:

```sh
#!/bin/sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=./helpers.sh
. "${SCRIPT_DIR}/helpers.sh"

# render_template template_file output_file [VAR1=val1 VAR2=val2 ...]
# Renders a template file using envsubst, replacing {{VAR}} placeholders.
# Exports provided variables so envsubst can substitute them.
render_template() {
  template_file="$1"
  output_file="$2"
  shift 2

  # Export all provided variables
  for pair in "$@"; do
    case "$pair" in
      *=*)
        key="${pair%%=*}"
        val="${pair#*=}"
        export "$key"="$val"
        ;;
    esac
  done

  if [ ! -f "$template_file" ]; then
    log_error "Template not found: $template_file"
    exit 1
  fi

  # Create output directory if needed
  mkdir -p "$(dirname "$output_file")"

  # envsubst replaces $VAR and ${VAR}; convert {{VAR}} to $VAR then substitute
  sed 's/{{\([a-zA-Z_][a-zA-Z_0-9]*\)}}/$\1/g' "$template_file" \
    | envsubst > "$output_file"

  log_success "Generated: $output_file"
}
```

- [ ] **Step 2: Verify syntax**

Run: `sh -n lib/template.sh`
Expected: silent exit (no errors)

- [ ] **Step 3: Commit**

```bash
git add lib/template.sh
git commit -m "feat: add template.sh with envsubst-based template rendering"
```

---

### Task 7: questions.sh

**Files:**
- Create: `lib/questions.sh`
- Test: shell syntax check

**Interfaces:**
- Consumes: helpers.sh (log_*, color constants)
- Produces: `ask_project_name`, `ask_project_type`, `ask_description`, `ask_tech_stack`, `ask_custom_rules`, `collect_all`

- [ ] **Step 1: Write questions.sh**

Write `lib/questions.sh`:

```sh
#!/bin/sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/helpers.sh"

ask_project_name() {
  default="${1:-}"
  if [ -n "$default" ]; then
    printf "  项目名称 [${default}]: "
  else
    printf "  项目名称: "
  fi
  read -r name
  echo "${name:-$default}"
}

ask_project_type() {
  echo "  项目类型:"
  echo "    1) cli-tool       — CLI 工具 (Python/Bash/Go/Rust)"
  echo "    2) web-app        — 前端/小程序/Web 应用"
  echo "    3) backend-api    — 后端 API 服务"
  echo "    4) knowledge-base — 知识库/笔记"
  echo "    5) meta-project   — 方法论/元项目"
  printf "  请选择 [1]: "
  read -r choice
  choice="${choice:-1}"
  case "$choice" in
    1) echo "cli-tool" ;;
    2) echo "web-app" ;;
    3) echo "backend-api" ;;
    4) echo "knowledge-base" ;;
    5) echo "meta-project" ;;
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
```

- [ ] **Step 2: Verify syntax**

Run: `sh -n lib/questions.sh`
Expected: silent exit (no errors)

- [ ] **Step 3: Commit**

```bash
git add lib/questions.sh
git commit -m "feat: add questions.sh with interactive Q&A flow"
```

---

### Task 8: bin/project-init (Main CLI Entry Point)

**Files:**
- Create: `bin/project-init`
- Test: `sh -n` + dry run on a temp directory

**Interfaces:**
- Consumes: lib/helpers.sh, lib/template.sh, lib/questions.sh
- Produces: the full `project-init` command

- [ ] **Step 1: Write bin/project-init**

Write `bin/project-init`:

```sh
#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

. "${SCRIPT_DIR}/lib/helpers.sh"
. "${SCRIPT_DIR}/lib/template.sh"
. "${SCRIPT_DIR}/lib/questions.sh"

PROJECT_INIT_VERSION="0.1.0"

# --- Defaults ---
MODE="full"     # full, claude-only
PROJECT_TYPE=""
PROJECT_NAME=""
YES_MODE=0

# --- Parse flags ---
while [ $# -gt 0 ]; do
  case "$1" in
    -n|--name) PROJECT_NAME="$2"; shift 2 ;;
    -t|--type) PROJECT_TYPE="$2"; shift 2 ;;
    -c|--claude-only) MODE="claude-only"; shift ;;
    -y|--yes) YES_MODE=1; shift ;;
    -v|--version) echo "project-init v${PROJECT_INIT_VERSION}"; exit 0 ;;
    -h|--help)
      cat <<EOF
project-init v${PROJECT_INIT_VERSION}
一键初始化新项目的 .claude/ 目录和 CLAUDE.md

用法: project-init [选项] [项目目录]

选项:
  -n, --name <name>    项目名
  -t, --type <type>    项目类型: cli-tool|web-app|backend-api|knowledge-base|meta-project
  -c, --claude-only    只生成 CLAUDE.md (已有项目中使用)
  -y, --yes            非交互模式 (使用所有默认值)
  -v, --version        版本信息
  -h, --help           帮助

项目目录:
  提供时 → 创建该目录并进入
  省略时 → 使用当前目录

示例:
  project-init -n my-app -t cli-tool -y
  project-init my-web-app
  cd my-project && project-init -c
EOF
      exit 0
    ;;
    -*)
      log_error "Unknown flag: $1"
      exit 1
    ;;
    *)
      PROJECT_DIR="$1"
      shift
    ;;
  esac
done

# --- Banner ---
cat << "EOF"
╭─────────────────────────────╮
│  project-init v0.1.0       │
│  一键初始化新项目           │
╰─────────────────────────────╯
EOF

# --- Determine target directory ---
if [ -n "${PROJECT_DIR:-}" ]; then
  mkdir -p "$PROJECT_DIR"
  cd "$PROJECT_DIR"
  log_info "Working in: $(pwd)"
fi

# --- Interactive Q&A (unless -y) ---
if [ "$YES_MODE" -eq 0 ] && [ "$MODE" = "full" ]; then
  eval "$(collect_all "${PROJECT_NAME:-$(basename "$(pwd)")}")"
else
  PROJECT_NAME="${PROJECT_NAME:-$(basename "$(pwd)")}"
  PROJECT_TYPE="${PROJECT_TYPE:-cli-tool}"
fi

# --- Set template vars ---
case "$PROJECT_TYPE" in
  cli-tool|web-app|backend-api|knowledge-base|meta-project)
    PRESET_FILE="${SCRIPT_DIR}/templates/presets/${PROJECT_TYPE}.md"
    ;;
  *)
    log_error "Unknown project type: $PROJECT_TYPE"
    exit 1
    ;;
esac

# Load preset content
PRESET_CONTENT=""
if [ -f "$PRESET_FILE" ]; then
  PRESET_CONTENT=$(cat "$PRESET_FILE")
fi

# --- Full mode: git init + .claude/ ---
if [ "$MODE" = "full" ]; then
  check_dependencies git

  if [ -d ".git" ]; then
    log_info "Git already initialized"
  else
    git init > /dev/null 2>&1
    log_success "git init"
  fi

  mkdir -p .claude/rules
  log_success ".claude/ directory created"

  # Write .gitignore if not exists
  if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'GITIGNORE'
.DS_Store
*.swp
*.swo
*~
.vscode/
.idea/
*.tmp
GITIGNORE
    log_success ".gitignore created"
  fi

  # Write basic project .claude/settings.json
  mkdir -p .claude
  cat > .claude/settings.json << 'SETTINGS'
{
  "permissions": {
    "allow": [],
    "deny": []
  }
}
SETTINGS
  log_success ".claude/settings.json created"
fi

# --- Generate CLAUDE.md ---
UNIVERSAL_TEMPLATE="${SCRIPT_DIR}/templates/universal.md"
CLAUDE_MD_PATH="$(pwd)/CLAUDE.md"

# Parse tech stack into components
LANGUAGE=""
FRAMEWORK=""
TEST_FRAMEWORK=""
RUNTIME=""
case "$PROJECT_TYPE" in
  cli-tool)
    LANGUAGE="${TECH_STACK%%,*}"
    TEST_FRAMEWORK="$(echo "${TECH_STACK}" | grep -oE 'pytest|bats|go test|cargo test|jest' || echo 'standard')"
    SHEBANG="bash"
    MODULE_BOUNDARIES="(由项目自定义)"
    ;;
  web-app)
    LANGUAGE="JavaScript/TypeScript"
    FRAMEWORK="${TECH_STACK}"
    TEST_FRAMEWORK="jest/vitest"
    RUNTIME="Node.js"
    UI_FRAMEWORK="${TECH_STACK}"
    STATE_MANAGEMENT="(由项目自定义)"
    MOCK_TOOL="vitest mocks / MSW"
    MODULE_BOUNDARIES="(由项目自定义)"
    ;;
esac

render_template "$UNIVERSAL_TEMPLATE" "$CLAUDE_MD_PATH" \
  "PROJECT_NAME=$PROJECT_NAME" \
  "PROJECT_DESCRIPTION=${PROJECT_DESCRIPTION:-}" \
  "LANGUAGE=$LANGUAGE" \
  "FRAMEWORK=$FRAMEWORK" \
  "TEST_FRAMEWORK=$TEST_FRAMEWORK" \
  "RUNTIME=$RUNTIME" \
  "PRESET_CONTENT=$PRESET_CONTENT" \
  "SHEBANG=${SHEBANG:-}" \
  "MODULE_BOUNDARIES=${MODULE_BOUNDARIES:-}" \
  "UI_FRAMEWORK=${UI_FRAMEWORK:-}" \
  "STATE_MANAGEMENT=${STATE_MANAGEMENT:-}" \
  "MOCK_TOOL=${MOCK_TOOL:-}"

log_success "CLAUDE.md generated"

# --- Initial commit (full mode) ---
if [ "$MODE" = "full" ]; then
  git add -A > /dev/null 2>&1
  git commit -m "chore: initialize project with project-init" > /dev/null 2>&1 || true
  log_success "Initial commit created"
fi

# --- Summary ---
echo ""
log_success "Done! Project initialized at $(pwd)"
echo ""
echo "  ${CYAN}Next steps:${NC}"
echo "  1. Edit CLAUDE.md to refine project-specific rules"
echo "  2. Start coding: claude"
echo ""
```

- [ ] **Step 2: Verify syntax**

Run: `sh -n bin/project-init`
Expected: silent exit (no errors)

- [ ] **Step 3: Make executable**

```bash
chmod +x bin/project-init
```

- [ ] **Step 4: Test dry run (create temp dir, run, verify output)**

```bash
cd /tmp
mkdir -p test-project && cd test-project
/Users/charliepan/Downloads/imskills/bin/project-init -n test-cli -t cli-tool -y
```

Expected output:
- `git init` succeeds
- `.claude/` directory created with `rules/` and `settings.json`
- `CLAUDE.md` created with CLI-tool specific content
- `.gitignore` created

- [ ] **Step 5: Verify generated CLAUDE.md content**

```bash
cat /tmp/test-project/CLAUDE.md
```
Expected: Contains project name "test-cli", DO/DON'T rules, cli-tool preset content.

- [ ] **Step 6: Clean up temp**

```bash
rm -rf /tmp/test-project
```

- [ ] **Step 7: Commit**

```bash
git add bin/project-init
git commit -m "feat: implement project-init CLI entry point"
```

---

### Task 9: install.sh

**Files:**
- Create: `install.sh`
- Verify: syntax check

- [ ] **Step 1: Write install.sh**

Write `install.sh`:

```sh
#!/bin/sh
set -e

INSTALL_DIR="${HOME}/.local/bin"
REPO="soeasy13142/program_init"
VERSION="${1:-main}"

# Detect platform
case "$(uname -s)" in
  Darwin) OS="darwin" ;;
  Linux)  OS="linux" ;;
  *)      echo "Unsupported OS"; exit 1 ;;
esac

echo "Installing project-init v${VERSION}..."

mkdir -p "$INSTALL_DIR"

# Download the script directly from GitHub
echo "  Downloading from ${REPO}..."
if command -v curl >/dev/null 2>&1; then
  if curl -fsSL "https://raw.githubusercontent.com/${REPO}/${VERSION}/bin/project-init" -o "${INSTALL_DIR}/project-init"; then
    chmod +x "${INSTALL_DIR}/project-init"
    echo "  ✅ Installed to ${INSTALL_DIR}/project-init"
  else
    echo "  ✗ Download failed"
    exit 1
  fi
elif command -v wget >/dev/null 2>&1; then
  wget -q "https://raw.githubusercontent.com/${REPO}/${VERSION}/bin/project-init" -O "${INSTALL_DIR}/project-init"
  chmod +x "${INSTALL_DIR}/project-init"
  echo "  ✅ Installed to ${INSTALL_DIR}/project-init"
else
  echo "  ✗ Neither curl nor wget found"
  exit 1
fi

# Also download templates
TEMPLATE_DIR="${HOME}/.local/share/project-init/templates"
mkdir -p "$TEMPLATE_DIR/presets"

for tmpl in universal.md presets/cli-tool.md presets/web-app.md; do
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "https://raw.githubusercontent.com/${REPO}/${VERSION}/templates/${tmpl}" \
      -o "${TEMPLATE_DIR}/${tmpl}" >/dev/null 2>&1
  else
    wget -q "https://raw.githubusercontent.com/${REPO}/${VERSION}/templates/${tmpl}" \
      -O "${TEMPLATE_DIR}/${tmpl}"
  fi
done
echo "  ✅ Templates installed to ${TEMPLATE_DIR}"

# Check PATH
case ":${PATH}:" in
  *:"${INSTALL_DIR}":*)
    ;;
  *)
    echo ""
    echo "  ⚠️  ${INSTALL_DIR} is not in your PATH."
    echo "     Add this to your shell profile:"
    echo "       export PATH=\"\$HOME/.local/bin:\$PATH\""
    ;;
esac

echo ""
echo "  Done! Run: project-init --help"
```

- [ ] **Step 2: Verify syntax**

Run: `sh -n install.sh`
Expected: silent exit

- [ ] **Step 3: Commit**

```bash
git add install.sh
git commit -m "feat: add install.sh for curl|bash install"
```

---

### Task 10: README.md + LICENSE

**Files:**
- Create: `README.md`
- Create: `LICENSE`

- [ ] **Step 1: Write README.md**

Write `README.md`:

```markdown
# project-init

一键初始化新项目的 `.claude/` 目录、`CLAUDE.md` 和 Git 仓库。

```bash
curl -fsSL https://raw.githubusercontent.com/soeasy13142/program_init/main/install.sh | bash
```

## 快速开始

```bash
# 创建并初始化新项目
project-init my-new-project

# 或者在当前目录初始化
cd existing-project
project-init -c
```

## 用法

```
project-init [选项] [项目目录]

选项:
  -n, --name <name>    项目名
  -t, --type <type>    项目类型: cli-tool|web-app|backend-api|knowledge-base|meta-project
  -c, --claude-only    只生成 CLAUDE.md (已有项目中用)
  -y, --yes            非交互模式
  -v, --version        版本
  -h, --help           帮助
```

## 项目类型

| 类型 | 说明 | 示例 |
|------|------|------|
| `cli-tool` | CLI 工具 | Python/Bash/Go/Rust |
| `web-app` | Web 应用 | 前端/小程序/Web |
| `backend-api` | 后端 API | RESTful/gRPC |
| `knowledge-base` | 知识库 | Obsidian/文档 |
| `meta-project` | 元项目 | 方法论/模板 |

## CLAUDE.md 模板

生成的 CLAUDE.md 包含:
- 跨项目共享的 DO/DON'T 通用规则
- 按项目类型自动适配的 preset
- 用户自定义规则区域

## 安装方式

### 一键安装
```bash
curl -fsSL https://raw.githubusercontent.com/soeasy13142/program_init/main/install.sh | bash
```

### 手动安装
```bash
git clone https://github.com/soeasy13142/program_init.git
cd project-init
ln -s "$(pwd)/bin/project-init" ~/.local/bin/
```

### 要求
- POSIX shell (`/bin/sh`)
- `git`
- `envsubst` (macOS/Linux 预装)

## 许可

MIT License
```

- [ ] **Step 2: Write LICENSE (MIT)**

Write `LICENSE`:

```
MIT License

Copyright (c) 2026 Charlie Pan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

- [ ] **Step 3: Commit**

```bash
git add README.md LICENSE
git commit -m "docs: add README.md and MIT license"
```

---

## Self-Review Checklist

### 1. Spec Coverage
- [x] CLI: git init + .claude/ + CLAUDE.md generation → Task 8 (bin/project-init)
- [x] 2 presets: cli-tool, web-app → Tasks 3, 4
- [x] Interactive Q&A → Task 7 (questions.sh)
- [x] install.sh → Task 9
- [x] Shared template universal.md → Task 2
- [x] Template rendering engine → Task 6 (template.sh)
- [x] Helpers (log, deps check) → Task 5 (helpers.sh)
- [x] README + LICENSE → Task 10

### 2. Placeholder Scan
- No TBD, TODO, "implement later" found
- No "add appropriate error handling" without code
- Every step has actual shell code or commands
- Clear file paths in every task

### 3. Type/Signature Consistency
- `render_template` called in Task 8 with same signature as defined in Task 6 ✓
- `collect_all` used in Task 8 matches Task 7's output format ✓
- Template vars (e.g., `{{PROJECT_NAME}}`) in Task 2 match `render_template` args in Task 8 ✓
