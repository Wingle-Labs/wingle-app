import 'dart:async';
import 'dart:convert';

import 'package:wingle/features/onboarding/domain/model/pass_start_response.dart';
import 'package:wingle/features/onboarding/domain/model/pass_verification_result.dart';
import 'package:wingle/features/onboarding/domain/repository/pass_repository.dart';

/// Mock PASS 인증 Repository
class MockPassRepository implements PassRepository {
  @override
  Future<PassStartResponse> startVerification() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return PassStartResponse(
      verificationUrl: Uri.dataFromString(
        '''
<html>
<body>
<h2>Mock PASS 인증</h2>
<button onclick="window.location.href='https://mock/pass-success'">
인증 성공
</button>
</body>
</html>
''',
        mimeType: 'text/html',
        encoding: utf8,
      ).toString(),
    );
  }

  @override
  Future<PassVerificationResult> fetchVerificationResult() async {
    await Future.delayed(const Duration(seconds: 1));

    return PassVerificationResult(
      ci: "MOCK_CI_123456",
      name: "홍길동",
      phoneNumber: "01012345678",
      birth: DateTime(1995, 3, 10),
      gender: "M",
    );
  }
}
