# Riverpod 공식 문서 재귀 학습 노트

- 기준일: 2026-05-20
- 출발 문서: https://riverpod.dev/docs/introduction/getting_started
- 대상: Riverpod 3.x 공식 문서의 좌측 사이드바에 노출된 문서 항목 전체
- 산출물 목적: Flutter/Riverpod 프로젝트에서 바로 참고할 수 있는 학습·설계·구현 기준서
- 작성 방식: 공식 문서를 그대로 복제하지 않고, 문서 구조를 따라 핵심 개념·주의점·적용 기준을 한국어로 재정리

---

## 0. 수집 범위와 한계

### 0.1 수집한 공식 문서 범위

다음 항목을 기준으로 재귀적으로 탐색했다.

| 분류 | 포함 항목 |
|---|---|
| Introduction | Getting started, What's new in Riverpod 3.0, Migrating 2.0 to 3.0, FAQ, DO/DON'T |
| Tutorial | Your first Riverpod app |
| Concepts | Providers, Consumers, ProviderContainers/ProviderScopes, Refs, Automatic disposal, Family, Mutations, Offline persistence, Automatic retry, ProviderObservers, Provider overrides, Scoping providers, About code generation, About hooks |
| Guides | Testing your providers, How to reduce provider/widget rebuilds, How to eagerly initialize providers, Implementing pull-to-refresh, How to debounce/cancel network requests |
| References | All Providers, Containers/Scopes, Refs, Consumers, Offline persistence, Mutations, core, misc |
| Migration guides | Riverpod for Provider Users, Provider vs Riverpod, Motivation, From StateNotifier, From ChangeNotifier, 0.14.0 to 1.0.0, 0.13.0 to 0.14.0 |
| Examples | Official examples, Third-party examples 링크 확인 |

### 0.2 한계

- 공식 문서가 Docusaurus 기반으로 렌더링되기 때문에, 모든 동적 탭의 코드 조각을 원문 수준으로 복제하지 않았다.
- GitHub 예제 저장소와 pub.dev API Reference의 모든 세부 클래스/메서드 문서까지 전문 번역하지 않았다.
- 이 문서는 “학습 요약 + 프로젝트 적용 기준”이다. 원문 대체본이 아니라, 구현 의사결정용 노트다.
- Riverpod은 버전 변화가 빠르므로, 실제 적용 시 `pubspec.yaml`의 Riverpod 계열 패키지 버전과 공식 문서의 버전이 일치하는지 확인해야 한다.

---

## 1. Riverpod 전체 결론

Riverpod의 핵심은 “상태를 Provider 객체 자체에 저장하지 않고, ProviderContainer가 상태를 보관하며, provider는 상태 생성·파생·캐싱·구독의 선언 단위가 된다”는 점이다.

Flutter 앱에서는 일반적으로 앱 최상단에 `ProviderScope`를 두고, 위젯에서는 `ConsumerWidget`, `ConsumerStatefulWidget`, `Consumer`, `HookConsumerWidget` 등을 통해 `WidgetRef`를 사용한다. Provider 내부에서는 `Ref`를 사용한다.

### 1.1 Wingle 프로젝트 기준 결론

현재 프로젝트가 Flutter 3.38.x, Riverpod, Clean Architecture를 전제로 한다면 다음 기준이 맞다.

| 상황 | 권장 방식 |
|---|---|
| 단순 의존성 주입 | `Provider` |
| 서버/DB에서 한 번 읽는 비동기 데이터 | `FutureProvider` 또는 `AsyncNotifierProvider` |
| 연속 스트림 데이터 | `StreamProvider` 또는 `StreamNotifierProvider` |
| 변경 가능한 동기 상태 | `NotifierProvider` |
| 변경 가능한 비동기 상태 | `AsyncNotifierProvider` |
| 화면별 파라미터가 있는 데이터 | `family` + 가능하면 `autoDispose` |
| API 요청 취소/검색 디바운스 | `autoDispose` + `ref.onDispose` |
| 테스트 | `ProviderContainer.test`, `ProviderScope(overrides: ...)` |
| 임시 UI 상태 | Provider로 올리지 말고 위젯 local state 또는 hooks |
| 레거시 마이그레이션 | `StateNotifierProvider`, `ChangeNotifierProvider`, `StateProvider`는 가급적 신규 코드에서 제외 |

### 1.2 가장 중요한 원칙

1. provider는 전역 `final`로 선언한다.
2. provider 내부에서는 다른 provider를 `ref.watch`로 의존한다.
3. 버튼 클릭, 제출, 저장 같은 명령형 동작은 `ref.read(provider.notifier).method()` 형태로 실행한다.
4. 화면의 임시 상태와 앱의 공유 상태를 섞지 않는다.
5. provider 생성 중에는 쓰기 작업, 네비게이션, 다이얼로그, HTTP POST 같은 side effect를 수행하지 않는다.
6. `family` 파라미터는 안정적인 `==`/`hashCode`를 가져야 한다.
7. rebuild 최적화는 먼저 구조를 단순하게 만든 다음, 필요한 곳에만 `select`를 사용한다.
8. 테스트 가능한 구조를 위해 Repository, UseCase, Notifier를 provider로 분리한다.
9. Riverpod 3.0에서는 retry, pause/resume, `Ref.mounted`, unified API 변경을 반드시 고려한다.
10. 실험 기능인 Mutations/Offline persistence는 MVP 핵심 경로에 바로 의존하지 않는 것이 안전하다.

---

## 2. Getting started

### 2.1 설치 패키지

Flutter 프로젝트 기준 핵심 패키지는 다음 계열이다.

- `flutter_riverpod`: Flutter에서 Riverpod을 쓰기 위한 기본 패키지
- `riverpod`: Dart-only 프로젝트에서 사용하는 코어 패키지
- `hooks_riverpod`: flutter_hooks와 함께 사용할 때 선택
- `riverpod_annotation`, `riverpod_generator`, `build_runner`, `custom_lint`, `riverpod_lint`: 코드 생성과 lint를 사용할 때 선택

현재 Wingle 프로젝트는 `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`, `build_runner`, `riverpod_lint`, `custom_lint`를 이미 사용하는 구조이므로 공식 문서의 권장 흐름과 맞다.

### 2.2 앱 루트 설정

Flutter 앱에서는 반드시 `ProviderScope`가 Riverpod 상태 저장소 역할을 하도록 앱 루트에 배치해야 한다. `ProviderScope`가 없으면 위젯 트리에서 provider를 구독할 수 없다.

Clean Architecture 프로젝트에서는 보통 `main.dart` 또는 앱 부트스트랩 파일에서 다음 계층을 둔다.

```text
runApp
└── ProviderScope
    └── App
        └── MaterialApp.router
```

테마, 라우터, localization, splash, dotenv 초기화는 `ProviderScope`보다 앞/뒤의 책임을 분리해야 한다. 단, provider가 dotenv 값을 읽어야 한다면 dotenv 초기화가 먼저 끝나야 한다.

### 2.3 provider 선언

provider는 일반적으로 파일 최상단의 전역 `final`로 선언한다. 클래스 필드나 위젯 내부에서 임의로 생성하면 캐싱·테스트·오버라이드의 장점이 깨진다.

### 2.4 위젯에서 읽기

- `ref.watch`: 값 변경 시 위젯 rebuild
- `ref.read`: 이벤트 핸들러에서 현재 값을 한 번 읽거나 notifier method 호출
- `ref.listen`: 값 변화를 감지해 스낵바, 다이얼로그, navigation 같은 UI side effect 실행

주의할 점은 `ref.read`를 build 메서드 안에서 상태 구독 목적으로 쓰지 않는 것이다. build에서 값이 필요하면 `watch`가 맞다.

### 2.5 riverpod_lint

공식 문서는 `riverpod_lint` 사용을 권장한다. 실수하기 쉬운 provider 사용, 잘못된 `ref` 접근, codegen 관련 문제를 정적으로 잡아준다. Wingle처럼 취업용 포트폴리오 성격의 프로젝트에서는 lint 도입 자체가 품질 신호가 된다.

---

## 3. What's new in Riverpod 3.0

Riverpod 3.0의 핵심 변화는 다음이다.

### 3.1 Offline persistence

provider 상태를 디바이스 또는 데이터베이스에 저장했다가 복원하는 실험 기능이다. 공식 구현 예시는 `riverpod_sqflite`와 JSON 직렬화를 사용한다.

주의점:

- 실험 기능이다.
- DB 대체제가 아니다.
- provider state를 저장하고 복원하는 얇은 계층이다.
- 기본 캐시 기간은 제한적이다.
- `unsafe_forever` 같은 영구 저장 설정은 데이터 무효화 전략이 없으면 위험하다.

Wingle 적용 판단:

- 코드북, 지역 코드, 선택지 목록처럼 비교적 안정적인 참조 데이터에는 검토 가치가 있다.
- 사용자 인증 토큰, 민감한 개인정보, 매칭 상태처럼 일관성·보안이 중요한 데이터는 Hive/secure storage/API freshness 정책을 명확히 유지하는 편이 안전하다.

### 3.2 Mutations

Mutations는 POST/PUT/DELETE 같은 side effect의 진행 상태를 UI가 추적하기 위한 실험 기능이다. `pending`, `success`, `error`, `idle` 같은 상태를 기반으로 버튼 disable, loading indicator, error message를 구성할 수 있다.

주의점:

- 실험 기능이다.
- 기존 `AsyncNotifier` method와 `AsyncValue` 조합으로도 대부분 구현 가능하다.
- MVP에서는 팀의 학습 비용을 고려해야 한다.

Wingle 적용 판단:

- 가입, 프로필 저장, 코드북 동기화 같은 명령형 작업에는 개념적으로 잘 맞는다.
- 다만 실험 기능이므로 핵심 기능에는 `AsyncNotifier` 기반 명령 메서드가 더 안정적이다.

### 3.3 Automatic retry

Riverpod 3.0은 provider 실패 시 기본적으로 재시도한다. 기본 정책은 제한된 횟수의 exponential backoff다.

적용 기준:

- 일시적 네트워크 오류에는 유리하다.
- 인증 실패, validation error, 404 같은 재시도해도 의미 없는 오류는 retry를 끄거나 조건 분기해야 한다.
- API 레이어에서 오류 타입을 명확히 분류해야 한다.

### 3.4 `Ref.mounted`

비동기 작업 후 provider가 아직 살아 있는지 확인할 수 있는 값이다. Flutter의 `BuildContext.mounted`와 유사한 안전장치다.

적용 기준:

- `await` 뒤에 provider 상태를 변경하거나 다른 provider를 읽을 때 유용하다.
- `autoDispose`와 비동기 작업이 같이 있을 때 특히 중요하다.
- 강제 언래핑을 지양하는 프로젝트 규칙과도 맞다.

### 3.5 Generic 지원

provider에서 generic을 더 자연스럽게 사용할 수 있다. 공통 Repository provider, paginated response provider, generic cache 계층을 만들 때 설계 폭이 넓어진다.

### 3.6 Pause/resume

화면에서 보이지 않는 provider 구독이 pause될 수 있다. Flutter에서 `TickerMode`와 연결되어 out-of-view 상태의 불필요한 작업을 줄인다.

주의점:

- 실시간성 있는 데이터, timer, stream을 다룰 때 pause/resume 동작을 의식해야 한다.
- provider가 항상 active라고 가정하면 버그가 날 수 있다.

### 3.7 Public API 통합

3.0에서 API가 더 일관적인 방향으로 정리되었다. `StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider`는 legacy 영역으로 이동했다.

Wingle 적용 판단:

- 신규 코드는 `NotifierProvider`, `AsyncNotifierProvider` 중심으로 작성해야 한다.
- 과거 튜토리얼이나 블로그의 `StateNotifierProvider` 예제는 그대로 복붙하면 구식 설계가 될 수 있다.

---

## 4. Migrating 2.0 to 3.0

### 4.1 자동 retry로 인한 변화

2.x에서는 실패한 provider가 그대로 실패 상태를 유지했을 수 있다. 3.0에서는 기본 retry가 있으므로 테스트와 UI 상태가 달라질 수 있다.

점검 항목:

- 실패 직후 에러 UI가 바로 떠야 하는 화면
- 인증 만료 처리
- validation error 처리
- 테스트에서 실패 상태를 즉시 기대하는 코드

### 4.2 화면 밖 provider pause

보이지 않는 위젯에서 provider 구독이 pause될 수 있다. 기존에 “화면에 없지만 계속 실행된다”고 가정한 구조는 점검해야 한다.

### 4.3 legacy import

`StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider` 등은 legacy import를 요구할 수 있다. 신규 코드에 계속 남겨두면 장기적으로 기술 부채다.

### 4.4 `==` 기반 update filtering

Riverpod 3.0에서는 provider 업데이트 판단에 `==`가 중요하다. immutable state와 value equality가 더 중요해진다.

Wingle 적용 기준:

- entity/model은 `json_serializable`만으로 끝내지 말고 value equality 전략을 정해야 한다.
- `freezed`를 쓰지 않는다면 직접 `==`/`hashCode` 구현 여부를 검토해야 한다.
- mutable List/Map을 그대로 state로 노출하면 rebuild 판단이 꼬일 수 있다.

### 4.5 ProviderObserver 변경

Observer 콜백에서 제공되는 context 구조가 바뀌었다. 로그/분석/디버깅 observer를 쓰는 경우 마이그레이션이 필요하다.

### 4.6 Ref 타입 변경

generic `Ref<T>` 형태가 제거되고 `Ref`를 직접 사용하는 방향으로 정리되었다. codegen 없는 provider에서도 `Ref`를 쓰는 형태가 표준이다.

### 4.7 family Notifier 변형 제거

family 전용 Notifier 변형이 정리되었다. 파라미터는 `build` 메서드 인자로 받는 방향이 더 일관적이다.

### 4.8 ProviderException

provider 실패가 `ProviderException`으로 다시 던져질 수 있다. 에러 핸들링과 테스트에서 wrapping 여부를 확인해야 한다.

---

## 5. FAQ

### 5.1 `ref.refresh`와 `ref.invalidate`

- `ref.invalidate(provider)`: provider 상태를 폐기하고 다음 구독/프레임에서 재계산하게 한다.
- `ref.refresh(provider)`: invalidate 후 즉시 read하는 편의 동작이다.

적용 기준:

- pull-to-refresh처럼 즉시 새 Future를 얻어야 하면 `refresh`가 적합하다.
- 단순히 캐시를 무효화하고 다음 접근 때 갱신하면 되는 경우 `invalidate`가 적합하다.

### 5.2 `Ref`와 `WidgetRef`는 왜 공통 인터페이스가 아닌가

provider 내부의 `Ref`와 위젯 내부의 `WidgetRef`는 역할이 다르다. 문서는 공통 인터페이스로 추상화하기보다 로직을 Notifier에 넣고 위젯에서는 method를 호출하는 방식을 권장한다.

Wingle 적용 기준:

- UI에서 복잡한 로직을 함수로 빼면서 `WidgetRef`를 넘기는 습관은 피한다.
- 비즈니스 동작은 Notifier/UseCase/Repository provider로 내려야 한다.

### 5.3 왜 `StatelessWidget` 대신 `ConsumerWidget`인가

InheritedWidget 기반 접근의 한계를 피하고, provider 구독을 명시적으로 다루기 위해 `ConsumerWidget` 계열을 사용한다.

---

## 6. DO / DON'T

### 6.1 provider 초기화를 위젯 생명주기에 묶지 말 것

위젯에서 provider를 임의로 초기화하거나 생성하는 방식은 Riverpod의 캐싱·오버라이드·테스트 모델을 깨뜨린다.

### 6.2 ephemeral state를 provider로 올리지 말 것

다음 상태는 provider로 올릴 필요가 낮다.

- TextField 입력 중 임시 값
- 선택 중인 탭 index
- animation controller 상태
- hover/focus 여부
- 한 위젯 내부에서만 쓰는 토글

이런 상태를 전역 provider로 만들면 오히려 복잡도가 증가한다.

### 6.3 provider 초기화 중 side effect 금지

provider의 build/생성 과정에서 다음을 수행하면 안 된다.

- POST/PUT/DELETE
- navigation
- dialog/snackbar
- analytics event
- 외부 시스템 변경

이런 동작은 명령형 이벤트 핸들러, Notifier method, Mutation, 또는 `ref.listen`에서 처리해야 한다.

### 6.4 provider는 정적으로 선언할 것

동적으로 provider를 생성하면 lint, override, 추적, 테스트가 어려워진다. 가능한 한 top-level provider를 선언하고 `family`로 파라미터를 전달한다.

---

## 7. Tutorial: Your first Riverpod app

공식 튜토리얼은 Flutter 앱에서 Riverpod으로 비동기 데이터를 가져오고 UI를 구성하는 흐름을 보여준다.

핵심 학습 포인트:

1. `ProviderScope`로 앱을 감싼다.
2. provider를 선언한다.
3. `ConsumerWidget`에서 `ref.watch`로 provider를 구독한다.
4. `AsyncValue`의 loading/error/data 상태를 UI로 분기한다.
5. `dio` 같은 HTTP 클라이언트와 Riverpod을 함께 쓴다.
6. `riverpod_lint`로 잘못된 사용을 줄인다.

Wingle 적용 기준:

- API fetch는 Repository provider와 UseCase provider를 거쳐 presentation provider에서 소비하는 구조가 맞다.
- 단순 튜토리얼처럼 UI provider에서 직접 `dio.get`을 호출하면 Clean Architecture가 무너질 수 있다.
- 튜토리얼은 문법 학습용이고, 실제 앱에서는 레이어 분리가 필요하다.

---

## 8. Concepts

## 8.1 Providers

Provider는 Riverpod의 중심 개념이다. provider는 상태 자체가 아니라 상태를 생성하고 읽는 방법을 정의하는 선언체다.

### 8.1.1 Provider의 역할

- 상태 생성
- 상태 캐싱
- 의존성 추적
- rebuild 트리거
- 테스트 오버라이드
- 환경별 구현 교체
- 비동기 상태 표현
- provider 간 조합

### 8.1.2 Provider 종류

| 종류 | 용도 |
|---|---|
| `Provider` | 읽기 전용 값, 의존성 주입, 계산된 값 |
| `FutureProvider` | 단발성 비동기 읽기 |
| `StreamProvider` | 연속 이벤트 스트림 |
| `NotifierProvider` | 변경 가능한 동기 상태와 method |
| `AsyncNotifierProvider` | 변경 가능한 비동기 상태와 method |
| `StreamNotifierProvider` | 변경 가능한 stream 상태와 method |

### 8.1.3 신규 코드 기준

Wingle 신규 코드에서는 다음 우선순위가 적합하다.

1. 단순 DI: `Provider`
2. API 조회만: `FutureProvider`
3. API 조회 + 명령 메서드: `AsyncNotifierProvider`
4. 로컬 UI 상태가 아닌 도메인 상태: `NotifierProvider`
5. 실시간 구독: `StreamProvider` 또는 `StreamNotifierProvider`

`StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider`는 신규 코드에서는 피하는 것이 낫다.

---

## 8.2 Consumers

Consumer는 widget tree와 provider graph를 연결한다.

### 8.2.1 Consumer 계열

| 타입 | 용도 |
|---|---|
| `ConsumerWidget` | StatelessWidget처럼 쓰되 `WidgetRef`를 받음 |
| `ConsumerStatefulWidget` | StatefulWidget이 필요하면서 provider도 읽어야 할 때 |
| `Consumer` | 기존 위젯 하위 일부만 provider 구독시키고 싶을 때 |
| `HookConsumerWidget` | hooks와 Riverpod을 함께 사용할 때 |
| `HookBuilder` | hooks를 특정 하위 위젯에만 적용할 때 |

### 8.2.2 선택 기준

- 기본은 `ConsumerWidget`
- local state가 필요하면 `ConsumerStatefulWidget`
- rebuild 범위를 줄이고 싶으면 `Consumer`
- hooks를 이미 쓰고 있으면 `HookConsumerWidget`

Wingle은 hooks 사용이 필수 라이브러리에 포함되어 있지 않으므로, 기본은 `ConsumerWidget`/`ConsumerStatefulWidget`로 두는 편이 단순하다.

---

## 8.3 ProviderContainers / ProviderScopes

ProviderContainer는 provider 상태가 저장되는 실제 컨테이너다. provider 선언 자체는 immutable descriptor에 가깝고, 상태는 container에 보관된다.

Flutter에서는 직접 `ProviderContainer`를 만들기보다 `ProviderScope`를 사용한다.

### 8.3.1 ProviderScope의 역할

- 앱 전체 Riverpod 상태 저장소 제공
- provider override 적용
- child subtree에 별도 scope 제공
- 테스트에서 provider 교체

### 8.3.2 ProviderContainer의 용도

- 순수 Dart 테스트
- unit test
- Flutter 외부에서 provider graph 실행
- 상태 dispose/pump/listen/read/refresh/invalidate 제어

실제 Flutter 앱 UI에서는 raw `ProviderContainer`를 직접 만드는 일을 최소화해야 한다.

---

## 8.4 Refs

Ref는 provider 내부에서 다른 provider와 상호작용하고 lifecycle을 제어하는 객체다. WidgetRef는 위젯에서 provider를 읽기 위한 객체다.

### 8.4.1 주요 메서드

| 메서드 | 의미 |
|---|---|
| `watch` | 의존 provider를 구독하고 변경 시 재계산 |
| `read` | 현재 값을 한 번 읽음 |
| `listen` | 값 변화에 대한 콜백 등록 |
| `onDispose` | provider 폐기 시 cleanup 등록 |
| `onCancel` | 마지막 listener가 사라질 때 호출 |
| `onResume` | listener가 다시 생길 때 호출 |
| `invalidate` | provider 상태 폐기 |
| `refresh` | 폐기 후 즉시 다시 읽기 |

### 8.4.2 실무 기준

- provider 내부 파생 값은 `ref.watch`
- 이벤트 핸들러에서 method 호출은 `ref.read`
- snackbar/navigation은 `ref.listen`
- stream/client/controller cleanup은 `ref.onDispose`
- async 이후 생존 확인은 `ref.mounted`

---

## 8.5 Automatic disposal

Automatic disposal은 provider를 더 이상 듣는 곳이 없을 때 상태를 제거하는 기능이다.

### 8.5.1 핵심 동작

- codegen을 쓰면 기본값이 autoDispose 방향이다.
- codegen 없이 provider를 만들 때는 `.autoDispose` 또는 `isAutoDispose: true`를 사용한다.
- provider가 다시 계산되면 이전 상태는 폐기된다.
- 마지막 listener가 제거되면 한 프레임 정도 후 dispose될 수 있다.

### 8.5.2 `family`와 autoDispose

문서는 `family`를 쓸 때 autoDispose를 권장한다. 파라미터별 provider state가 계속 쌓일 수 있기 때문이다.

예:

- 사용자 상세 화면: userId마다 provider state 생성
- 지역 코드북: group마다 provider state 생성
- 검색어: query마다 provider state 생성

검색어처럼 값이 자주 바뀌는 family provider에서 autoDispose가 없으면 메모리 낭비가 커진다.

### 8.5.3 cleanup

`ref.onDispose`는 다음에 사용한다.

- HTTP 요청 cancel token 취소
- stream subscription 취소
- timer 취소
- controller close
- socket close

주의: `onDispose` 안에서 다른 provider를 수정하는 side effect는 피해야 한다.

---

## 8.6 Family

Family는 하나의 provider 선언으로 파라미터별 독립 state를 만드는 기능이다.

### 8.6.1 사용 예

- `userProvider(userId)`
- `codebookProvider(group)`
- `regionProvider(parentRegionId)`
- `profileImageProvider(imageId)`
- `searchResultProvider(query)`

### 8.6.2 파라미터 조건

family 파라미터는 안정적인 equality를 가져야 한다.

좋은 파라미터:

- `String`
- `int`
- `enum`
- immutable value object
- `==`/`hashCode`가 구현된 객체

나쁜 파라미터:

- 매번 새로 생성되는 mutable object
- equality가 없는 custom class
- mutable List/Map

### 8.6.3 override

family provider도 특정 파라미터 또는 전체 family 단위로 override할 수 있다. 테스트에서 특정 userId나 특정 codebook group에 fake data를 주입할 때 유용하다.

---

## 8.7 Mutations

Mutations는 side effect의 상태를 UI가 추적하게 해주는 실험 기능이다.

### 8.7.1 사용 목적

- 버튼 클릭 후 요청 진행 중 표시
- 요청 성공/실패 상태 표시
- 동시에 여러 mutation scope 관리
- submit 중 중복 클릭 방지

### 8.7.2 상태 개념

- idle
- pending
- success
- error

### 8.7.3 Wingle 적용 판단

MVP에서는 다음처럼 판단하는 편이 안전하다.

| 작업 | 권장 |
|---|---|
| 가입/로그인 | `AsyncNotifier` method 우선 |
| 프로필 저장 | `AsyncNotifier` method 우선 |
| 코드북 동기화 | `AsyncNotifier` 또는 service provider |
| 버튼별 mutation status가 복잡함 | Mutations 검토 |
| 장기 유지보수 안정성 우선 | 실험 기능 보류 |

---

## 8.8 Offline persistence

Offline persistence는 provider state를 저장소에 유지하고 복원하는 실험 기능이다.

### 8.8.1 개념

- Storage abstraction을 만들고 provider/notifier에서 persist한다.
- JSON 직렬화가 필요하다.
- provider별 key를 관리해야 한다.
- cache duration 정책이 중요하다.

### 8.8.2 적합한 데이터

- 코드북
- 지역 목록
- 약관 버전
- 앱 설정
- 캐시 가능한 public metadata

### 8.8.3 부적합한 데이터

- 인증 토큰
- 민감한 개인정보
- 서버 권한 상태
- 결제/매칭의 최종 상태
- 서버와 강한 일관성이 필요한 데이터

Wingle은 이미 Hive/secure storage를 사용하므로, offline persistence를 무리하게 도입하기보다 현재 저장소 전략과 비교해 결정해야 한다.

---

## 8.9 Automatic retry

Automatic retry는 provider 실패 시 자동으로 재시도하는 기능이다.

### 8.9.1 기본 정책

- 제한된 횟수 재시도
- exponential backoff
- 특정 Error/ProviderException은 기본적으로 retry 제외

### 8.9.2 제어 기준

재시도해야 하는 오류:

- 네트워크 일시 오류
- timeout
- 서버 일시 장애
- 503
- flaky connection

재시도하지 말아야 하는 오류:

- 400 validation
- 401/403 인증·권한
- 404 리소스 없음
- 비즈니스 rule violation
- 사용자가 고쳐야 하는 입력 오류

### 8.9.3 Wingle 적용

Dio interceptor에서 API error type을 분류하고, provider retry 정책과 충돌하지 않게 해야 한다. 인증 오류가 자동 retry에 묶이면 로그인 만료 처리가 지연될 수 있다.

---

## 8.10 ProviderObservers

ProviderObserver는 provider lifecycle을 관찰하는 hook이다.

### 8.10.1 사용 목적

- provider 생성/업데이트/폐기 로그
- 디버깅
- 상태 변화 추적
- 테스트 관찰
- 성능 문제 추적

### 8.10.2 주의점

state가 mutable object인 경우 이전/현재 값을 비교해도 같은 참조일 수 있다. Observer를 제대로 쓰려면 immutable state가 더 적합하다.

Wingle 적용 기준:

- debug build에서만 상세 로그 observer를 켠다.
- production에서는 개인정보/민감정보가 로그에 남지 않도록 필터링한다.
- provider name을 명확히 두면 로그 추적이 쉬워진다.

---

## 8.11 Provider overrides

Override는 provider 구현 또는 값을 특정 scope/test에서 교체하는 기능이다.

### 8.11.1 사용처

- 테스트에서 fake repository 주입
- 개발/운영 환경별 base URL 교체
- 특정 subtree에 다른 값 제공
- preview/sandbox 모드
- mock 데이터로 UI 확인

### 8.11.2 방식

- `overrideWith`
- `overrideWithValue`
- `overrideWithBuild`

### 8.11.3 Clean Architecture 적용

Repository interface provider를 만들고, 실제 구현은 override로 교체하는 방식이 테스트에 유리하다.

예상 구조:

```text
domain/
  repositories/
data/
  repositories/
presentation/
  providers/
```

테스트에서는 data repository provider를 fake implementation으로 override한다.

---

## 8.12 Scoping providers

Scoping은 provider 값을 특정 subtree에서 다르게 만드는 기능이다.

### 8.12.1 장점

- 작은 subtree에 다른 값 주입
- 파라미터를 매번 넘기지 않음
- 특정 화면 단위 override
- 일부 성능 최적화

### 8.12.2 주의점

문서는 scoping을 강력한 기능이지만 복잡도를 높일 수 있다고 경고한다. 대부분의 경우 `family`가 더 명시적이다.

### 8.12.3 적용 기준

- 앱 전체 환경값: scope 가능
- 특정 화면의 userId/detailId: `family` 우선
- 테마/locale: 기존 Flutter mechanism 또는 provider 모두 가능
- nested navigation별 독립 상태: 신중히 scope 검토

---

## 8.13 About code generation

Riverpod code generation은 필수는 아니지만, 공식 문서가 권장하는 방향이다.

### 8.13.1 장점

- provider boilerplate 감소
- function/class provider 문법 통일
- family parameter를 함수/메서드 인자로 자연스럽게 선언
- autoDispose 기본값
- provider name/debug 정보 개선
- lint와 함께 사용 시 실수 감소

### 8.13.2 단점

- build_runner 실행 필요
- generated file 관리 필요
- 초기 학습 비용
- 빌드 시간이 늘 수 있음

### 8.13.3 Wingle 적용 기준

이미 `riverpod_annotation`, `riverpod_generator`, `build_runner`를 사용 중이므로 codegen을 기준으로 통일하는 편이 낫다.

다만 팀원/미래 유지보수자에게 다음 규칙을 강제해야 한다.

1. provider 파일명과 `.g.dart` part 이름 일치
2. generated file 직접 수정 금지
3. provider 변경 후 build_runner 실행
4. lint warning 방치 금지
5. provider public API docs 작성 규칙 준수

---

## 8.14 About hooks

Hooks는 Riverpod 자체 기능이 아니다. Flutter local state와 lifecycle logic을 재사용하기 위한 별도 패키지다.

### 8.14.1 hooks가 맞는 경우

- TextEditingController 관리
- AnimationController 관리
- FocusNode 관리
- local state 재사용
- StatefulWidget boilerplate 감소

### 8.14.2 hooks가 아닌 경우

- 앱 전역 상태
- 서버 캐시
- 도메인 상태
- 비즈니스 로직
- provider graph 대체

### 8.14.3 Wingle 적용 기준

현재 필수 라이브러리 목록에 `flutter_hooks`/`hooks_riverpod`이 없다면, 굳이 도입하지 않는 편이 단순하다. local controller가 많고 반복 코드가 커질 때 도입을 검토해도 늦지 않다.

---

## 9. Guides

## 9.1 Testing your providers

Riverpod의 provider는 전역으로 선언되지만 상태는 `ProviderContainer`에 저장되므로 테스트 격리가 가능하다.

### 9.1.1 Unit test

- `ProviderContainer.test` 사용
- 테스트마다 새 container 생성
- 테스트 종료 시 dispose
- autoDispose provider는 `listen`으로 생존시켜야 할 수 있음

### 9.1.2 Widget test

- 테스트 위젯을 `ProviderScope`로 감싼다.
- 필요한 provider를 overrides로 교체한다.
- `tester.container()`로 container를 얻어 provider 값을 확인할 수 있다.

### 9.1.3 Async test

- `provider.future`를 await해 최종 값을 검증할 수 있다.
- loading/error/data 전환을 확인해야 하면 listen을 사용한다.

### 9.1.4 Notifier mocking

문서는 Notifier 자체 mocking을 권장하지 않는다. 대신 dependency provider, repository provider를 fake로 교체하는 편이 낫다.

Wingle 테스트 전략:

1. Repository fake 구현
2. UseCase provider override
3. Notifier provider 실제 사용
4. UI widget test에서 ProviderScope override
5. provider observer로 상태 변화 확인

---

## 9.2 How to reduce provider/widget rebuilds

### 9.2.1 `select`

`select`는 provider 상태 전체가 아니라 특정 필드만 구독한다. 선택한 값이 바뀌지 않으면 rebuild를 피할 수 있다.

적합한 경우:

- user object 중 name만 필요
- profile 중 imageUrl만 필요
- settings 중 themeMode만 필요

주의점:

- 선택한 값은 immutable이어야 한다.
- mutable List를 select하면 내부 변경을 감지하지 못할 수 있다.
- `select` 자체도 약간의 비용이 있으므로 무조건 쓰면 안 된다.

### 9.2.2 `selectAsync`

비동기 provider에서 특정 필드만 기다리거나 구독할 때 사용한다.

### 9.2.3 Wingle 적용 기준

먼저 provider를 잘게 나누고, 그래도 rebuild가 문제가 되는 hot path에만 `select`를 적용한다. 무작정 `select`를 남발하면 가독성만 나빠진다.

---

## 9.3 How to eagerly initialize providers

Riverpod provider는 기본적으로 lazy다. 즉, 누군가 watch/read/listen하기 전까지 생성되지 않는다.

### 9.3.1 eager init 방식

공식 문서는 별도 eager flag가 없으며, `ProviderScope` 아래에서 특정 provider를 watch/read하는 위젯을 두는 방식을 제시한다.

### 9.3.2 child 패턴

앱 전체 rebuild를 막기 위해 eager init widget의 child를 그대로 반환하는 패턴을 사용한다.

### 9.3.3 Wingle 적용 예

eager init 후보:

- 앱 설정
- 인증 상태
- codebook current versions
- localization 준비
- remote config

주의:

- 모든 provider를 eager init하면 startup이 느려진다.
- splash screen에서 필요한 최소 provider만 초기화해야 한다.
- 실패 시 retry/오프라인 fallback 정책이 필요하다.

---

## 9.4 Implementing pull-to-refresh

Riverpod은 pull-to-refresh 구현을 선언적으로 처리할 수 있다.

### 9.4.1 해결해야 할 UX 문제

- 최초 로딩은 전체 spinner
- 새로고침은 기존 데이터를 유지하면서 refresh indicator
- 에러 발생 시 기존 데이터 유지 여부
- refresh indicator가 너무 빨리 사라지지 않게 처리

### 9.4.2 핵심 방식

- `RefreshIndicator`의 `onRefresh`에서 provider refresh
- `AsyncValue`의 loading/error/data 상태 구분
- refresh 중 이전 데이터 유지

### 9.4.3 Wingle 적용

매칭 목록, 코드북 갱신, 프로필 조회 등에서 refresh 정책을 명확히 해야 한다. 새로고침 때 화면 전체가 빈 로딩으로 바뀌면 UX가 나빠진다.

---

## 9.5 How to debounce/cancel network requests

검색·자동완성·필터 변경처럼 입력이 빠르게 바뀌는 화면은 네트워크 요청이 중복될 수 있다.

### 9.5.1 핵심 방식

- `autoDispose`
- `ref.onDispose`
- cancel token
- debounce timer
- family parameter

### 9.5.2 적용 예

- 지역 검색
- 학교 검색
- 닉네임 중복 확인
- 추천 상대 필터 검색
- 코드북 group별 fetch

### 9.5.3 Wingle 적용 기준

Dio를 쓰므로 요청 단위 cancel token을 provider lifecycle과 연결하는 구조가 적합하다. 화면을 벗어나거나 검색어가 바뀌면 이전 요청은 취소해야 한다.

---

## 10. References

## 10.1 All Providers

Provider API Reference는 각 provider 타입의 constructor, modifier, override, equality, source hash, name, dependencies 등을 설명한다.

실무적으로 봐야 할 항목:

- provider type 선택
- `.autoDispose`
- `.family`
- `overrideWith`
- `overrideWithValue`
- provider name/debug 정보
- dependency 선언

## 10.2 Containers / Scopes

ProviderContainer API Reference에서 중요한 메서드:

| 메서드 | 용도 |
|---|---|
| `read` | provider 현재 값 읽기 |
| `listen` | provider 변화 구독 |
| `refresh` | invalidate + read |
| `invalidate` | 상태 폐기 |
| `dispose` | container 폐기 |
| `pump` | provider dispose/rebuild 대기 |
| `updateOverrides` | override 갱신 |

Flutter 앱에서는 `ProviderScope`를 주로 쓰고, `ProviderContainer`는 테스트에서 주로 쓴다.

## 10.3 Refs

Ref API에서 중요한 속성/개념:

- `container`
- `mounted`
- `isFirstBuild`
- `isRefresh`
- `isReload`
- `isPaused`

비동기 작업 후 `mounted`를 확인하는 습관은 `autoDispose` provider에서 특히 중요하다.

## 10.4 Consumers

Consumer 계열은 Flutter 위젯과 provider graph를 연결하는 공식 API다. StatelessWidget에서 직접 provider를 읽으려 하지 말고 Consumer 계열로 변환해야 한다.

## 10.5 Offline persistence / Mutations

둘 다 Riverpod 3.0에서 문서화된 실험 기능이다. API Reference를 확인하고, 버전별 breaking change 가능성을 감수할 수 있을 때만 사용한다.

## 10.6 core / misc

core/misc reference는 provider lifecycle, AsyncValue, ProviderException, retry, observer, override 등 세부 타입을 확인하는 용도다.

---

## 11. Migration guides

## 11.1 Riverpod for Provider Users - Quickstart

기존 `provider` 패키지 사용자에게는 다음 전략이 제시된다.

1. 한 번에 전체 마이그레이션하지 않는다.
2. leaf provider부터 옮긴다.
3. 기존 provider와 Riverpod을 함께 사용할 수 있다.
4. ProxyProvider 계열은 `ref.watch` 기반 provider 조합으로 대체한다.
5. 최종적으로 Riverpod provider graph로 통합한다.

신규 Wingle 프로젝트라면 Provider 패키지를 섞을 이유가 없다.

---

## 11.2 Provider vs Riverpod

### 11.2.1 Provider 패키지

Provider는 위젯 트리의 InheritedWidget 모델에 강하게 묶여 있다. 같은 타입 provider 충돌, context 의존성, widget tree 위치 문제, ConsumerN 패턴 등의 한계가 있다.

### 11.2.2 Riverpod

Riverpod은 provider를 위젯 트리 밖의 Dart object로 선언하고, `ProviderScope`/`ProviderContainer`가 상태를 관리한다. 이 구조 덕분에 테스트, override, provider 조합, 동일 타입 여러 provider 선언이 더 자연스럽다.

### 11.2.3 family vs scoping

Provider 패키지에서 scoping으로 해결하던 문제는 Riverpod에서는 `family`로 명시적으로 처리하는 경우가 많다. scoping은 가능하지만 더 복잡하므로 남발하지 않는 것이 좋다.

---

## 11.3 Motivation

Riverpod이 등장한 이유는 Provider 패키지가 InheritedWidget API의 제약을 그대로 받기 때문이다.

핵심 문제:

- 같은 타입 provider 여러 개를 안정적으로 다루기 어려움
- provider가 한 번에 하나의 값만 emit하는 모델의 제약
- context 의존성으로 인한 위치 문제
- 파생 상태 조합의 불편함
- 테스트와 override의 제약

Riverpod은 provider를 위젯 트리에서 분리해 더 현대적인 상태 관리, 캐싱, 반응형 모델을 제공하는 방향이다.

---

## 11.4 From StateNotifier

공식 문서는 `StateNotifier`에서 `Notifier`/`AsyncNotifier`로 이동하는 것을 권장한다.

### 11.4.1 차이

기존 방식:

- `StateNotifier` 클래스
- provider 선언에서 ref/parameter 주입
- async state는 `AsyncValue<T>`를 직접 state로 다룸
- `AsyncValue.guard` 사용
- family/autoDispose modifier가 provider 선언에 붙음

신규 방식:

- `Notifier` 또는 `AsyncNotifier`
- 초기화 로직은 `build`
- ref는 notifier 내부에서 접근 가능
- async state는 `AsyncNotifier<T>`가 더 자연스럽게 처리
- parameter는 `build` 인자로 받음
- codegen과 잘 맞음

### 11.4.2 마이그레이션 기준

- `StateNotifier<AsyncValue<T>>`는 `AsyncNotifier<T>`로 바꾸는 것이 대체로 맞다.
- 초기 fetch는 `build`로 이동한다.
- side effect method에서는 `future`, `update`, `state`를 적절히 사용한다.
- build 안에서 불필요한 try/catch/guard를 제거한다.

---

## 11.5 From ChangeNotifier

`ChangeNotifier`는 mutable state와 `notifyListeners` 호출에 의존한다. 공식 문서는 신규 구조에서 `Notifier`/`AsyncNotifier`와 immutable state를 사용하는 방향을 제시한다.

### 11.5.1 ChangeNotifier의 문제

- loading/error/data를 bool 여러 개로 관리하기 쉬움
- 잘못된 중간 상태가 생기기 쉬움
- `notifyListeners` 호출 누락/중복 위험
- mutable state 때문에 변경 추적이 어렵다
- 테스트와 디버깅이 불편하다

### 11.5.2 전환 기준

질문 순서:

1. side effect method가 필요한가?
   - 필요하면 class-based provider
   - 아니면 function provider
2. state를 비동기로 로드해야 하는가?
   - 필요하면 `AsyncNotifier`
   - 아니면 `Notifier`
3. parameter가 필요한가?
   - 필요하면 `build` 인자로 받는다.

---

## 11.6 0.14.0 to 1.0.0

핵심 변화는 provider interaction syntax 통합이다.

- `useProvider` 제거
- `HookConsumerWidget` + `ref.watch` 사용
- `ConsumerWidget` build signature 변경
- `context.read` 대신 `ref.read`
- `StateProvider` watch 결과가 controller가 아니라 state 중심으로 정리

구버전 자료를 볼 때 이 차이를 모르면 현재 Riverpod 코드와 맞지 않는 예제를 따라 하게 된다.

---

## 11.7 0.13.0 to 0.14.0

핵심 변화는 `StateNotifierProvider` 관련 접근 방식이다.

- notifier를 얻으려면 `.notifier`
- state를 얻으려면 provider 자체 watch
- `.state` 접근 패턴 변경
- migration CLI 제공

현시점 신규 코드에서는 직접 적용할 일은 적지만, 오래된 블로그/StackOverflow 답변을 해석할 때 중요하다.

---

## 12. Wingle Clean Architecture 적용안

## 12.1 레이어별 provider 배치

권장 구조:

```text
lib/
  core/
    config/
    network/
    storage/
    router/
    theme/
  features/
    codebook/
      data/
        data_sources/
        repositories/
      domain/
        entities/
        repositories/
        use_cases/
      presentation/
        providers/
        widgets/
        pages/
```

### 12.1.1 data layer

- Dio client provider
- API data source provider
- local data source provider
- repository implementation provider

### 12.1.2 domain layer

- repository abstract class
- use case class
- entity/value object

### 12.1.3 presentation layer

- screen state provider
- `AsyncNotifier`/`Notifier`
- widget 전용 selector provider
- UI component

---

## 12.2 코드북 동기화 기능에 대한 Riverpod 설계 기준

현재 Wingle 프로젝트에서 코드북 동기화를 구현한다면 다음 기준이 맞다.

### 12.2.1 책임 분리

| 책임 | 위치 |
|---|---|
| Hive에서 local version 읽기 | local data source |
| `/api/v1/codebook/current-versions` 호출 | remote data source |
| 낮은 버전/누락 group 계산 | use case 또는 repository |
| 필요한 group만 fetch | use case |
| Hive 저장 | local data source |
| 앱 부팅 시 orchestrating | `AsyncNotifier` 또는 bootstrapping provider |
| Splash UI 반영 | presentation provider watch |

### 12.2.2 provider 선택

- Dio client: `Provider`
- CodebookRemoteDataSource: `Provider`
- CodebookLocalDataSource: `Provider`
- CodebookRepository: `Provider`
- SyncCodebooksUseCase: `Provider`
- CodebookSyncController: `AsyncNotifierProvider`

### 12.2.3 autoDispose 여부

앱 부팅 동기화 provider는 앱 생명주기 전체에서 유지할지, splash 통과 후 폐기할지 결정해야 한다.

- 앱 전체에서 동기화 상태가 필요하면 keep alive
- splash에서만 쓰면 autoDispose 가능
- 코드북 데이터 자체는 Hive에 저장하고 필요 시 family provider로 읽는 것이 낫다.

---

## 12.3 상태 분류표

| 상태 | Riverpod 사용 여부 | 이유 |
|---|---:|---|
| 로그인 사용자 정보 | O | 앱 전체 공유 |
| 인증 토큰 | 직접 provider 노출 주의 | secure storage와 보안 고려 |
| 코드북 목록 | O | 캐시/동기화 대상 |
| 폼 입력 중 값 | 보통 X | 위젯 local state |
| 선택된 프로필 이미지 임시 파일 | 상황별 | 여러 단계에서 공유하면 O |
| 매칭 추천 목록 | O | API/cache/refresh 필요 |
| 버튼 loading | Notifier state 또는 Mutation | side effect 상태 |
| Dialog open 여부 | X | UI local |
| 현재 라우트 | 보통 go_router | router 책임 |

---

## 13. Anti-pattern 체크리스트

아래 항목이 보이면 구조를 다시 봐야 한다.

- [ ] build 메서드에서 `ref.read`로 상태를 구독한다.
- [ ] provider 안에서 navigation을 한다.
- [ ] provider 초기화 중 POST 요청을 한다.
- [ ] TextField의 매 글자를 전역 provider에 저장한다.
- [ ] `family` 파라미터로 mutable object를 넘긴다.
- [ ] `autoDispose` 없는 검색 provider가 query마다 생성된다.
- [ ] `ChangeNotifierProvider`를 신규 기능에 사용한다.
- [ ] `StateNotifierProvider`를 구식 예제 그대로 사용한다.
- [ ] repository를 직접 UI에서 생성한다.
- [ ] test에서 실제 API를 호출한다.
- [ ] provider override 없이 전역 singleton을 mock한다.
- [ ] mutable List를 state로 두고 내부만 수정한다.
- [ ] Observer 로그에 개인정보가 찍힌다.
- [ ] retry가 인증 오류까지 반복한다.
- [ ] provider를 위젯 내부에서 선언한다.

---

## 14. 실무 의사결정 매트릭스

| 질문 | 답 | 선택 |
|---|---|---|
| 이 값이 여러 위젯에서 공유되는가? | 아니오 | local state |
| 서버/저장소에서 비동기로 가져오는가? | 예 | FutureProvider/AsyncNotifier |
| 값을 변경하는 method가 필요한가? | 예 | Notifier/AsyncNotifier |
| 파라미터별 독립 상태가 필요한가? | 예 | family |
| 파라미터가 자주 바뀌는가? | 예 | family + autoDispose |
| side effect 진행 상태를 UI가 알아야 하는가? | 예 | AsyncNotifier state 또는 Mutation |
| 테스트에서 구현을 바꿔야 하는가? | 예 | Provider override |
| rebuild가 실제로 문제인가? | 예 | provider 분리 후 select |
| 앱 시작 전에 반드시 필요인가? | 예 | eager init |
| 실패 시 자동 재시도가 위험한가? | 예 | retry 정책 비활성/커스텀 |

---

## 15. Riverpod 학습 우선순위

Wingle 프로젝트 구현 기준으로 학습 우선순위를 매기면 다음 순서가 맞다.

1. `ProviderScope`, `ConsumerWidget`, `WidgetRef`
2. `Provider`, `FutureProvider`, `AsyncValue`
3. `NotifierProvider`, `AsyncNotifierProvider`
4. `ref.watch/read/listen`
5. `autoDispose`, `family`
6. provider override와 testing
7. retry, invalidate/refresh
8. select와 rebuild 최적화
9. ProviderObserver
10. code generation
11. scoping
12. Mutations/Offline persistence

Mutations와 Offline persistence는 흥미롭지만 실험 기능이다. MVP의 핵심 안정성이 먼저다.

---

## 16. 공식 문서 URL 목록

### Introduction

- https://riverpod.dev/docs/introduction/getting_started
- https://riverpod.dev/docs/introduction/why_riverpod
- https://riverpod.dev/docs/whats_new
- https://riverpod.dev/docs/migration/from_2
- https://riverpod.dev/docs/root/faq
- https://riverpod.dev/docs/root/do_dont

### Tutorials

- https://riverpod.dev/docs/tutorials/first_app

### Concepts

- https://riverpod.dev/docs/concepts2/providers
- https://riverpod.dev/docs/concepts2/consumers
- https://riverpod.dev/docs/concepts2/containers
- https://riverpod.dev/docs/concepts2/refs
- https://riverpod.dev/docs/concepts2/auto_dispose
- https://riverpod.dev/docs/concepts2/family
- https://riverpod.dev/docs/concepts2/mutations
- https://riverpod.dev/docs/concepts2/offline
- https://riverpod.dev/docs/concepts2/retry
- https://riverpod.dev/docs/concepts2/observers
- https://riverpod.dev/docs/concepts2/overrides
- https://riverpod.dev/docs/concepts2/scoping
- https://riverpod.dev/docs/concepts2/about_code_generation
- https://riverpod.dev/docs/concepts2/about_hooks

### Guides

- https://riverpod.dev/docs/how_to/testing
- https://riverpod.dev/docs/how_to/select
- https://riverpod.dev/docs/how_to/eager_initialization
- https://riverpod.dev/docs/how_to/pull_to_refresh
- https://riverpod.dev/docs/how_to/cancel

### Migration

- https://riverpod.dev/docs/from_provider/quickstart
- https://riverpod.dev/docs/from_provider/provider_vs_riverpod
- https://riverpod.dev/docs/from_provider/motivation
- https://riverpod.dev/docs/migration/from_state_notifier
- https://riverpod.dev/docs/migration/from_change_notifier
- https://riverpod.dev/docs/migration/0.14.0_to_1.0.0
- https://riverpod.dev/docs/migration/0.13.0_to_0.14.0

### References

- https://pub.dev/documentation/flutter_riverpod/latest/flutter_riverpod/
- https://pub.dev/documentation/flutter_riverpod/latest/flutter_riverpod/ProviderContainer-class.html
- https://pub.dev/documentation/flutter_riverpod/latest/flutter_riverpod/Ref-class.html

---

## 17. 최종 판단

Riverpod 문서를 프로젝트에 적용할 때 가장 큰 실수는 “모든 상태를 provider로 올리는 것”과 “구식 StateNotifier 예제를 그대로 따라 하는 것”이다.

Wingle은 Flutter/Riverpod/Clean Architecture 조합이므로 다음을 강제하는 편이 맞다.

1. 신규 상태 로직은 `Notifier`/`AsyncNotifier` 중심.
2. 의존성 주입은 `Provider`.
3. 화면별 비동기 조회는 `FutureProvider` 또는 `AsyncNotifier`.
4. 화면 parameter는 `family`.
5. 자주 바뀌는 family는 `autoDispose`.
6. local UI state는 provider 금지.
7. API 호출은 repository/use case를 통해 수행.
8. 테스트는 override 중심.
9. retry 정책은 API error taxonomy와 함께 설계.
10. 실험 기능은 핵심 경로에서 보수적으로 사용.

이 기준을 따르면 Riverpod을 단순 상태관리 라이브러리가 아니라, 앱의 의존성 그래프·캐시·테스트 가능성·비동기 상태 모델까지 통합하는 구조로 사용할 수 있다.
