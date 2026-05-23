import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/presentation/components/selection/region_codebook_selection_panel.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 기본 프로필 입력의 첫 단계인 거주지 입력 페이지.
class BasicProfileResidencePage extends ConsumerWidget {
  /// 생성자
  const BasicProfileResidencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(basicProfileProvider);
    final notifier = ref.read(basicProfileProvider.notifier);

    return BasicProfileInputScaffold(
      currentStep: BasicProfileInputConstants.residenceStep,
      totalSteps: BasicProfileInputConstants.totalSteps,
      title: 'onboarding.basicProfile.residence.title',
      subtitle: 'onboarding.basicProfile.residence.subtitle',
      buttonLabel: 'common.button.next',
      disabled: !state.canContinueResidence,
      onPressed: () {
        context.pushNamed(OnboardingRoutes.basicProfileHeight.name);
      },
      child: RegionCodebookSelectionPanel(
        selectedCode: state.residenceCode?.level3,
        onSelected: (selection) {
          final path = selection.path;
          notifier.selectResidenceCode(
            ResidenceCode(
              level1: path.isNotEmpty ? path[0].code : selection.code,
              level2: path.length > 1 ? path[1].code : '',
              level3: selection.code,
            ),
            query: selection.query,
          );
        },
      ),
    );
  }
}
