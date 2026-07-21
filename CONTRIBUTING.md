# Contributing

欢迎贡献 `project-init`！

## 开发环境

- POSIX shell (`/bin/sh`)
- `git`
- `envsubst`（macOS / Linux 预装）
- （可选）`bats` 用于 shell 测试

## 项目结构

```
bin/project-init          # 入口脚本
lib/
  helpers.sh              # 日志函数 + 依赖检查
  questions.sh            # 交互式 Q&A
  template.sh             # 模板渲染引擎
templates/
  universal.md            # 通用 CLAUDE.md 模板
  presets/
    cli-tool.md           # CLI 工具 preset
    web-app.md            # Web 应用 preset
install.sh                # 独立安装脚本
```

## 开发流程

1. 编辑对应的 lib 文件
2. 手动测试：
   ```bash
   ./bin/project-init -n test-proj -t cli-tool -y
   ./bin/project-init -n test-web -t web-app -y
   ```
3. 确保 `dash` 兼容（Debian/Ubuntu）：
   ```bash
   # Docker 验证
   docker run --rm -v "$PWD:/app" -w /app ubuntu:latest sh -c '
     apt-get update -qq && apt-get install -y -qq gettext-base
     ./bin/project-init -n test -t cli-tool -y
   '
   ```
4. 提交前：
   - 无硬编码路径
   - 无 bashisms（`[[ ]]`, `source`, `local` 等）
   - 所有 `log_*` 调用使用统一的日志函数
   - `.gitignore` 覆盖 agent 产物（`/.claude/worktrees/`, `.superpowers/`）

## 代码风格

- 顶格 `set -eu`（入口用 `set -e`）
- 函数名 `snake_case`
- 全局常量 `UPPER_SNAKE_CASE`
- 注释说明函数行为、参数、返回值

## 提交规范

```
<type>: <description>

feat: add --preset flag for custom template paths
fix: handle empty stdin in non-interactive mode
docs: update README with new options
test: add bats tests for template rendering
```

## 许可

MIT — 见 [LICENSE](LICENSE)。
