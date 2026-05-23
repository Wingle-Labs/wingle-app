// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_profile_completion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 기본 프로필 업로드 상태 관리 Notifier.

@ProviderFor(BasicProfileCompletion)
const basicProfileCompletionProvider = BasicProfileCompletionProvider._();

/// 기본 프로필 업로드 상태 관리 Notifier.
final class BasicProfileCompletionProvider
    extends
        $NotifierProvider<BasicProfileCompletion, BasicProfileCompletionModel> {
  /// 기본 프로필 업로드 상태 관리 Notifier.
  const BasicProfileCompletionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'basicProfileCompletionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$basicProfileCompletionHash();

  @$internal
  @override
  BasicProfileCompletion create() => BasicProfileCompletion();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BasicProfileCompletionModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BasicProfileCompletionModel>(value),
    );
  }
}

String _$basicProfileCompletionHash() =>
    r'910c73ccce73dbe766f1ab474aa0ffb458bc090f';

/// 기본 프로필 업로드 상태 관리 Notifier.

abstract class _$BasicProfileCompletion
    extends $Notifier<BasicProfileCompletionModel> {
  BasicProfileCompletionModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<BasicProfileCompletionModel, BasicProfileCompletionModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                BasicProfileCompletionModel,
                BasicProfileCompletionModel
              >,
              BasicProfileCompletionModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
