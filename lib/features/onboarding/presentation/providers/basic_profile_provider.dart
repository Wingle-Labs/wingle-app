import 'dart:async';
import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/app/providers/current_user_gender_provider.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/auth_session_persistence.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_basic_profile.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/presentation/models/basic_profile_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/body_shape_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

part 'basic_profile_provider.g.dart';

/// 기본 프로필 입력 상태를 관리하는 Notifier.
@Riverpod(keepAlive: true)
class BasicProfile extends _$BasicProfile {
  @override
  BasicProfileModel build() {
    final persistedProfile = AuthSessionPersistence.readBasicProfile();
    if (persistedProfile == null || !persistedProfile.hasAnyValue) {
      return const BasicProfileModel();
    }

    return _modelFromLoginProfile(persistedProfile);
  }

  /// 상태를 초기화한다.
  void reset() {
    state = const BasicProfileModel();
    _ignorePersistenceFailure(AuthSessionPersistence.saveBasicProfile(null));
  }

  /// 로그인 응답에 포함된 기본 프로필 정보로 상태를 복원한다.
  void restoreFromLogin(LoginBasicProfile? profile) {
    if (profile == null || !profile.hasAnyValue) {
      return;
    }

    state = _modelFromLoginProfile(profile);
    _ignorePersistenceFailure(AuthSessionPersistence.saveBasicProfile(profile));
  }

  /// 서버의 내 프로필 스냅샷이 준비되어 있으면 기본 프로필 상태를 갱신한다.
  Future<void> restoreFromServerProfileIfAvailable() async {
    try {
      final repository = ref.read(profileRepositoryProvider);
      final snapshot = await repository.fetchMyProfile();
      final profile = snapshot?.basicProfile;
      if (!ref.mounted || profile == null || !profile.hasAnyValue) {
        return;
      }

      if (snapshot != null) {
        await AuthSessionPersistence.saveMyProfileSnapshot(snapshot);
      }
      if (!ref.mounted) return;
      restoreFromLogin(profile);
    } catch (_) {
      // 로그인 플로우를 막지 않기 위해 프로필 스냅샷 복원 실패는 무시한다.
    }
  }

  /// 랜덤 닉네임을 불러온다.
  Future<void> loadNickname({bool force = false}) async {
    if (!force && state.nickname.trim().isNotEmpty) {
      return;
    }

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
      _persistCurrentState();
    } catch (_) {
      if (!ref.mounted) return;

      state = state.copyWith(
        isNicknameLoading: false,
        nicknameErrorMessage: ApiErrorMessages.fetchRandomNicknameFailed,
      );
    }
  }

  /// 랜덤 닉네임을 다시 불러온다.
  Future<void> refreshNickname() => loadNickname(force: true);

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
    _persistCurrentState();
  }

  /// 거주지 선택을 초기화한다.
  void clearResidence() {
    state = state.copyWith(residenceQuery: '', residenceCode: null);
    _persistCurrentState();
  }

  /// 거주지 코드를 직접 설정한다.
  void selectResidenceCode(ResidenceCode residenceCode, {String? query}) {
    state = state.copyWith(
      residenceQuery: query ?? state.residenceQuery,
      residenceCode: residenceCode,
    );
    _persistCurrentState();
  }

  /// 키 값을 갱신한다.
  void updateHeight(String value) {
    final trimmed = _sanitizeHeight(value);

    if (state.height == trimmed) return;

    state = state.copyWith(height: trimmed);
    _persistCurrentState();
  }

  /// 체형 코드를 갱신한다.
  void selectBodyShape(String code) {
    if (state.bodyShapeCode == code) return;
    state = state.copyWith(bodyShapeCode: code);
    _persistCurrentState();
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
    final bodyShapeOption = codebook.optionForGenderAndCode(
      gender,
      bodyShapeCode,
    );

    if (nickname.isEmpty ||
        residence == null ||
        height.length != 3 ||
        bodyShapeCode == null ||
        bodyShapeOption == null) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitBasicProfileFailed,
      );
      return false;
    }

    final shouldUpdate = _readProfileStatus().hasCompletedBasicInfo;

    state = state.copyWith(isSubmitting: true, submitErrorMessage: null);

    try {
      final repository = ref.read(profileRepositoryProvider);
      final parsedHeight = int.parse(height);

      if (shouldUpdate) {
        await repository.updateBasicProfile(
          nickname: nickname,
          residence: residence,
          height: parsedHeight,
          bodyTypeCode: bodyShapeCode,
        );
      } else {
        await repository.submitBasicProfile(
          nickname: nickname,
          residence: residence,
          height: parsedHeight,
          bodyTypeCode: bodyShapeCode,
        );
      }

      await AuthSessionPersistence.saveBasicProfile(
        LoginBasicProfile(
          nickname: nickname,
          residenceCode: residence.level3,
          height: parsedHeight,
          bodyTypeCode: bodyShapeCode,
        ),
      );
      if (!shouldUpdate) {
        await HiveUtil.write(
          key: HiveLoginBox.profileStatus,
          value: LoginProfileStatus.basicInfoCompleted.apiValue,
        );
      }

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

  ResidenceCode? _residenceCodeFromApiValue(String? value) {
    final code = _nonEmpty(value);
    if (code == null) {
      return null;
    }

    final segments = _regionAncestorCodes(code);
    return ResidenceCode(
      level1: segments.isNotEmpty ? segments[0] : code,
      level2: segments.length > 1 ? segments[1] : code,
      level3: code,
    );
  }

  BasicProfileModel _modelFromLoginProfile(LoginBasicProfile profile) {
    return BasicProfileModel(
      nickname: profile.nickname?.trim() ?? '',
      residenceQuery: '',
      residenceCode: _residenceCodeFromApiValue(profile.residenceCode),
      height: profile.height == null ? '' : _sanitizeHeight(profile.height),
      bodyShapeCode: _nonEmpty(profile.bodyTypeCode),
    );
  }

  void _persistCurrentState() {
    _ignorePersistenceFailure(
      AuthSessionPersistence.saveBasicProfile(_profileFromState()),
    );
  }

  LoginBasicProfile _profileFromState() {
    return LoginBasicProfile(
      nickname: _nonEmpty(state.nickname),
      residenceCode: state.residenceCode?.level3,
      height: int.tryParse(state.height),
      bodyTypeCode: _nonEmpty(state.bodyShapeCode),
    );
  }

  void _ignorePersistenceFailure(Future<void> future) {
    unawaited(future.catchError((_) {}));
  }

  LoginProfileStatus _readProfileStatus() {
    try {
      final rawValue = HiveUtil.read(HiveLoginBox.profileStatus);
      return LoginProfileStatus.fromApiValue(rawValue);
    } catch (_) {
      return LoginProfileStatus.signupCompleted;
    }
  }

  List<String> _regionAncestorCodes(String code) {
    if (!code.startsWith('R_') || code.length <= 2) {
      return [code];
    }

    final digits = code.substring(2);
    final ancestors = <String>[];

    if (digits.length >= 2) {
      ancestors.add('R_${digits.substring(0, 2)}');
    }

    if (digits.length >= 5) {
      ancestors.add('R_${digits.substring(0, 5)}');
    } else if (ancestors.isEmpty) {
      ancestors.add(code);
    }

    if (!ancestors.contains(code)) {
      ancestors.add(code);
    }

    return ancestors;
  }

  String _sanitizeHeight(Object? value) {
    final sanitized = value.toString().replaceAll(RegExp(r'[^0-9]'), '');
    return sanitized.length > 3 ? sanitized.substring(0, 3) : sanitized;
  }

  String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
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
