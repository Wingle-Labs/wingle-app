# Swagger API Reference

Source: [Swagger UI](https://test.wingle.kr/api/v1/swagger-ui/index.html)

OpenAPI base: `https://test.wingle.kr/api/v1`

Swagger definitions are grouped through
`https://test.wingle.kr/api/v1/v3/api-docs/swagger-config`.

## Definition Groups

### `onboarding`

온보딩, 인증, 프로필, 답변, 파일 presign 등 모바일 온보딩 플로우에서 사용하는 API.

- `POST /auth/login`
- `POST /auth/logout`
- `POST /auth/reissue`
- `POST /auth/signup/terms`
- `POST /auth/signup/profile`
- `POST /auth/signup/password`
- `POST /auth/signup/identity-verification`
- `GET /auth/signup/nickname/random`
- `PUT /user/profile`
- `GET /profiles/me`
- `PUT /user/profile/job`
- `POST /user/profile/job`
- `POST /user/profile/job/email-verifications`
- `POST /user/profile/job/email-verifications/confirm`
- `PUT /user/profile/education`
- `POST /user/profile/education`
- `POST /user/profile/education/email-verifications`
- `POST /user/profile/education/email-verifications/confirm`
- `POST /user/profile/education/certification`
- `POST /profiles/detail`
- `PUT /profiles/detail`
- `POST /profiles/approval/request`
- `POST /profiles/reapply`
- `GET /profiles/rejection-reason`
- `GET /choice-questions/answers`
- `POST /choice-questions/answers`
- `GET /essay-questions/answers`
- `POST /essay-questions/answers`
- `GET /files/presigned/style`
- `GET /files/presigned/face`
- `GET /files/presigned/certification`

### `card`

카드 추천/필터 및 연락처 업로드 관련 API.

- `GET /card/filter`
- `PUT /card/filter`
- `POST /contacts`

### `common`

서비스 시작 전/공통 흐름에서 사용하는 코드북, 약관, 질문, healthcheck API.

- `GET /terms/current-versions`
- `GET /terms/snapshot`
- `GET /codebook/current-versions`
- `GET /codebook/snapshot`
- `GET /choice-questions/current-versions`
- `GET /choice-questions/snapshot`
- `GET /essay-questions/current-versions`
- `GET /essay-questions/snapshot`
- `GET /healthcheck`

### `admin`

관리자 페이지에서만 사용하는 API. 모바일 앱에서 직접 사용하지 않는다.

- `GET /admin/approvals`
- `POST /admin/approvals/{approvalId}/approve`
- `POST /admin/approvals/{approvalId}/reject`
- `GET /admin/onboarding/summary`
- `GET /admin/onboarding/users`
- `GET /admin/rejection-reason-codes`
- `DELETE /admin/users/{userId}`
- `POST /admin/users/{userId}/education/verify`
- `GET /admin/users/{userId}/profile`

## Auth Policy

- Swagger OpenAPI documents declare global `bearerAuth`.
- No per-path public override was found in the grouped documents.
- Implementation may still treat some endpoints as public, but Swagger currently does not mark them that way.

## Implementation Coverage

### Implemented

- `LoginRepositoryImpl`
- `SignupRepositoryImpl`
- `ProfileRepositoryImpl`
- `QuestionRepositoryImpl`
- `FileRepositoryImpl`
- `ContactRepositoryImpl`
- `HealthRepositoryImpl`
- `AnswerRepositoryImpl`
- `TermRepositoryImpl`
- `CodebookRepositoryImpl`
- `CodebookRemoteDataSource`
- `CodebookLocalDataSource`
- `AuthenticatedApiClient`

### Intentionally not implemented yet

- `PassRepositoryImpl`
- `BodyShapeRepositoryImpl` is currently mock-backed
- `PhoneAuthRepositoryImpl` is local Firebase stub

## Test Coverage

- [common/utils/authenticated_api_client_test.dart](/Users/myknow/coding/wingle/test/common/utils/authenticated_api_client_test.dart)
- [common/constants/api_paths_test.dart](/Users/myknow/coding/wingle/test/common/constants/api_paths_test.dart)
- [features/auth/data/repositories/login_repository_impl_test.dart](/Users/myknow/coding/wingle/test/features/auth/data/repositories/login_repository_impl_test.dart)
- [features/onboarding/data/signup_repository_test.dart](/Users/myknow/coding/wingle/test/features/onboarding/data/signup_repository_test.dart)
- [features/onboarding/data/profile_repository_test.dart](/Users/myknow/coding/wingle/test/features/onboarding/data/profile_repository_test.dart)
- [features/onboarding/data/question_repository_test.dart](/Users/myknow/coding/wingle/test/features/onboarding/data/question_repository_test.dart)
- [features/onboarding/data/file_repository_test.dart](/Users/myknow/coding/wingle/test/features/onboarding/data/file_repository_test.dart)
- [features/onboarding/data/contact_repository_test.dart](/Users/myknow/coding/wingle/test/features/onboarding/data/contact_repository_test.dart)
- [features/onboarding/data/health_repository_test.dart](/Users/myknow/coding/wingle/test/features/onboarding/data/health_repository_test.dart)
- [features/onboarding/data/answer_repository_test.dart](/Users/myknow/coding/wingle/test/features/onboarding/data/answer_repository_test.dart)
- [features/onboarding/data/term_repository_impl_test.dart](/Users/myknow/coding/wingle/test/features/onboarding/data/term_repository_impl_test.dart)
- [features/onboarding/data/codebook_repository_test.dart](/Users/myknow/coding/wingle/test/features/onboarding/data/codebook_repository_test.dart)
- [features/onboarding/data/codebook/codebook_local_datasource_test.dart](/Users/myknow/coding/wingle/test/features/onboarding/data/codebook/codebook_local_datasource_test.dart)
- [features/onboarding/data/codebook/codebook_repository_impl_test.dart](/Users/myknow/coding/wingle/test/features/onboarding/data/codebook/codebook_repository_impl_test.dart)

## Live Contract Tests

실제 test server를 대상으로 하는 live contract test는 기본 `flutter test` 셋에 포함된다.
환경 변수는 `lib/app/config/env/live_api.env` 또는 프로세스 환경변수에서 읽는다.

### Required

- `TEST_API_BASE_URL`
- `TEST_API_ACCESS_TOKEN`

### Optional Fixtures

- `TEST_API_REFRESH_TOKEN`
- `TEST_API_LOGIN_PHONE_NUMBER`
- `TEST_API_LOGIN_PASSWORD`
- `TEST_API_SIGNUP_UUID`
- `TEST_API_SIGNUP_PASSWORD`
- `TEST_API_PROFILE_NICKNAME`
- `TEST_API_PROFILE_HEIGHT`
- `TEST_API_PROFILE_RESIDENCE_CODE`
- `TEST_API_PROFILE_BODY_TYPE_CODE`
- `TEST_API_PROFILE_MBTI`
- `TEST_API_PROFILE_INTRODUCTION`
- `TEST_API_PROFILE_COMPANY`
- `TEST_API_PROFILE_OCCUPATION`
- `TEST_API_PROFILE_UNIVERSITY`
- `TEST_API_PROFILE_EDUCATION_LEVEL`
- `TEST_API_IDENTITY_NAME`
- `TEST_API_IDENTITY_PHONE`
- `TEST_API_IDENTITY_CI`
- `TEST_API_IDENTITY_GENDER`
- `TEST_API_IDENTITY_BIRTH`
- `TEST_API_IDENTITY_AGE`
- `TEST_API_CONTACT_PHONE_NUMBERS`
- `TEST_API_ADMIN_ACCESS_TOKEN`
- `TEST_API_ADMIN_USER_ID`
- `TEST_API_ADMIN_DESTRUCTIVE_OK`

### Live Test Files

- [live_api/live_api_public_contract_test.dart](/Users/myknow/coding/wingle/test/live_api/live_api_public_contract_test.dart)
- [live_api/live_api_authenticated_contract_test.dart](/Users/myknow/coding/wingle/test/live_api/live_api_authenticated_contract_test.dart)
- [live_api/live_api_admin_contract_test.dart](/Users/myknow/coding/wingle/test/live_api/live_api_admin_contract_test.dart)
