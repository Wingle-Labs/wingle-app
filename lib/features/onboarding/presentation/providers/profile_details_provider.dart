import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/utils/auth_session_persistence.dart';
import 'package:wingle/features/auth/domain/models/login_profile_details.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';
import 'package:wingle/features/onboarding/presentation/models/profile_details_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/file_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

part 'profile_details_provider.g.dart';

const int _maxProfilePhotoCount = 3;
const String _unsupportedProfilePhotoKey =
    'onboarding.basicProfile.profilePhoto.unsupportedFile';

/// 상세 프로필 로컬 저장소.
abstract interface class ProfileDetailsPersistence {
  /// 저장된 상세 프로필 정보를 읽는다.
  LoginProfileDetails? readProfileDetails();

  /// 상세 프로필 정보를 저장한다.
  Future<void> saveProfileDetails(LoginProfileDetails? profile);

  /// 온보딩 프로필 상태를 저장한다.
  Future<void> saveProfileStatus(LoginProfileStatus status);
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

  @override
  Future<void> saveProfileStatus(LoginProfileStatus status) {
    return AuthSessionPersistence.saveProfileStatus(status);
  }
}

/// 상세 프로필 로컬 저장소 provider.
final profileDetailsPersistenceProvider = Provider<ProfileDetailsPersistence>(
  (ref) => const AuthSessionProfileDetailsPersistence(),
);

/// 상세 프로필 입력 상태를 관리하는 Notifier.
@Riverpod(keepAlive: true)
class ProfileDetails extends _$ProfileDetails {
  Future<void> _profilePersistenceQueue = Future<void>.value();

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
      await _saveProfileDetails(_profileFromState());
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

  /// 사진 파일을 업로드하고 업로드 결과를 반환한다.
  Future<ProfilePhotoInput?> uploadPhotoFile({
    required ProfilePhotoType type,
    required String name,
    required String contentType,
    required Uint8List bytes,
  }) async {
    final normalizedContentType = contentType.trim().toLowerCase();
    if (!FileUploadConstants.supportedImageContentTypes.contains(
      normalizedContentType,
    )) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: _unsupportedProfilePhotoKey,
      );
      return null;
    }

    state = state.copyWith(submitErrorMessage: null);

    try {
      final repository = ref.read(fileRepositoryProvider);
      final presignedUrl = switch (type) {
        ProfilePhotoType.style => await repository.createStyleImagePresignedUrl(
          contentType: normalizedContentType,
        ),
        ProfilePhotoType.face => await repository.createFaceImagePresignedUrl(
          contentType: normalizedContentType,
        ),
      };

      await repository.uploadBytesToPresignedUrl(
        presignedUrl: presignedUrl.presignedUrl,
        bytes: bytes,
        contentType: normalizedContentType,
      );

      if (!ref.mounted) return null;

      return ProfilePhotoInput(
        s3Key: presignedUrl.s3Key,
        name: name,
        contentType: normalizedContentType,
        previewBytes: bytes,
      );
    } catch (error, stackTrace) {
      if (!ref.mounted) return null;

      _logProfilePhotoUploadFailure(
        type: type,
        name: name,
        contentType: normalizedContentType,
        bytesLength: bytes.length,
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.uploadFileFailed,
      );
      return null;
    }
  }

  /// 사진을 업로드하고 S3 key를 로컬 상세 프로필에 저장한다.
  Future<bool> uploadPhoto({
    required ProfilePhotoType type,
    required int slotIndex,
    required String name,
    required String contentType,
    required Uint8List bytes,
  }) async {
    if (slotIndex < 0 || slotIndex >= _maxProfilePhotoCount) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: _unsupportedProfilePhotoKey,
      );
      return false;
    }

    final uploadedPhoto = await uploadPhotoFile(
      type: type,
      name: name,
      contentType: contentType,
      bytes: bytes,
    );
    if (!ref.mounted || uploadedPhoto == null) return false;

    final nextState = _replacePhotoInState(
      state,
      type: type,
      slotIndex: slotIndex,
      photo: uploadedPhoto,
    );

    return replacePhotos(type: type, photos: _photosFor(nextState, type));
  }

  /// 사진 목록 순서를 로컬 상세 프로필에 저장한다.
  Future<bool> replacePhotos({
    required ProfilePhotoType type,
    required List<ProfilePhotoInput> photos,
  }) async {
    final normalizedPhotos = List<ProfilePhotoInput>.unmodifiable(
      photos.take(_maxProfilePhotoCount),
    );
    final nextState = switch (type) {
      ProfilePhotoType.style => state.copyWith(
        stylePhotos: normalizedPhotos,
        submitErrorMessage: null,
      ),
      ProfilePhotoType.face => state.copyWith(
        facePhotos: normalizedPhotos,
        submitErrorMessage: null,
      ),
    };

    state = nextState;

    try {
      await _saveProfileDetails(_profileFromModel(nextState));
      return ref.mounted;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        submitErrorMessage: ApiErrorMessages.submitProfileDetailsFailed,
      );
      return false;
    }
  }

  /// 사진을 제거하고 로컬 상세 프로필에 반영한다.
  Future<bool> removePhoto({
    required ProfilePhotoType type,
    required int slotIndex,
  }) async {
    final photos = _photosFor(state, type);
    if (slotIndex < 0 || slotIndex >= photos.length) {
      return true;
    }

    final nextPhotos = List<ProfilePhotoInput>.of(photos)..removeAt(slotIndex);
    final nextState = switch (type) {
      ProfilePhotoType.style => state.copyWith(stylePhotos: nextPhotos),
      ProfilePhotoType.face => state.copyWith(facePhotos: nextPhotos),
    };

    return _saveProfileState(nextState);
  }

  /// 스타일 사진 단계 입력값을 저장한다.
  Future<bool> saveStylePhotos() {
    if (!state.canContinueStylePhotos) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitProfileDetailsFailed,
      );
      return Future.value(false);
    }

    return _saveProfileState(state);
  }

  /// 얼굴 사진 단계 입력값을 저장한다.
  Future<bool> saveFacePhotos() {
    if (!state.canContinueFacePhotos) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitProfileDetailsFailed,
      );
      return Future.value(false);
    }

    return _saveProfileState(state);
  }

  /// 자기소개 입력값을 갱신하고 로컬 draft에 저장한다.
  void updateSelfIntroduction(String value) {
    final normalizedValue =
        value.length > ProfileDetailsModel.selfIntroductionMaxLength
        ? value.substring(0, ProfileDetailsModel.selfIntroductionMaxLength)
        : value;
    final nextState = state.copyWith(
      selfIntroduction: normalizedValue,
      submitErrorMessage: null,
    );

    if (identical(nextState, state) || nextState == state) return;

    state = nextState;
    _persistCurrentState();
  }

  /// 자기소개 단계 입력값을 저장한다.
  Future<bool> saveSelfIntroduction() {
    if (!state.canContinueSelfIntroduction) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitProfileDetailsFailed,
      );
      return Future.value(false);
    }

    return _saveProfileState(
      state.copyWith(selfIntroduction: state.selfIntroduction.trim()),
    );
  }

  /// 상세 프로필 전체를 API에 등록한다.
  Future<bool> submitProfileDetails() async {
    final mbti = state.mbti;
    final selfIntroduction = state.selfIntroduction.trim();
    if (mbti == null ||
        selfIntroduction.isEmpty ||
        !state.canContinueStylePhotos ||
        !state.canContinueFacePhotos ||
        selfIntroduction.length >
            ProfileDetailsModel.selfIntroductionMaxLength) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitProfileDetailsFailed,
      );
      return false;
    }

    final nextState = state.copyWith(
      selfIntroduction: selfIntroduction,
      isSubmitting: true,
      submitErrorMessage: null,
    );
    state = nextState;

    try {
      await ref
          .read(profileRepositoryProvider)
          .submitProfileDetails(
            mbti: mbti,
            selfIntroduction: selfIntroduction,
            mainStylePhotoKey: nextState.mainStylePhotoKey,
            subStylePhotoKeys: nextState.subStylePhotoKeys,
            mainFacePhotoKey: nextState.mainFacePhotoKey,
            subFacePhotoKeys: nextState.subFacePhotoKeys,
          );
      await _saveProfileDetails(_profileFromModel(nextState));
      if (!ref.mounted) return false;

      state = nextState.copyWith(isSubmitting: false, submitErrorMessage: null);
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = nextState.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitProfileDetailsFailed,
      );
      return false;
    }
  }

  /// 프로필 심사를 요청하고 로컬 온보딩 상태를 심사 대기로 갱신한다.
  Future<bool> requestProfileApproval() async {
    state = state.copyWith(isSubmitting: true, submitErrorMessage: null);

    try {
      await ref.read(profileRepositoryProvider).requestProfileApproval();
      await ref
          .read(profileDetailsPersistenceProvider)
          .saveProfileStatus(LoginProfileStatus.awaitingApproval);
      if (!ref.mounted) return false;

      state = state.copyWith(isSubmitting: false, submitErrorMessage: null);
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.requestProfileApprovalFailed,
      );
      return false;
    }
  }

  void _persistCurrentState() {
    _ignorePersistenceFailure(_saveProfileDetails(_profileFromState()));
  }

  LoginProfileDetails _profileFromState() {
    return _profileFromModel(state);
  }

  LoginProfileDetails _profileFromModel(ProfileDetailsModel model) {
    return LoginProfileDetails(
      mbti: model.mbti,
      selfIntroduction: _nonEmpty(model.selfIntroduction),
      mainStylePhotoKey: model.mainStylePhotoKey,
      subStylePhotoKeys: model.subStylePhotoKeys,
      mainFacePhotoKey: model.mainFacePhotoKey,
      subFacePhotoKeys: model.subFacePhotoKeys,
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
      stylePhotos: _photoInputsFromKeys([
        if (_nonEmpty(profile.mainStylePhotoKey) != null)
          profile.mainStylePhotoKey!,
        ...profile.subStylePhotoKeys,
      ]),
      facePhotos: _photoInputsFromKeys([
        if (_nonEmpty(profile.mainFacePhotoKey) != null)
          profile.mainFacePhotoKey!,
        ...profile.subFacePhotoKeys,
      ]),
    );
  }

  ProfileDetailsModel _replacePhotoInState(
    ProfileDetailsModel currentState, {
    required ProfilePhotoType type,
    required int slotIndex,
    required ProfilePhotoInput photo,
  }) {
    final nextPhotos = List<ProfilePhotoInput>.of(
      _photosFor(currentState, type),
    );
    if (slotIndex < nextPhotos.length) {
      nextPhotos[slotIndex] = photo;
    } else {
      nextPhotos.add(photo);
    }

    return switch (type) {
      ProfilePhotoType.style => currentState.copyWith(stylePhotos: nextPhotos),
      ProfilePhotoType.face => currentState.copyWith(facePhotos: nextPhotos),
    };
  }

  List<ProfilePhotoInput> _photosFor(
    ProfileDetailsModel currentState,
    ProfilePhotoType type,
  ) {
    return switch (type) {
      ProfilePhotoType.style => currentState.stylePhotos,
      ProfilePhotoType.face => currentState.facePhotos,
    };
  }

  Future<bool> _saveProfileState(ProfileDetailsModel nextState) async {
    state = nextState.copyWith(isSubmitting: true, submitErrorMessage: null);

    try {
      await _saveProfileDetails(_profileFromModel(nextState));
      if (!ref.mounted) return false;

      state = nextState.copyWith(isSubmitting: false, submitErrorMessage: null);
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

  List<ProfilePhotoInput> _photoInputsFromKeys(List<String> keys) {
    return List<ProfilePhotoInput>.unmodifiable(
      keys
          .map(_nonEmpty)
          .whereType<String>()
          .map(
            (key) => ProfilePhotoInput(
              s3Key: key,
              name: key.split('/').last,
              contentType: FileUploadConstants.defaultProfileImageContentType,
            ),
          ),
    );
  }

  void _ignorePersistenceFailure(Future<void> future) {
    unawaited(future.catchError((_) {}));
  }

  Future<void> _saveProfileDetails(LoginProfileDetails profile) {
    final operation = _profilePersistenceQueue.then((_) {
      return ref
          .read(profileDetailsPersistenceProvider)
          .saveProfileDetails(profile);
    });
    _profilePersistenceQueue = operation.catchError((_) {});
    return operation;
  }

  void _logProfilePhotoUploadFailure({
    required ProfilePhotoType type,
    required String name,
    required String contentType,
    required int bytesLength,
    required Object error,
    required StackTrace stackTrace,
  }) {
    if (kReleaseMode) return;

    debugPrint(
      'Failed to upload profile photo: '
      'type=${type.name}, name=$name, '
      'contentType=$contentType, bytes=$bytesLength, error=$error',
    );
    debugPrintStack(stackTrace: stackTrace);
  }

  String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }
}
