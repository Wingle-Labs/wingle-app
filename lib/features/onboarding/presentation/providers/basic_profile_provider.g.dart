// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 기본 프로필 입력 상태를 관리하는 Notifier.

@ProviderFor(BasicProfile)
const basicProfileProvider = BasicProfileProvider._();

/// 기본 프로필 입력 상태를 관리하는 Notifier.
final class BasicProfileProvider
    extends $NotifierProvider<BasicProfile, BasicProfileModel> {
  /// 기본 프로필 입력 상태를 관리하는 Notifier.
  const BasicProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'basicProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$basicProfileHash();

  @$internal
  @override
  BasicProfile create() => BasicProfile();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BasicProfileModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BasicProfileModel>(value),
    );
  }
}

String _$basicProfileHash() => r'586dfc3e5a064560c6466fa1d9892036238a6932';

/// 기본 프로필 입력 상태를 관리하는 Notifier.

abstract class _$BasicProfile extends $Notifier<BasicProfileModel> {
  BasicProfileModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BasicProfileModel, BasicProfileModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BasicProfileModel, BasicProfileModel>,
              BasicProfileModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
