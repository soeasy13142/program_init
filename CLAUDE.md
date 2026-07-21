# project-init

一键初始化新项目的 `.claude/` 目录、`CLAUDE.md` 和 Git 仓库。详见 [README.md](README.md)。

- **Tech**: POSIX Shell (`/bin/sh`), Git, `envsubst`
- **Tests**: 暂无（计划引入 `bats`）

## Quick Start

```bash
# Clone & dev
git clone https://github.com/soeasy13142/project-init.git
cd project-init

# Run directly (dev mode)
./bin/project-init -n my-app -t cli-tool -y

# Install locally
ln -s "$(pwd)/bin/project-init" ~/.local/bin/
```

## Key Conventions

- **POSIX shell only**: 目标环境是 `/bin/sh` — 不用 bashisms（`[[ ]]`, `<<<`, `source`, `local`, `export -f` 等）
- **`set -eu` in lib**：库文件顶部统一 `set -eu`；入口脚本用 `set -e`（可选变量可能未定义）
- **`dash` 兼容**：在 Debian/Ubuntu 等 `dash` 为 `/bin/sh` 的系统上也要正常工作
- **Immutability**：模板渲染生成新文件，不原地修改
- **Idempotent**：重复执行 `project-init` 在同一目录必须安全
- **Colors 只在终端输出**：`[ -t 1 ]` 检测是否终端，非终端不输出 ANSI 转义
- **No silent failures**：`set -e` 确保出错即停，所有异常显式处理
- **Template-first**：CLAUDE.md 由 `templates/universal.md` + preset 渲染生成，不硬编码

## Module Boundaries

| Module | Responsibility | Must NOT import |
|--------|---------------|-----------------|
| `bin/project-init` | 入口：参数解析、流程编排 | `lib/` 以外的 shell lib |
| `lib/helpers.sh` | 日志函数（`log_info/success/warn/error`）、依赖检查 | 业务逻辑 |
| `lib/questions.sh` | 交互式 Q&A 提示（`ask_*` 函数） | 模板渲染 |
| `lib/template.sh` | `envsubst` 模板渲染引擎（`render_template`） | 用户交互 |
| `templates/universal.md` | 通用 CLAUDE.md 模板（`{{VAR}}` 占位符） | 无 |
| `templates/presets/` | 按项目类型的 preset 片段 | 无 |
| `install.sh` | 独立安装脚本（从 GitHub raw 下载） | 无 |

## DO / DON'T

### ✅ DO
- DO **任何不确定立刻问** — 无论大小，一律用 `AskUserQuestion` 工具询问用户，不替用户做任何决定
- DO **高频提交** — 每完成一个逻辑步骤立即 `git commit`，不做大捆提交；分支上自由提交，不等用户许可
- DO 使用 `log_info/success/warn/error` 统一日志，不裸 `echo`
- DO 新增函数时附带对应的 bats 测试
- DO 用 `envsubst` 做模板渲染（`{{VAR}}` → 替换）
- DO 交互式模式下 `read -r` 读取用户输入
- DO 多步替换时循环解析嵌套占位符
- DO 所有用户可见文本最终用环境变量或预设控制

### ❌ DON'T
- DON'T **替用户做决定** — 任何选择/偏好/不确定性，都用 `AskUserQuestion`，禁止擅自拍板
- DON'T **攒批提交** — 完成一步马上 commit，不等到一个阶段做完才提交
- DON'T 使用 bash-only 语法（`[[ ]]`, `source` 等）
- DON'T 在 lib 中用未被 `set -eu` 保护的未定义变量
- DON'T 硬编码项目名称/类型到模板中 — 永远通过变量传递
- DON'T 使用 `sudo` 或要求 root 权限
- DON'T 留下未使用的模板文件或 presets
- DON'T 渲染模板时直接 `eval` 用户输入

## Architecture

```
                    ┌──────────────┐
                    │  User runs   │
                    │ project-init │
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐       ┌──────────────────┐
                    │  bin/        │       │  lib/helpers.sh   │
                    │ project-init ├──────▶│  lib/questions.sh │
                    │  (entry)     │       │  lib/template.sh  │
                    └──────┬───────┘       └──────────────────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
     ┌────────────┐ ┌───────────┐ ┌──────────┐
     │ .claude/   │ │ CLAUDE.md │ │ .git/    │
     │ settings   │ │           │ │ init     │
     │ rules/     │ │           │ │          │
     └────────────┘ └───────────┘ └──────────┘
```

- 模板文件是不可变源文件，输出文件由 `render_template` 生成
- `questions.sh` 仅在非 `-y` 模式下被调用
- 每个 lib 文件独立 `set -eu`，入口 `set -e` 以避免可选变量报错
- `install.sh` 是独立脚本，不依赖 lib/ 中的任何文件

## Reference

| Doc | For |
|-----|-----|
| [README.md](README.md) | Project overview, install, usage |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Developer guide |
| [LICENSE](LICENSE) | MIT License |
| `docs/superpowers/specs/2026-07-21-project-init-design.md` | Design spec |
| `docs/superpowers/plans/2026-07-21-project-init-mvp.md` | MVP plan |
