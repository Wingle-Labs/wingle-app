import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/utils/auth_session_persistence.dart';
import 'package:wingle/features/auth/domain/models/login_profile_details.dart';
import 'package:wingle/features/onboarding/presentation/models/profile_details_model.dart';

part 'profile_details_provider.g.dart';

/// 상세 프로필 로컬 저장소.
abstract interface class ProfileDetailsPersistence {
  /// 저장된 상세 프로필 정보를 읽는다.
  LoginProfileDetails? readProfileDetails();

  /// 상세 프로필 정보를 저장한다.
  Future<void> saveProfileDetails(LoginProfileDetails? profile);
}

/// Hive 기반 상세 프로필 로컬 저장소.
class AuthSessionProfileDetailsPersistence
    implements ProfileDetailsPersistence {
  /// 생성자.
  const AuthSessionProfileDetailsPersistence();

  @override
  LoginProfileDetails? readProfileDetails() {
    return AuthSessionPersistence.readProfileDetails();
  }

  @override
  Future<void> saveProfileDetails(LoginProfileDetails? profile) {
    return AuthSessionPersistence.saveProfileDetails(profile);
  }
}

/// 상세 프로필 로컬 저장소 provider.
final profileDetailsPersistenceProvider = Provider<ProfileDetailsPersistence>(
  (ref) => const AuthSessionProfileDetailsPersistence(),
);

/// 상세 프로필 입력 상태를 관리하는 Notifier.
@Riverpod(keepAlive: true)
class ProfileDetails extends _$ProfileDetails {
  @override
  ProfileDetailsModel build() {
    final persistedProfile = ref
        .read(profileDetailsPersistenceProvider)
        .readProfileDetails();
    if (persistedProfile == null || !persistedProfile.hasAnyValue) {
      return const ProfileDetailsModel();
    }

    return _modelFromLoginProfile(persistedProfile);
  }

  /// MBTI 글자를 선택한다.
  void selectMbtiLetter(String value) {
    final letter = value.trim().toUpperCase();
    if (letter.length != 1) return;

    final nextState = switch (letter) {
      'E' || 'I' => state.copyWith(energy: letter, submitErrorMessage: null),
      'N' ||
      'S' => state.copyWith(perception: letter, submitErrorMessage: null),
      'F' || 'T' => state.copyWith(decision: letter, submitErrorMessage: null),
      'P' || 'J' => state.copyWith(lifestyle: letter, submitErrorMessage: null),
      _ => state,
    };

    if (identical(nextState, state) || nextState == state) return;

    state = nextState;
    if (state.canContinueMbti) {
      _persistCurrentState();
    }
  }

  /// 현재 MBTI 값을 로컬에 저장한다.
  Future<bool> saveMbti() async {
    final mbti = state.mbti;
    if (mbti == null) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitProfileDetailsFailed,
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, submitErrorMessage: null);

    try {
      await ref
          .read(profileDetailsPersistenceProvider)
          .saveProfileDetails(_profileFromState());
      if (!ref.mounted) return false;

      state = state.copyWith(isSubmitting: false, submitErrorMessage: null);
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitProfileDetailsFailed,
      );
      return false;
    }
  }

  void _persistCurrentState() {
    _ignorePersistenceFailure(
      ref
          .read(profileDetailsPersistenceProvider)
          .saveProfileDetails(_profileFromState()),
    );
  }

  LoginProfileDetails _profileFromState() {
    return LoginProfileDetails(
      mbti: state.mbti,
      selfIntroduction: _nonEmpty(state.selfIntroduction),
    );
  }

  ProfileDetailsModel _modelFromLoginProfile(LoginProfileDetails profile) {
    final mbti = _nonEmpty(profile.mbti);
    return ProfileDetailsModel(
      energy: mbti == null ? null : mbti[0],
      perception: mbti == null ? null : mbti[1],
      decision: mbti == null ? null : mbti[2],
      lifestyle: mbti == null ? null : mbti[3],
      selfIntroduction: profile.selfIntroduction?.trim() ?? '',
    );
  }

  void _ignorePersistenceFailure(Future<void> future) {
    unawaited(future.catchError((_) {}));
  }

  String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }
}
