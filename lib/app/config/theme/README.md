# Wingle Design System Notes

이 문서는 현재 구현을 재작성하지 않고 장기 유지보수 가능한 방향으로 정규화하기 위한 기준이다.

## Layering

`lib/app/config/theme`는 다음 역할로 해석한다.

- `constants`: primitive token과 semantic component token을 둔다.
- `color`, `text`, `elevation`, `layout`: ThemeExtension 또는 foundation contract를 둔다.
- `components`: 여러 feature에서 재사용 가능한 UI component를 둔다.
- `layout`: breakpoint, grid preset, grid composition helper를 둔다.

Feature 전용 조합은 design system component가 아니다. `agreement_group`, `onboarding_bottom_buttons`, `introduce_card_group`, `selective_card_group`처럼 플로우 의미를 가진 위젯은 `lib/features/onboarding/presentation/components` 같은 feature layer에 둔다.

## Component Taxonomy

현재 파일 이동 없이 Widgetbook과 문서 기준 taxonomy를 먼저 적용한다.

- `Buttons`: filled, outlined, text, full width, chip
- `Input`: `DefaultInputField(variant: ...)`
- `Navigation`: `DefaultAppBar`, pagination
- `Feedback`: badge, state, snackbar
- `Surfaces`: card, divider, wrappers
- `Selection`: check, checkbox, radio, toggle
- `Text`: `DefaultText`
- `Icons`: icon primitives
- `Patterns`: onboarding/auth/profile composition boundary

## Semantic Token Policy

Primitive token은 foundation이며, reusable component 내부에서는 역할 기반 token을 우선한다.

- Primitive: `AppSpacing`, `AppPadding`, `AppRadius`, `AppContainerSize`, `AppIconSize`
- Semantic: `AppComponentPadding`, `AppComponentSpacing`, `AppComponentRadius`, `AppComponentSize`

새로운 component 제원이 반복 사용되거나 Figma에 명시되어 있으면 `component_tokens.dart`에 역할명으로 추가한다. 단일 위젯의 일회성 보정값만 private constant로 둔다.

## Naming Migration

`Default*` public API는 기존 화면과 테스트 호환성을 위해 즉시 제거하지 않는다.

- 신규 사용 문서에서는 역할 기반 이름을 병기한다.
- `DefaultInputField(variant: ...)`를 canonical input API로 본다.
- `DefaultOutlinedInputField`, `DefaultUnderlineInputField`, `DefaultMultilineInputField`는 compatibility wrapper로 유지한다.
- `DefaultAppBar`는 basic/side/display variant를 가진 AppBar abstraction으로 유지한다.
- `ProfileInputAppBar`는 feature adapter 후보이며, 즉시 제거하지 않는다.

## AppBar Contract

`DefaultAppBar`의 variant는 다음 의미를 가진다.

- `basic`: 표준 icon-action AppBar. title은 중앙 정렬된다.
- `side`: 텍스트 action이나 복합 action을 허용하는 side-action AppBar.
- `display`: title/subtitle을 좌측 content로 사용하는 정보 강조 AppBar.

Sizing, action gap, subtitle gap, horizontal padding은 `AppComponent*` token을 통해 관리한다.

## Responsive Layout

화면에서는 `context.currentGrid`, `context.currentGridSpec`, `context.currentGridPreset`을 우선 사용한다. 특정 디자인이 명시적으로 다른 preset을 요구할 때만 `context.grid(AppLayoutPreset...)`를 사용한다.

`context.isTablet` 같은 imperative branching을 화면마다 반복하지 않는다. Grid span과 ratio span으로 composition을 표현하는 것이 기본 방향이다.

## Widgetbook

Widgetbook entrypoint는 `lib/widgetbook.dart`이다.

검증 및 배포 준비 명령:

```bash
flutter build web -t lib/widgetbook.dart
```

현재 taxonomy는 `Foundations`, `Components`, `Patterns`, `Screens`를 기준으로 한다. Foundation 사용 원칙은 Widgetbook의 `Foundations / Usage Guide / Token Policy`에서 확인한다.
