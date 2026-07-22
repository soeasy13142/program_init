# Bug Fix & vvvps Project Init — 2026-07-22

## Summary

使用 curl 方式安装 project-init，然后在 `/Users/charliepan/Downloads/vvvps` 初始化 VPS 每日汇报脚本项目。过程中发现并修复了若干 bug。

## What Was Done

### 1. curl 安装尝试

按 README 命令执行：
```bash
curl -fsSL https://raw.githubusercontent.com/soeasy13142/program_init/main/install.sh | bash
```
**结果：失败** — install.sh 下载成功，但内部文件下载全部 404。

### 2. Bug 修复 — install.sh

**Bug #1: REPO 变量指向不存在的仓库**
- 位置：`install.sh:6`
- 错误值：`REPO="soeasy13142/project-init"`
- 正确值：`REPO="soeasy13142/program_init"`
- git remote 显示的 origin 是 `https://github.com/soeasy13142/program_init.git`，但 install.sh 写死了 `project-init`
- **影响**：用户按 README 执行 curl 安装时，所有文件下载都会 404，安装彻底失败
- **状态**：已修复

安装后验证通过：
```
$ project-init --version
project-init v0.1.0
```

### 3. vvvps 项目初始化

```bash
project-init -n vvvps -t cli-tool -y /Users/charliepan/Downloads/vvvps
```
✅ 成功。生成了：
- `.claude/settings.json`
- `.claude/rules/`（空目录）
- `.gitignore`
- `CLAUDE.md`
- Git 仓库 + 初始 commit

### 4. 发现的额外 Bug

#### Bug #2: CUSTOM_RULES 收集但从未使用
- 位置：`bin/project-init:100`
- 交互模式下，`ask_custom_rules()` 收集用户输入的自定义规则到 `CUSTOM_RULES` 变量
- 但该变量 **从未传入 `render_template`**，且模板 `templates/universal.md` 中也没有 `{{CUSTOM_RULES}}` 占位符
- **影响**：用户在交互模式下输入的特殊规则被静默丢弃，不生效
- **状态**：未修复（需重新设计模板和渲染逻辑）

#### Bug #3 ~ #5: 文档引用错误的仓库名
多处文档引用 `github.com/soeasy13142/project-init`，但实际仓库名是 `program_init`：

| 文件 | 行 | 内容 |
|------|-----|------|
| `CLAUDE.md` | 12 | `git clone https://github.com/soeasy13142/project-init.git` |
| `docs/superpowers/specs/2026-07-21-project-init-design.md` | 15 | `github.com/soeasy13142/project-init` |
| `docs/superpowers/specs/2026-07-21-project-init-design.md` | 187 | `raw.githubusercontent.com/soeasy13142/project-init/.../init.md` |
| `docs/superpowers/plans/2026-07-21-project-init-mvp.md` | 755,849,898,903 | 多处 curl 和 git clone URL |

#### Bug #6: OS 变量未使用
- 位置：`install.sh:12`
- `case` 检测平台后设置 `OS="darwin"` 或 `OS="linux"`，但该变量从未被使用
- shellcheck SC2034

#### Bug #7: printf 格式字符串含变量
- 位置：`lib/questions.sh:10`
- `printf "  项目名称 [${default}]: "` — 变量在 printf format 字符串中
- shellcheck SC2059（info 级别风险：若 `$default` 含 `%` 会异常）

### 5. 功能缺失/改进建议

#### #8: 缺少 shell-script 预设
- VPS 每日汇报脚本是纯 Shell 项目，最接近的是 `cli-tool` 预设
- cli-tool 预设内容基本适用（入口/日志/幂等性），但缺少 Shell 项目特有内容（cron 配置、SSH 连接、报告生成等）
- 建议为纯 Shell 项目创建独立的 `shell-script` 预设

#### #9: `-y` 模式下技术栈字段为空
- `-y` 模式下 `TECH_STACK` 为空，导致 CLAUDE.md 中：
  ```
  - 语言: 
  - 框架: 
  ```
- 对于 cli-tool 类型，可以添加合理的默认值（如 `LANGUAGE="Shell"`）

## 当前 vvvps 项目状态

- 已初始化但 CLAUDE.md 内容较通用（缺少项目描述和技术栈）
- 建议下一步：
  1. 编辑 `CLAUDE.md`，添加项目描述（VPS 每日汇报脚本）
  2. 创建 `bin/` 目录放置主脚本
  3. 创建 `lib/` 目录放置辅助函数
  4. 创建 `config/` 或 `.env.example` 管理服务器配置

## Next Steps for imskills

1. 修复 Bug #2（CUSTOM_RULES 传递到模板）
2. 修复文档 Bug #3~#5（仓库名不一致）
3. 清理 Bug #6（删除未使用的 OS 变量）
4. 修复 Bug #7（printf 格式字符串）
5. 考虑为 `-y` 模式添加 cli-tool 默认 LANGUAGE="Shell"
