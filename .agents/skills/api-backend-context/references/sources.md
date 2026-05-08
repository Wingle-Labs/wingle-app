# Source Guide

Use sources in this order unless the task clearly needs a different order.

## Swagger UI

- URL: `https://test.wingle.kr/api/v1/swagger-ui/index.html`
- Purpose: quick visual inspection of endpoints, tags, methods, auth markers, request bodies, and response schemas.
- Limitation: some details may be easier to inspect from raw OpenAPI JSON than from the rendered UI.

## OpenAPI JSON

- URL: `https://test.wingle.kr/api/v1/v3/api-docs`
- Purpose: direct machine-readable source for paths, schemas, tags, and security definitions.
- Known facts:
  - title: `Wingle API`
  - version: `v1.0.0`
  - server base: `https://test.wingle.kr/api/v1`
  - global security: `bearerAuth`
- Example tags currently exposed:
  - `Admin`
  - `Auth`
  - `Profile`
  - `Contact`
  - `ChoiceAnswer`
  - `EssayAnswer`
  - `File`
  - `Health`

## Swagger Config

- URL: `https://test.wingle.kr/api/v1/v3/api-docs/swagger-config`
- Purpose: fallback discovery point when Swagger UI loads but the actual OpenAPI source URL needs to be confirmed.

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
