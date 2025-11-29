import 'package:json_annotation/json_annotation.dart';
import 'package:wingle/common/enums/social_provider.dart';

part 'social_login_payload.g.dart';

/// 소셜 로그인 요청 데이터
@JsonSerializable()
class SocialLoginPayload {
  /// 소셜 프로바이더
  final SocialProvider provider;

  /// 액세스 토큰
  final String? accessToken;

  /// ID 토큰
  final String? idToken;

  /// 생성자
  const SocialLoginPayload({
    required this.provider,
    this.accessToken,
    this.idToken,
  });

  /// JSON으로부터 변환
  factory SocialLoginPayload.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginPayloadFromJson(json);

  /// JSON으로 변환
  Map<String, dynamic> toJson() => _$SocialLoginPayloadToJson(this);
}
