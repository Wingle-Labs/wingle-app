# Source Guide

Use sources in this order unless the task clearly needs a different order.

## Swagger UI

- URL: `https://test.wingle.kr/api/v1/swagger-ui/index.html`
- Purpose: quick visual inspection of endpoints, tags, methods, auth markers, request bodies, and response schemas.
- Definition groups:
  - `onboarding`: 온보딩, 인증, 프로필, 답변, 파일 presign 등 모바일 온보딩 플로우 API
  - `card`: 카드 추천/필터 및 연락처 업로드 API
  - `common`: 코드북, 약관, 질문, healthcheck 등 서비스 시작 전/공통 API
  - `admin`: 관리자 페이지에서만 사용하는 API
- Limitation: some details may be easier to inspect from raw OpenAPI JSON than from the rendered UI.

## OpenAPI JSON Groups

- Swagger config URL: `https://test.wingle.kr/api/v1/v3/api-docs/swagger-config`
- Group URLs:
  - `https://test.wingle.kr/api/v1/v3/api-docs/onboarding`
  - `https://test.wingle.kr/api/v1/v3/api-docs/card`
  - `https://test.wingle.kr/api/v1/v3/api-docs/common`
  - `https://test.wingle.kr/api/v1/v3/api-docs/admin`
- Purpose: direct machine-readable source for paths, schemas, tags, and security definitions.
- Known facts:
  - title: `Wingle API`
  - version: `v1.0.0`
  - server base: `https://test.wingle.kr/api/v1`
  - global security: `bearerAuth`
- Current grouped path counts as of 2026-05-28:
  - `onboarding`: 26 paths
  - `card`: 2 paths
  - `common`: 9 paths
  - `admin`: 9 paths

## Swagger Config

- URL: `https://test.wingle.kr/api/v1/v3/api-docs/swagger-config`
- Purpose: discovery point for grouped OpenAPI source URLs and definition names.

## Notion API Docs

- URL: `https://myknow.notion.site/API-2-2f9406c3c48880bf9499d396752ee0c9?source=copy_link`
- Purpose: business rules, workflow semantics, field meanings, and supplementary backend context.
- Usage:
  - consult when Swagger names are ambiguous
  - consult when product policy matters more than wire shape
  - consult when implementing onboarding or approval-related logic
- If the page returns 404 or requires access, report that and continue with confirmed Swagger/admin evidence only.

## Admin Page

- URL: `https://test.wingle.kr/api/v1/admin.html`
- Purpose: validate approval flows, onboarding states, admin-facing labels, and operational visibility.
- Use only when the task needs runtime or operator-facing confirmation.
