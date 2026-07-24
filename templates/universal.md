# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

> **任何开始**：先读本文 → 再读 `.claude/HANDOFF.md` → 再动手。
> **任何结束**：追加 `.claude/HANDOFF.md`（决策 / 新约定 / 踩过的坑）。

---

## 核心红线（DO / DON'T）

### ✅ 必做

**D1. Plans 先行** — ≥3 步 / ≥2 文件 / 涉架构或数据决策 → 先写 `docs/plans/`，等确认再动手。

**D2. 每步必 commit** — Plan 每完成一步 → 立即 `git commit`（分支上自由提交，不等许可）。不攒批。

**D3. 必问原则** — 任何不确定 → `AskUserQuestion`。不替用户决策。

**D4. 改前读 / 改后写** — 每次改前改后查 `.claude/HANDOFF.md`，新约定回写。

**D5. TDD** — 先测试（RED）→ 最小实现（GREEN）→ 重构（IMPROVE），覆盖率 ≥ 80%。

**D6. 完成前验证** — 测试全绿 + Code Review 通过，方可称完成。

**D7. SubAgent 优先** — 批量操作 / 大量读写 / 全库搜索替换 → 默认派 SubAgent，主会话保持轻量。

### ❌ 禁止

**X1** 替用户决策 | **X2** 跳过 plans | **X3** 不经询问创建/删除文件 | **X4** 硬编码 secrets
**X5** 未要求就 `git push`（分支上 commit 不受限） | **X6** 残留调试输出
**X7** 测试未过就称完成

### D3 三档触发

| 🔴 必须问 | 🟡 可不问 | 🟢 不问 |
|-----------|-----------|---------|
| 库/框架选型、方案对比、UI 偏好、边界不明事项 | CLAUDE.md / HANDOFF.md 中已约定 | 刻意空置（怀疑即回 🔴） |

> 错误成本：多问 10 次的代价 << 擅自拍板一次的重做代价。

---

## 技术栈

- 语言: {{LANGUAGE}}
- 框架: {{FRAMEWORK}}
- 测试框架: {{TEST_FRAMEWORK}}
- 运行时: {{RUNTIME}}

## 模块约定

{{PRESET_CONTENT}}

## 开发工作流

```
读 HANDOFF.md
→ 复杂任务？写 plans（docs/plans/）
→ 等确认 → 按 plan 逐步骤实现（每步结尾: git commit → 测试）
→ 全完成 → Code Review → 验证 → 更新 handoff
```

## 文件命名约定（按需补充）

| 类型 | 格式 | 示例 |
|------|------|------|
|（由项目自定义）| | |

---

## 规则文件索引

| 文件 | 内容 |
|------|------|
| `CLAUDE.md` | 本文件 — 项目规则与约定 |
| `.claude/HANDOFF.md` | 交接文档 — 决策 / 踩坑记录 |
| `.claude/settings.json` | Claude Code 权限配置 |

{{CUSTOM_RULES}}
