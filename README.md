# project-init

一键初始化新项目的 `.claude/` 目录、`CLAUDE.md` 和 Git 仓库。

```bash
curl -fsSL https://raw.githubusercontent.com/soeasy13142/project-init/main/install.sh | bash
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
  -t, --type <type>    项目类型: cli-tool|web-app|ts-lib|next-app
  -p, --preset <path>  自定义 preset 文件路径
  --types <type,type>  批量初始化 (如 cli-tool,web-app,ts-lib,next-app)
  -c, --claude-only    只生成 CLAUDE.md (已有项目中用)
  -y, --yes, --non-interactive  非交互模式 (使用所有默认值)
  -v, --version        版本
  -h, --help           帮助
```

## 项目类型

| 类型 | 说明 | 示例 |
|------|------|------|
| `cli-tool` | CLI 工具 | Python/Bash/Go/Rust |
| `web-app` | Web 应用 | 前端/小程序/Web |
| `ts-lib` | TypeScript 库 | tsup/tsc + vitest |
| `next-app` | Next.js 应用 | App Router + Tailwind |

## CLAUDE.md 模板

生成的 CLAUDE.md 包含:
- 跨项目共享的 DO/DON'T 通用规则
- 按项目类型自动适配的 preset
- 用户自定义规则区域

## 安装方式

### 一键安装
```bash
curl -fsSL https://raw.githubusercontent.com/soeasy13142/project-init/main/install.sh | bash
```

### 手动安装
```bash
git clone https://github.com/soeasy13142/project-init.git
cd project-init
ln -s "$(pwd)/bin/project-init" ~/.local/bin/
```

### 要求
- POSIX shell (`/bin/sh`)
- `git`
- `envsubst` (macOS/Linux 预装)

## 许可

MIT License
