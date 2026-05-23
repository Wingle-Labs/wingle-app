// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'codebook_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [CodebookRepository] 구현체를 제공하는 Provider.

@ProviderFor(codebookRepository)
const codebookRepositoryProvider = CodebookRepositoryProvider._();

/// [CodebookRepository] 구현체를 제공하는 Provider.

final class CodebookRepositoryProvider
    extends
        $FunctionalProvider<
          CodebookRepository,
          CodebookRepository,
          CodebookRepository
        >
    with $Provider<CodebookRepository> {
  /// [CodebookRepository] 구현체를 제공하는 Provider.
  const CodebookRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codebookRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codebookRepositoryHash();

  @$internal
  @override
  $ProviderElement<CodebookRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CodebookRepository create(Ref ref) {
    return codebookRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CodebookRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CodebookRepository>(value),
    );
  }
}

String _$codebookRepositoryHash() =>
    r'3850f48257d8b8a58fe680eab9b2fa7b63a5cdb3';
