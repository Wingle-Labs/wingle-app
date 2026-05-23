---
name: riverpod-advanced-practices
description: Use when designing, implementing, refactoring, reviewing, or testing Flutter Riverpod 3.x code, especially annotation-based generated providers with @riverpod, riverpod_generator/build_runner, Notifier/AsyncNotifier/StreamNotifier architecture, provider graph design, cache-first/offline-first flows, ref.watch/read/listen/select usage, provider overrides, and Wingle Clean Architecture provider placement.
---

# Riverpod Advanced Practices

Use this skill for Riverpod work in Flutter projects, especially Wingle.

For deeper background, read [references/riverpod_docs_study_ko.md](references/riverpod_docs_study_ko.md) selectively. Search that file by section title rather than loading it all when possible.

## Required Workflow

1. Identify whether the state is dependency injection, synchronous mutable state, asynchronous state, stream state, parameterized data, or ephemeral UI state.
2. Choose the narrowest provider that fits the responsibility.
3. Keep business/data dependencies in providers; keep transient UI-only state local unless it must be shared across screens.
4. Use `ref.watch` for reactive dependencies, `ref.read` for event handlers and commands, and `ref.listen` for UI side effects such as navigation, dialogs, and snackbars.
5. Validate lifecycle behavior: `autoDispose`, `family` parameter stability, cancellation, retry, and `Ref.mounted` after awaits.
6. Add provider override-friendly tests for repository/use-case/notifier logic.
7. Before finalizing, check the anti-pattern list below.

## Provider Selection

Use annotation-based generated Riverpod providers by default. The preferred
syntax is `@riverpod`/`@Riverpod(keepAlive: true)` plus generated
`Notifier`/`AsyncNotifier`/`StreamNotifier` providers, not manual provider
declarations.

Manual `Provider`, `FutureProvider`, `StreamProvider`,
`NotifierProvider`, `AsyncNotifierProvider`, `StateNotifierProvider`,
`StateProvider`, or `ChangeNotifierProvider` declarations are allowed only for
legacy maintenance, migration bridges, requirements that code generation cannot
express cleanly, or explicit user requests.

Avoid experimental Mutations and Offline persistence for critical MVP paths
unless the user explicitly asks.

## Riverpod Code Generation & Annotation Rules

### 1. Default provider style

All new Riverpod providers must prefer annotation-based code generation.

Use this style by default:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'example_controller.g.dart';

@riverpod
class ExampleController extends _$ExampleController {
  @override
  Future<ExampleState> build() async {
    return const ExampleState.initial();
  }

  Future<void> submit() async {
    // business action
  }
}
```

Do not use this as the default for new code:

```dart
final exampleProvider = FutureProvider<ExampleState>((ref) async {
  // ...
});
```

Manual provider declarations are allowed only when maintaining legacy code,
bridging old code during migration, a generated provider cannot express the
requirement cleanly, or the user explicitly asks for non-generator syntax.

### 2. Mandatory generated file structure

Every file containing `@riverpod` must include:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '<file_name>.g.dart';
```

Rules:

- The part file name must match the source file name.
- Do not invent generated files manually.
- Generated files must be created by build_runner.
- If the provider class is renamed, update all generated provider usages.
- Run `dart run build_runner build --delete-conflicting-outputs`.
- During active development, use `dart run build_runner watch --delete-conflicting-outputs`.

### 3. Generated provider naming

```dart
@riverpod
class CodebookSyncController extends _$CodebookSyncController {
  @override
  Future<void> build() async {}
}
```

Generates `codebookSyncControllerProvider`.

Usage:

```dart
final state = ref.watch(codebookSyncControllerProvider);
await ref.read(codebookSyncControllerProvider.notifier).sync();
```

### 4. Provider type selection

| Requirement | Preferred Riverpod pattern |
|---|---|
| Synchronous derived value | `@riverpod` function or generated Notifier |
| Mutable synchronous state | `@riverpod class ... extends _$...` with synchronous `build()` |
| Async server state | `@riverpod class ... extends _$...` with `Future<T> build()` |
| Stream state | `@riverpod class ... extends _$...` with `Stream<T> build()` |
| One-off user action | Method inside generated Notifier/AsyncNotifier or separate action controller |
| Complex business state | Generated Notifier/AsyncNotifier, not StateProvider |
| Legacy migration only | StateNotifierProvider only if unavoidable |

Prefer Notifier/AsyncNotifier over StateNotifier. Do not introduce
StateNotifierProvider in new code unless required for compatibility. Do not use
StateProvider for business logic. Widgets consume state; providers/controllers
own business logic.

### 5. Family parameters with code generation

Provider parameters must be represented as `build()` parameters.

```dart
@riverpod
class ProfileDetailController extends _$ProfileDetailController {
  @override
  Future<ProfileDetailModel> build(String profileId) async {
    final repository = ref.watch(profileRepositoryProvider);
    return repository.fetchProfileDetail(profileId);
  }
}
```

Usage:

```dart
final profile = ref.watch(profileDetailControllerProvider(profileId));
```

Do not use old `.family` syntax for new generated providers. Keep parameter
types immutable and equality-safe. Prefer primitive IDs or immutable value
objects. Avoid passing mutable model objects as provider parameters.

### 6. Consumer usage rules

Use `ConsumerWidget` for stateless Riverpod UI:

```dart
class ExampleView extends ConsumerWidget {
  const ExampleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exampleControllerProvider);
    return state.when(
      data: (value) => Text(value.toString()),
      loading: CircularProgressIndicator.new,
      error: (error, stackTrace) => Text(error.toString()),
    );
  }
}
```

Use `ConsumerStatefulWidget`/`ConsumerState` for stateful Riverpod UI:

```dart
class ExampleView extends ConsumerStatefulWidget {
  const ExampleView({super.key});

  @override
  ConsumerState<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends ConsumerState<ExampleView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exampleControllerProvider);
    return Text(state.toString());
  }
}
```

Do not write `State<T>.build(BuildContext context, WidgetRef ref)`.
`WidgetRef` is available in `ConsumerWidget`. In `ConsumerState`, use the
`ref` property. Use `ref.watch` for UI subscriptions, `ref.read(...notifier)`
for event handlers, and avoid `ref.watch` inside callbacks.

### 7. AsyncValue rules

All async provider UI states must handle loading, error, and data.

```dart
final state = ref.watch(exampleControllerProvider);
return state.when(
  data: ExampleContent.new,
  loading: ExampleLoadingView.new,
  error: (error, stackTrace) => ExampleErrorView(
    error: error,
    onRetry: () => ref.invalidate(exampleControllerProvider),
  ),
);
```

Do not manually model `isLoading`, `errorMessage`, and nullable data if
`AsyncValue<T>` already fits. Use `ref.invalidate(provider)` or
`ref.refresh(provider.future)` intentionally for reload. Do not call
refresh/invalidate blindly inside `build()`.

### 8. Provider dependency direction

Provider dependencies must remain mostly unidirectional.

Bad pattern:

```text
PostListProvider <--> PostDetailProvider
```

Preferred pattern:

```text
PostListProvider --> SharedPostProvider <-- PostDetailProvider
```

Do not make list/detail providers directly mutate each other if a shared
domain-level provider is more appropriate. Extract shared entity state into a
common provider when multiple screens need synchronization. Avoid circular
dependencies. If provider dependencies become hard to explain in one paragraph,
redesign the provider graph.

### 9. Cache-first detail screen pattern

When navigating from a list screen to a detail screen:

1. Use cached list data immediately if available.
2. Show partial detail UI from cache.
3. Fetch full detail from API.
4. Replace or merge with fresh detail state.
5. Update shared cache if necessary.

Example target structure:

```text
profile_list_controller.dart
profile_detail_controller.dart
profile_cache_controller.dart
profile_repository.dart
```

The detail controller may read a cached item first, but canonical shared entity
state belongs in a shared cache/domain provider when synchronization is needed.

### 10. Offline-first pattern

For local-first data such as codebooks, settings, and cached profile metadata:

1. Read local Hive/storage first.
2. Emit local data quickly.
3. Request server version/current state.
4. If server has newer data, fetch updates.
5. Save to local storage.
6. Emit updated state.
7. If network fails, keep local state and expose a non-blocking error if needed.

For Wingle codebook synchronization, prefer:

```text
App boot
  -> read local codebook versions from Hive
  -> GET /api/v1/codebook/current-versions
  -> compare local vs remote versions
  -> fetch missing/outdated codebook groups
  -> persist updated groups into Hive
  -> expose ready/synced/error state through Riverpod
```

Do not block the entire app unnecessarily if non-critical codebooks can be
lazily updated.

### 11. Request cancellation and lifecycle

When a provider starts cancelable network work, wire cancellation to provider
disposal.

```dart
@riverpod
class SearchController extends _$SearchController {
  @override
  Future<SearchResult> build(String query) async {
    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    final repository = ref.watch(searchRepositoryProvider);
    return repository.search(query, cancelToken: cancelToken);
  }
}
```

Use `ref.onDispose` for cancellation/cleanup. For text search, debounce and
cancel stale requests. Do not let outdated requests overwrite newer state. Be
explicit about autoDispose/keepAlive behavior. Generated providers are
autoDispose by default unless configured otherwise, so long-lived cache
controllers must intentionally opt into keep-alive behavior when needed.

```dart
@Riverpod(keepAlive: true)
class CodebookCacheController extends _$CodebookCacheController {
  @override
  Future<CodebookCacheState> build() async {
    // long-lived app-level cache
  }
}
```

### 12. ref.watch, ref.read, ref.listen, select

| API | Use for | Avoid |
|---|---|---|
| `ref.watch` | Declarative dependency/subscription | Event callbacks |
| `ref.read` | One-time read in callbacks/actions | Building reactive UI |
| `ref.listen` | Side effects such as snackbar/navigation | Pure UI rendering |
| `select` | Narrow rebuild scope | Premature optimization everywhere |
| `selectAsync` | Narrow async field subscription | Complex unreadable chains |

Do not over-watch large objects. If only one field affects UI, consider
`select`. If many providers are watched and network requests multiply,
redesign or debounce. Do not optimize with `select` blindly; use it when
rebuild cost is real.

### 13. Clean Architecture placement

Recommended feature layout:

```text
lib/features/profile/
  data/
    datasources/
      profile_remote_data_source.dart
      profile_local_data_source.dart
    models/
      profile_response_dto.dart
    repositories/
      profile_repository_impl.dart
  domain/
    entities/
      profile.dart
    repositories/
      profile_repository.dart
    usecases/
      get_profile_detail_use_case.dart
  presentation/
    providers/
      profile_list_controller.dart
      profile_detail_controller.dart
      profile_cache_controller.dart
    pages/
      profile_list_page.dart
      profile_detail_page.dart
    widgets/
      profile_card.dart
      profile_detail_content.dart
```

Riverpod controllers belong in `presentation/providers` unless the provider is
app-wide infrastructure. Repository providers may live near data/domain
composition roots. UI widgets must not call data sources directly. Providers
should depend on repositories/use cases, not raw Dio/Hive directly, unless it
is an infrastructure provider. Do not put business logic inside widgets.

### 14. Wingle-specific examples

When suggesting Wingle code, use these target files and responsibilities:

- `lib/features/codebook/presentation/providers/codebook_sync_controller.dart`: `@Riverpod(keepAlive: true)` async controller that reads local Hive versions, requests current server versions, compares versions, fetches missing/outdated groups, persists updates, and exposes `AsyncValue<CodebookSyncState>`.
- `lib/features/matching/presentation/providers/matching_candidate_list_controller.dart`: generated list controller that watches a filter provider.
- `lib/features/matching/presentation/providers/matching_candidate_detail_controller.dart`: generated detail controller that uses cached list item first, then fetches detail.
- `lib/features/matching/presentation/providers/matching_candidate_cache_controller.dart`: shared cache provider updated by favorite/pass/block actions; list and detail must not directly mutate each other.
- `lib/features/matching/presentation/providers/matching_filter_controller.dart`: synchronous generated Notifier with immutable filter state; debounce search-like inputs if they trigger network requests.

### 15. Migration rules

When existing code uses manual providers:

1. Do not convert everything blindly.
2. Convert feature-by-feature.
3. Start with providers that own async server state.
4. Replace StateNotifierProvider with generated AsyncNotifier or Notifier where appropriate.
5. Keep public behavior unchanged.
6. Add tests or update existing tests.
7. Run `dart format .`, `dart analyze`, and `dart run build_runner build --delete-conflicting-outputs`.

Migration checklist:

- Added `riverpod_annotation` import.
- Added correct `part '*.g.dart';`.
- Converted provider class/function to `@riverpod`.
- Updated generated provider usages.
- Removed obsolete manual provider declaration.
- Handled `AsyncValue` loading/error/data.
- Checked lifecycle: autoDispose vs keepAlive.
- Checked provider dependency direction.
- Ran build_runner.
- Ran analyzer.
- Verified no circular dependencies.

### 16. Banned anti-patterns

- New StateNotifierProvider for ordinary feature state.
- StateProvider for complex business logic.
- Provider-to-provider circular references.
- List/detail providers directly mutating each other when shared cache is needed.
- Calling API directly from widgets.
- Calling repository/data source directly from widgets.
- Calling `ref.watch` inside button callbacks.
- Calling `ref.refresh` or `ref.invalidate` unconditionally inside `build()`.
- Passing mutable models as generated provider parameters.
- Manually editing `.g.dart` files.
- Forgetting `part '<file>.g.dart';`.
- Forgetting to run build_runner after adding `@riverpod`.
- Using `BuildContext` inside providers unless narrowly justified.
- Storing UI-only context/navigation logic inside domain/data providers.
- Force-unwrapping nullable state with `!` when a safe branch is possible.

### 17. Output format for future code suggestions

Future Riverpod code suggestions should include:

1. Directory path.
2. File name.
3. Purpose.
4. Fenced Dart code block.
5. build_runner/analyze command if generated code is involved.
6. Migration notes when updating existing code.

Example:

```text
경로: lib/features/codebook/presentation/providers/codebook_sync_controller.dart
파일: codebook_sync_controller.dart
목적: 앱 부팅 시 코드북 버전 비교 및 업데이트를 담당하는 Riverpod generated AsyncNotifier
```

```dart
// code here
```

```text
dart run build_runner build --delete-conflicting-outputs
dart analyze
```

## Wingle Architecture Rules

- Place infrastructure providers near the data layer: API clients, local data sources, remote data sources, repository implementations.
- Place abstract repositories and entities in the domain layer, not Riverpod-specific code unless the project already does so.
- Place screen state, derived UI selectors, and Notifier/AsyncNotifier providers in presentation providers.
- Preserve mock/live switching through repository providers and overrides.
- Do not instantiate repositories directly inside widgets.
- For codebook/reference data, prefer local cache data sources and explicit sync orchestration over provider state as the persistent store.
- Do not use native Flutter state management for feature/business state unless explicitly justified.
- Avoid magic numbers for colors, sizes, durations, and spacing; use project constants or design tokens.
- Avoid force unwrapping/null assertions when a safe branch or typed state can express the case.
- Public Dart members in suggested code must include API docs that satisfy `public_member_api_docs`.
- Unless the user asks to edit app code, provide Riverpod code as suggestions in fenced Dart blocks rather than applying it automatically.

## Ref Usage Rules

- In build methods, use `ref.watch` for values rendered by the widget.
- In event handlers, use `ref.read(provider.notifier).method()` or `ref.read(provider)` for one-time reads.
- Use `ref.listen` only for side effects triggered by state changes.
- Do not use `ref.read` in build as a substitute for `watch`.
- Inside providers, use `ref.watch` to declare dependencies. Use `read` sparingly for command-style calls.
- After `await` inside provider logic, check `ref.mounted` when the provider may have been disposed.

## Lifecycle And Performance

- Use `autoDispose` for search, detail pages, parameterized providers, and network requests tied to screen lifetime.
- Use `ref.onDispose` to cancel HTTP requests, timers, subscriptions, and debounced work.
- Ensure `family` parameters have stable `==` and `hashCode`; do not pass mutable lists/maps.
- Do not add `select` first. Split providers or state first, then use `select` or `selectAsync` only where rebuilds are measured or obvious.
- Consider eager initialization when data is required before app flow proceeds, using a dedicated bootstrap/splash provider or app-level watcher.
- Be explicit with automatic retry. Disable or customize retry for auth errors, validation errors, 404s, and other non-transient failures.

## Testing Rules

- Use `ProviderContainer.test` or `ProviderScope(overrides: ...)`.
- Override repositories/data sources, not random global singletons.
- Do not let provider tests call real APIs unless the test is explicitly integration-level.
- Test Notifier/AsyncNotifier behavior through public methods and emitted states.
- Test `AsyncValue` branches: loading, data, error, retry/refresh behavior when relevant.

## Anti-Patterns

Flag and fix these before finalizing Riverpod work:

- Provider declared inside a widget or method instead of as a stable top-level final/codegen declaration.
- Provider initialization performs navigation, dialogs, snackbars, or POST/PUT/DELETE side effects.
- TextField keystrokes are stored in global provider state without a cross-screen reason.
- Mutable list/map state is mutated in place instead of replaced immutably.
- `family` receives mutable objects.
- Search/query providers omit `autoDispose`.
- Widget directly constructs repository implementations.
- Tests depend on real network or global singletons instead of overrides.
- Sensitive data is logged by a ProviderObserver.
- Automatic retry repeats auth or validation failures.

## When To Read The Reference

Read `references/riverpod_docs_study_ko.md` when:

- Migrating Riverpod 2.x to 3.x.
- Deciding between `refresh`, `invalidate`, retry, pause/resume, or eager initialization.
- Designing provider tests or overrides.
- Reviewing provider anti-patterns.
- Working on Wingle codebook sync, cached reference data, or Clean Architecture provider placement.
