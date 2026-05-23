// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_gender_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 현재 로그인한 사용자의 성별을 읽는 Provider.
///
/// 로그인 시점에 저장된 값을 읽어오며, 화면을 벗어나면 자동 해제된다.

@ProviderFor(currentUserGender)
const currentUserGenderProvider = CurrentUserGenderProvider._();

/// 현재 로그인한 사용자의 성별을 읽는 Provider.
///
/// 로그인 시점에 저장된 값을 읽어오며, 화면을 벗어나면 자동 해제된다.

final class CurrentUserGenderProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// 현재 로그인한 사용자의 성별을 읽는 Provider.
  ///
  /// 로그인 시점에 저장된 값을 읽어오며, 화면을 벗어나면 자동 해제된다.
  const CurrentUserGenderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserGenderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserGenderHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentUserGender(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentUserGenderHash() => r'78ae315bdffcce0d1750451ab0ea79a1c4de0705';
