// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [QuestionRepository] 구현체를 제공하는 Provider.

@ProviderFor(questionRepository)
const questionRepositoryProvider = QuestionRepositoryProvider._();

/// [QuestionRepository] 구현체를 제공하는 Provider.

final class QuestionRepositoryProvider
    extends
        $FunctionalProvider<
          QuestionRepository,
          QuestionRepository,
          QuestionRepository
        >
    with $Provider<QuestionRepository> {
  /// [QuestionRepository] 구현체를 제공하는 Provider.
  const QuestionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questionRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuestionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  QuestionRepository create(Ref ref) {
    return questionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuestionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuestionRepository>(value),
    );
  }
}

String _$questionRepositoryHash() =>
    r'bdbf68571225b6cfa3a5b86b038b441602b75bd5';
