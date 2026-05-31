/// 직업 코드별 회사 입력/이메일 인증 정책.
abstract final class JobOccupationPolicy {
  /// 직업 선택 첫 화면에서 루트로 노출할 직업 코드.
  static const Set<String> topLevelOccupationCodes = {
    'J101', // 무직
  };

  /// 회사명과 회사 이메일 인증을 받을 수 없는 직업 코드.
  static const Set<String> companyUnavailableCodes = {
    'J101', // 무직
    'J102', // 학생
  };

  /// 회사명 입력과 회사 이메일 인증이 필요한지 여부.
  static bool requiresCompany(String? occupationCode) {
    final code = occupationCode?.trim();
    if (code == null || code.isEmpty) {
      return false;
    }
    return !companyUnavailableCodes.contains(code);
  }

  /// 회사명 입력과 이메일 인증 단계를 건너뛰어야 하는지 여부.
  static bool skipsCompanyAndEmail(String? occupationCode) {
    final code = occupationCode?.trim();
    return code != null && companyUnavailableCodes.contains(code);
  }
}
