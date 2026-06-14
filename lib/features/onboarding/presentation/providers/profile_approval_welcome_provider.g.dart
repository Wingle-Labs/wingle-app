// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_approval_welcome_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 프로필 승인 완료 안내 화면 저장소 provider.

@ProviderFor(profileApprovalWelcomePersistence)
const profileApprovalWelcomePersistenceProvider =
    ProfileApprovalWelcomePersistenceProvider._();

/// 프로필 승인 완료 안내 화면 저장소 provider.

final class ProfileApprovalWelcomePersistenceProvider
    extends
        $FunctionalProvider<
          ProfileApprovalWelcomePersistence,
          ProfileApprovalWelcomePersistence,
          ProfileApprovalWelcomePersistence
        >
    with $Provider<ProfileApprovalWelcomePersistence> {
  /// 프로필 승인 완료 안내 화면 저장소 provider.
  const ProfileApprovalWelcomePersistenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileApprovalWelcomePersistenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$profileApprovalWelcomePersistenceHash();

  @$internal
  @override
  $ProviderElement<ProfileApprovalWelcomePersistence> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileApprovalWelcomePersistence create(Ref ref) {
    return profileApprovalWelcomePersistence(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileApprovalWelcomePersistence value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileApprovalWelcomePersistence>(
        value,
      ),
    );
  }
}

String _$profileApprovalWelcomePersistenceHash() =>
    r'cb6a393b11c3db49fa5d3a6971028106c657ec7e';

/// 프로필 승인 완료 안내 화면 상태를 관리한다.

@ProviderFor(ProfileApprovalWelcomeController)
const profileApprovalWelcomeControllerProvider =
    ProfileApprovalWelcomeControllerProvider._();

/// 프로필 승인 완료 안내 화면 상태를 관리한다.
final class ProfileApprovalWelcomeControllerProvider
    extends
        $NotifierProvider<
          ProfileApprovalWelcomeController,
          ProfileApprovalWelcomeModel
        > {
  /// 프로필 승인 완료 안내 화면 상태를 관리한다.
  const ProfileApprovalWelcomeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileApprovalWelcomeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileApprovalWelcomeControllerHash();

  @$internal
  @override
  ProfileApprovalWelcomeController create() =>
      ProfileApprovalWelcomeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileApprovalWelcomeModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileApprovalWelcomeModel>(value),
    );
  }
}

String _$profileApprovalWelcomeControllerHash() =>
    r'1cfc290753f854c111043403e6819bfa4d4ac768';

/// 프로필 승인 완료 안내 화면 상태를 관리한다.

abstract class _$ProfileApprovalWelcomeController
    extends $Notifier<ProfileApprovalWelcomeModel> {
  ProfileApprovalWelcomeModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<ProfileApprovalWelcomeModel, ProfileApprovalWelcomeModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ProfileApprovalWelcomeModel,
                ProfileApprovalWelcomeModel
              >,
              ProfileApprovalWelcomeModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
