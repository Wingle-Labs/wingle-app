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
- 매직 넘버를 컴포넌트나 화면에 직접 흩뿌리지 않는다.
- 크기, 두께, 간격, 반경, 아이콘, 애니메이션 시간 등 반복 사용되거나 디자인 시스템 제원에 해당하는 값은 `lib/app/config/theme/constants` 아래의 적절한 상수 집합 파일에 정리한다.
- `constants/color.dart`: 레거시/공통 색상 상수. 가능하면 먼저 `context.colors` semantic token을 사용하고, 정말 공통 색상 상수가 필요할 때만 확장한다.
- `constants/padding.dart`: `EdgeInsets`로 표현되는 안쪽/바깥쪽 여백의 의미 단위 값. 화면 좌우 패딩, 카드 내부 패딩, 버튼 내부 패딩, 액션 마진처럼 특정 컴포넌트의 padding/margin 성격 값은 여기에 둔다.
- `constants/radius.dart`: 둥근 모서리와 squircle smoothing 값. Figma Radius 문서에 있는 6/8/16/18/24px 등 corner radius 제원은 여기에 둔다.
- `constants/spacing.dart`: 위젯 사이 간격, gap, section spacing, 리스트 item 간격처럼 `SizedBox`나 `Gap`으로 쓰이는 거리 값. 2/4/6/8px 단위 간격은 기존 `sN` 토큰을 우선 사용한다.
- `constants/size.dart`: 폰트 크기(`AppFontSize`), 아이콘 크기(`AppIconSize`), 아이콘 터치 영역(`AppIconTouchSize`), 아이콘 제작 그리드/도형 크기, 컴포넌트 높이·너비(`AppContainerSize`), 선 두께(`AppLineWidth`)를 둔다.
- `constants/weight.dart`: 폰트 굵기(`AppFontWeight`)를 둔다.
- 기존 상수 집합에 맞는 파일이 있으면 그 파일을 우선 확장하고, 성격이 다른 상수라면 새 상수 클래스를 만들어 의미 단위로 묶는다.
- 예외적으로 단일 위젯 내부에서만 쓰이는 일회성 레이아웃 보정값은 private 상수로 둘 수 있으나, 재사용 가능하거나 Figma/디자인 시스템에 명시된 값이면 공용 상수로 승격한다.
- 디자인 시스템 또는 공용 컴포넌트를 추가/수정하면 Widgetbook도 함께 갱신한다.
- Widgetbook은 Light Mode를 기본값으로 두고, 선택지는 `Light / Dark / System`을 유지한다.

## Verification

- 공용 컴포넌트, 토큰, 라우팅, 상태 흐름을 수정한 경우 `flutter analyze`와 `flutter test`를 실행한다.
- Widgetbook 전용의 좁은 변경은 최소 `flutter analyze`를 실행한다.

## Staging

- 작업을 완료하면 커밋 전에 반드시 작업 범위를 확인하고, 논리적으로 구분되는 변경만 선별해서 staging 한다.
- 워크트리에 이전 작업이나 사용자 변경이 섞여 있을 수 있으므로 `git status --short`와 `git diff`를 확인한 뒤 현재 작업에 속한 파일 또는 hunk만 `git add` 한다.
- 하나의 요청 안에서도 문서, 디자인 시스템 컴포넌트, 기능 구현처럼 성격이 다른 변경은 가능한 한 별도 커밋으로 분리한다.
