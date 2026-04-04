import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/app/router/redirect_logic.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    final key = Hive.generateSecureKey();
    await HiveUtil.initialize(HiveAesCipher(key));
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('로그인하지 않은 사용자는 onboarding으로 리디렉션된다', () {
    expect(
      appRedirectLogic(false, AppRoute.home.path),
      AppRoute.onboarding.path,
    );
  });

  test('승인 완료 사용자는 onboarding에서 home으로 이동한다', () async {
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.firstApprovalApproved.apiValue,
    );

    expect(
      appRedirectLogic(true, AppRoute.onboarding.path),
      AppRoute.home.path,
    );
  });

  test('프로필 진행 중 사용자는 home에서 onboarding으로 이동한다', () async {
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.beforeProfileDetails.apiValue,
    );

    expect(
      appRedirectLogic(true, AppRoute.home.path),
      AppRoute.onboarding.path,
    );
  });
}
