// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_profile_nickname_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 기본 프로필 랜덤 닉네임 상태 관리 Notifier.

@ProviderFor(BasicProfileNickname)
const basicProfileNicknameProvider = BasicProfileNicknameProvider._();

/// 기본 프로필 랜덤 닉네임 상태 관리 Notifier.
final class BasicProfileNicknameProvider
    extends $NotifierProvider<BasicProfileNickname, BasicProfileNicknameModel> {
  /// 기본 프로필 랜덤 닉네임 상태 관리 Notifier.
  const BasicProfileNicknameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'basicProfileNicknameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$basicProfileNicknameHash();

  @$internal
  @override
  BasicProfileNickname create() => BasicProfileNickname();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BasicProfileNicknameModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BasicProfileNicknameModel>(value),
    );
  }
}

String _$basicProfileNicknameHash() =>
    r'ddd11ab2ab0e2cda1b9da8d57c426233d5f72de5';

/// 기본 프로필 랜덤 닉네임 상태 관리 Notifier.

abstract class _$BasicProfileNickname
    extends $Notifier<BasicProfileNicknameModel> {
  BasicProfileNicknameModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<BasicProfileNicknameModel, BasicProfileNicknameModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BasicProfileNicknameModel, BasicProfileNicknameModel>,
              BasicProfileNicknameModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
