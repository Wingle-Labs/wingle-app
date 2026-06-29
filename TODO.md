# Wingle Onboarding Risk TODO

Last checked: 2026-06-15 KST

## Scope
- PASS live verification is excluded from this checklist by request.
- This list only marks non-PASS onboarding risks against the current Notion docs, Swagger/OpenAPI, and app code.

## Sources
- Notion: `API 명세서(1) - 온보딩 관련`
  - https://app.notion.com/p/2f9406c3c48880bf9499d396752ee0c9
- Notion: `상태 정리` 0615 version
  - https://app.notion.com/p/2e9406c3c48880f896c7f1abbe751597
- Swagger/OpenAPI
  - https://test.wingle.kr/api/v1/v3/api-docs/onboarding
  - https://test.wingle.kr/api/v1/v3/api-docs/common

## Legend
- `[ ]` Implementable now: Notion policy and Swagger endpoint/schema exist, but app code is still incomplete or mock-backed.
- `[~]` Partial/blocked: Notion mentions it, but Swagger or design assets are missing, so app-only implementation would be speculative.
- `[x]` Confirmed: Swagger and app implementation basis are already present.

## Implementable Now

- [x] Replace residence mock code with `REGION` codebook lookup.
  - Evidence: Swagger common has `GET /api/v1/codebook/snapshot?groups=REGION`; Notion Part 2 requires residence in basic profile.
  - Current app risk: `BasicProfileResidence` and `BasicProfileProvider` still derive a stable mock `ResidenceCode` from free text.
  - Implementation target: load cached/remote `CodebookGroup.region`, provide searchable/selectable regions, and submit the selected server code.

- [x] Replace body shape mock repository with `BODY_TYPE` codebook.
  - Evidence: Swagger common has `GET /api/v1/codebook/snapshot?groups=BODY_TYPE`; Notion Part 2 requires body type in basic profile.
  - Current app risk: `BodyShapeRepositoryImpl.fetchBodyShapeCodebook()` still returns `BodyShapeCodebook.mock()`.
  - Implementation target: map `CodebookGroup.bodyType` entries into the existing body shape UI model and add regression tests.

- [x] Remove or retire the legacy `selectiveSelfIntro` mock flow.
  - Evidence: Latest policy treats essay questions as optional; Swagger exposes `/essay-questions/snapshot` and `/essay-questions/answers`.
  - Current app risk: `selective_self_intro_mock_data.dart` and `SelectiveSelfIntro` route still exist, while the real essay question flow is already API-backed.
  - Implementation target: audit route references, remove dead mock UI if unused, or hard-disable it behind the current essay question flow.

- [x] Lock down unknown university handling with tests.
  - Evidence: Swagger `RegisterEducationRequest` allows exactly one of `university` or `customUniversityName`; Notion TODO says unknown schools should be accepted through "other/direct input".
  - Current app basis: `EducationProfile` already sends `customUniversityName` when no `UNIVERSITY` codebook entry matches.
  - Implementation target: add focused tests for codebook match, custom school name, and high-school/no-school-name submission.

- [x] Add regression tests for education certification fallback.
  - Evidence: Swagger has `GET /files/presigned/certification` and `POST /user/profile/education/certification`; Notion TODO calls out school email difficulty and certificate photo fallback.
  - Current app basis: certification presign/upload/submit methods exist.
  - Implementation target: test email fallback path, `certificationKey` submission, and rejected-state education update behavior.

## Partial Or Blocked

- [~] File upload completion verification and file delete/update API.
  - Evidence: Notion defines `files`, `file_upload`, `file_reference`, and asks for upload verification plus photo edit/delete presigned features.
  - Swagger gap: current onboarding/common Swagger only exposes presigned URL endpoints for `style`, `face`, and `certification`; no upload-complete, file lookup, or delete endpoint is exposed.
  - Current app risk: `FileRepositoryImpl` intentionally throws `UnsupportedError` for upload-complete, file lookup, and delete APIs.
  - Decision: keep S3 PUT + domain key submission for now; request backend Swagger endpoints before app-side verification/delete.

- [~] Reset password and phone-number change placeholder screens.
  - Evidence: app routes exist for `reset-password` and `change-phone-number`.
  - Swagger gap: onboarding/common Swagger exposes `/auth/signup/password`, but no reset-password or change-phone endpoint.
  - Decision: do not implement real flows until Swagger defines request/response and token policy.

- [~] Email verification duplicate/logging/prefix policy.
  - Evidence: Notion TODO mentions email log accumulation, school/job prefix refactor, and duplicate email prevention.
  - Swagger basis: separate job and education email verification endpoints already exist.
  - Gap: no explicit duplicate-check/logging contract is exposed to the app.
  - Decision: app can keep endpoint separation and error display, but duplicate/log semantics need backend contract or documented error codes.

- [~] Essay question full skip server transition.
  - Evidence: Product policy confirmed on 2026-06-28 that essay questions have no required items and may be skipped entirely.
  - Swagger/BE gap: `/essay-questions/answers` requires a non-empty `answers` list and current BE checks required essay answers before `ESSAY_QUESTION_COMPLETED`.
  - Current app basis: essay skip does not POST an empty array and moves to the contact step locally.
  - Decision: backend should remove required essay completion checks or expose an essay skip transition before contact upload/skip can reliably complete onboarding.

- [~] Approval pending illustration/image area.
  - Evidence: Notion/Figma-like flow expects a visual area for approval pending/completion.
  - Swagger gap: not API-driven.
  - Current app risk: `ProfileApprovalPendingPage` still uses a Flutter `Placeholder()`.
  - Decision: replace when design asset or approved generated asset is available.

## Confirmed Or Already Implemented

- [x] Latest onboarding status order is reflected by API basis.
  - Evidence: 0615 Notion state doc defines `ONBOARDING_COMPLETED` after contact upload or skip; essay question policy was corrected on 2026-06-28 to allow full skip.
  - Swagger basis: `/essay-questions/answers`, `/contacts`, and `/contacts/skip` exist.

- [x] Contact upload/skip is implementable and present.
  - Evidence: Swagger has `POST /contacts`, `DELETE /contacts`, and `POST /contacts/skip`; `/contacts/skip` explicitly transitions `onboardingStatus` to `ONBOARDING_COMPLETED`.
  - Current app basis: `ContactRepositoryImpl`, device contact service, and contact block page/providers exist.

- [x] FCM token registration is implementable and present.
  - Evidence: Swagger common has `POST /notifications/token` with `RegisterFcmTokenRequest.token`.
  - Current app basis: `features/notification` repository/service/provider exists and `main.dart` wires the FCM token service.

- [x] Rejection reason/reapply flow is implementable and present.
  - Evidence: Swagger has `/profiles/rejection-reason`, `/profiles/reapply`, and `/profiles/me`.
  - Current app basis: rejection reason model/provider/page and rejected edit mode exist.

- [x] Profile detail submission and approval request are implementable and present.
  - Evidence: Swagger has `POST/PUT /profiles/detail` and `POST /profiles/approval/request`.
  - Current app basis: MBTI, photo, self-introduction, detail submit, and approval request flow have repository/page/provider coverage.

- [x] Choice questions are implementable and present.
  - Evidence: Swagger common has choice question snapshot/current versions, and onboarding has `/choice-questions/answers`.
  - Current app basis: choice question page/provider/tests exist, including scroll-to-first-incomplete behavior.

## Excluded

- [ ] PASS live verification.
  - Reason: explicitly excluded from this risk pass. Current app still keeps PASS behind mock-ready switching until a separate PASS implementation task is opened.
