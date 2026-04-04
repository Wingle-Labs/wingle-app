import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/features/onboarding/presentation/models/basic_profile_nickname_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

/// 기본 프로필 랜덤 닉네임 상태를 관리하는 Provider.
final basicProfileNicknameProvider =
    NotifierProvider.autoDispose<
      BasicProfileNicknameNotifier,
      BasicProfileNicknameModel
    >(BasicProfileNicknameNotifier.new);

/// 기본 프로필 랜덤 닉네임 상태 관리 Notifier.
class BasicProfileNicknameNotifier extends Notifier<BasicProfileNicknameModel> {
  @override
  BasicProfileNicknameModel build() {
    return const BasicProfileNicknameModel(isLoading: true);
  }

  /// 랜덤 닉네임을 새로 불러온다.
  Future<void> loadNickname() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(profileRepositoryProvider);
      final nickname = await repository.fetchRandomNickname();

      if (!ref.mounted) return;

      state = state.copyWith(
        nickname: nickname,
        isLoading: false,
        errorMessage: null,
      );
    } catch (_) {
      if (!ref.mounted) return;

      state = state.copyWith(
        isLoading: false,
        errorMessage: ApiErrorMessages.fetchRandomNicknameFailed,
      );
    }
  }

  /// 닉네임 변경 요청을 다시 수행한다.
  Future<void> refreshNickname() => loadNickname();
}
