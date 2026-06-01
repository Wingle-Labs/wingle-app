// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 학교 정보 입력 상태를 관리하는 Notifier.

@ProviderFor(EducationProfile)
const educationProfileProvider = EducationProfileProvider._();

/// 학교 정보 입력 상태를 관리하는 Notifier.
final class EducationProfileProvider
    extends $NotifierProvider<EducationProfile, EducationProfileModel> {
  /// 학교 정보 입력 상태를 관리하는 Notifier.
  const EducationProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'educationProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$educationProfileHash();

  @$internal
  @override
  EducationProfile create() => EducationProfile();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EducationProfileModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EducationProfileModel>(value),
    );
  }
}

String _$educationProfileHash() => r'9af9b3334e5caf38d1a9d3d5bf40b9931994f1d3';

/// 학교 정보 입력 상태를 관리하는 Notifier.

abstract class _$EducationProfile extends $Notifier<EducationProfileModel> {
  EducationProfileModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<EducationProfileModel, EducationProfileModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EducationProfileModel, EducationProfileModel>,
              EducationProfileModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
