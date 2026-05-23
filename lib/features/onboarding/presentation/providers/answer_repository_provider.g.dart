// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [AnswerRepository] 구현체를 제공하는 Provider.

@ProviderFor(answerRepository)
const answerRepositoryProvider = AnswerRepositoryProvider._();

/// [AnswerRepository] 구현체를 제공하는 Provider.

final class AnswerRepositoryProvider
    extends
        $FunctionalProvider<
          AnswerRepository,
          AnswerRepository,
          AnswerRepository
        >
    with $Provider<AnswerRepository> {
  /// [AnswerRepository] 구현체를 제공하는 Provider.
  const AnswerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'answerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$answerRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnswerRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnswerRepository create(Ref ref) {
    return answerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnswerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnswerRepository>(value),
    );
  }
}

String _$answerRepositoryHash() => r'eec95f05e9f4e9035a269675779a089131d15bc7';
