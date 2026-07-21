### TypeScript Library
- 入口用 `src/index.ts`，类型声明用 `src/types.ts`
- 测试用 vitest，配置见 `vitest.config.ts`
- ESLint flat config + Prettier
- 构建用 `tsup` 或 `tsc`
- 发布前跑 `npm run build && npm test`

### 模块边界
- `src/` — 源码
- `test/` — 测试文件
- 公开 API 通过 `src/index.ts` re-export
