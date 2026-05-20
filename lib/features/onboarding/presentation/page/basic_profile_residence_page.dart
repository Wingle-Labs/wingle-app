import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/presentation/components/selection/region_codebook_selection_panel.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/region_codebook_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 기본 프로필 입력의 첫 단계인 거주지 입력 페이지.
class BasicProfileResidencePage extends ConsumerStatefulWidget {
  /// 생성자
  const BasicProfileResidencePage({super.key});

  @override
  ConsumerState<BasicProfileResidencePage> createState() =>
      _BasicProfileResidencePageState();
}

class _BasicProfileResidencePageState
    extends ConsumerState<BasicProfileResidencePage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(basicProfileProvider);
    final notifier = ref.read(basicProfileProvider.notifier);
    final tree = ref.watch(regionCodebookTreeProvider);

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
        tree: tree,
        selectedCode: state.residenceCode?.level3,
        onSelected: (value) {
          final path = tree.pathTo(value);
          notifier.selectResidenceCode(
            ResidenceCode(
              level1: path.isNotEmpty ? path[0].code : value,
              level2: path.length > 1 ? path[1].code : '',
              level3: path.length > 2 ? path[2].code : value,
            ),
            query: path.map((node) => node.codeName).join(' '),
          );
        },
      ),
    );
  }
}
