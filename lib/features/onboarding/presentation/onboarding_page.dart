import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/features/auth/data/datasources/google_api.dart';
import 'package:wingle/features/auth/data/datasources/kakao_api.dart';

/// Onboarding 페이지
class OnboardingPage extends ConsumerStatefulWidget {
  /// 초기 화면으로 사용자에게 앱을 소개하는 페이지
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () async {
                await KakaoApiManager.instance.getTokenWithLogin();
              },
              child: Text("카카오톡으로 로그인 "),
            ),
            FilledButton(
              onPressed: () async {
                await GoogleApiManager.instance.signIn();
              },
              child: Text("구글로 로그인 "),
            ),
          ],
        ),
      ),
    );
  }
}
