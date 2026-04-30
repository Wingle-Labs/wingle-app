# Wingle Agent Instructions

## Communication

- 기본 답변 언어는 한국어로 한다.
- 작업 결과는 변경 파일, 검증 명령, 남은 리스크를 중심으로 간결하게 보고한다.

## Commit Messages

- 커밋 메시지는 Conventional Commit 형식을 사용한다.
- 헤더 타입은 영어로 유지하고, 콜론 뒤 설명은 한국어로 작성한다.
- 예시:
  - `feat: 기본 프로필 입력 플로우 구현`
  - `fix: 로그인 상태 리다이렉트 오류 수정`
  - `refactor: StepIndicator 공용 컴포넌트 분리`

## Design System

- 공용 UI 컴포넌트와 토큰은 `lib/app/config/theme` 아래 기존 구조를 우선 따른다.
- 디자인 시스템 또는 공용 컴포넌트를 추가/수정하면 Widgetbook도 함께 갱신한다.
- Widgetbook은 Light Mode를 기본값으로 두고, 선택지는 `Light / Dark / System`을 유지한다.

## Verification

- 공용 컴포넌트, 토큰, 라우팅, 상태 흐름을 수정한 경우 `flutter analyze`와 `flutter test`를 실행한다.
- Widgetbook 전용의 좁은 변경은 최소 `flutter analyze`를 실행한다.
