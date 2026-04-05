import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/features/onboarding/presentation/components/input/profile_input_search_field.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
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
  final TextEditingController _controller = TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicProfileInputScaffold(
      currentStep: BasicProfileInputConstants.residenceStep,
      totalSteps: BasicProfileInputConstants.totalSteps,
      title: 'onboarding.basicProfile.residence.title',
      subtitle: 'onboarding.basicProfile.residence.subtitle',
      buttonLabel: 'common.button.next',
      disabled: _query.trim().isEmpty,
      onPressed: () {
        context.pushNamed(OnboardingRoutes.basicProfileHeight.name);
      },
      child: ProfileInputSearchField(
        controller: _controller,
        hintText: 'onboarding.basicProfile.residence.field.hint',
        showClearButton: _query.isNotEmpty,
        onClear: () {
          _controller.clear();
          setState(() {
            _query = '';
          });
        },
        onChanged: (value) {
          setState(() {
            _query = value;
          });
        },
      ),
    );
  }
}
