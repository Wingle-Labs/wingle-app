import 'package:wingle/features/auth/domain/models/phone_number.dart';

/// 휴대폰 인증 상태
class PhoneAuthState {
  /// 전화번호
  final PhoneNumber phoneNumber;

  /// 인증번호
  final String smsCode;

  /// 인증번호 발송 loading 상태
  final bool isSending;

  /// 코드 발송 완료 여부
  final bool isSent;

  /// 코드 대조 loading 상태
  final bool isVerifying;

  /// 코드 일치 여부
  final bool isVerified;

  /// 에러 메시지
  final String? errorMessage;

  /// 생성자
  const PhoneAuthState({
    required this.phoneNumber,
    required this.smsCode,
    required this.isSending,
    required this.isSent,
    required this.isVerifying,
    required this.isVerified,
    required this.errorMessage,
  });

  /// 초기화
  static PhoneAuthState init() {
    return PhoneAuthState(
      phoneNumber: PhoneNumber(''),
      smsCode: '',
      isSending: false,
      isSent: false,
      isVerifying: false,
      isVerified: false,
      errorMessage: null,
    );
  }

  /// 상태 복사
  PhoneAuthState copyWith({
    PhoneNumber? phoneNumber,
    String? smsCode,
    bool? isSending,
    bool? isSent,
    bool? isVerifying,
    bool? isVerified,
    String? errorMessage,
  }) {
    return PhoneAuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      smsCode: smsCode ?? this.smsCode,
      isSending: isSending ?? this.isSending,
      isSent: isSent ?? this.isSent,
      isVerifying: isVerifying ?? this.isVerifying,
      isVerified: isVerified ?? this.isVerified,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// 인증 코드 입력 화면으로 이동 가능 여부 확인
  bool pushOtpCondition() {
    if (phoneNumber.isValid && isSent) {
      return true;
    }
    return false;
  }
}
