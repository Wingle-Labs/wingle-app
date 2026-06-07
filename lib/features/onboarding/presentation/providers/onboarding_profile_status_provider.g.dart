// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_profile_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 승인 대기 화면에서 서버 온보딩 상태를 갱신한다.

@ProviderFor(ProfileApprovalStatusController)
const profileApprovalStatusControllerProvider =
    ProfileApprovalStatusControllerProvider._();

/// 승인 대기 화면에서 서버 온보딩 상태를 갱신한다.
final class ProfileApprovalStatusControllerProvider
    extends
        $AsyncNotifierProvider<
          ProfileApprovalStatusController,
          LoginProfileStatus?
        > {
  /// 승인 대기 화면에서 서버 온보딩 상태를 갱신한다.
  const ProfileApprovalStatusControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileApprovalStatusControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileApprovalStatusControllerHash();

  @$internal
  @override
  ProfileApprovalStatusController create() => ProfileApprovalStatusController();
}

String _$profileApprovalStatusControllerHash() =>
    r'3ac22c71a15bf623ad6ca512f8f0721e283a58f2';

/// 승인 대기 화면에서 서버 온보딩 상태를 갱신한다.

abstract class _$ProfileApprovalStatusController
    extends $AsyncNotifier<LoginProfileStatus?> {
  FutureOr<LoginProfileStatus?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<LoginProfileStatus?>, LoginProfileStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LoginProfileStatus?>, LoginProfileStatus?>,
              AsyncValue<LoginProfileStatus?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
