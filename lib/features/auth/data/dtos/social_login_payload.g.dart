// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_login_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialLoginPayload _$SocialLoginPayloadFromJson(Map<String, dynamic> json) =>
    SocialLoginPayload(
      provider: $enumDecode(_$SocialProviderEnumMap, json['provider']),
      accessToken: json['accessToken'] as String?,
      idToken: json['idToken'] as String?,
    );

Map<String, dynamic> _$SocialLoginPayloadToJson(SocialLoginPayload instance) =>
    <String, dynamic>{
      'provider': _$SocialProviderEnumMap[instance.provider]!,
      'accessToken': instance.accessToken,
      'idToken': instance.idToken,
    };

const _$SocialProviderEnumMap = {
  SocialProvider.google: 'google',
  SocialProvider.kakao: 'kakao',
  SocialProvider.apple: 'apple',
};
