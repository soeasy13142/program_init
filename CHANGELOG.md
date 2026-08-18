# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- 交互式模式：`ask_*` 提示符/菜单改走 stderr，避免被 `$(...)` 命令替换捕获并污染变量值（此前交互模式生成的 CLAUDE.md 必然值错乱或失败）
- 非终端 stdin：交互模式检测到 stdin 非终端时给出明确指引并退出，不再因 `read` 撞 EOF 触发 `set -e` 静默中止（exit 1 无任何输出）
- 依赖检查提前到任何文件生成之前：`-c`（claude-only）模式缺失 `envsubst` 时优雅报错，不再先写入 `.claude/`、HANDOFF 等半成品再裸崩溃
- `tests/questions.bats` 断言改为精确匹配（防止提示文本混入的回归漏网）；新增 `tests/entry.bats` 入口集成测试（tty 守卫、缺失 envsubst、`-y` 端到端）

### Changed

- README：更正 envsubst「macOS / Linux 预装」的错误说法（macOS 需 `brew install gettext`，Linux 需 `gettext-base`）

## [0.1.0] - 2026-07-24

### Added

- Scaffold project directory structure
- Add shared `universal.md` template
- Add `cli-tool` preset template
- Add `web-app` preset template
- Add `ts-lib` and `next-app` preset templates
- Add `shell-script` preset template
- Add `helpers.sh` with log functions and dependency check
- Add `template.sh` with envsubst-based template rendering
- Add `questions.sh` with interactive Q&A flow
- Implement `project-init` CLI entry point
- Add `install.sh` for curl|bash install
- Add `--preset` flag for custom template path
- Add `--types` flag for batch init of multiple types
- Add `--non-interactive` alias for `-y`
- Add `CHANGELOG.md` and issue/PR templates
- Add bats test framework for lib modules
- Add GitHub Actions CI workflow (shellcheck + bats)
- Add HANDOFF mechanism with `docs/handover/` directory
- Add `-c` / `--claude-only` mode for existing projects
- Ensure `.claude/` directory created in both full and claude-only modes

### Fixed

- Replace `pipefail` with `set -eu` for dash compatibility
- Address initial review findings
- Remove placeholder project types from README usage example
- Correct `install.sh` REPO URL from `project-init` to `program_init`
- Resolve all 7 documented bugs (install.sh 404, CUSTOM_RULES unused, doc repo names, OS variable unused, printf format string)

### Changed

- Upgrade `universal.md` template per official Claude spec with numbered DO/DON'T
- Refactor CLAUDE.md template with modular layout (module boundaries, architecture diagram)
- Rewrite README with community-standard badges and structure
- Update `install.sh` with new presets and consistent repo references

### Docs

- Add project-init design spec
- Add v0.1 MVP implementation plan
- Add bug report, feature request, and pull request templates
- Add handover documentation workflow
