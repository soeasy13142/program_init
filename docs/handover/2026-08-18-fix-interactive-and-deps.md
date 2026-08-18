# 交互模式与依赖检查修复 — 2026-08-18

## Summary

排查并修复 .claude/HANDOFF.md 中记录的两个遗留问题（envsubst 依赖、非终端 stdin），
过程中发现并修复了一个更严重的隐藏 bug：交互式 Q&A 的提示符被 $(...) 命令替换捕获，污染变量值，导致交互模式必然失败。

## 问题排查结论（均为实测验证）

### 1. envsubst 依赖 — 真实存在，且文档说法错误

- check_dependencies envsubst 只在 full 模式调用（旧 bin/project-init:201），claude-only（-c）完全绕过检查，缺失时裸崩溃（exit 127，envsubst: command not found），且 .claude/、HANDOFF 已先写入（半成品副作用）
- README 声称 envsubst「macOS / Linux 预装」与事实不符：本机来自 Homebrew（/opt/homebrew/bin/envsubst）；项目自己的 CI 也需在 Linux 装 gettext-base、macOS 装 gettext
- full 模式缺失时原本就能优雅报错（Missing dependency: envsubst）

### 2. 非 -y 模式 stdin 非终端 — 真实存在，但记录描述不准确

- HANDOFF 记录为「read 静默返回空值」；实测是 read 撞 EOF 返回非零 → set -e → 整个脚本静默退出（exit 1，零输出），/bin/sh 与 dash 一致
- 微测试：去掉 set -e 时 read 在 EOF 处确实 rc=1 且变量留空（当时大概据此记录），但漏了 set -e 会先杀进程

### 3.（新发现）交互模式整体损坏 — 提示符污染变量值

- ask_* 函数把提示符/菜单打到 stdout，而入口用 $(...) 命令替换取值 → 提示文本一并被捕获
- 实测：PROJECT_NAME 变成「  项目名称 [x]: demo」、PROJECT_TYPE 变成整个菜单文本 → 端到端必然报 Unknown project type，交互模式永远无法生成 CLAUDE.md；真实终端下连提示符都看不到
- collect_all 同样受影响（bats 旧断言用子串匹配 *...*，污染后仍通过，未拦住回归）

## 修复内容

| 文件 | 改动 |
|------|------|
| lib/questions.sh | 所有提示符/菜单改走 stderr（>&2）；stdout 只输出数据值；read 增加 EOF 兜底（read ... || { 提示已中断; exit 1; }） |
| bin/project-init | 依赖检查提前到任何提示/文件生成之前（full: git envsubst；claude-only: envsubst），删除 full 块内的旧检查；新增非终端 stdin 守卫（非 -y 且 stdin 非终端 → 指引 -y 并 exit 1） |
| README.md | 更正 envsubst 依赖说明（macOS 需 brew install gettext，Linux 需 gettext-base） |
| tests/questions.bats | 断言改为精确匹配（=），新增「stdout 不含提示文本」断言；collect_all 输入显式补空行终止规则循环 |
| tests/entry.bats | 新增入口集成测试：tty 守卫、claude-only/full 缺 envsubst 优雅失败且无副作用、-y 端到端生成干净 CLAUDE.md |

## 验证记录

1. sh -n、dash -n 全部通过；shellcheck 无新告警
2. bats tests/：23/23 通过（新增 entry.bats 4 个 + questions.bats 精确断言）
3. 真实 pty（python3 pty 模块驱动）交互流程：提示符可见、exit 0、CLAUDE.md 零污染（# demo、语言: JavaScript/TypeScript、自定义规则正确注入）
4. tty 守卫：project-init -t cli-tool < /dev/null → 明确报错 + 指引，exit 1，无 .claude 残留（/bin/sh 与 dash 均验证）
5. claude-only 缺 envsubst（PATH=/usr/bin:/bin）：Missing dependency: envsubst，exit 1，目标目录完全干净（修复前会残留 .claude/ + HANDOFF）
6. -y 与 -c 正常路径回归：均 exit 0，CLAUDE.md 正确生成

## Next Steps

- 如发布新版本，建议 bump 到 v0.1.1（语义化版本，破坏性为 0，纯修复）
- 可考虑将 install.sh 安装说明同步补充 envsubst 依赖提示
- collect_all 目前入口未使用（直接逐个调用 ask_*），可考虑后续让入口复用 collect_all 减少重复
