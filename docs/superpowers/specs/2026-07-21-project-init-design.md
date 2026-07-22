# project-init: 一键项目初始化工具

## 概述

每次启动新项目时，开发者需要反复做三件事：初始化 git、初始化 `.claude/` 目录、编写 CLAUDE.md。 
project-init 提供一个命令解决这三个步骤，同时确保 CLAUDE.md 的内容既有跨项目共享的通用规则骨架，又能按项目类型做个性化定制。

项目定位：开源、纯 Shell + Claude Code Skill 双层架构，零外部依赖，可在任何设备上运行。

---

## 架构

```
GitHub: github.com/soeasy13142/program_init
├── install.sh                           # 一键安装
├── bin/project-init                     # 核心 CLI (纯 Shell, 零依赖)
├── lib/
│   ├── template.sh                      # 模板引擎 (envsubst)
│   ├── questions.sh                     # 交互式问答
│   └── helpers.sh                       # 通用辅助函数
├── templates/
│   ├── universal.md                     # 共享 DO/DON'T 骨架 (~60行)
│   └── presets/
│       ├── web-app.md                   # 前端/小程序项目
│       ├── cli-tool.md                  # CLI 工具 (Python/Bash/Go)
│       ├── backend-api.md               # 后端 API 项目
│       ├── knowledge-base.md            # 知识库/笔记项目
│       └── meta-project.md              # 方法论/元项目
├── skill/
│   ├── SKILL.md                         # Skill 元数据
│   └── init.md                          # /init 命令实现
├── docs/
│   └── design/                          # 设计文档
└── README.md
```

### 双层架构交互

```
         终端环境                          Claude Code 环境
    ┌────────────────┐              ┌─────────────────────┐
    │ project-init   │              │  /init (skill)      │
    │ (shell script) │              │  (AI 驱动)          │
    │                │              │                     │
    │ 机械部分:      │              │ 智能部分:           │
    │ • git init     │              │ • 交互式问答        │
    │ • mkdir .claude│              │ • 理解项目上下文    │
    │ • 创建 rules   │              │ • AI 适配生成       │
    │ • .gitignore   │              │ • 分析已有代码      │
    └──────┬─────────┘              └──────────┬──────────┘
           │                                   │
           └───────────┬───────────────────────┘
                       │
              ┌────────▼────────┐
              │  templates/     │
              │  共用同一套模板  │
              └─────────────────┘
```

---

## 模板系统

### universal.md (共享模板, ~60行)

基于用户 5 个真实项目 (my-miniapp, linux-one-key, pulse-bot, my-obsidian, grown-workflow) 的交集提炼。

```markdown
# {{project_name}}

{{description}}

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
- 语言: {{language}}
- 框架: {{framework}}
- 测试: {{test_framework}}
- 运行时: {{runtime}}

## 模块约定
以下区域由所选 preset 填充，例如 CLI 工具的模块边界表、Web 应用的页面路由规则等。
{{preset_content}}
```

### Preset 系统

按用户已有项目类型映射:

| Preset | 适用项目 | 特有内容 |
|--------|---------|---------|
| `web-app` | my-miniapp | 前端规范、UI 风格、MCP 配置 |
| `cli-tool` | linux-one-key, pulse-bot | 入口约定、日志规范、模块边界表 |
| `knowledge-base` | my-obsidian | 文件命名、frontmatter、文件夹结构 |
| `meta-project` | grown-workflow | 方法论规则、迭代节奏 |
| `backend-api` | — | API 设计规范、路由约定 |

---

## CLI (Shell Script) 设计

### 命令接口

```bash
project-init [flags] [项目目录]

# 项目目录 作为可选参数:
#   提供时 → 创建该目录并进入 (类似 mkdir && cd)
#   省略时 → 使用当前目录

Flags:
  -n, --name <name>    项目名 (非交互模式)
  -t, --type <type>    项目类型: web-app|cli-tool|backend-api|knowledge-base|meta-project
  -c, --claude-only    只生成 CLAUDE.md (已有项目中用)
  -y, --yes            全部默认 (非交互)
  -v, --version        版本
```

### 交互流程

```
$ project-init my-new-project

  ╭─────────────────────────────╮
  │  project-init v0.1.0        │
  │  一键初始化新项目            │
  ╰─────────────────────────────╯

  1/5  项目名称: [my-new-project]
  2/5  项目类型: [cli-tool]
  3/5  项目简介: A CLI tool for ...
  4/5  技术栈: Python 3.11+, pytest
  5/5  特殊规则: (可选)

  ✅ git init        done
  ✅ .claude/        done
  ✅ .gitignore      done
  ✅ CLAUDE.md       done

  Next steps:
    cd my-new-project
    claude    # 启动 Claude Code
```

### CLI 职责边界

**做:**
- `git init`
- `mkdir -p .claude/rules/`
- 写入 `.gitignore`
- 生成 CLAUDE.md (模板 + 用户输入 → envsubst 渲染)
- 生成 `.claude/settings.json` 骨架
- 首个 `git commit`

**不做:**
- 安装运行时/依赖
- 创建业务代码
- 配置 MCP 服务器
- 写测试

---

## Skill (Claude Code) 设计

### 安装

```bash
# 方法1: 在 Claude Code 里
/plugin install project-init

# 方法2: 手动
curl -o .claude/skills/init/init.md https://raw.githubusercontent.com/soeasy13142/program_init/main/skill/init.md
```

### 工作流

```
用户输入 /init

  ↓

1. 交互问答 (AI 驱动, 更智能):
   - "这个项目做什么的?"
   - "用了什么技术栈?"
   - "有什么特殊规则?"

  ↓

2. 如果还没有 git / .claude/:
   → 调用 CLI 的机械部分

  ↓

3. AI 理解项目上下文后:
   → 选择合适 preset
   → 填充模板变量
   → 生成 CLAUDE.md

  ↓

4. 如果项目中已有 CLAUDE.md:
   → 分析现有文件
   → 建议改进点
   → 提供 diff 供用户确认
```

### Skill 和模板的关系

Skill 的 `init.md` 直接引用和渲染 `templates/universal.md` 及 preset 文件。
这意味着 CLI 和 Skill 共享同一套模板，不会有不同步问题。

---

## 版本规划

### v0.1 — MVP
- [ ] CLI: `git init` + `.claude/` + CLAUDE.md 生成
- [ ] 2 个 preset: `cli-tool`, `web-app`
- [ ] 交互式问答
- [ ] 安装脚本
- [ ] 开源发布

### v0.2 — Skill 集成
- [ ] `/init` Skill 实现
- [ ] AI 驱动的上下文理解
- [ ] 已有项目适配

### v0.3 — 生态完善
- [ ] 更多 preset (`backend-api`, `knowledge-base`, `meta-project`)
- [ ] 社区贡献模板
- [ ] NPM/Homebrew 安装

---

## CLAUDE.md 规范遵从

本设计严格遵循 Claude Code 官方文档要求:

| 规范 | 设计决策 |
|------|---------|
| 目标 ≤200 行 | 共享模板 ~60 行, preset ~30-50 行, 合计 ~100 行 |
| 发现性过滤 | 技术栈、目录结构等可发现信息已删除, 只保留非显式约定 |
| advisory vs enforced | CLAUDE.md 放建议性规则, hooks/settings 放确定性规则 |
| 自我改进 | 模板末尾留自定义区域, 用户可追加已犯过的错误 |
| `@` 导入 | 暂不采用, 保持单文件简单 |
| markdown 层级 | 使用 `##` 和 `-`, 无深层嵌套 |

---

## 局限性与风险

- **CLI 无 diff/preview** — 写入前不展示预览差异 (用户确认通过问答进行)
- **模板非强制** — 生成后用户可能不修改, 导致 CLAUDE.md 内容不完整
- **envsubst 局限性** — 纯 Shell 模板引擎不支持条件/循环逻辑 (但够用)
- **无更新机制** — 生成后模板变化不会自动同步到已有项目
