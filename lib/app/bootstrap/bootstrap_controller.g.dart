// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bootstrap_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 앱 실행에 필요한 부트스트랩 상태를 관리한다.

@ProviderFor(BootstrapController)
const bootstrapControllerProvider = BootstrapControllerProvider._();

/// 앱 실행에 필요한 부트스트랩 상태를 관리한다.
final class BootstrapControllerProvider
    extends
        $AsyncNotifierProvider<BootstrapController, BootstrapInitializeResult> {
  /// 앱 실행에 필요한 부트스트랩 상태를 관리한다.
  const BootstrapControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bootstrapControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bootstrapControllerHash();

  @$internal
  @override
  BootstrapController create() => BootstrapController();
}

String _$bootstrapControllerHash() =>
    r'a8ef6968a9a4ce546b10f9f20244853f37c754b2';

/// 앱 실행에 필요한 부트스트랩 상태를 관리한다.

abstract class _$BootstrapController
    extends $AsyncNotifier<BootstrapInitializeResult> {
  FutureOr<BootstrapInitializeResult> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<BootstrapInitializeResult>,
              BootstrapInitializeResult
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<BootstrapInitializeResult>,
                BootstrapInitializeResult
              >,
              AsyncValue<BootstrapInitializeResult>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
