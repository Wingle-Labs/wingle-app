# Riverpod State Audit

갱신일: 2026-05-20

## Migration Status

- 상태: migrated
- 실행 기준: `riverpod-advanced-practices`의 annotation/codegen provider 규칙
- 결과: 감사 당시 발견된 수동 Riverpod provider 22개를 모두 `riverpod_annotation` 기반 generated provider로 전환했다.
- 유지: Riverpod이 필요 없는 local lifecycle state와 Widgetbook demo state는 유지한다.

## Scope

- 대상: `lib/**`, `test/**`
- 제외: `*.g.dart` generated output
- 기준: `.agents/skills/riverpod-advanced-practices`의 `Riverpod Code Generation & Annotation Rules`
- 목적: code generator를 사용하지 않은 Riverpod provider와 Riverpod 없이 Flutter 내장 state를 사용하는 코드를 리스트업한다.

## Summary

| 구분 | 발견 수 | 판정 |
| --- | ---: | --- |
| Manual Riverpod provider declarations | 0 | migration 완료 |
| Generated Riverpod provider source files | 31 | code generation 사용 |
| Pure `StatefulWidget` classes | 22 | 제품 코드 4개, Widgetbook/demo 18개 |
| `ConsumerStatefulWidget` classes | 19 | Riverpod 사용 중이므로 참고 목록으로 분리 |

## 판단 기준

- `Provider(...)`, `Provider.autoDispose(...)`, `NotifierProvider(...)` 등 수동 provider 선언은 모두 목록화한다.
- repository/data source DI용 수동 `Provider`도 포함하되, 일반적으로 P2로 둔다.
- 화면/비즈니스 상태를 소유하는 `NotifierProvider`는 generated `Notifier`/`AsyncNotifier` 전환 우선순위를 높게 둔다.
- `TextEditingController`, `FocusNode`, `AnimationController` 같은 위젯 생명주기 state는 local state 유지가 가능하다.
- Widgetbook/test local state는 전체 범위 때문에 포함하지만 제품 코드 migration 우선순위와 분리한다.

## Migrated Manual Riverpod Providers

아래 항목은 최초 감사에서 수동 provider로 발견됐고, 이번 migration에서 generated provider로 전환된 목록이다.

| 우선순위 | 위치 | 패턴 | 현재 역할 | 판정 | 권장 조치 |
| --- | --- | --- | --- | --- | --- |
| P1 | `lib/app/providers/current_user_gender_provider.dart` | `@riverpod` function | Hive에 저장된 현재 사용자 성별 파생값 | migrated | 기본 autoDispose 유지 |
| P2 | `lib/features/auth/presentation/providers/login_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | 로그인 repository DI | migrated | keepAlive로 기존 DI 생명주기 보존 |
| P1 | `lib/app/bootstrap/bootstrap_initializer_provider.dart` | `@Riverpod(keepAlive: true)` function | 앱 부팅 코드북 sync initializer 조립 | migrated | app bootstrap 생명주기 보존 |
| P2 | `lib/features/onboarding/presentation/providers/contact_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | 연락처 repository DI | migrated | keepAlive |
| P2 | `lib/features/onboarding/presentation/providers/question_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | 질문 repository DI | migrated | keepAlive |
| P2 | `lib/features/onboarding/presentation/providers/health_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | health repository DI | migrated | keepAlive |
| P0 | `lib/features/onboarding/presentation/providers/basic_profile_body_shape_provider.dart` | `@Riverpod(keepAlive: true)` generated `Notifier` | 기본 프로필 체형 선택 상태 | migrated | 기존 state model/동작 보존 |
| P0 | `lib/features/onboarding/presentation/providers/basic_profile_completion_provider.dart` | `@Riverpod(keepAlive: true)` generated `Notifier` | 기본 프로필 제출 상태와 서버 업로드 action | migrated | 기존 loading/error model 보존 |
| P2 | `lib/features/onboarding/presentation/providers/codebook_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | 코드북 repository DI | migrated | keepAlive |
| P2 | `lib/features/onboarding/presentation/providers/answer_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | 답변 repository DI | migrated | keepAlive |
| P0 | `lib/features/onboarding/presentation/providers/basic_profile_nickname_provider.dart` | `@Riverpod(keepAlive: true)` generated `Notifier` | 닉네임 입력/랜덤 닉네임 로딩 상태 | migrated | 기존 loading/error model 보존 |
| P2 | `lib/features/onboarding/presentation/providers/file_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | 파일 repository DI | migrated | keepAlive |
| P2 | `lib/features/onboarding/presentation/providers/signup_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | 회원가입 repository DI | migrated | keepAlive |
| P2 | `lib/features/onboarding/presentation/providers/profile_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | 프로필 repository DI | migrated | keepAlive |
| P2 | `lib/features/onboarding/presentation/providers/term_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | 약관 repository DI | migrated | keepAlive |
| P1 | `lib/features/onboarding/presentation/providers/carousel_index_provider.dart` | `@Riverpod(keepAlive: true)` generated `Notifier` | 온보딩 carousel index | migrated | controller lifecycle 보존 |
| P0 | `lib/features/onboarding/presentation/providers/basic_profile_height_provider.dart` | `@Riverpod(keepAlive: true)` generated `Notifier` | 기본 프로필 키 입력 상태 | migrated | 기존 sanitize 동작 보존 |
| P2 | `lib/features/onboarding/presentation/providers/body_shape_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | 체형 repository DI 및 API/mock selector | migrated | `ref.onDispose(client.close)` 유지 |
| P1 | `lib/features/onboarding/presentation/providers/body_shape_repository_provider.dart` | `@Riverpod(keepAlive: true)` function | 체형 코드북 파생값 | migrated | keepAlive |
| P0 | `lib/features/onboarding/presentation/providers/basic_profile_provider.dart` | `@Riverpod(keepAlive: true)` generated `Notifier` | 기본 프로필 입력/제출 통합 상태 | migrated | 기존 state model/동작 보존 |
| P0 | `lib/features/onboarding/presentation/providers/basic_profile_residence_provider.dart` | `@Riverpod(keepAlive: true)` generated `Notifier` | 기본 프로필 거주지 입력 상태 | migrated | REGION 코드북 선택 코드 보존 |
| P1 | `lib/features/onboarding/presentation/providers/region_codebook_provider.dart` | `@Riverpod(keepAlive: true)` function | Hive local REGION snapshot을 트리로 제공 | migrated | empty snapshot throw 동작 보존 |

## Generated Riverpod Providers

아래 목록은 최초 감사 시점에 이미 generated provider였던 대표 항목이다. 전체 generated provider source file 수는 migration 완료 후 31개다.

| 위치 | 패턴 | 현재 역할 |
| --- | --- | --- |
| `lib/app/providers/router_provider.dart:11` | `part '*.g.dart'`, `@Riverpod(keepAlive: true)` | 앱 router provider |
| `lib/app/providers/device_uuid_provider.dart:6` | `part '*.g.dart'`, `@Riverpod(keepAlive: true)` | device UUID provider |
| `lib/app/providers/localization_provider.dart:5` | `part '*.g.dart'`, `@Riverpod(keepAlive: true)` | localization provider |
| `lib/features/auth/presentation/providers/phone_auth_repository_provider.dart:8` | `part '*.g.dart'`, `@riverpod` | phone auth repository provider |
| `lib/features/auth/presentation/providers/request_phone_code.dart:5` | `part '*.g.dart'`, `@riverpod` | phone code request controller/provider |
| `lib/features/auth/presentation/providers/phone_auth_provider.dart:6` | `part '*.g.dart'`, `@riverpod` | phone auth provider |
| `lib/features/onboarding/presentation/providers/onboarding_password_input_page_provider.dart:6` | `part '*.g.dart'`, `@riverpod` | password input page state |
| `lib/features/onboarding/presentation/providers/pass_provider.dart:13` | `part '*.g.dart'`, `@riverpod`, `@Riverpod(keepAlive: true)` | PASS 인증 관련 provider |
| `lib/features/onboarding/presentation/providers/agreement_list_provider.dart:7` | `part '*.g.dart'`, `@Riverpod(keepAlive: true)` | 약관 목록 provider |
| `lib/features/onboarding/presentation/providers/login_page_provider.dart:11` | `part '*.g.dart'`, `@riverpod` | login page provider |

## Pure Flutter Stateful Usage

### 제품/공용 컴포넌트

| 우선순위 | 위치 | 패턴 | 현재 역할 | 판정 | 권장 조치 |
| --- | --- | --- | --- | --- | --- |
| P1 | `lib/features/onboarding/presentation/components/selection/region_codebook_selection_panel.dart:12` | `StatefulWidget`, `setState` | REGION 검색어와 dropdown local 선택 상태 | 검토 필요 | 검색어/선택값이 프로필 상태와 공유되면 generated `Notifier`로 승격. 단순 presentation state면 `TextEditingController`와 local state 유지 가능 |
| P2 | `lib/features/onboarding/presentation/components/input/basic_profile_height_input.dart:10` | `StatefulWidget`, `TextEditingController`, `FocusNode`, `setState` | 3자리 키 입력 focus/controller 관리 | 허용 가능 | controller/focus는 local state 유지. 실제 height 값은 generated provider에서 소유 |
| P2 | `lib/app/config/theme/components/states/animation_progress_indicator.dart:8` | `StatefulWidget`, animation lifecycle | progress animation controller | 허용 가능 | `AnimationController` 생명주기 state이므로 local state 유지 |
| P2 | `lib/app/config/theme/components/text_fields/default_input_field.dart:54` | `StatefulWidget`, input local state | text field focus/visibility/interaction state | 허용 가능 | reusable input component local state 유지. business validation은 provider/page layer에 둠 |

### Widgetbook/Test Local State

| 우선순위 | 위치 | 패턴 | 현재 역할 | 판정 | 권장 조치 |
| --- | --- | --- | --- | --- | --- |
| P3 | `lib/widgetbook/components/codebook/codebook_page.dart:448` | `StatefulWidget` | gender preview local selection | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/codebook/codebook_page.dart:481` | `StatefulWidget` | region preview local selection | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/codebook/codebook_snapshot_page.dart:177` | `StatefulWidget` | region snapshot preview local selection | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/pagination_page.dart:14` | `StatefulWidget` | pagination preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/input_field_page.dart:17` | `StatefulWidget` | input preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/selections/checkbox_page.dart:13` | `StatefulWidget` | checkbox preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/selections/radio_page.dart:13` | `StatefulWidget` | radio preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/selections/check_page.dart:13` | `StatefulWidget` | check preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/selections/toggle_switch_page.dart:13` | `StatefulWidget` | toggle switch preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/selections/toggle_icon_page.dart:12` | `StatefulWidget` | toggle icon preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/buttons/basic_button_page.dart:17` | `StatefulWidget` | button preview interaction state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/buttons_page.dart:14` | `StatefulWidget` | buttons overview preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/buttons/text_button_page.dart:13` | `StatefulWidget` | text button preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/buttons/full_width_button_page.dart:13` | `StatefulWidget` | full width button preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/misc_components_page.dart:10` | `StatefulWidget` | misc component preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/buttons/filled_button_page.dart:13` | `StatefulWidget` | filled button preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/components/buttons/outlined_button_page.dart:13` | `StatefulWidget` | outlined button preview state | Widgetbook demo state | local state 유지 |
| P3 | `lib/widgetbook/screens/widgetbook_preview_app.dart:30` | `StatefulWidget` | Widgetbook preview app theme/device state | Widgetbook infrastructure state | local state 유지 |

## Riverpod Consumer Stateful Usage

아래 항목은 Riverpod을 사용하므로 "Riverpod 없이 내장 State" 위반으로 보지 않는다. 다만 business state가 `ConsumerState` 내부 `setState`에 들어가 있다면 별도 migration 대상이다.

| 위치 | 패턴 | 현재 분류 | 권장 조치 |
| --- | --- | --- | --- |
| `lib/features/onboarding/presentation/page/pass_webview_page.dart:16` | `ConsumerStatefulWidget` | Riverpod + lifecycle state | WebView/controller lifecycle만 local 유지 |
| `lib/app/app.dart:9` | `ConsumerStatefulWidget` | app root lifecycle | app lifecycle state만 local 유지 |
| `lib/features/home/presentation/home.dart:12` | `ConsumerStatefulWidget` | home page state | business state는 provider로 이동 검토 |
| `lib/features/onboarding/presentation/page/age_pick.page.dart:13` | `ConsumerStatefulWidget` | onboarding page state | business state는 generated provider로 이동 검토 |
| `lib/widgetbook/components/codebook/codebook_page.dart:12` | `ConsumerStatefulWidget` | Widgetbook | local state 유지 가능 |
| `lib/features/onboarding/presentation/page/login_page.dart:24` | `ConsumerStatefulWidget` | login page state | input/business state는 generated provider로 유지/전환 |
| `lib/features/auth/presentation/components/phone_textfield.dart:9` | `ConsumerStatefulWidget` | auth input component | controller/focus local 유지 가능 |
| `lib/widgetbook/components/codebook/codebook_explorer_page.dart:8` | `ConsumerStatefulWidget` | Widgetbook | local state 유지 가능 |
| `lib/features/onboarding/presentation/page/basic_profile_residence_page.dart:13` | `ConsumerStatefulWidget` | residence page state | REGION selection provider와 정합성 검토 |
| `lib/features/auth/presentation/components/phone_otp_textfield.dart:6` | `ConsumerStatefulWidget` | auth OTP input component | controller/focus local 유지 가능 |
| `lib/widgetbook/components/codebook/codebook_snapshot_page.dart:14` | `ConsumerStatefulWidget` | Widgetbook | local state 유지 가능 |
| `lib/features/onboarding/presentation/page/onboarding_page.dart:15` | `ConsumerStatefulWidget` | onboarding flow page | navigation/page lifecycle만 local 유지 |
| `lib/features/onboarding/presentation/page/onboarding_password_page.dart:17` | `ConsumerStatefulWidget` | password page state | 이미 generated provider와 연결된 state 유지 |
| `lib/features/onboarding/presentation/page/basic_profile_nickname_page.dart:25` | `ConsumerStatefulWidget` | nickname page state | manual provider migration과 함께 검토 |
| `lib/features/auth/presentation/phone_otp.dart:12` | `ConsumerStatefulWidget` | auth page state | timer/controller lifecycle만 local 유지 |
| `lib/features/auth/presentation/phone_auth.dart:13` | `ConsumerStatefulWidget` | auth page state | business state는 generated provider로 유지 |
| `lib/app/config/theme/components/wrappers/scrollable_scaffold.dart:10` | `ConsumerStatefulWidget` | reusable scaffold state | scroll lifecycle local 유지 가능 |
| `lib/app/config/theme/components/text_fields/underline_text_field.dart:9` | `ConsumerStatefulWidget` | reusable text field state | controller/focus local 유지 가능 |

## Migration Result

### P0: feature/business state provider 전환 완료

- 대상:
  - `basic_profile_provider.dart`
  - `basic_profile_completion_provider.dart`
  - `basic_profile_nickname_provider.dart`
  - `basic_profile_residence_provider.dart`
  - `basic_profile_height_provider.dart`
  - `basic_profile_body_shape_provider.dart`
- 결과:
  - `NotifierProvider` 수동 선언 제거
  - `@Riverpod(keepAlive: true) class ... extends _$...` generated `Notifier`로 전환
  - 기존 provider 이름과 UI 동작 보존

### P1: app-wide/cache/derived provider 전환 완료

- 대상:
  - `bootstrap_initializer_provider.dart`
  - `region_codebook_provider.dart`
  - `current_user_gender_provider.dart`
  - `bodyShapeCodebookProvider`
  - `carousel_index_provider.dart`
- 결과:
  - app boot/cache 성격은 `@Riverpod(keepAlive: true)` 사용
  - 단순 파생값인 `currentUserGenderProvider`는 기본 autoDispose `@riverpod` 사용
  - local-first 코드북 tree provider는 기존 Hive read 동작 보존

### P2: DI provider 전환 완료

- 대상:
  - repository provider 전반
- 결과:
  - repository provider 전반을 `@Riverpod(keepAlive: true)` 함수로 전환
  - `ref.onDispose` client close lifecycle 유지
  - repository/data source는 widget에서 직접 호출하지 않고 provider/use case 경유 유지

### P3: Widgetbook/local lifecycle state 유지

- 대상:
  - Widgetbook preview page state
  - `TextEditingController`, `FocusNode`, `AnimationController`
- 방향:
  - demo/local lifecycle state는 유지
  - 제품 business state와 섞이면 해당 state만 provider로 분리

## Follow-up Checklist

- [x] P0 provider를 generated provider로 전환한다.
- [x] P1/P2 provider를 generated provider로 전환한다.
- [x] `dart run build_runner build --delete-conflicting-outputs`를 실행한다.
- [ ] Basic profile 관련 중복 provider 역할을 정리한다.
- [ ] REGION 선택 패널의 검색/선택 상태가 page provider와 중복되는지 확인한다.
- [ ] 코드북 local-first sync provider를 별도 cache controller로 고도화할지 검토한다.
- [ ] `flutter analyze`와 `flutter test` 결과를 최종 확인한다.
