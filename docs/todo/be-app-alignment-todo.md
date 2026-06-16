# BE-APP 정합성 수정 TODO

Last checked: 2026-06-16 KST

## Scope

- 기준 BE 저장소: `/Users/myknow/coding/wingle-be`
- 기준 BE 브랜치: `dev`
- 기준 BE HEAD: `d7e11b3`
- 목적: 현재 Flutter APP 구현 중 BE Swagger/소스 사양과 불일치하거나, BE 사양상 위험한 요청을 발생시킬 수 있는 부분을 수정한다.

## Sources

- Swagger/OpenAPI
  - `https://test.wingle.kr/api/v1/v3/api-docs/onboarding`
  - `https://test.wingle.kr/api/v1/v3/api-docs/card`
  - `https://test.wingle.kr/api/v1/v3/api-docs/common`
- BE source
  - `/Users/myknow/coding/wingle-be/src/main/java/org/kr/wingle/wingle`
- 기존 APP TODO
  - `TODO.md`
  - `docs/todo/me-profile-api-todo.md`

## Legend

- `[ ]` APP에서 바로 수정할 항목
- `[~]` BE 보완 또는 정책 확인이 필요한 항목
- `[x]` 이미 앱 구현 방향과 BE 사양이 맞는 항목

## P0: 앱 요청/상태 전이를 BE 사양에 맞출 항목

- [x] 주관식 선택 문항 스킵 시 빈 배열 POST를 보내지 않는다.
  - BE evidence: `SaveEssayAnswersRequest.answers`는 `@NotEmpty`.
  - BE behavior: 상태 전이는 `CHOICE_QUESTION_COMPLETED` 상태에서 필수 주관식 답변이 모두 있을 때만 `ESSAY_QUESTION_COMPLETED`.
  - APP target: 선택 주관식만 스킵하는 경우 `/essay-questions/answers`를 호출하지 않고, 이미 필수 주관식 저장으로 상태가 전환됐는지 `/profiles/me` 또는 로컬 상태로 확인한 뒤 연락처 차단 단계로 이동한다.

- [x] 연락처 차단 스킵은 빈 배열 업로드가 아니라 `POST /contacts/skip`을 사용한다.
  - BE evidence: `UploadContactsRequest.phoneNumbers`는 `@NotEmpty`, `@Size(max = 500)`.
  - BE behavior: `skipContacts`는 `ESSAY_QUESTION_COMPLETED` 상태에서만 `ONBOARDING_COMPLETED`로 전환한다.
  - APP target: 연락처 스킵 버튼은 반드시 `/contacts/skip`을 호출하고, 성공 후 `/profiles/me` 동기화로 `ONBOARDING_COMPLETED`를 반영한다.

- [x] 연락처 업로드 전 전화번호를 `010-XXXX-XXXX` 형식으로 정규화한다.
  - BE evidence: Swagger 설명은 `010-XXXX-XXXX` 형식 요구.
  - APP target: iOS/Android 연락처에서 `+82`, 공백, 괄호, 하이픈 없는 번호를 수집해도 서버 전송 전 동일 형식으로 정규화하고, 유효하지 않은 번호는 제외한다.

- [x] 세부 프로필 제출은 S3 key만 보내고 presigned URL을 저장하지 않는다.
  - BE evidence: `/profiles/detail`은 `mainStylePhotoKey`, `subStylePhotoKeys`, `mainFacePhotoKey`, `subFacePhotoKeys`를 받는다.
  - BE validation: style key는 `users/{userId}/style/`, face key는 `users/{userId}/face/` prefix를 가져야 한다.
  - APP target: 업로드 완료 후 저장하는 값과 수정 모드 복원 값이 URL이 아니라 `s3Key`인지 점검한다.

- [x] 학력 정보 등록/수정 시 `university`와 `customUniversityName` 중 정확히 하나만 보낸다.
  - BE evidence: 등록 서비스는 둘 다 null이거나 둘 다 있으면 400.
  - BE gap: 수정 서비스에는 동일 검증이 빠져 있으므로 APP 방어가 더 중요하다.
  - APP target: 코드북 대학교 선택 시 `university`만, 직접 입력/고등학교/기타 학교명 입력 시 `customUniversityName`만 전송한다.

- [x] 학적 증명서 업로드 UI에서 PDF 선택/전송을 막거나 비활성화한다.
  - BE evidence: `/files/presigned/certification` contentType은 `image/jpeg`, `image/png`, `image/webp`만 허용.
  - APP target: BE PDF 지원 전까지 문서 picker의 PDF 허용을 제거하거나, PDF 선택 시 명확한 안내를 띄운다.

- [x] API 오류 파서는 `{ "message": "..." }`를 우선 읽는다.
  - BE evidence: `GlobalExceptionHandler`는 400 응답을 `ErrorResponse(message)`로 반환한다.
  - APP target: 이메일 인증 실패, 파일 타입 실패, 상태 전이 실패 등에서 서버 message를 토스트/필드 에러 정책에 맞게 노출한다.

## P1: 화면/데이터 모델을 BE 응답 형태에 맞출 항목

- [~] `GET /cards` 응답을 배열이 아니라 객체로 파싱한다.
  - BE response: `{ "initial": [], "refresh": [], "refreshUsedToday": 0, "refreshLimitPerDay": 2 }`
  - APP target: 오늘의 카드 조회 모델을 `TodayCardsResponse` 형태로 맞추고 기존 배열 가정이 있으면 제거한다.
  - Current APP: 카드 feature/repository가 아직 없어 수정 대상 코드 없음. 카드 구현 시 선반영할 계약.

- [~] `POST /cards`와 `POST /cards/refresh`는 배열 응답으로 유지한다.
  - BE response: `List<ProfileCardResponse>`
  - APP target: 최초 발급/재추첨과 오늘 카드 조회 DTO를 분리한다.
  - Current APP: 카드 feature/repository가 아직 없어 수정 대상 코드 없음. 카드 구현 시 선반영할 계약.

- [x] FCM 토큰은 로그인 성공 및 토큰 갱신 시 `POST /notifications/token`으로 등록한다.
  - BE behavior: 승인/반려 시 `PROFILE_REVIEW_RESULT` push data를 발송한다.
  - APP target: access token이 없는 상태에서는 등록하지 않고, 로그인/세션 복구 이후 등록한다.

- [x] 승인/반려 push 수신 시 `/profiles/me`를 재조회해 라우팅한다.
  - BE push data: `eventType=PROFILE_REVIEW_RESULT`, `status=APPROVED|REJECTED`.
  - APP target: push payload만 믿지 않고 서버 상태를 동기화한 뒤 승인 완료/반려 화면으로 이동한다.

- [x] 자기소개 길이 정책을 BE 기준과 앱 UX 기준으로 분리한다.
  - BE evidence: `/profiles/detail`의 `selfIntroduction`은 최소 1자, 최대 1000자.
  - APP target: 앱이 100자 이상 등 더 엄격한 UX 가이드를 적용한다면 서버 오류가 아니라 클라이언트 가이드로 명시하고, BE DTO/Repository 검증은 1~1000 기준을 허용한다.

- [x] 주관식 질문 답변 길이는 200~1000자로 유지한다.
  - BE evidence: `EssayAnswerItemRequest.content`는 `@Size(min = 200, max = 1000)`.
  - APP target: 자기소개와 주관식 질문의 길이 검증을 혼동하지 않는다.

## P2: BE 보완 요청 또는 방어적 앱 처리 필요

- [~] 카드 응답의 `stylePictureUrl`/`facePictureUrl`이 실제 URL인지 확인한다.
  - BE source finding: `CardService.toResponse()`는 현재 presigned URL이 아니라 `UserPhoto.s3Key`를 그대로 넣는다.
  - Risk: 앱이 이 필드를 이미지 URL로 렌더링하면 로딩 실패 가능.
  - APP fallback: 값이 `http`로 시작하지 않으면 이미지 요청을 하지 않고 placeholder를 표시한다.
  - BE request: `FileService.generateGetPresignedUrl(s3Key)`로 내려주도록 수정 요청.

- [x] 학적 증명서 key 소유권 검증은 BE에 아직 없다.
  - BE source finding: `uploadCertification()`은 `certificationKey`를 그대로 저장한다.
  - APP target: 앱은 `users/{userId}/certification/` prefix의 key만 저장하도록 방어한다.
  - APP done: Repository에서 `users/{userId}/certification/` 형식만 등록 API로 통과시킨다.
  - BE request: style/face와 동일한 s3Key ownership 검증 추가.

- [~] 파일 업로드 완료 확인/삭제 API는 아직 없다.
  - BE source finding: 현재는 presigned PUT URL 발급만 제공.
  - APP target: 업로드 성공 후 domain API에 key를 제출하는 구조 유지.
  - BE request: 추후 파일 삭제/교체/업로드 완료 검증 API가 생기면 Repository 인터페이스의 unsupported 구현 제거.

## Already Aligned

- [x] `/profiles/me` 기반 온보딩 상태 동기화.
  - BE response includes `onboardingStatus`.

- [x] 프로필 반려 사유 구조.
  - BE response: `reasons[]`, `reviewedAt`.

- [x] 재심사 요청.
  - BE endpoint: `POST /profiles/reapply`, body 없음.

- [x] 코드북/질문 snapshot은 인증 없이 bootstrap 가능.
  - BE security whitelist includes codebook, choice question snapshot, essay question snapshot.

## Verification Plan

- [x] APP 변경 전 관련 Repository/Provider 테스트 위치 확인
- [x] 연락처 업로드/스킵 단위 테스트
- [x] 주관식 선택 스킵 라우팅 테스트
- [~] 카드 응답 DTO 파싱 테스트
  - 카드 feature/repository 부재로 현재 추가 대상 없음.
- [x] 파일 contentType/extension 정책 테스트
- [x] `flutter analyze`
- [x] 관련 `flutter test`
- [x] 필요 시 `flutter test` 전체 실행
