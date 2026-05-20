# API And Backend

Sources: `API 명세서 2` (`2f9406c3-c488-80bf-9499-d396752ee0c9`), `그룹별 코드북 스냅샷 일괄 조회` (`34d406c3-c488-804b-a23b-f5395460cbdc`), `백엔드 로직 질문` (`35d406c3-c488-800d-92c0-e1e5113293da`).

## API Source Order

- Swagger/OpenAPI is the primary contract source for endpoint shape.
- Notion complements Swagger with policy, state transitions, and implementation notes.
- Admin UI is used for operational verification and profile approval/rejection flows.

## Public API Entry Points

- Swagger UI: `https://test.wingle.kr/api/v1/swagger-ui/index.html`
- Admin page: `https://test.wingle.kr/api/v1/admin.html`
- Codebook snapshot: `GET /api/v1/codebook/snapshot?groups=BODY_TYPE,REGION`
- Codebook current versions: `GET /api/v1/codebook/current-versions`

## Signup Flow

`API 명세서 2` describes signup as a staged backend process:

1. Identity verification stores verified identity temporarily and issues a UUID.
2. Active terms are fetched and accepted terms are stored against the UUID.
3. Required terms are validated before account creation.
4. Password registration combines temporary identity and terms data, creates the user, persists agreements, clears temporary state, and issues session credentials.

## File Domain

File handling is modeled around three responsibilities:

- `files`: canonical file record created or confirmed after upload completion.
- `file_upload`: upload session created when upload URL is issued and completed after backend validation.
- `file_reference`: logical domain reference for profile, post, review, and future usages.

The design intentionally avoids one join table per domain. `file_reference` trades database-level FK strictness for extensibility, so application-level cleanup and validation are required.

## Onboarding State Machine

The backend tracks user onboarding with explicit states:

- `SIGNUP_COMPLETED`: account created after credential registration.
- `BASIC_INFO_COMPLETED`: basic profile registered.
- `JOB_INFO_COMPLETED`: job info registered.
- `EDUCATION_INFO_COMPLETED`: education info registered.
- `PROFILE_COMPLETED`: profile detail registered.
- `AWAITING_APPROVAL`: profile approval requested.
- `PROFILE_APPROVED` / `PROFILE_REJECTED`: admin decision.
- `CHOICE_QUESTION_COMPLETED`: required choice answers completed.
- `ESSAY_QUESTION_COMPLETED`: essay answers completed.
- `ONBOARDING_COMPLETED`: final onboarding completion.

Approval state is separately represented as `PENDING`, `APPROVED`, and `REJECTED`.

## Backend Open Items From Notion

- Rejection reason screen and re-review edit flow are product/API requirements.
- Certificate upload is needed when education email verification cannot be used.
- Uploaded files should be verified by backend after client upload.
- Education/job email verification needs a more robust data collection and review path.

## Implementation Notes

- Avoid screen-shaped temporary APIs. Prefer domain state and action based endpoints.
- Do not trust client-provided codebook or question versions for persistence decisions.
- Cacheable resources should expose lightweight version endpoints and full snapshot endpoints.
