# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

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
- 语言: {{LANGUAGE}}
- 框架: {{FRAMEWORK}}
- 测试框架: {{TEST_FRAMEWORK}}
- 运行时: {{RUNTIME}}

## 模块约定
以下内容由项目类型预设填充

{{PRESET_CONTENT}}

{{CUSTOM_RULES}}
