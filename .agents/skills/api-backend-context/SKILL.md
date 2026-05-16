---
name: api-backend-context
description: Use when working on backend API tasks for the Wingle project, including Swagger/OpenAPI inspection, endpoint/schema confirmation, admin flow verification, backend integration, API debugging, and checking policy details in the linked Notion API docs before implementation.
---

# API Backend Context

Use this skill for Wingle API-related work in `/Users/myknow/coding/wingle`.

Trigger this skill when the task involves:

- API 명세 확인
- Swagger 확인
- backend 또는 BE 연동
- 엔드포인트/스키마 확인
- 실제 서버 기준 API 디버깅
- 관리자 페이지를 통한 운영 상태 확인

## Sources

- Swagger UI: `https://test.wingle.kr/api/v1/swagger-ui/index.html`
- OpenAPI JSON: `https://test.wingle.kr/api/v1/v3/api-docs`
- Swagger config: `https://test.wingle.kr/api/v1/v3/api-docs/swagger-config`
- Admin page: `https://test.wingle.kr/api/v1/admin.html`
- Notion API docs: `https://myknow.notion.site/API-2-2f9406c3c48880bf9499d396752ee0c9?source=copy_link`

Read [references/sources.md](references/sources.md) before using these sources in earnest. Read [references/admin-access.md](references/admin-access.md) when the task needs admin verification.

## Required Workflow

1. Check Swagger UI first. If the UI does not expose enough detail, fetch the OpenAPI JSON or swagger-config endpoint directly.
2. Check the Notion API docs for business rules, naming conventions, onboarding policy, or field semantics that Swagger does not explain.
3. Use the admin page only when the task needs operational confirmation, approval-state inspection, or behavior validation against live-like data.
4. Only after those checks, design repository interfaces, DTOs, mock/real API switching points, or integration code.

## Working Rules

- Treat Swagger/OpenAPI as the primary source of truth for endpoint shape.
- Treat Notion as the primary source of truth for policy and supplementary backend context.
- If Swagger, OpenAPI JSON, Notion, or admin is unavailable, state that explicitly and continue only with confirmed facts.
- Do not store admin credentials in repo-tracked files. Use separately provided private credentials at execution time.
- When summarizing an API, include the endpoint, method, auth requirement, key request fields, and key response fields.
- When implementing a client or repository, preserve easy switching between mock data and real API integration.

## Notes

- The discovered OpenAPI server base is `https://test.wingle.kr/api/v1`.
- The current OpenAPI document advertises bearer token auth via `bearerAuth`.
