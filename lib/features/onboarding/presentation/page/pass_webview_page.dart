import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portone_flutter/Iamport_certification.dart';
import 'package:portone_flutter/model/certification_data.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_scaffold.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/features/onboarding/presentation/providers/pass_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// PASS 인증 웹뷰 페이지
class PassWebViewPage extends ConsumerStatefulWidget {
  /// 생성자
  const PassWebViewPage({super.key});

  @override
  ConsumerState<PassWebViewPage> createState() => _PassWebViewPageState();
}

class _PassWebViewPageState extends ConsumerState<PassWebViewPage> {
  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    return IamportCertification(
      appBar: DefaultAppBar(
        child: DefaultText("PASS 본인 인증", style: typography.title),
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
          DefaultToast.show(context, result['error_msg'] ?? "에러가 발생했습니다.");
          context.pop();
          return;
        }

        final notifier = ref.read(passVerificationProvider.notifier);

        await notifier.completeVerification(impUid);

        if (!context.mounted) return;

        context.pushReplacementNamed(OnboardingRoutes.passResult.name);
      },
    );
  }
}
