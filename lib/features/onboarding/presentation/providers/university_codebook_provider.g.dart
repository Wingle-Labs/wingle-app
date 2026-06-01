// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'university_codebook_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// UNIVERSITY 코드북 항목을 제공한다.

@ProviderFor(universityCodebookEntries)
const universityCodebookEntriesProvider = UniversityCodebookEntriesProvider._();

/// UNIVERSITY 코드북 항목을 제공한다.

final class UniversityCodebookEntriesProvider
    extends
        $FunctionalProvider<
          List<CodebookEntry>,
          List<CodebookEntry>,
          List<CodebookEntry>
        >
    with $Provider<List<CodebookEntry>> {
  /// UNIVERSITY 코드북 항목을 제공한다.
  const UniversityCodebookEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'universityCodebookEntriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$universityCodebookEntriesHash();

  @$internal
  @override
  $ProviderElement<List<CodebookEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<CodebookEntry> create(Ref ref) {
    return universityCodebookEntries(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CodebookEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CodebookEntry>>(value),
    );
  }
}

String _$universityCodebookEntriesHash() =>
    r'e5b4a4a3b8aa78e0063e2eb5f17c27d9f3cef3ba';
