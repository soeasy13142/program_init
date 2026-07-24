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

**不确定必问，已约直行。** 不在 CLAUDE.md / HANDOFF.md 中 → 问。在 → 执行。
怀疑 → 回退到问。

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

{{CUSTOM_RULES}}

