import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/providers/current_user_gender_provider.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/presentation/models/basic_profile_completion_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_body_shape_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_height_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_nickname_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_residence_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/body_shape_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

/// 기본 프로필 업로드 상태를 관리하는 Provider.
final basicProfileCompletionProvider =
    NotifierProvider<
      BasicProfileCompletionNotifier,
      BasicProfileCompletionModel
    >(BasicProfileCompletionNotifier.new);

/// 기본 프로필 업로드 상태 관리 Notifier.
class BasicProfileCompletionNotifier
    extends Notifier<BasicProfileCompletionModel> {
  @override
  BasicProfileCompletionModel build() => const BasicProfileCompletionModel();

  /// 상태를 초기화한다.
  void reset() {
    state = const BasicProfileCompletionModel();
  }

  /// 기본 프로필 정보를 서버에 업로드한다.
  Future<bool> submit() async {
    if (state.isLoading) return false;

    final nickname = ref.read(basicProfileNicknameProvider).nickname.trim();
    final residence = ref.read(basicProfileResidenceProvider).residenceCode;
    final height = ref.read(basicProfileHeightProvider).trim();
    final bodyShapeCode = ref.read(basicProfileBodyShapeProvider);
    final gender = ref.read(currentUserGenderProvider);
    final codebook = ref.read(bodyShapeCodebookProvider);

    final bodyType = codebook.labelForGenderAndCode(gender, bodyShapeCode);

    if (nickname.isEmpty ||
        residence == null ||
        height.length != 3 ||
        bodyType == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: ApiErrorMessages.submitBasicProfileFailed,
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.submitBasicProfile(
        nickname: nickname,
        residence: residence,
        height: int.parse(height),
        bodyType: bodyType,
      );

      await HiveUtil.write(
        key: HiveLoginBox.profileStatus,
        value: LoginProfileStatus.beforeCompanyInfo.apiValue,
      );

      if (!ref.mounted) return false;

      state = state.copyWith(isLoading: false, errorMessage: null);
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isLoading: false,
        errorMessage: ApiErrorMessages.submitBasicProfileFailed,
      );
      return false;
    }
  }
}
