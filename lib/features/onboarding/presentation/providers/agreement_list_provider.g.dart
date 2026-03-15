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
    extends $AsyncNotifierProvider<AgreementList, AgreementListState> {
  /// Riverpod Notifier
  const AgreementListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agreementListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agreementListHash();

  @$internal
  @override
  AgreementList create() => AgreementList();
}

String _$agreementListHash() => r'968ceab7f9af871419f3b7b34c27e62a3cd798ef';

/// Riverpod Notifier

abstract class _$AgreementList extends $AsyncNotifier<AgreementListState> {
  FutureOr<AgreementListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<AgreementListState>, AgreementListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AgreementListState>, AgreementListState>,
              AsyncValue<AgreementListState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
