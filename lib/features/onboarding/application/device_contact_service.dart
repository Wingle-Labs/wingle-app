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

/// 기기 연락처 조회 서비스.
abstract interface class DeviceContactService {
  /// 사용자에게 공유된 연락처를 조회한다.
  Future<List<ContactBlockContact>> readContacts();
}

/// flutter_contacts 기반 기기 연락처 조회 서비스.
class FlutterDeviceContactService implements DeviceContactService {
  static final RegExp _nonDigitPattern = RegExp(r'\D');

  /// 생성자.
  const FlutterDeviceContactService();

  @override
  Future<List<ContactBlockContact>> readContacts() async {
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

      normalizedContacts.sort((a, b) {
        return a.displayName.compareTo(b.displayName);
      });
      return normalizedContacts;
    } catch (_) {
      throw const DeviceContactReadFailedException();
    }
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
