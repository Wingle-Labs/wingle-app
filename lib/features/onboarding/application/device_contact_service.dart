import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:wingle/features/onboarding/domain/model/contact_block_contact.dart';

/// 연락처 권한이 거부된 경우.
class DeviceContactPermissionDeniedException implements Exception {
  /// 생성자.
  const DeviceContactPermissionDeniedException();
}

/// 연락처를 불러오지 못한 경우.
class DeviceContactReadFailedException implements Exception {
  /// 생성자.
  const DeviceContactReadFailedException();
}

/// 연락처 선택을 사용자가 취소한 경우.
class DeviceContactSelectionCanceledException implements Exception {
  /// 생성자.
  const DeviceContactSelectionCanceledException();
}

/// 플랫폼 연락처 선택 결과.
class DeviceContactSelectionResult {
  /// API로 전송 가능한 연락처 목록.
  final List<ContactBlockContact> contacts;

  /// 앱 내부에서 다중 선택 확인 UI를 한 번 더 보여줘야 하는지 여부.
  final bool requiresInAppSelection;

  /// 생성자.
  const DeviceContactSelectionResult({
    required this.contacts,
    required this.requiresInAppSelection,
  });
}

/// 기기 연락처 조회 서비스.
abstract interface class DeviceContactService {
  /// 사용자에게 공유받거나 사용자가 선택할 수 있는 연락처를 조회한다.
  Future<DeviceContactSelectionResult> selectContacts();
}

/// 플랫폼별 기기 연락처 선택 서비스.
class PlatformDeviceContactService implements DeviceContactService {
  static const MethodChannel _contactPickerChannel = MethodChannel(
    'wingle/contact_picker',
  );
  static final RegExp _nonDigitPattern = RegExp(r'\D');

  /// 생성자.
  const PlatformDeviceContactService();

  @override
  Future<DeviceContactSelectionResult> selectContacts() {
    if (Platform.isIOS) {
      return _selectIosContacts();
    }

    return _selectAndroidContacts();
  }

  Future<DeviceContactSelectionResult> _selectIosContacts() async {
    try {
      final result = await _contactPickerChannel
          .invokeMapMethod<String, Object?>('pickContacts');
      if (result == null) {
        throw const DeviceContactReadFailedException();
      }

      if (result['canceled'] == true) {
        throw const DeviceContactSelectionCanceledException();
      }

      final rawContacts = result['contacts'];
      if (rawContacts is! List) {
        throw const DeviceContactReadFailedException();
      }

      return DeviceContactSelectionResult(
        contacts: _contactBlockContactsFromNative(rawContacts),
        requiresInAppSelection: false,
      );
    } on DeviceContactSelectionCanceledException {
      rethrow;
    } on PlatformException {
      throw const DeviceContactReadFailedException();
    }
  }

  Future<DeviceContactSelectionResult> _selectAndroidContacts() async {
    final permission = await FlutterContacts.permissions.request(
      PermissionType.read,
    );
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.limited) {
      throw const DeviceContactPermissionDeniedException();
    }

    try {
      final contacts = await FlutterContacts.getAll(
        properties: const {ContactProperty.phone},
      );

      return DeviceContactSelectionResult(
        contacts: _contactBlockContactsFromFlutter(contacts),
        requiresInAppSelection: true,
      );
    } catch (_) {
      throw const DeviceContactReadFailedException();
    }
  }

  List<ContactBlockContact> _contactBlockContactsFromFlutter(
    List<Contact> contacts,
  ) {
    final normalizedContacts = <ContactBlockContact>[];
    for (final contact in contacts) {
      final phoneNumbers = _normalizedPhoneNumbers(contact);
      if (phoneNumbers.isEmpty) {
        continue;
      }

      normalizedContacts.add(
        ContactBlockContact(
          id: contact.id ?? contact.displayName ?? phoneNumbers.first,
          displayName: _displayNameOf(contact, phoneNumbers.first),
          phoneNumbers: phoneNumbers,
        ),
      );
    }

    return _sortedContacts(normalizedContacts);
  }

  List<ContactBlockContact> _contactBlockContactsFromNative(
    List<Object?> rawContacts,
  ) {
    final normalizedContacts = <ContactBlockContact>[];
    for (final rawContact in rawContacts) {
      if (rawContact is! Map) {
        continue;
      }

      final rawPhoneNumbers = rawContact['phoneNumbers'];
      if (rawPhoneNumbers is! List) {
        continue;
      }

      final phoneNumbers = rawPhoneNumbers
          .whereType<String>()
          .map(_normalizeKoreanMobilePhoneNumber)
          .nonNulls
          .toSet()
          .toList(growable: false);
      if (phoneNumbers.isEmpty) {
        continue;
      }

      final rawDisplayName = rawContact['displayName'];
      final displayName = rawDisplayName is String ? rawDisplayName.trim() : '';

      normalizedContacts.add(
        ContactBlockContact(
          id: _nativeContactIdOf(rawContact, phoneNumbers.first),
          displayName: displayName.isNotEmpty
              ? displayName
              : phoneNumbers.first,
          phoneNumbers: phoneNumbers,
        ),
      );
    }

    return _sortedContacts(normalizedContacts);
  }

  String _nativeContactIdOf(Map<dynamic, dynamic> rawContact, String fallback) {
    final id = rawContact['id'];
    if (id is String && id.trim().isNotEmpty) {
      return id;
    }

    return fallback;
  }

  List<ContactBlockContact> _sortedContacts(
    List<ContactBlockContact> contacts,
  ) {
    contacts.sort((a, b) {
      return a.displayName.compareTo(b.displayName);
    });
    return contacts;
  }

  List<String> _normalizedPhoneNumbers(Contact contact) {
    final numbers = <String>{};
    for (final phone in contact.phones) {
      final normalized =
          _normalizeKoreanMobilePhoneNumber(phone.normalizedNumber) ??
          _normalizeKoreanMobilePhoneNumber(phone.number);
      if (normalized != null) {
        numbers.add(normalized);
      }
    }
    return numbers.toList(growable: false);
  }

  String? _normalizeKoreanMobilePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final digits = value.replaceAll(_nonDigitPattern, '');
    final localDigits = switch (digits) {
      final text when text.length == 11 && text.startsWith('010') => text,
      final text when text.length == 12 && text.startsWith('8210') =>
        '0${text.substring(2)}',
      _ => null,
    };

    if (localDigits == null) {
      return null;
    }

    return '${localDigits.substring(0, 3)}-'
        '${localDigits.substring(3, 7)}-'
        '${localDigits.substring(7)}';
  }

  String _displayNameOf(Contact contact, String fallbackPhoneNumber) {
    final displayName = contact.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    return fallbackPhoneNumber;
  }
}
