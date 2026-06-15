import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/application/device_contact_service.dart';
import 'package:wingle/features/onboarding/presentation/models/contact_block_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/contact_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/device_contact_service_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';

part 'contact_block_provider.g.dart';

/// 연락처 지인 제외 화면 상태를 관리한다.
@riverpod
class ContactBlockController extends _$ContactBlockController {
  @override
  ContactBlockModel build() {
    return const ContactBlockModel();
  }

  /// 기기 연락처를 불러온다.
  Future<bool> loadContacts() async {
    if (state.isBusy) {
      return false;
    }

    state = state.copyWith(isLoadingContacts: true, errorMessage: null);

    try {
      final selectionResult = await ref
          .read(deviceContactServiceProvider)
          .selectContacts();
      if (!ref.mounted) {
        return selectionResult.contacts.isNotEmpty;
      }

      final selectedContactIds = selectionResult.requiresInAppSelection
          ? const <String>{}
          : selectionResult.contacts.map((contact) => contact.id).toSet();

      state = state.copyWith(
        contacts: selectionResult.contacts,
        selectedContactIds: selectedContactIds,
        isLoadingContacts: false,
        requiresInAppSelection: selectionResult.requiresInAppSelection,
        errorMessage: selectionResult.contacts.isEmpty
            ? 'onboarding.contactBlock.emptyContacts'
            : null,
      );
      return selectionResult.contacts.isNotEmpty;
    } on DeviceContactSelectionCanceledException {
      if (!ref.mounted) {
        return false;
      }

      state = state.copyWith(isLoadingContacts: false, errorMessage: null);
      return false;
    } on DeviceContactPermissionDeniedException {
      if (!ref.mounted) {
        return false;
      }

      state = state.copyWith(
        isLoadingContacts: false,
        errorMessage: 'onboarding.contactBlock.permissionDenied',
      );
      return false;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }

      state = state.copyWith(
        isLoadingContacts: false,
        errorMessage: 'onboarding.contactBlock.loadFailed',
      );
      return false;
    }
  }

  /// 연락처 선택 상태를 토글한다.
  void toggleContact(String contactId) {
    if (state.isBusy) {
      return;
    }

    final nextSelectedIds = {...state.selectedContactIds};
    if (!nextSelectedIds.add(contactId)) {
      nextSelectedIds.remove(contactId);
    }

    state = state.copyWith(
      selectedContactIds: nextSelectedIds,
      errorMessage: null,
    );
  }

  /// 선택한 연락처를 업로드하고 온보딩을 완료한다.
  Future<bool> uploadSelectedContacts() async {
    if (state.isBusy) {
      return false;
    }

    final phoneNumbers = state.selectedPhoneNumbers;
    if (phoneNumbers.isEmpty) {
      state = state.copyWith(
        errorMessage: 'onboarding.contactBlock.emptySelection',
      );
      return false;
    }

    state = state.copyWith(isUploading: true, errorMessage: null);

    try {
      await ref
          .read(contactRepositoryProvider)
          .uploadContacts(phoneNumbers: phoneNumbers);
      await _saveOnboardingCompletedStatus();
      if (!ref.mounted) {
        return true;
      }

      state = state.copyWith(isUploading: false, errorMessage: null);
      return true;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }

      state = state.copyWith(
        isUploading: false,
        errorMessage: ApiErrorMessages.uploadContactsFailed,
      );
      return false;
    }
  }

  /// 연락처 업로드 없이 온보딩을 완료한다.
  Future<bool> completeWithoutBlocking() async {
    if (state.isBusy) {
      return false;
    }

    state = state.copyWith(isUploading: true, errorMessage: null);

    try {
      await ref.read(contactRepositoryProvider).skipContacts();
      await _saveOnboardingCompletedStatus();
      if (!ref.mounted) {
        return true;
      }

      state = state.copyWith(isUploading: false, errorMessage: null);
      return true;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }

      state = state.copyWith(
        isUploading: false,
        errorMessage: 'onboarding.contactBlock.completeFailed',
      );
      return false;
    }
  }

  Future<void> _saveOnboardingCompletedStatus() {
    return ref
        .read(onboardingProfileStatusPersistenceProvider)
        .saveProfileStatus(LoginProfileStatus.onboardingCompleted);
  }
}
