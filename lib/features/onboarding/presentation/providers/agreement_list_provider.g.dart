// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod Notifier

@ProviderFor(AgreementList)
const agreementListProvider = AgreementListProvider._();

/// Riverpod Notifier
final class AgreementListProvider
    extends $NotifierProvider<AgreementList, AgreementListState> {
  /// Riverpod Notifier
  const AgreementListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agreementListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agreementListHash();

  @$internal
  @override
  AgreementList create() => AgreementList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AgreementListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AgreementListState>(value),
    );
  }
}

String _$agreementListHash() => r'49e02b0a330d197bd925b2393aabca45315afac4';

/// Riverpod Notifier

abstract class _$AgreementList extends $Notifier<AgreementListState> {
  AgreementListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AgreementListState, AgreementListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AgreementListState, AgreementListState>,
              AgreementListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
