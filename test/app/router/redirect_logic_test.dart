import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/app/router/onboarding_redirect_resolver.dart';
import 'package:wingle/app/router/redirect_logic.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/home/route/home_routes.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

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

  test('무효화된 세션은 현재 위치와 무관하게 login으로 리디렉션된다', () {
    expect(
      appRedirectLogic(
        false,
        OnboardingRoutes.basicProfileCompany.fullPath,
        forceLogin: true,
      ),
      OnboardingRoutes.login.fullPath,
    );
  });

  test('로그인하지 않은 사용자는 보호된 온보딩 경로에서 login으로 리디렉션된다', () {
    expect(
      appRedirectLogic(false, OnboardingRoutes.basicProfileCompany.fullPath),
      OnboardingRoutes.login.fullPath,
    );
  });

  test('로그인하지 않은 사용자는 공개 회원가입 경로에 머무를 수 있다', () {
    expect(appRedirectLogic(false, OnboardingRoutes.signup.fullPath), isNull);
    expect(appRedirectLogic(false, OnboardingRoutes.phone.fullPath), isNull);
  });

  test('온보딩 완료 사용자는 onboarding에서 home으로 이동한다', () async {
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.onboardingCompleted.apiValue,
    );

    expect(
      appRedirectLogic(true, AppRoute.onboarding.path),
      AppRoute.home.path,
    );
  });

  test('기본 프로필 정보 등록 전 사용자는 home에서 basicProfile로 이동한다', () async {
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.signupCompleted.apiValue,
    );

    expect(
      appRedirectLogic(true, AppRoute.home.path),
      OnboardingRoutes.basicProfile.fullPath,
    );
  });

  test('회사 정보 등록 전 사용자는 home에서 company로 이동한다', () async {
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.basicInfoCompleted.apiValue,
    );

    expect(
      appRedirectLogic(true, AppRoute.home.path),
      OnboardingRoutes.basicProfileCompany.fullPath,
    );
  });

  test('상세 프로필 등록 전 사용자는 home에서 상세 프로필 placeholder로 이동한다', () async {
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.educationInfoCompleted.apiValue,
    );

    expect(
      appRedirectLogic(true, AppRoute.home.path),
      OnboardingRoutes.profileDetails.fullPath,
    );
  });

  test('BE 온보딩 상태 전체가 명시적인 목적지로 매핑된다', () {
    final cases = <LoginProfileStatus, String>{
      LoginProfileStatus.signupCompleted: OnboardingRoutes.basicProfile.name,
      LoginProfileStatus.basicInfoCompleted:
          OnboardingRoutes.basicProfileCompany.name,
      LoginProfileStatus.jobInfoCompleted:
          OnboardingRoutes.basicProfileEducation.name,
      LoginProfileStatus.educationInfoCompleted:
          OnboardingRoutes.profileDetails.name,
      LoginProfileStatus.profileCompleted:
          OnboardingRoutes.approvalRequest.name,
      LoginProfileStatus.awaitingApproval:
          OnboardingRoutes.approvalPending.name,
      LoginProfileStatus.profileRejected: OnboardingRoutes.profileRejected.name,
      LoginProfileStatus.profileApproved:
          OnboardingRoutes.profileApprovedWelcome.name,
      LoginProfileStatus.choiceQuestionCompleted:
          OnboardingRoutes.requiredSelfIntro.name,
      LoginProfileStatus.essayQuestionCompleted:
          OnboardingRoutes.contactBlock.name,
      LoginProfileStatus.onboardingCompleted: HomeRoutes.root.name,
    };

    for (final entry in cases.entries) {
      expect(resolveOnboardingDestination(entry.key).name, entry.value);
    }
  });

  test('승인 완료 안내를 이미 본 사용자는 객관식 질문으로 이동한다', () {
    final destination = resolveOnboardingDestination(
      LoginProfileStatus.profileApproved,
      hasSeenProfileApprovalWelcome: true,
    );

    expect(destination.name, OnboardingRoutes.choiceQuestions.name);
  });

  test('승인 완료 안내를 이미 본 사용자는 home에서 객관식 질문으로 이동한다', () async {
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.profileApproved.apiValue,
    );
    await HiveUtil.write(
      key: HiveLoginBox.profileApprovalWelcomeSeen,
      value: 'true',
    );

    expect(
      appRedirectLogic(true, AppRoute.home.path),
      OnboardingRoutes.choiceQuestions.fullPath,
    );
  });
}
