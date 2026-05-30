# TODO: /profiles/me API 후속 정리

## 배경

- 현재 `POST /auth/login`과 `POST /auth/reissue`는 기본 프로필 입력값을 반환하지 않는다.
- 따라서 `BASIC_INFO_COMPLETED` 이후 회사/체형 입력 단계로 진입해도, 서버 기준의 닉네임/거주지/키/체형을 복원할 수 없다.
- 현재 앱은 같은 기기/같은 유저에 한해 Hive 로컬 스냅샷으로 기본 프로필 입력값을 복원한다.

## BE 요청

- 인증 필요: Bearer access token
- 현재 Swagger 엔드포인트: `GET /profiles/me`
- 목적: 로그인/토큰 재발급 후 현재 유저의 프로필 입력값을 서버 기준으로 복원한다.

## 클라이언트가 필요한 필드

- `nickname`
- `residenceCode`
- `height`
- `bodyTypeCode`

## 클라이언트 준비 구현

- `ProfileRepository.fetchMyBasicProfile()`를 추가해 서버 스냅샷 조회 지점을 마련한다.
- 서버가 `GET /profiles/me`를 제공하므로 Swagger 응답 스키마 기준으로 파싱을 유지한다.
- 앱 부팅 시 인증 세션 복구가 성공하면 `/profiles/me` 스냅샷을 시도하고, 값이 있으면 Hive 기본 프로필 스냅샷을 갱신한다.
- 로그인 성공 후에도 같은 스냅샷 동기화를 시도한다.

## 완료 조건

- Swagger/OpenAPI `onboarding` 그룹에 `GET /profiles/me`가 유지된다.
- 실제 응답 필드와 `LoginBasicProfile.fromJson` 파싱 키가 일치하는지 확인한다.
- `404/405` 임시 허용 로직을 제거하거나, 명시적인 feature flag로 전환한다.
