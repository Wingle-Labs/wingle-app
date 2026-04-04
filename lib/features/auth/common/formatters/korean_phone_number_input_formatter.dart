import 'package:flutter/services.dart';

/// 한국 휴대폰 번호 입력 포맷터
class KoreanPhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final formatted = _formatDigits(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatDigits(String digits) {
    if (digits.length <= 3) {
      return digits;
    }

    if (digits.length <= 7) {
      return '${digits.substring(0, 3)}-${digits.substring(3)}';
    }

    final middle = digits.substring(3, 7);
    final end = digits.substring(7);
    return '${digits.substring(0, 3)}-$middle-$end';
  }
}
