// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 상세 프로필 입력 상태를 관리하는 Notifier.

@ProviderFor(ProfileDetails)
const profileDetailsProvider = ProfileDetailsProvider._();

/// 상세 프로필 입력 상태를 관리하는 Notifier.
final class ProfileDetailsProvider
    extends $NotifierProvider<ProfileDetails, ProfileDetailsModel> {
  /// 상세 프로필 입력 상태를 관리하는 Notifier.
  const ProfileDetailsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileDetailsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileDetailsHash();

  @$internal
  @override
  ProfileDetails create() => ProfileDetails();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileDetailsModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileDetailsModel>(value),
    );
  }
}

String _$profileDetailsHash() => r'b46b56a36ecdc341cd27e04a972605fbcf9b9e8a';

/// 상세 프로필 입력 상태를 관리하는 Notifier.

abstract class _$ProfileDetails extends $Notifier<ProfileDetailsModel> {
  ProfileDetailsModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ProfileDetailsModel, ProfileDetailsModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileDetailsModel, ProfileDetailsModel>,
              ProfileDetailsModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
