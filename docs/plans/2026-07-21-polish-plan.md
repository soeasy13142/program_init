# Polish Plan — 2026-07-21

## 依赖关系

```
Phase 1 (全并行)          Phase 2 (依赖 Phase 1)     Phase 3 (依赖 Phase 2)
──────────────────────    ──────────────────────    ─────────────────────
A. 清理 .gitkeep 垃圾
B. CHANGELOG.md
C. GitHub 模板
D. 实现缺失功能 ──────────▶ E. 添加 bats 测试 ───────▶ F. 添加 CI
```

## 分工

| # | 任务 | 说明 |
|---|------|------|
| A | 清理 .gitkeep | 删除 `bin/.gitkeep` `lib/.gitkeep` `templates/presets/.gitkeep` |
| B | CHANGELOG.md | 从 git log 生成，格式 keepachangelog |
| C | GitHub 模板 | `.github/ISSUE_TEMPLATE/{bug,feature}.md` + `PULL_REQUEST_TEMPLATE.md` |
| D | 实现缺失功能 | `--types` 批量初始化、`--preset` 自定义路径、`--non-interactive` 别名、TypeScript presets |
| E | bats 测试 | 测试 lib/*.sh 各函数、bin/project-init 各 flag、模板渲染 |
| F | CI | GitHub Actions: shellcheck + bats 测试，macOS/Ubuntu 矩阵 |
