// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [TermRepository] 구현체를 제공하는 Provider.
///
/// - Presentation 레이어는 이 Provider를 통해 Repository에 접근한다.
/// - 구현체 교체(테스트, Mock 등)를 용이하게 하기 위한 추상화 지점이다.

@ProviderFor(termRepository)
const termRepositoryProvider = TermRepositoryProvider._();

/// [TermRepository] 구현체를 제공하는 Provider.
///
/// - Presentation 레이어는 이 Provider를 통해 Repository에 접근한다.
/// - 구현체 교체(테스트, Mock 등)를 용이하게 하기 위한 추상화 지점이다.

final class TermRepositoryProvider
    extends $FunctionalProvider<TermRepository, TermRepository, TermRepository>
    with $Provider<TermRepository> {
  /// [TermRepository] 구현체를 제공하는 Provider.
  ///
  /// - Presentation 레이어는 이 Provider를 통해 Repository에 접근한다.
  /// - 구현체 교체(테스트, Mock 등)를 용이하게 하기 위한 추상화 지점이다.
  const TermRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'termRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$termRepositoryHash();

  @$internal
  @override
  $ProviderElement<TermRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TermRepository create(Ref ref) {
    return termRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TermRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TermRepository>(value),
    );
  }
}

String _$termRepositoryHash() => r'52c77eebd31b306aec396adaac3483ef9dc20640';
