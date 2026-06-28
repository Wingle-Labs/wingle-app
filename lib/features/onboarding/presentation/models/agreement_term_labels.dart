/// 약관 type code를 화면 표시 정책으로 변환한다.
class AgreementTermLabels {
  const AgreementTermLabels._();

  /// 화면에 노출할 약관 제목.
  static String titleFor({required String? type, required String fallback}) {
    return switch (type) {
      'TOS' => '이용약관 동의',
      'PRIVACY' => '개인정보 수집 및 이용 동의',
      'LOCATION' => '위치정보 이용약관 동의',
      'SENSITIVE' => '민감정보 수집 및 이용 동의',
      'MARKETING' || 'ADS' => '마케팅 수신 동의',
      'OUTSOURCE' => '개인정보 처리위탁 동의',
      'OVERSEAS' => '개인정보 국외 이전 동의',
      _ => fallback,
    };
  }

  /// 약관 표시 순서.
  static int sortWeight(String? type) {
    return switch (type) {
      'TOS' => 0,
      'PRIVACY' => 1,
      'LOCATION' => 2,
      'SENSITIVE' => 3,
      'MARKETING' => 4,
      'ADS' => 5,
      'OUTSOURCE' => 6,
      'OVERSEAS' => 7,
      _ => 100,
    };
  }
}
