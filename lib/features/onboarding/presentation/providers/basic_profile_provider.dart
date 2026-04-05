import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/providers/current_user_gender_provider.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/presentation/models/basic_profile_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/body_shape_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

/// 기본 프로필 입력 상태를 관리하는 Provider.
final basicProfileProvider =
    NotifierProvider<BasicProfileNotifier, BasicProfileModel>(
      BasicProfileNotifier.new,
    );

/// 기본 프로필 입력 상태를 관리하는 Notifier.
class BasicProfileNotifier extends Notifier<BasicProfileModel> {
  @override
  BasicProfileModel build() => const BasicProfileModel();

  /// 상태를 초기화한다.
  void reset() {
    state = const BasicProfileModel();
  }

  /// 랜덤 닉네임을 불러온다.
  Future<void> loadNickname() async {
    state = state.copyWith(isNicknameLoading: true, nicknameErrorMessage: null);

    try {
      final repository = ref.read(profileRepositoryProvider);
      final nickname = await repository.fetchRandomNickname();

      if (!ref.mounted) return;

      state = state.copyWith(
        nickname: nickname,
        isNicknameLoading: false,
        nicknameErrorMessage: null,
      );
    } catch (_) {
      if (!ref.mounted) return;

      state = state.copyWith(
        isNicknameLoading: false,
        nicknameErrorMessage: ApiErrorMessages.fetchRandomNicknameFailed,
      );
    }
  }

  /// 랜덤 닉네임을 다시 불러온다.
  Future<void> refreshNickname() => loadNickname();

  /// 거주지 검색어를 갱신한다.
  ///
  /// 현재는 실제 주소 코드북이 연결되기 전이므로,
  /// 입력 문자열을 기반으로 한 안정적인 목업 코드를 함께 만든다.
  void updateResidenceQuery(String value) {
    final trimmed = value.trim();
    final nextResidenceCode = trimmed.isEmpty
        ? null
        : _mockResidenceCodeFromQuery(trimmed);

    if (state.residenceQuery == value &&
        state.residenceCode == nextResidenceCode) {
      return;
    }

    state = state.copyWith(
      residenceQuery: value,
      residenceCode: nextResidenceCode,
    );
  }

  /// 거주지 선택을 초기화한다.
  void clearResidence() {
    state = state.copyWith(residenceQuery: '', residenceCode: null);
  }

  /// 거주지 코드를 직접 설정한다.
  void selectResidenceCode(ResidenceCode residenceCode, {String? query}) {
    state = state.copyWith(
      residenceQuery: query ?? state.residenceQuery,
      residenceCode: residenceCode,
    );
  }

  /// 키 값을 갱신한다.
  void updateHeight(String value) {
    final sanitized = value.replaceAll(RegExp(r'[^0-9]'), '');
    final trimmed = sanitized.length > 3
        ? sanitized.substring(0, 3)
        : sanitized;

    if (state.height == trimmed) return;

    state = state.copyWith(height: trimmed);
  }

  /// 체형 코드를 갱신한다.
  void selectBodyShape(String code) {
    if (state.bodyShapeCode == code) return;
    state = state.copyWith(bodyShapeCode: code);
  }

  /// 기본 프로필 정보를 서버에 업로드한다.
  Future<bool> submit() async {
    if (state.isSubmitting) return false;

    final nickname = state.nickname.trim();
    final residence = state.residenceCode;
    final height = state.height.trim();
    final bodyShapeCode = state.bodyShapeCode;
    final gender = ref.read(currentUserGenderProvider);
    final codebook = ref.read(bodyShapeCodebookProvider);
    final bodyType = codebook.labelForGenderAndCode(gender, bodyShapeCode);

    if (nickname.isEmpty ||
        residence == null ||
        height.length != 3 ||
        bodyShapeCode == null ||
        bodyType == null) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitBasicProfileFailed,
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, submitErrorMessage: null);

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

      state = state.copyWith(isSubmitting: false, submitErrorMessage: null);
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitBasicProfileFailed,
      );
      return false;
    }
  }

  ResidenceCode _mockResidenceCodeFromQuery(String query) {
    final seed = query.runes.fold<int>(0, (sum, rune) => sum + rune);
    return ResidenceCode(
      level1: _mockDigits(seed: seed, multiplier: 3, width: 3),
      level2: _mockDigits(seed: seed, multiplier: 31, width: 5),
      level3: _mockDigits(seed: seed, multiplier: 131, width: 8),
    );
  }

  String _mockDigits({
    required int seed,
    required int multiplier,
    required int width,
  }) {
    final max = math.pow(10, width).toInt();
    final value = (seed * multiplier).abs() % max;
    return value.toString().padLeft(width, '0');
  }
}
