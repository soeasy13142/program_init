## 变更摘要

请清晰、简洁地说明此 PR 做了哪些更改，以及为什么需要这些更改。

## 关联 Issue

关闭 #（填写关联的 Issue 编号）

## 测试说明

请描述你是如何测试这些变更的：

- [ ] 在本地运行 `./bin/project-init -n test-proj -t cli-tool -y` 通过
- [ ] 在本地运行 `./bin/project-init -n test-web -t web-app -y` 通过
- [ ] 已添加或更新相关测试

## 兼容性检查

请确认你的变更在以下环境中均能正常工作：

- **Shell 类型**:（请勾选已测试的）
  - [ ] bash
  - [ ] zsh
  - [ ] dash（Debian/Ubuntu）
- **操作系统**:（请勾选已测试的）
  - [ ] macOS
  - [ ] Linux（Ubuntu / Debian）
  - [ ] 其他（请注明：\_\_\_\_）

## 代码质量

- [ ] 无 bashisms（`[[ ]]`、`source`、`local` 等）
- [ ] 无硬编码路径
- [ ] 所有日志调用统一使用 `log_*` 函数
- [ ] 函数名使用 `snake_case`
- [ ] 全局常量使用 `UPPER_SNAKE_CASE`

## 额外说明

在此处添加任何审查者需要注意的额外信息。
