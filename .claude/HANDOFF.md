# HANDOFF.md — 项目交接文档

> **入手先读**：`CLAUDE.md` → 本文（当前进展章节）→ `docs/superpowers/`。
> **修改后追加**：每次会话结束，将新约定/决策/踩坑追加到本文末尾。

---

## 当前进展

- **MVP 已完成** — 见 `docs/superpowers/plans/2026-07-21-project-init-mvp.md`
- 所有 10 个 Task 均完成并通过 code review
- `project-init v0.1.0` 已可工作在 `-t cli-tool` 和 `-t web-app` 两种类型

## 已知待办（README 中列出）

- `--types` 批量初始化支持
- `--preset` 自定义 preset 路径
- `--non-interactive` 别名
- TypeScript preset（`ts-lib`、`next-app`）

## 已知问题

- `envsubst` 在 macOS/Linux 预装，但某些最小化 Docker 镜像可能缺失
- 非 `-y` 模式下，如果 stdin 不是终端，`read` 会静默返回空值
- **Bug #1 (已修复):** `install.sh` 中 `REPO="soeasy13142/project-init"` 错误，应为 `soeasy13142/program_init`；已修复
- **Bug #2 (待修复):** `CUSTOM_RULES` 在交互模式收集 (`bin/project-init:100`) 但从未传给 `render_template`，模板也没有对应占位符，用户输入被静默丢弃
- **Bug #3~#5 (待修复):** CLAUDE.md、设计规格、MVP 计划等多处文档引用不存在的仓库 `github.com/soeasy13142/project-init`，应为 `program_init`
- **Bug #6 (待清理):** `install.sh` 中 `OS` 变量被赋值但从未使用 (SC2034)
- **Bug #7 (待修复):** `lib/questions.sh:10` printf 格式字符串含变量 (SC2059)
- **Suggestion #8:** 缺少 `shell-script` 预设，纯 Shell 项目只能选 `cli-tool`
- **Suggestion #9:** `-y` 非交互模式下，技术栈字段全部为空；cli-tool 等类型可设合理默认值

## 架构决策记录

| 日期 | 决策 | 理由 |
|------|------|------|
| 2026-07-21 | 模板用 `{{VAR}}` 而非 `$VAR` | 避免与 shell `$VAR` 冲突，无需转义 `$` |
| 2026-07-21 | lib 用 `set -eu`，入口用 `set -e` | lib 中未定义变量应报错；入口因可选变量可能未设 |
| 2026-07-21 | dash 兼容不用 `pipefail` | Debian/Ubuntu `/bin/sh` 是 dash，不支持 `pipefail` |
| 2026-07-21 | `-o pipefail` 注释说明 | 保留在注释中供 bash 用户参考 |
| 2026-07-21 | 多步替换循环解析嵌套占位符 | Preset 内容嵌入 universal 模板时可能出现 `{{VAR}}` 嵌套 |
| 2026-07-21 | 入口脚本 source lib 而非子进程调用 | 共享函数和变量，保持单一进程模型 |
| 2026-07-21 | `install.sh` 完全独立，不依赖 lib/ | 安装时 lib/ 尚不存在，需从 GitHub raw 下载 |
| 2026-07-21 | `.claude/worktrees/` 和 `.superpowers/` 加入 `.gitignore` | agent 工作产物不提交仓库 |

## CLI 与全局配置

- 全局 `~/.claude/settings.json` 中 `ECC_GATEGUARD` 已设为 `off`
- 本项目 `permissions` 设为 `bypassPermissions`（全局生效）
- 所有模型请求路由到 `deepseek-v4-flash`

## 新约定（工作过程中追加）

_（暂无 — 按需追加）_
