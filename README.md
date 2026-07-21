# project-init

> 一键初始化新项目的 `.claude/` 目录、`CLAUDE.md` 和 Git 仓库。

[![CI](https://github.com/soeasy13142/program_init/actions/workflows/ci.yml/badge.svg)](https://github.com/soeasy13142/program_init/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![SemVer](https://img.shields.io/badge/version-0.1.0-brightgreen)](https://github.com/soeasy13142/program_init/releases)
[![POSIX Shell](https://img.shields.io/badge/shell-POSIX%20%2Fbin%2Fsh-lightgrey)](https://pubs.opengroup.org/onlinepubs/9699919799/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Project Types](#project-types)
- [Architecture](#architecture)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

`project-init` 是一个 POSIX Shell 编写的 CLI 工具，帮助开发者快速为新项目搭建 Claude Code 开发环境。它会自动生成：

- `.claude/` 目录（settings、rules 等）
- 按项目类型适配的 `CLAUDE.md`
- 初始化 Git 仓库

无需手动编写重复的配置模板，一条命令即可完成项目初始化。

## Features

- 🚀 **一键初始化** — 创建项目的同时生成完整的 Claude Code 配置
- 🎯 **多类型支持** — CLI 工具、Web 应用、TypeScript 库、Next.js 应用等预设
- 📦 **可扩展预设** — 通过自定义 preset 文件支持任意项目类型
- 🔧 **Claude-only 模式** — 在已有项目中单独生成/更新 CLAUDE.md
- 🤖 **非交互模式** — CI 环境或脚本中通过 `-y` 参数静默运行
- 🐚 **POSIX Shell 兼容** — 在 bash、zsh、dash 下均能正常工作
- 💻 **跨平台** — macOS / Linux 全支持

## Installation

### 一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/soeasy13142/program_init/main/install.sh | bash
```

### 手动安装

```bash
git clone https://github.com/soeasy13142/program_init.git
cd program_init
ln -s "$(pwd)/bin/project-init" ~/.local/bin/
```

### 验证安装

```bash
project-init --version
# => project-init v0.1.0
```

### 依赖

- **POSIX Shell** (`/bin/sh`) — bash / zsh / dash 均可
- **Git** — 初始化仓库
- **envsubst** — 模板变量替换（macOS / Linux 预装，或通过 `gettext` 包安装）

## Quick Start

```bash
# 创建新项目 CLI 工具
project-init my-cli-tool -t cli-tool

# 创建 TypeScript 库
project-init my-ts-lib -t ts-lib

# 在当前目录初始化（已有项目）
cd existing-project
project-init -c

# 非交互模式（所有选项使用默认值）
project-init my-app -t web-app -y
```

## Usage

```text
project-init [选项] [项目目录]

选项:
  -n, --name <name>        项目名称
  -t, --type <type>        项目类型: cli-tool|web-app|ts-lib|next-app
  -p, --preset <path>      自定义 preset 文件路径
  --types <type,type>      批量初始化多个类型（逗号分隔）
  -c, --claude-only        只生成 CLAUDE.md（已有项目中使用）
  -y, --yes, --non-interactive  非交互模式，使用所有默认值
  -v, --version            显示版本信息
  -h, --help               显示帮助信息
```

### 示例

```bash
# 交互式创建（推荐新手）
project-init

# 指定名称和类型
project-init -n my-app -t web-app

# 批量初始化多个 preset
project-init --types cli-tool,web-app,ts-lib,next-app

# 使用自定义 preset 模板
project-init -n my-custom -p ./my-preset.md
```

## Project Types

| Type | Description | Use Case |
|------|-------------|----------|
| `cli-tool` | CLI 工具 | Python / Bash / Go / Rust 命令行工具 |
| `web-app` | Web 应用 | 前端 / 小程序 / Web 应用 |
| `ts-lib` | TypeScript 库 | tsup / tsc + vitest |
| `next-app` | Next.js 应用 | App Router + Tailwind |

每个类型对应 `templates/presets/` 目录下的独立预设文件，可在初始化时按需加载自定义预设。

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

### Module Boundaries

| Module | Responsibility | Dependencies |
|--------|---------------|--------------|
| `bin/project-init` | 入口：参数解析、流程编排 | 所有 `lib/` 模块 |
| `lib/helpers.sh` | 日志函数、依赖检查 | 无 |
| `lib/questions.sh` | 交互式 Q&A | 无 |
| `lib/template.sh` | `envsubst` 模板渲染引擎 | 无 |
| `templates/universal.md` | 通用 CLAUDE.md 模板 | 无 |
| `templates/presets/` | 按项目类型的 preset 片段 | 无 |
| `install.sh` | 独立安装脚本（自包含） | 无 |

## Documentation

| Resource | Description |
|----------|-------------|
| [CHANGELOG.md](CHANGELOG.md) | Release history and versioning |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Developer guide and coding standards |
| [CLAUDEMD](CLAUDE.md) | Project-level Claude Code instructions |
| [LICENSE](LICENSE) | MIT License |
| [Design Spec](docs/superpowers/specs/2026-07-21-project-init-design.md) | Architecture and design decisions |
| [MVP Plan](docs/superpowers/plans/2026-07-21-project-init-mvp.md) | Initial implementation plan |

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Development setup and workflow
- Coding standards (POSIX shell conventions)
- How to run tests with `bats`
- Commit message format
- PR submission guidelines

### Quick Dev

```bash
git clone https://github.com/soeasy13142/program_init.git
cd program_init

# Run from source
./bin/project-init -n test-proj -t cli-tool -y

# Run tests
bats tests/

# Check shell syntax
for f in bin/project-init lib/*.sh install.sh; do sh -n "$f"; done
```

Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

## License

[MIT](LICENSE) © 2026 [soeasy13142](https://github.com/soeasy13142)
