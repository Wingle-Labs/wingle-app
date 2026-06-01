import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wingle/app/config/theme/components/buttons/default_radio.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';
import 'package:wingle/features/onboarding/presentation/components/input/profile_input_search_field.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
import 'package:wingle/features/onboarding/presentation/models/education_profile_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/education_profile_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

enum _EducationInputStage { level, school, email, certification }

/// 기본 프로필 입력의 학교 정보 입력 페이지.
class BasicProfileEducationPage extends ConsumerStatefulWidget {
  /// 생성자.
  const BasicProfileEducationPage({super.key});

  @override
  ConsumerState<BasicProfileEducationPage> createState() =>
      _BasicProfileEducationPageState();
}

class _BasicProfileEducationPageState
    extends ConsumerState<BasicProfileEducationPage> {
  late final TextEditingController _schoolController;
  late final FocusNode _schoolFocusNode;
  _EducationInputStage _stage = _EducationInputStage.level;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(educationProfileProvider);
    _schoolController = TextEditingController(text: initialState.schoolName);
    _schoolFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _schoolFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(educationProfileProvider);
    final notifier = ref.read(educationProfileProvider.notifier);

    ref.listen(educationProfileProvider, (previous, next) {
      if (_schoolFocusNode.hasFocus ||
          _schoolController.text == next.schoolName) {
        return;
      }
      _schoolController.text = next.schoolName;
    });

    void navigateBack() {
      switch (_stage) {
        case _EducationInputStage.level:
          OnboardingRouteChain.goPrevious(
            context,
            OnboardingRouteFlow.profileInput,
            OnboardingRoutes.basicProfileEducation,
          );
          return;
        case _EducationInputStage.school:
          setState(() => _stage = _EducationInputStage.level);
          return;
        case _EducationInputStage.email:
          setState(() => _stage = _EducationInputStage.school);
          return;
        case _EducationInputStage.certification:
          setState(() => _stage = _EducationInputStage.email);
          return;
      }
    }

    final canContinue = _canContinue(state);

    return BasicProfileInputScaffold(
      currentStep: BasicProfileInputConstants.educationStep,
      totalSteps: BasicProfileInputConstants.totalSteps,
      title: _titleKey,
      subtitle: _subtitleKey,
      buttonLabel: 'common.button.next',
      isLoading: state.isSubmitting,
      disabled: state.isSubmitting || !canContinue,
      canPop: false,
      forceBackButton: true,
      appBarTrailing:
          _stage == _EducationInputStage.email ||
              _stage == _EducationInputStage.certification
          ? _SkipAction(onTap: _navigateToProfileDetails)
          : null,
      onBackPressed: navigateBack,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        navigateBack();
      },
      onPressed: () => _handlePressed(context, state, notifier),
      child: switch (_stage) {
        _EducationInputStage.level => _EducationLevelSection(
          selectedLevel: state.educationLevel,
          onSelected: notifier.selectEducationLevel,
        ),
        _EducationInputStage.school => _SchoolNameSection(
          controller: _schoolController,
          focusNode: _schoolFocusNode,
          showClearButton: _schoolController.text.isNotEmpty,
          onChanged: notifier.updateSchoolName,
          onClear: () {
            _schoolController.clear();
            notifier.updateSchoolName('');
          },
        ),
        _EducationInputStage.email => _SchoolEmailSection(
          state: state,
          onEmailChanged: notifier.updateEmail,
          onCodeChanged: notifier.updateVerificationCode,
          onGuideTap: () {
            notifier.clearCertificationFile();
            setState(() => _stage = _EducationInputStage.certification);
          },
        ),
        _EducationInputStage.certification => _CertificationUploadSection(
          state: state,
          onTap: () => _pickCertificationImage(context, notifier),
          onClear: notifier.clearCertificationFile,
        ),
      },
    );
  }

  String get _titleKey {
    return switch (_stage) {
      _EducationInputStage.level =>
        'onboarding.basicProfile.education.levelTitle',
      _EducationInputStage.school =>
        'onboarding.basicProfile.education.schoolTitle',
      _EducationInputStage.email =>
        'onboarding.basicProfile.educationEmail.title',
      _EducationInputStage.certification =>
        'onboarding.basicProfile.educationCertification.title',
    };
  }

  String? get _subtitleKey {
    return switch (_stage) {
      _EducationInputStage.level =>
        'onboarding.basicProfile.education.levelSubtitle',
      _EducationInputStage.school =>
        'onboarding.basicProfile.education.schoolSubtitle',
      _EducationInputStage.email =>
        'onboarding.basicProfile.educationEmail.subtitle',
      _EducationInputStage.certification =>
        'onboarding.basicProfile.educationCertification.subtitle',
    };
  }

  bool _canContinue(EducationProfileModel state) {
    return switch (_stage) {
      _EducationInputStage.level => state.canContinueEducationLevel,
      _EducationInputStage.school => state.canContinueSchool,
      _EducationInputStage.email =>
        state.isVerificationCodeSent
            ? state.canConfirmVerificationCode
            : state.canSendVerificationEmail,
      _EducationInputStage.certification => state.canSubmitCertification,
    };
  }

  Future<void> _handlePressed(
    BuildContext context,
    EducationProfileModel state,
    EducationProfile notifier,
  ) async {
    switch (_stage) {
      case _EducationInputStage.level:
        if (state.educationLevel?.skipsSchoolName ?? false) {
          await _submitAndNavigate(context, notifier, skipVerification: true);
          return;
        }
        setState(() => _stage = _EducationInputStage.school);
        return;
      case _EducationInputStage.school:
        await _submitAndNavigate(context, notifier);
        return;
      case _EducationInputStage.email:
        final wasVerificationCodeSent = state.isVerificationCodeSent;
        final success = wasVerificationCodeSent
            ? await notifier.confirmVerificationCode()
            : await notifier.sendVerificationEmail();
        if (!context.mounted) return;

        if (success && wasVerificationCodeSent) {
          _navigateToProfileDetails();
          return;
        }

        if (success) {
          DefaultToast.show(
            context,
            'onboarding.basicProfile.educationEmail.codeSent',
          );
          return;
        }

        final latestState = ref.read(educationProfileProvider);
        DefaultToast.show(
          context,
          latestState.verificationCodeErrorMessage ??
              latestState.emailVerificationErrorMessage ??
              ApiErrorMessages.verifyEducationEmailFailed,
        );
        return;
      case _EducationInputStage.certification:
        final success = await notifier.submitCertification();
        if (!context.mounted) return;

        if (success) {
          _navigateToProfileDetails();
          return;
        }

        DefaultToast.show(
          context,
          ref.read(educationProfileProvider).certificationErrorMessage ??
              ApiErrorMessages.submitEducationCertificationFailed,
        );
        return;
    }
  }

  Future<void> _submitAndNavigate(
    BuildContext context,
    EducationProfile notifier, {
    bool skipVerification = false,
  }) async {
    final success = await notifier.submitEducation();
    if (!context.mounted) return;

    if (!success) {
      DefaultToast.show(
        context,
        ref.read(educationProfileProvider).submitErrorMessage ??
            ApiErrorMessages.submitEducationFailed,
      );
      return;
    }

    final latestState = ref.read(educationProfileProvider);
    if (skipVerification ||
        (latestState.educationLevel?.skipsEducationVerification ?? false)) {
      _navigateToProfileDetails();
      return;
    }

    setState(() => _stage = _EducationInputStage.email);
  }

  void _navigateToProfileDetails() {
    context.pushNamed(OnboardingRoutes.profileDetails.name);
  }

  Future<void> _pickCertificationImage(
    BuildContext context,
    EducationProfile notifier,
  ) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );
      if (image == null || !context.mounted) return;

      final contentType = _resolveImageContentType(
        fileName: image.name,
        mimeType: image.mimeType,
      );
      final bytes = await image.readAsBytes();
      if (!context.mounted) return;

      final success = notifier.selectCertificationFile(
        name: image.name,
        contentType: contentType,
        bytes: bytes,
      );

      if (!success) {
        DefaultToast.show(
          context,
          'onboarding.basicProfile.educationCertification.unsupportedFile',
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Failed to pick education certification image: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!context.mounted) return;
      DefaultToast.show(
        context,
        'onboarding.basicProfile.educationCertification.pickFailed',
      );
    }
  }

  String _resolveImageContentType({
    required String fileName,
    String? mimeType,
  }) {
    final normalizedMimeType = mimeType?.trim().toLowerCase();
    if (normalizedMimeType != null &&
        FileUploadConstants.supportedImageContentTypes.contains(
          normalizedMimeType,
        )) {
      return normalizedMimeType;
    }

    final extension = fileName.split('.').last.toLowerCase();
    return switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => '',
    };
  }
}

class _EducationLevelSection extends StatelessWidget {
  final EducationLevel? selectedLevel;
  final ValueChanged<EducationLevel> onSelected;

  const _EducationLevelSection({
    required this.selectedLevel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.selectionButtonGap,
      children: [
        for (final level in EducationLevel.values)
          _EducationLevelTile(
            labelKey: level.labelKey,
            selected: selectedLevel == level,
            onTap: () => onSelected(level),
          ),
      ],
    );
  }
}

class _EducationLevelTile extends StatelessWidget {
  final String labelKey;
  final bool selected;
  final VoidCallback onTap;

  const _EducationLevelTile({
    required this.labelKey,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final backgroundColor = selected
        ? colors.componentSecondaryFilledButtonEnabled
        : colors.componentSelectionButtonBackground;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.iosStyle),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppContainerSize.selectionButtonHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.selectionButtonHorizontal,
              vertical: AppPadding.selectionButtonVertical,
            ),
            child: Row(
              children: [
                DefaultRadio(isSelected: selected, onChanged: (_) => onTap()),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: DefaultText(
                    labelKey,
                    style: typography.buttonMedium.copyWith(
                      color: selected
                          ? colors.textNormal
                          : colors.textAlternative,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SchoolNameSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showClearButton;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SchoolNameSection({
    required this.controller,
    required this.focusNode,
    required this.showClearButton,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileInputSearchField(
      hintText: 'onboarding.basicProfile.education.schoolHint',
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      showClearButton: showClearButton,
      onClear: onClear,
    );
  }
}

class _SchoolEmailSection extends StatelessWidget {
  final EducationProfileModel state;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onCodeChanged;
  final VoidCallback onGuideTap;

  const _SchoolEmailSection({
    required this.state,
    required this.onEmailChanged,
    required this.onCodeChanged,
    required this.onGuideTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultInputField(
          labelText: 'onboarding.basicProfile.educationEmail.emailLabel',
          hintText: 'onboarding.basicProfile.educationEmail.emailHint',
          assistiveText:
              'onboarding.basicProfile.educationEmail.emailAssistive',
          initialValue: state.email,
          keyboardType: TextInputType.emailAddress,
          onChanged: onEmailChanged,
          errorText: state.emailVerificationErrorMessage,
        ),
        if (state.isVerificationCodeSent) ...[
          const SizedBox(height: AppSpacing.s20),
          DefaultInputField(
            labelText: 'onboarding.basicProfile.educationEmail.codeLabel',
            hintText: 'onboarding.basicProfile.educationEmail.codeHint',
            initialValue: state.verificationCode,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onCodeChanged,
            errorText: state.verificationCodeErrorMessage,
          ),
        ],
        const SizedBox(height: AppSpacing.s64),
        _CertificationGuideAction(onTap: onGuideTap),
      ],
    );
  }
}

class _CertificationGuideAction extends StatelessWidget {
  final VoidCallback onTap;

  const _CertificationGuideAction({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s8,
            vertical: AppSpacing.s4,
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.s8,
            children: [
              DefaultText(
                'onboarding.basicProfile.educationEmail.certificationGuide',
                style: typography.bodySub.copyWith(
                  color: colors.textAlternative,
                  fontWeight: FontWeight.w700,
                ),
              ),
              DefaultIcon(
                icon: Icons.chevron_right_rounded,
                size: AppIconSize.md,
                color: colors.textAlternative,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CertificationUploadSection extends StatelessWidget {
  final EducationProfileModel state;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _CertificationUploadSection({
    required this.state,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CertificationUploadTile(
          file: state.certificationFile,
          onTap: onTap,
          onClear: onClear,
        ),
        const SizedBox(height: AppSpacing.s16),
        DefaultText(
          'onboarding.basicProfile.educationCertification.notice',
          style: context.typography.bodySub.copyWith(
            color: context.colors.textAlternative,
          ),
        ),
        if (state.certificationErrorMessage != null) ...[
          const SizedBox(height: AppSpacing.s12),
          DefaultText(
            state.certificationErrorMessage!,
            style: context.typography.bodySub.copyWith(
              color: context.colors.statusNegative,
            ),
          ),
        ],
      ],
    );
  }
}

class _CertificationUploadTile extends StatelessWidget {
  final EducationCertificationFile? file;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _CertificationUploadTile({
    required this.file,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final selectedFile = file;

    return Material(
      color: colors.backgroundNormal,
      borderRadius: BorderRadius.circular(AppRadius.iosStyle),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: AppContainerSize.xl),
          padding: const EdgeInsets.all(AppSpacing.s20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.iosStyle),
            border: Border.all(
              color: selectedFile == null
                  ? colors.strokeStructuralBorder
                  : colors.primaryNormal,
              width: AppLineWidth.outline,
            ),
          ),
          child: selectedFile == null
              ? _EmptyCertificationContent(
                  foregroundColor: colors.textAlternative,
                  titleStyle: typography.buttonMedium.copyWith(
                    color: colors.textNormal,
                  ),
                  descriptionStyle: typography.bodySub.copyWith(
                    color: colors.textAlternative,
                  ),
                )
              : _SelectedCertificationContent(
                  file: selectedFile,
                  onClear: onClear,
                ),
        ),
      ),
    );
  }
}

class _EmptyCertificationContent extends StatelessWidget {
  final Color foregroundColor;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;

  const _EmptyCertificationContent({
    required this.foregroundColor,
    required this.titleStyle,
    required this.descriptionStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DefaultIcon(
          icon: Icons.upload_file_rounded,
          size: AppIconSize.xl,
          color: foregroundColor,
        ),
        const SizedBox(height: AppSpacing.s12),
        DefaultText(
          'onboarding.basicProfile.educationCertification.uploadLabel',
          style: titleStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.s6),
        DefaultText(
          'onboarding.basicProfile.educationCertification.uploadAssistive',
          style: descriptionStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SelectedCertificationContent extends StatelessWidget {
  final EducationCertificationFile file;
  final VoidCallback onClear;

  const _SelectedCertificationContent({
    required this.file,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Image.memory(
            Uint8List.fromList(file.bytes),
            width: AppContainerSize.large,
            height: AppContainerSize.large,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                file.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typography.buttonMedium.copyWith(
                  color: colors.textNormal,
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              DefaultText(
                'onboarding.basicProfile.educationCertification.changeLabel',
                style: typography.bodySub.copyWith(
                  color: colors.textAlternative,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s8),
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          onTap: onClear,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: DefaultIcon(
              icon: Icons.close_rounded,
              size: AppIconSize.md,
              color: colors.textAlternative,
            ),
          ),
        ),
      ],
    );
  }
}

class _SkipAction extends StatelessWidget {
  final VoidCallback onTap;

  const _SkipAction({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s8,
          vertical: AppSpacing.s4,
        ),
        child: DefaultText(
          'onboarding.button.skip',
          style: context.typography.body.copyWith(
            color: context.colors.textAlternative,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
