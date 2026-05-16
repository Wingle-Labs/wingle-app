# Grid Widgetbook 구현 TODO

## 목적

Figma의 Grid 관련 4개 정의 이미지를 기준으로 Widgetbook `Foundations`에 Grid 문서를 구현한다.

구현 대상:

- [x] 화면(Screen): 모바일/태블릿/데스크톱 기준 폭과 safe area, 앱 화면 캔버스 정의
- [x] 간격(Spacing): 2/4/6/8/12/16/24/32/40/48/56/64 기준과 예외 규칙
- [x] Breakpoint: `mobile-sm`부터 `desktop`까지 최종 breakpoint 설계
- [x] Grid Preview: breakpoint별 grid spec, padding, gutter, column 변화를 실제로 확인하는 인터랙티브 프리뷰

## 현재 코드 상태

관련 파일:

- `lib/app/config/theme/layout/app_breakpoints.dart`
- `lib/app/config/theme/layout/app_grid_spec.dart`
- `lib/app/config/theme/layout/app_layout_tokens.dart`
- `lib/app/config/theme/layout/grid_metrics.dart`
- `lib/app/config/theme/layout/widgets/grid_container.dart`
- `lib/app/config/theme/layout/widgets/grid_row.dart`
- `lib/app/config/theme/layout/widgets/grid_span.dart`
- `lib/app/config/theme/layout/widgets/grid_ratio_span.dart`
- `lib/app/config/theme/layout/extensions/context_layout.dart`

현재 breakpoint는 `xs / md / xl` 3단계다.

현재 layout preset은 `xsMobile`, `mdTabletThreeCol`, `mdTabletTwoCol`, `xlDesktopTwelveCol`, `xlDesktopAsymmetric` 중심이다.

이미지 기준 최종 breakpoint는 7단계라 현재 구현과 차이가 있다.

## 정의 이미지 기준 정리

### 1. 화면

이미지에서 확인되는 화면 기준:

- 모바일 화면 기준을 먼저 시각화한다.
- 세로 화면에서는 좌우 safe area와 하단 navigation 영역을 함께 보여준다.
- 가로/태블릿/데스크톱에서는 앱 캔버스가 중앙에 놓이고, 화면 폭에 따라 콘텐츠 영역이 확장된다.
- Widgetbook에서는 실제 기기 이미지를 쓰기보다, 토큰 기반 mock device frame으로 구현한다.

구현 항목:

- [x] `Screen Size` 섹션 추가
- [x] 모바일/대형 모바일/태블릿/데스크톱 폭 프리셋 제공
- [x] 각 프리셋별 canvas width와 content width를 시각화
- [x] safe area, navigation bar, content 영역을 색상으로 구분

### 2. 간격

이미지 기준:

- 기본 여백은 4의 배수를 사용한다.
- 예외적으로 정밀 보정이 필요한 경우 2의 배수를 사용한다.
- 시각 보정이 더 필요하면 1px 단위까지 조정할 수 있다.
- 기준 값: `2, 4, 6, 8, 12, 16, 24, 32, 40, 48, 56, 64`

현재 `AppSpacing`과 비교할 항목:

- [x] 위 값들이 모두 토큰화되어 있는지 확인
- [x] 누락된 값은 `AppSpacing`에 추가할지, Grid 전용 visual token으로 둘지 결정
- [x] 기존 `SpacingPage`와 중복될 수 있으므로 Grid 문서에서는 "간격 규칙이 Grid에 어떻게 쓰이는지"를 보여준다.

구현 항목:

- [x] `Spacing Scale` 섹션 추가
- [x] 2px 보정값은 red line, 4px 이상 기본값은 blue band로 표현
- [x] 각 band 중앙에 값 chip 표시
- [x] `훑어보기` 예시 4개 구현
- [x] 텍스트/아이콘 사이 기본 4px 예시
- [x] 시각 보정 2px/1px 예시
- [x] 특정 요소 높이가 되어야 하는 케이스 예시
- [x] navigation bar 56px + 1px separator 예시

### 3. Breakpoint

이미지 기준 최종 breakpoint:

| Token | min-width | 주요 대상 | 레이아웃 변화 |
| --- | ---: | --- | --- |
| `mobile-sm` | 360px | Galaxy 기본 | 기본 1-column |
| `mobile-md` | 390px | iPhone 표준 | 여백/폰트 확장 |
| `mobile-lg` | 430px | Pro Max, Ultra | 콘텐츠 영역 확장 |
| `tablet-sm` | 744px | iPad Mini, Tab S9 | 2-column 전환 |
| `tablet-md` | 882px | Fold 펼침, iPad Air | 사이드바 고정 |
| `tablet-lg` | 1024px | iPad Pro 13" | 풀 레이아웃 |
| `desktop` | 1280px | Tab Ultra, 웹 | 최대 레이아웃 |

현재 구현과의 차이:

- 현재 `AppBreakpoint`는 `xs / md / xl`만 있음
- 현재 resolver 기준은 `<391`, `<744`, 그 외로 단순화되어 있음
- 새 설계를 반영하려면 enum과 resolver를 확장해야 함

구현 항목:

- [x] `AppBreakpoint` 확장 후보:
  - [x] `mobileSm`
  - [x] `mobileMd`
  - [x] `mobileLg`
  - [x] `tabletSm`
  - [x] `tabletMd`
  - [x] `tabletLg`
  - [x] `desktop`
- [x] `AppLayoutResolver.resolveBreakpoint(width)` 기준 재정의
- [x] 기존 `xs / md / xl` API를 바로 제거할지, compatibility alias를 둘지 결정
- [x] Widgetbook `Breakpoint` 섹션에 timeline과 표 구현

### 4. Grid Preview

Widgetbook에서 실제 확인해야 하는 것:

- 선택한 viewport width
- 현재 breakpoint
- horizontal padding
- gutter
- column count
- content width
- column width
- span 계산 결과

구현 항목:

- [x] `GridPage` 또는 `GridFoundationPage` 추가
- [x] `Foundations > Grid` 등록
- [x] knobs:
  - [ ] viewport width preset
  - [x] custom viewport width slider
  - [x] show safe area
  - [x] show column labels
  - [x] show gutter
  - [x] show content bounds
- [x] breakpoint별 preview card:
  - [x] 모바일 1-column
  - [x] tablet-sm 2-column
  - [x] tablet-lg full layout
  - [x] desktop max layout

## 구현 순서

1. [x] `AppBreakpoint` 설계 확정
2. [x] `AppLayoutTokens`가 이미지 기준 breakpoint를 표현할 수 있는지 점검
3. [x] 필요한 경우 layout token 확장
4. [x] `GridMetrics` 계산식이 1-column/2-column/full layout을 모두 표현하는지 테스트
5. [x] `GridFoundationPage` 생성
6. [x] `Foundations`에 `Grid` 등록
7. [x] `Spacing Scale`, `Breakpoint`, `Screen`, `Grid Preview` 섹션 구현
8. [x] Widgetbook 기본 테마는 Light로 유지
9. [x] `flutter analyze` 실행
10. [x] layout 계산 변경 시 `flutter test` 추가/수정

## 결정 필요 사항

- [x] 기존 `AppBreakpoint.xs/md/xl`를 유지하면서 새 7단계를 추가할지, breaking change로 교체할지 결정
- [x] `AppLayoutPreset`을 breakpoint 이름과 1:1로 맞출지, grid 사용 시나리오별 preset으로 유지할지 결정
- [x] desktop에서 최대 content width를 고정할지, 현재 화면 전체 폭 기준으로 계속 계산할지 결정
- [x] spacing 기준 이미지는 기존 `SpacingPage`와 통합할지, Grid 문서 내부에 별도 섹션으로 둘지 결정

## 검증 기준

- [x] `flutter analyze` 통과
- [x] layout token 계산을 수정하는 경우 resolver/preset unit test 추가
- [x] `flutter test` 통과
- [x] Widgetbook에서 Light 기본값 유지
- [x] `Foundations > Grid`에서 4개 정의가 한 페이지에서 순서대로 확인 가능
