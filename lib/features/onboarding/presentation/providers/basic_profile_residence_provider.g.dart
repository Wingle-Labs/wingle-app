// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_profile_residence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 기본 프로필 거주지 입력 상태 관리 Notifier.

@ProviderFor(BasicProfileResidence)
const basicProfileResidenceProvider = BasicProfileResidenceProvider._();

/// 기본 프로필 거주지 입력 상태 관리 Notifier.
final class BasicProfileResidenceProvider
    extends
        $NotifierProvider<BasicProfileResidence, BasicProfileResidenceModel> {
  /// 기본 프로필 거주지 입력 상태 관리 Notifier.
  const BasicProfileResidenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'basicProfileResidenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$basicProfileResidenceHash();

  @$internal
  @override
  BasicProfileResidence create() => BasicProfileResidence();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BasicProfileResidenceModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BasicProfileResidenceModel>(value),
    );
  }
}

String _$basicProfileResidenceHash() =>
    r'15dae135c39e2220d8d5aff39b0dd60c4713a78d';

/// 기본 프로필 거주지 입력 상태 관리 Notifier.

abstract class _$BasicProfileResidence
    extends $Notifier<BasicProfileResidenceModel> {
  BasicProfileResidenceModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<BasicProfileResidenceModel, BasicProfileResidenceModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                BasicProfileResidenceModel,
                BasicProfileResidenceModel
              >,
              BasicProfileResidenceModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
