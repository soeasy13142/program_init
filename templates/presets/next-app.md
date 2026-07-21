### Next.js App
- App Router 约定
- 服务端组件优先，客户端组件用 `"use client"`
- API 路由在 `app/api/` 下
- 数据获取在 Server Component 中直接 async
- Tailwind CSS 样式

### 模块边界
- `app/` — Next.js App Router 页面和 API
- `components/` — 可复用 React 组件
- `lib/` — 工具函数和 API 客户端
- `types/` — TypeScript 类型定义
