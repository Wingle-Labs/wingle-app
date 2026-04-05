import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/auth/data/dto/login_response_dto.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';

void main() {
  test('LoginResponseDto는 profileStatus를 파싱해 도메인으로 변환한다', () {
    final dto = LoginResponseDto.fromJson({
      'accessToken': 'access-token',
      'refreshToken': 'refresh-token',
      'profileStatus': 'FIRST_APPROVAL_PENDING',
      'gender': 'female',
    });

    expect(dto.accessToken, 'access-token');
    expect(dto.refreshToken, 'refresh-token');
    expect(dto.profileStatus, LoginProfileStatus.firstApprovalPending);
    expect(dto.gender, 'female');

    final result = dto.toDomain();
    expect(result.profileStatus, LoginProfileStatus.firstApprovalPending);
    expect(result.gender, 'female');
  });

  test('LoginResponseDto는 profileStatus가 없으면 승인 완료로 처리한다', () {
    final dto = LoginResponseDto.fromJson({
      'accessToken': 'access-token',
      'refreshToken': 'refresh-token',
    });

    expect(dto.profileStatus, LoginProfileStatus.firstApprovalApproved);
    expect(
      dto.toDomain().profileStatus,
      LoginProfileStatus.firstApprovalApproved,
    );
    expect(dto.gender, isNull);
  });
}
