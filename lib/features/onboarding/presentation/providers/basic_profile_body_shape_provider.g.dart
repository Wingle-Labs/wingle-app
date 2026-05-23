// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_profile_body_shape_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 기본 프로필 체형 선택 상태 관리 Notifier.

@ProviderFor(BasicProfileBodyShape)
const basicProfileBodyShapeProvider = BasicProfileBodyShapeProvider._();

/// 기본 프로필 체형 선택 상태 관리 Notifier.
final class BasicProfileBodyShapeProvider
    extends $NotifierProvider<BasicProfileBodyShape, String?> {
  /// 기본 프로필 체형 선택 상태 관리 Notifier.
  const BasicProfileBodyShapeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'basicProfileBodyShapeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$basicProfileBodyShapeHash();

  @$internal
  @override
  BasicProfileBodyShape create() => BasicProfileBodyShape();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$basicProfileBodyShapeHash() =>
    r'865c94db514b64e07dd5fb49ba0aa25201727c33';

/// 기본 프로필 체형 선택 상태 관리 Notifier.

abstract class _$BasicProfileBodyShape extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
