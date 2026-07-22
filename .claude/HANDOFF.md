# HANDOFF.md — 项目交接文档

> **入手先读**：`CLAUDE.md` → 本文（当前进展章节）→ `docs/superpowers/`。
> **修改后追加**：每次会话结束，将新约定/决策/踩坑追加到本文末尾。

---

## 当前进展

- **MVP 已完成** — 见 `docs/superpowers/plans/2026-07-21-project-init-mvp.md`
- 所有 10 个 Task 均完成并通过 code review
- `project-init v0.1.0` 已可工作在 `cli-tool`、`shell-script`、`web-app`、`ts-lib`、`next-app` 五种类型

## 已知待办（README 中列出）

- `--types` 批量初始化支持
- `--preset` 自定义 preset 路径
- `--non-interactive` 别名
- TypeScript preset（`ts-lib`、`next-app`）

## 已修复问题

| # | 问题 | 状态 | 文件 |
|---|------|------|------|
| 1 | `install.sh` REPO 指向不存在的 `project-init` 仓库 | ✅ 已修复 | `install.sh:6` |
| 2 | `CUSTOM_RULES` 收集但从未传给 `render_template` | ✅ 已修复 | `bin/project-init`, `templates/universal.md` |
| 3~5 | 文档引用不存在的仓库 `github.com/.../project-init` | ✅ 已修复 | `CLAUDE.md`, 设计规格, MVP计划 |
| 6 | `install.sh` 中 `OS` 变量未使用 (SC2034) | ✅ 已修复 | `install.sh` |
| 7 | `lib/questions.sh:10` printf 格式字符串含变量 (SC2059) | ✅ 已修复 | `lib/questions.sh` |
| 8 | 缺少 `shell-script` 预设 | ✅ 已新增 | `templates/presets/shell-script.md` |
| 9 | `-y` 模式技术栈字段为空 | ✅ 已修复 | `bin/project-init` (非交互模式默认值) |

## 已知问题

- `envsubst` 在 macOS/Linux 预装，但某些最小化 Docker 镜像可能缺失
- 非 `-y` 模式下，如果 stdin 不是终端，`read` 会静默返回空值

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

| 2026-07-22 | `shell-script` 预设 — Shell 项目专用 | VPS 每日汇报等运维脚本需要 cron/SSH 等内容 |
| 2026-07-22 | `.claude/` 脱离 `full` 模式限制 | claude-only 模式也需要 `.claude/` 目录 |
| 2026-07-22 | `CUSTOM_RULES` 传递到模板 | 交互模式用户输入的自定义规则不再丢失 |
