// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choice_questions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 승인 이후 필수 객관식 질문 입력 상태를 관리한다.

@ProviderFor(ChoiceQuestionsController)
const choiceQuestionsControllerProvider = ChoiceQuestionsControllerProvider._();

/// 승인 이후 필수 객관식 질문 입력 상태를 관리한다.
final class ChoiceQuestionsControllerProvider
    extends
        $AsyncNotifierProvider<
          ChoiceQuestionsController,
          ChoiceQuestionsModel
        > {
  /// 승인 이후 필수 객관식 질문 입력 상태를 관리한다.
  const ChoiceQuestionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'choiceQuestionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$choiceQuestionsControllerHash();

  @$internal
  @override
  ChoiceQuestionsController create() => ChoiceQuestionsController();
}

String _$choiceQuestionsControllerHash() =>
    r'f390c8bdbac4de154103af8bbcda499a009b3cd7';

/// 승인 이후 필수 객관식 질문 입력 상태를 관리한다.

abstract class _$ChoiceQuestionsController
    extends $AsyncNotifier<ChoiceQuestionsModel> {
  FutureOr<ChoiceQuestionsModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<ChoiceQuestionsModel>, ChoiceQuestionsModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ChoiceQuestionsModel>,
                ChoiceQuestionsModel
              >,
              AsyncValue<ChoiceQuestionsModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
