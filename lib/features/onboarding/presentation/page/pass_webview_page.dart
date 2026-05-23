import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portone_flutter/Iamport_certification.dart';
import 'package:portone_flutter/model/certification_data.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_scaffold.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/features/onboarding/presentation/providers/pass_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// PASS 인증 웹뷰 페이지
class PassWebViewPage extends ConsumerWidget {
  /// 생성자
  const PassWebViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IamportCertification(
      appBar: DefaultAppBar(
        layout: DefaultAppBarLayout.display,
        title: 'onboarding.pass.webview.title',
      ),
      /* 웹뷰 로딩 컴포넌트 */
      initialChild: DefaultScaffold(
        body: Center(child: AnimationProgressIndicator()),
      ),
      /* [필수입력] 가맹점 식별코드 */
      userCode: EnvUtil.get(PortoneEnvFile.userCode),
      /* [필수입력] 본인인증 데이터 */
      data: CertificationData(
        pg: EnvUtil.get(PortoneEnvFile.pg),
        merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}',
        mRedirectUrl: EnvUtil.get(PortoneEnvFile.redirectUrl),
      ),
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) async {
        final impUid = ref
            .read(passVerificationProvider.notifier)
            .preprocessResult(result);

        if (impUid == null) {
          // 실패 처리
          DefaultToast.show(
            context,
            result['error_msg'] ?? 'onboarding.pass.webview.error.default',
          );
          context.pop();
          return;
        }

        try {
          final response = await ref
              .read(passVerificationProvider.notifier)
              .completeVerification(impUid);

          final user = response.identityVerification.verifiedCustomer;

          if (!context.mounted) return;
          if (!user.isValid) {
            DefaultToast.show(
              context,
              'onboarding.pass.webview.error.verificationFailed',
            );
            context.pop();
            return;
          }

          context.pushReplacementNamed(
            OnboardingRoutes.onboardingPassword.name,
            extra: user.phoneNumber!,
          );
        } catch (_) {
          if (!context.mounted) return;
          DefaultToast.show(
            context,
            'onboarding.pass.webview.error.verificationFailed',
          );
          context.pop();
        }
      },
    );
  }
}
