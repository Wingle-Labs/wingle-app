import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/design_system.dart';
import 'package:wingle/features/home/route/home_router.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';
import 'package:wingle/widgetbook/screens/widgetbook_preview_app.dart';

/// Widgetbook의 페이지 화면 폴더를 구성한다.
WidgetbookFolder buildScreenFolder() {
  return WidgetbookFolder(
    name: 'Screens',
    children: [_buildAppFolder(), _buildAuthFolder(), _buildOnboardingFolder()],
  );
}

WidgetbookFolder _buildAppFolder() {
  return WidgetbookFolder(
    name: 'App',
    children: [
      _screenComponent(name: 'Home', initialLocation: homeRoute.path),
      _screenComponent(
        name: 'Design System',
        initialLocation: designSystemRoute.path,
      ),
    ],
  );
}

WidgetbookFolder _buildAuthFolder() {
  return WidgetbookFolder(
    name: 'Auth',
    children: [
      _screenComponent(
        name: 'Phone Auth',
        initialLocation: OnboardingRoutes.phone.fullPath,
      ),
      _screenComponent(
        name: 'Phone OTP',
        initialLocation: OnboardingRoutes.otp.fullPath,
      ),
      _screenComponent(
        name: 'Login',
        initialLocation: OnboardingRoutes.login.fullPath,
      ),
    ],
  );
}

WidgetbookFolder _buildOnboardingFolder() {
  return WidgetbookFolder(
    name: 'Onboarding',
    children: [
      _screenComponent(
        name: 'Onboarding',
        initialLocation: OnboardingRoutes.root.fullPath,
      ),
      _screenComponent(
        name: 'Agreement',
        initialLocation: OnboardingRoutes.agreement.fullPath,
      ),
      _screenComponent(
        name: 'Basic Profile Nickname',
        initialLocation: OnboardingRoutes.basicProfile.fullPath,
      ),
      _screenComponent(
        name: 'Basic Profile Residence',
        initialLocation: OnboardingRoutes.basicProfileResidence.fullPath,
      ),
      _screenComponent(
        name: 'Basic Profile Height',
        initialLocation: OnboardingRoutes.basicProfileHeight.fullPath,
      ),
      _screenComponent(
        name: 'Basic Profile Body Shape',
        initialLocation: OnboardingRoutes.basicProfileBodyShape.fullPath,
        showGenderKnob: true,
      ),
      _screenComponent(
        name: 'Basic Profile Occupation',
        initialLocation: OnboardingRoutes.basicProfileCompany.fullPath,
      ),
      _screenComponent(
        name: 'Basic Profile Company',
        initialLocation: OnboardingRoutes.basicProfileCompanyName.fullPath,
      ),
      _screenComponent(
        name: 'Basic Profile Company Email',
        initialLocation: OnboardingRoutes.basicProfileCompanyEmail.fullPath,
      ),
      _screenComponent(
        name: 'Profile Style Photos',
        initialLocation: OnboardingRoutes.profileStylePhotos.fullPath,
      ),
      _screenComponent(
        name: 'Profile Face Photos',
        initialLocation: OnboardingRoutes.profileFacePhotos.fullPath,
      ),
      _screenComponent(
        name: 'Profile Self Introduction',
        initialLocation: OnboardingRoutes.profileSelfIntroduction.fullPath,
      ),
      _screenComponent(
        name: 'Profile Approval Pending',
        initialLocation: OnboardingRoutes.approvalPending.fullPath,
      ),
      _screenComponent(
        name: 'Pass',
        initialLocation: OnboardingRoutes.pass.fullPath,
      ),
      _screenComponent(
        name: 'PASS WebView',
        initialLocation: OnboardingRoutes.passWebView.fullPath,
      ),
      _screenComponent(
        name: 'Onboarding Password',
        initialLocation: OnboardingRoutes.onboardingPassword.fullPath,
      ),
      _screenComponent(
        name: 'Age Pick',
        initialLocation: OnboardingRoutes.age.fullPath,
      ),
      _screenComponent(
        name: 'Required Self Intro',
        initialLocation: OnboardingRoutes.requiredSelfIntro.fullPath,
      ),
      _screenComponent(
        name: 'Selective Self Intro',
        initialLocation: OnboardingRoutes.selectiveSelfIntro.fullPath,
      ),
    ],
  );
}

WidgetbookComponent _screenComponent({
  required String name,
  required String initialLocation,
  bool showGenderKnob = false,
}) {
  return WidgetbookComponent(
    name: name,
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) {
          final themeMode = context.knobs.object.dropdown<ThemeMode>(
            label: '테마',
            options: const [ThemeMode.light, ThemeMode.dark, ThemeMode.system],
            initialOption: ThemeMode.light,
            labelBuilder: (mode) => switch (mode) {
              ThemeMode.light => 'Light',
              ThemeMode.dark => 'Dark',
              ThemeMode.system => 'System',
            },
          );
          final textScaleFactor = context.knobs.double.slider(
            label: '글자 크기',
            initialValue: 1,
            min: 0.8,
            max: 1.6,
            precision: 2,
          );
          final userGender = showGenderKnob
              ? context.knobs.object.dropdown<String>(
                  label: '성별',
                  options: const ['male', 'female'],
                  initialOption: 'male',
                )
              : null;

          return WidgetbookPreviewApp(
            initialLocation: initialLocation,
            themeMode: themeMode,
            textScaleFactor: textScaleFactor,
            userGender: userGender,
          );
        },
      ),
    ],
  );
}
