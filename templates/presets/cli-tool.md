### 入口与日志
- 入口脚本用 `#!/usr/bin/env {{SHEBANG}}` + `set -euo pipefail`
- 使用统一的日志输出（`log_info/success/warn/error`），不得用裸 `echo`
- 所有用户可见文本使用国际化变量（`MSG_*`）

### 幂等性
- 多次执行必须安全、无副作用
- 修改配置文件前先备份原始文件

### 模块边界
{{MODULE_BOUNDARIES}}

### 测试
- 新增函数/脚本必须有对应测试
- 修改安全模块后必须运行安全相关测试
