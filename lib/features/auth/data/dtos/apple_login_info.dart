import 'package:json_annotation/json_annotation.dart';

/// Apple 로그인 정보
@JsonSerializable()
class AppleLoginInfo {
  /// 식별자 토큰
  /// Apple 로그인을 위한 식별자 토큰
  final String identityToken;

  /// 인증 코드
  /// Apple 로그인을 위한 인증 코드
  final String authorizationCode;

  /// 사용자 식별자
  /// Apple 로그인을 위한 사용자 식별자
  final String userIdentifier;

  /// 생성자
  AppleLoginInfo({
    required this.identityToken,
    required this.authorizationCode,
    required this.userIdentifier,
  });
}
