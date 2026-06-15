// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'essay_questions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 승인 이후 선택 주관식 질문 입력 상태를 관리한다.

@ProviderFor(EssayQuestionsController)
const essayQuestionsControllerProvider = EssayQuestionsControllerProvider._();

/// 승인 이후 선택 주관식 질문 입력 상태를 관리한다.
final class EssayQuestionsControllerProvider
    extends
        $AsyncNotifierProvider<EssayQuestionsController, EssayQuestionsModel> {
  /// 승인 이후 선택 주관식 질문 입력 상태를 관리한다.
  const EssayQuestionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'essayQuestionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$essayQuestionsControllerHash();

  @$internal
  @override
  EssayQuestionsController create() => EssayQuestionsController();
}

String _$essayQuestionsControllerHash() =>
    r'5ccb9cc016f6bc075f35c73c827c439a373c3ce5';

/// 승인 이후 선택 주관식 질문 입력 상태를 관리한다.

abstract class _$EssayQuestionsController
    extends $AsyncNotifier<EssayQuestionsModel> {
  FutureOr<EssayQuestionsModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<EssayQuestionsModel>, EssayQuestionsModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EssayQuestionsModel>, EssayQuestionsModel>,
              AsyncValue<EssayQuestionsModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
