import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/states/step_indicator.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// StepIndicator를 확인할 수 있는 페이지
class StepIndicatorPage extends StatefulWidget {
  /// 초기 현재 단계
  final int initialCurrentStep;

  /// 초기 전체 단계 수
  final int initialTotalSteps;

  /// 생성자
  const StepIndicatorPage({
    super.key,
    this.initialCurrentStep = 1,
    this.initialTotalSteps = 6,
  });

  @override
  State<StepIndicatorPage> createState() => _StepIndicatorPageState();
}

class _StepIndicatorPageState extends State<StepIndicatorPage> {
  late int _currentStep;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialCurrentStep;
  }

  void _setStep(int nextStep, int totalSteps) {
    setState(() {
      _currentStep = nextStep.clamp(1, totalSteps);
    });
  }

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    final totalSteps = context.knobs.object.dropdown<int>(
      label: 'Total Steps',
      options: const [2, 3, 4, 5, 6, 7, 8],
      initialOption: widget.initialTotalSteps,
    );

    final resolvedCurrentStep = _currentStep.clamp(1, totalSteps);

    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.backgroundNormal,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: colors.strokeStructuralBorder),
            boxShadow: [
              BoxShadow(
                color: colors.overlayPressed.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Step Indicator', style: typography.title),
              const SizedBox(height: 8),
              Text(
                '현재 단계와 전체 단계 수를 버튼으로 실제 이동시키며 확인합니다.',
                style: typography.bodySub.copyWith(
                  color: colors.textAlternative,
                ),
              ),
              const SizedBox(height: 24),
              StepIndicator(
                currentStep: resolvedCurrentStep,
                totalSteps: totalSteps,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              Text(
                'currentStep: $resolvedCurrentStep / totalSteps: $totalSteps',
                style: typography.body,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(totalSteps, (index) {
                  final step = index + 1;
                  final isSelected = step == resolvedCurrentStep;

                  return FilledButton.tonal(
                    onPressed: () => _setStep(step, totalSteps),
                    style: FilledButton.styleFrom(
                      backgroundColor: isSelected
                          ? colors.primaryNormal
                          : colors.backgroundAlternative,
                      foregroundColor: isSelected
                          ? colors.onPrimaryNormal
                          : colors.textNormal,
                      minimumSize: const Size(44, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    child: Text('$step'),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DefaultFilledButton(
                      label: 'Previous',
                      isDisabled: resolvedCurrentStep <= 1,
                      onPressed: resolvedCurrentStep > 1
                          ? () => _setStep(resolvedCurrentStep - 1, totalSteps)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DefaultFilledButton(
                      label: 'Reset',
                      isDisabled: resolvedCurrentStep == 1,
                      onPressed: resolvedCurrentStep > 1
                          ? () => _setStep(1, totalSteps)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DefaultFilledButton(
                      label: 'Next',
                      isDisabled: resolvedCurrentStep >= totalSteps,
                      onPressed: resolvedCurrentStep < totalSteps
                          ? () => _setStep(resolvedCurrentStep + 1, totalSteps)
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
