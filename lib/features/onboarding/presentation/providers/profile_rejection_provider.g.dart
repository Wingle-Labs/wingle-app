// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_rejection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 프로필 반려 사유 조회와 재심사 요청을 관리한다.

@ProviderFor(ProfileRejectionController)
const profileRejectionControllerProvider =
    ProfileRejectionControllerProvider._();

/// 프로필 반려 사유 조회와 재심사 요청을 관리한다.
final class ProfileRejectionControllerProvider
    extends
        $AsyncNotifierProvider<
          ProfileRejectionController,
          ProfileRejectionState
        > {
  /// 프로필 반려 사유 조회와 재심사 요청을 관리한다.
  const ProfileRejectionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRejectionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRejectionControllerHash();

  @$internal
  @override
  ProfileRejectionController create() => ProfileRejectionController();
}

String _$profileRejectionControllerHash() =>
    r'78465749d6c1d26eaa13cfd5bf5419c509c89515';

/// 프로필 반려 사유 조회와 재심사 요청을 관리한다.

abstract class _$ProfileRejectionController
    extends $AsyncNotifier<ProfileRejectionState> {
  FutureOr<ProfileRejectionState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<ProfileRejectionState>, ProfileRejectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ProfileRejectionState>,
                ProfileRejectionState
              >,
              AsyncValue<ProfileRejectionState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
