import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/buttons/default_checkbox.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_input_field.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_outlined_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/component_resolved_spec.dart';

/// 입력 필드 컴포넌트 프리뷰
class InputFieldPage extends StatefulWidget {
  /// 생성자
  const InputFieldPage({super.key});

  @override
  State<InputFieldPage> createState() => _InputFieldPageState();
}

class _InputFieldPageState extends State<InputFieldPage> {
  late final TextEditingController _defaultController;
  late final TextEditingController _filledController;
  late final TextEditingController _focusedController;
  late final TextEditingController _errorController;
  late final TextEditingController _suffixController;
  late final TextEditingController _prefixSuffixController;
  late final TextEditingController _assistiveController;
  final FocusNode _focusedNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _defaultController = TextEditingController();
    _filledController = TextEditingController(text: 'Input Field');
    _focusedController = TextEditingController(text: '텍스트를 작성하고');
    _errorController = TextEditingController(text: '사용자가 입력한 값');
    _suffixController = TextEditingController();
    _prefixSuffixController = TextEditingController();
    _assistiveController = TextEditingController();
  }

  @override
  void dispose() {
    _defaultController.dispose();
    _filledController.dispose();
    _focusedController.dispose();
    _errorController.dispose();
    _suffixController.dispose();
    _prefixSuffixController.dispose();
    _assistiveController.dispose();
    _focusedNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final state = context.knobs.object.dropdown<DefaultInputFieldState>(
      label: 'state',
      options: DefaultInputFieldState.values,
      initialOption: DefaultInputFieldState.defaultState,
      labelBuilder: (value) => switch (value) {
        DefaultInputFieldState.defaultState => 'Default',
        DefaultInputFieldState.filled => 'Filled',
        DefaultInputFieldState.focused => 'Focused',
        DefaultInputFieldState.error => 'Error',
      },
    );
    final type = context.knobs.object.dropdown<DefaultInputFieldType>(
      label: 'type',
      options: DefaultInputFieldType.values,
      initialOption: DefaultInputFieldType.inputSuffix,
      labelBuilder: (value) => switch (value) {
        DefaultInputFieldType.inputSuffix => 'Input / Suffix',
        DefaultInputFieldType.inputPrefixSuffix => 'Input / Prefix + Suffix',
        DefaultInputFieldType.inputAssistiveAction =>
          'Input / Assistive Action',
      },
    );
    final resolvedSpec = _buildResolvedSpec(context, state, type);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Input Field', style: typography.title),
            const SizedBox(height: AppSpacing.s8),
            Text(
              '기본 구조는 Label / Input Field / Assistive Text로 유지하고, '
              'Normal variant를 공용 shell로 확장합니다.',
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text('Input Field / Normal', style: typography.main),
            const SizedBox(height: AppSpacing.s16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppPadding.card),
              decoration: BoxDecoration(
                color: colors.backgroundAlternative,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInteractiveSection(context, state, type),
                  const SizedBox(height: AppSpacing.s24),
                  _buildStateSection(context),
                  const SizedBox(height: AppSpacing.s24),
                  _buildTypeSection(context),
                  const SizedBox(height: AppSpacing.s24),
                  WidgetbookResolvedSpecCard(entries: resolvedSpec),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateSection(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppPadding.card),
            decoration: BoxDecoration(
              color: colors.backgroundNormal,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KnobLabel(
                  title: 'state =',
                  values: const ['Default', 'Filled', 'Focused', 'Error'],
                ),
                const SizedBox(height: AppSpacing.s20),
                _buildNormalFieldSample(
                  controller: _defaultController,
                  labelText: 'Label Text',
                  hintText: 'Hint Text',
                  assistiveText: 'Assistive text',
                  state: DefaultInputFieldState.defaultState,
                ),
                const SizedBox(height: AppSpacing.s20),
                _buildNormalFieldSample(
                  controller: _filledController,
                  labelText: 'Label Text',
                  hintText: 'Hint Text',
                  assistiveText: 'Assistive text',
                  state: DefaultInputFieldState.filled,
                ),
                const SizedBox(height: AppSpacing.s20),
                _buildNormalFieldSample(
                  controller: _focusedController,
                  labelText: 'Label Text',
                  hintText: 'Hint Text',
                  assistiveText: 'Assistive text',
                  state: DefaultInputFieldState.focused,
                  focusNode: _focusedNode,
                ),
                const SizedBox(height: AppSpacing.s20),
                _buildNormalFieldSample(
                  controller: _errorController,
                  labelText: 'Label Text',
                  hintText: 'Hint Text',
                  errorText: 'Error Text',
                  state: DefaultInputFieldState.error,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s52),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Default : 입력 전 상태로, placeholder(hint text)가 표시돼요.',
                  style: typography.body,
                ),
                const SizedBox(height: AppSpacing.s12),
                Text(
                  '• Filled : 입력값이 존재하는 상태로, 실제 입력값이 표시돼요.',
                  style: typography.body,
                ),
                const SizedBox(height: AppSpacing.s12),
                Text(
                  '• Focused : 입력중인 상태로, 커서가 활성화되고 입력 필드가 강조돼요.\n'
                  '  Anchor가 텍스트 길이에 따라 움직여요.',
                  style: typography.body,
                ),
                const SizedBox(height: AppSpacing.s12),
                Text(
                  '• Error : 입력값 검증에 실패한 상태로, 입력 필드와 에러 메시지를 통해 '
                  '문제를 인지하고 수정할 수 있도록 안내해요.',
                  style: typography.body,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveSection(
    BuildContext context,
    DefaultInputFieldState state,
    DefaultInputFieldType type,
  ) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: colors.backgroundNormal,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _KnobLabel(
            title: 'live =',
            values: const ['state knob', 'type knob'],
          ),
          const SizedBox(height: AppSpacing.s20),
          _buildNormalFieldSample(
            controller: _controllerForState(state),
            labelText: 'Label Text',
            hintText: 'Hint Text',
            assistiveText: state == DefaultInputFieldState.error
                ? null
                : 'Assistive text',
            errorText: state == DefaultInputFieldState.error
                ? 'Error Text'
                : null,
            state: state,
            type: type,
            focusNode: state == DefaultInputFieldState.focused
                ? _focusedNode
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSection(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppPadding.card),
            decoration: BoxDecoration(
              color: colors.backgroundNormal,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KnobLabel(
                  title: 'type =',
                  values: const [
                    'Input / Suffix',
                    'Input / Prefix + Suffix',
                    'Input / Assistive Action',
                  ],
                ),
                const SizedBox(height: AppSpacing.s20),
                _buildNormalFieldSample(
                  controller: _suffixController,
                  labelText: 'Label Text',
                  hintText: 'Hint Text',
                  assistiveText: 'Assistive text',
                  state: DefaultInputFieldState.defaultState,
                  type: DefaultInputFieldType.inputSuffix,
                ),
                const SizedBox(height: AppSpacing.s20),
                Row(
                  children: [
                    Expanded(
                      child: _buildNormalFieldSample(
                        controller: _prefixSuffixController,
                        labelText: 'Label Text',
                        hintText: 'Hint Text',
                        assistiveText: 'Assistive text',
                        state: DefaultInputFieldState.defaultState,
                        type: DefaultInputFieldType.inputPrefixSuffix,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: _buildNormalFieldSample(
                        controller: _assistiveController,
                        labelText: 'Label Text',
                        hintText: 'Hint Text',
                        assistiveText: 'Assistive text',
                        state: DefaultInputFieldState.defaultState,
                        type: DefaultInputFieldType.inputAssistiveAction,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s52),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Input Field는 Prefix/Suffix 및 보조 액션 여부에 따라 '
                  '다양한 형태로 확장돼요.',
                  style: typography.body,
                ),
                const SizedBox(height: AppSpacing.s12),
                Text(
                  '• 필드 내부 요소는 Prefix와 Suffix로 구분되며, 외부 보조 액션은 '
                  'Assistive 영역에서 제공돼요.',
                  style: typography.body,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalFieldSample({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    String? assistiveText,
    String? errorText,
    required DefaultInputFieldState state,
    DefaultInputFieldType type = DefaultInputFieldType.inputSuffix,
    FocusNode? focusNode,
  }) {
    return DefaultOutlinedInputField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      assistiveText: assistiveText,
      errorText: errorText,
      state: state,
      type: type,
      focusNode: focusNode,
      prefix: type == DefaultInputFieldType.inputPrefixSuffix
          ? const _InputFieldPlaceholder()
          : null,
      suffix: type == DefaultInputFieldType.inputAssistiveAction
          ? null
          : const _InputFieldPlaceholder(),
      assistiveAction: type == DefaultInputFieldType.inputAssistiveAction
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                DefaultCheckbox(isChecked: false),
                SizedBox(width: AppSpacing.s8),
                DefaultText(
                  'Assistive text',
                  isTranslationKey: false,
                  policy: TextScalePolicy.cappedMedium,
                ),
              ],
            )
          : null,
      policy: TextScalePolicy.cappedMedium,
    );
  }

  TextEditingController _controllerForState(DefaultInputFieldState state) {
    return switch (state) {
      DefaultInputFieldState.defaultState => _defaultController,
      DefaultInputFieldState.filled => _filledController,
      DefaultInputFieldState.focused => _focusedController,
      DefaultInputFieldState.error => _errorController,
    };
  }

  List<WidgetbookResolvedSpecEntry> _buildResolvedSpec(
    BuildContext context,
    DefaultInputFieldState state,
    DefaultInputFieldType type,
  ) {
    final colors = context.colors;
    final borderColor = switch (state) {
      DefaultInputFieldState.defaultState => colors.strokeStructuralBorder,
      DefaultInputFieldState.filled => colors.strokeStructuralBorder,
      DefaultInputFieldState.focused => colors.primaryNormal,
      DefaultInputFieldState.error => colors.statusNegative,
    };
    final assistiveColor = switch (state) {
      DefaultInputFieldState.error => colors.statusNegative,
      _ => colors.textAssistive,
    };

    return [
      const WidgetbookResolvedSpecEntry(label: 'Variant', value: 'normal'),
      WidgetbookResolvedSpecEntry(label: 'State', value: state.name),
      WidgetbookResolvedSpecEntry(label: 'Type', value: type.name),
      const WidgetbookResolvedSpecEntry(label: 'Height', value: '48px'),
      const WidgetbookResolvedSpecEntry(label: 'Radius', value: '18px'),
      const WidgetbookResolvedSpecEntry(label: 'Padding', value: 'All 16px'),
      const WidgetbookResolvedSpecEntry(label: 'Label gap', value: '4px'),
      const WidgetbookResolvedSpecEntry(
        label: 'Label style',
        value: '16px / 500',
      ),
      const WidgetbookResolvedSpecEntry(
        label: 'Input text style',
        value: '16px / 500',
      ),
      const WidgetbookResolvedSpecEntry(
        label: 'Assistive style',
        value: '12px / 600',
      ),
      const WidgetbookResolvedSpecEntry(label: 'Suffix slot', value: '16px'),
      WidgetbookResolvedSpecEntry(
        label: 'Background',
        value:
            'backgroundNormal '
            '(${widgetbookColorToHex(colors.backgroundNormal)})',
        swatchColor: colors.backgroundNormal,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Border',
        value:
            '${_borderTokenName(state)} (${widgetbookColorToHex(borderColor)})',
        swatchColor: borderColor,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Input text',
        value: 'textNormal (${widgetbookColorToHex(colors.textNormal)})',
        swatchColor: colors.textNormal,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Hint/Assistive',
        value: state == DefaultInputFieldState.error
            ? 'statusNegative (${widgetbookColorToHex(assistiveColor)})'
            : 'textAssistive (${widgetbookColorToHex(assistiveColor)})',
        swatchColor: assistiveColor,
      ),
    ];
  }

  String _borderTokenName(DefaultInputFieldState state) {
    return switch (state) {
      DefaultInputFieldState.focused => 'primaryNormal',
      DefaultInputFieldState.error => 'statusNegative',
      _ => 'strokeStructuralBorder',
    };
  }
}

class _InputFieldPlaceholder extends StatelessWidget {
  const _InputFieldPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: AppIconSize.xs,
      height: AppIconSize.xs,
      color: colors.interactionInactive,
    );
  }
}

class _KnobLabel extends StatelessWidget {
  final String title;
  final List<String> values;

  const _KnobLabel({required this.title, required this.values});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(title, style: typography.main),
        for (final value in values)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s8,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: colors.backgroundAlternative,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(value, style: typography.bodySub),
          ),
      ],
    );
  }
}
