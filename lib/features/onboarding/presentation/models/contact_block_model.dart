import 'package:wingle/features/onboarding/domain/model/contact_block_contact.dart';

/// 연락처 지인 제외 화면 상태.
class ContactBlockModel {
  /// 선택 가능한 연락처 목록.
  final List<ContactBlockContact> contacts;

  /// 선택한 연락처 id 목록.
  final Set<String> selectedContactIds;

  /// 연락처를 불러오는 중인지 여부.
  final bool isLoadingContacts;

  /// 선택한 연락처를 업로드하는 중인지 여부.
  final bool isUploading;

  /// 앱 내부 연락처 선택 확인이 필요한지 여부.
  final bool requiresInAppSelection;

  /// 오류 메시지 localization key.
  final String? errorMessage;

  /// 생성자.
  const ContactBlockModel({
    this.contacts = const [],
    this.selectedContactIds = const {},
    this.isLoadingContacts = false,
    this.isUploading = false,
    this.requiresInAppSelection = false,
    this.errorMessage,
  });

  /// 작업 중 여부.
  bool get isBusy => isLoadingContacts || isUploading;

  /// 선택한 연락처 수.
  int get selectedContactCount => selectedContactIds.length;

  /// 선택한 연락처가 있는지 여부.
  bool get hasSelectedContacts => selectedContactIds.isNotEmpty;

  /// 연락처별 선택 여부.
  bool isSelected(String contactId) => selectedContactIds.contains(contactId);

  /// 선택한 연락처의 전화번호 목록.
  List<String> get selectedPhoneNumbers {
    final selectedNumbers = <String>{};
    for (final contact in contacts) {
      if (selectedContactIds.contains(contact.id)) {
        selectedNumbers.addAll(contact.phoneNumbers);
      }
    }
    return selectedNumbers.toList(growable: false);
  }

  /// 변경된 상태 복사본.
  ContactBlockModel copyWith({
    List<ContactBlockContact>? contacts,
    Set<String>? selectedContactIds,
    bool? isLoadingContacts,
    bool? isUploading,
    bool? requiresInAppSelection,
    String? errorMessage,
  }) {
    return ContactBlockModel(
      contacts: contacts ?? this.contacts,
      selectedContactIds: selectedContactIds ?? this.selectedContactIds,
      isLoadingContacts: isLoadingContacts ?? this.isLoadingContacts,
      isUploading: isUploading ?? this.isUploading,
      requiresInAppSelection:
          requiresInAppSelection ?? this.requiresInAppSelection,
      errorMessage: errorMessage,
    );
  }
}
