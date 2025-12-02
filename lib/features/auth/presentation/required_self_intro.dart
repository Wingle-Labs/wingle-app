import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 필수 자기소개 페이지
class RequiredSelfIntroPage extends ConsumerWidget {
  /// 생성자
  const RequiredSelfIntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('onboarding.selfIntro.title'.tr())),
      body: Placeholder(),
    );
  }
}
