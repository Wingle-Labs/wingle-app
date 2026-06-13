import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/states/default_bottom_sheet.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/router/route_node.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/domain/model/profile/rejection_reason.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_rejection_provider.dart';
import 'package:wingle/features/onboarding/presentation/utils/onboarding_rejection_edit_mode.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 프로필 심사 거절 사유 및 재심사 요청 화면.
class ProfileRejectedPage extends ConsumerWidget {
  /// 생성자.
  const ProfileRejectedPage({super.key});

  static const double _bottomReservedSpacing =
      AppSpacing.bottom + AppSpacing.s64;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rejectionState = ref.watch(profileRejectionControllerProvider);
    final currentState = _asyncDataOrNull(rejectionState);
    final isSubmitting = currentState?.isSubmitting ?? false;

    return ConstrainedScrollableScaffold(
      canPop: false,
      textScalePolicy: TextScalePolicy.cappedLarge,
      appBar: const DefaultAppBar(
        title: 'onboarding.profileRejected.appBarTitle',
        forceImplyLeading: false,
      ),
      floatingActionButton: DefaultFloatingButton(
        label: 'onboarding.profileRejected.reapplyButton',
        isLoading: isSubmitting,
        disabled: currentState == null || isSubmitting,
        onPressed: () => _showReapplyConfirmation(context, ref),
      ),
      child: rejectionState.when(
        loading: () => const _ProfileRejectedLoading(),
        error: (_, _) => _ProfileRejectedError(
          onRetry: () => ref.invalidate(profileRejectionControllerProvider),
        ),
        data: (state) => _ProfileRejectedContent(
          state: state,
          onEdit: (route) => goOnboardingRejectionEditRoute(context, route),
        ),
      ),
    );
  }

  void _showReapplyConfirmation(BuildContext context, WidgetRef ref) {
    DefaultBottomSheet.show<void>(
      context,
      isHandleContained: true,
      body: DefaultPageHeader(
        title: 'onboarding.profileRejected.confirmTitle',
        subtitle: 'onboarding.profileRejected.confirmSubtitle',
        padding: EdgeInsets.zero,
        subtitleStyle: context.typography.bodySub,
        subtitleColor: context.colors.textAlternative,
      ),
      mainLabel: 'common.button.request',
      onMain: () {
        context.pop();
        unawaited(_requestReapply(context, ref));
      },
      subLabel: 'common.button.cancel',
      onSub: context.pop,
    );
  }

  Future<void> _requestReapply(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(profileRejectionControllerProvider.notifier)
        .requestReapply();
    if (!context.mounted) return;

    if (success) {
      context.goNamed(OnboardingRoutes.approvalPending.name);
      ref.invalidate(profileRejectionControllerProvider);
      return;
    }

    DefaultToast.show(
      context,
      _asyncDataOrNull(
            ref.read(profileRejectionControllerProvider),
          )?.submitErrorMessage ??
          ApiErrorMessages.requestProfileReapplyFailed,
    );
  }
}

class _ProfileRejectedLoading extends StatelessWidget {
  const _ProfileRejectedLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 360,
      child: Center(child: AnimationProgressIndicator()),
    );
  }
}

class _ProfileRejectedError extends StatelessWidget {
  final VoidCallback onRetry;

  const _ProfileRejectedError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultPageHeader(
          title: 'onboarding.profileRejected.title',
          subtitle: 'onboarding.profileRejected.subtitle',
          titleStyle: typography.title,
          subtitleStyle: typography.bodySub,
          subtitleColor: colors.textAlternative,
          padding: const EdgeInsets.only(
            top: AppSpacing.s40,
            bottom: AppSpacing.s32,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: DefaultCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultText(
                  ApiErrorMessages.fetchRejectionReasonFailed,
                  style: typography.bodySub,
                  color: colors.textNormal,
                ),
                const SizedBox(height: AppSpacing.s16),
                DefaultTextButton(
                  label: 'common.button.retry',
                  variant: .sm,
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: ProfileRejectedPage._bottomReservedSpacing),
      ],
    );
  }
}

class _ProfileRejectedContent extends StatelessWidget {
  final ProfileRejectionState state;
  final ValueChanged<RouteNode> onEdit;

  const _ProfileRejectedContent({required this.state, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final groups = _groupReasons(state.rejectionReason.reasons);
    final reviewedAtText = _formatReviewedAt(state.rejectionReason.reviewedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultPageHeader(
          title: 'onboarding.profileRejected.summaryTitle',
          subtitle: 'onboarding.profileRejected.summarySubtitle',
          titleStyle: typography.title,
          subtitleStyle: typography.bodySub,
          subtitleColor: colors.textAlternative,
          padding: const EdgeInsets.only(
            top: AppSpacing.s40,
            bottom: AppSpacing.s24,
          ),
        ),
        _ReviewSummaryPanel(
          reasonCount: state.rejectionReason.reasons.length,
          reviewedAtText: reviewedAtText,
        ),
        const SizedBox(height: AppSpacing.s32),
        DefaultText(
          'onboarding.profileRejected.reasonSectionTitle',
          style: typography.subtitle,
          color: colors.textStrong,
        ),
        const SizedBox(height: AppSpacing.s12),
        if (groups.isEmpty)
          const _EmptyReasonPanel()
        else
          _RejectionReasonList(groups: groups, onEdit: onEdit),
        const SizedBox(height: ProfileRejectedPage._bottomReservedSpacing),
      ],
    );
  }

  List<_RejectionReasonGroup> _groupReasons(List<RejectionReasonItem> reasons) {
    final grouped = <String, List<RejectionReasonItem>>{};
    for (final reason in reasons) {
      final category = reason.categoryDisplayName.trim();
      grouped.putIfAbsent(category, () => <RejectionReasonItem>[]).add(reason);
    }

    return grouped.entries
        .map(
          (entry) => _RejectionReasonGroup(
            categoryDisplayName: entry.key,
            items: List<RejectionReasonItem>.unmodifiable(entry.value),
          ),
        )
        .toList(growable: false);
  }

  String? _formatReviewedAt(String reviewedAt) {
    final parsed = DateTime.tryParse(reviewedAt);
    if (parsed == null) return null;

    final local = parsed.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}.$month.$day';
  }
}

class _ReviewSummaryPanel extends StatelessWidget {
  final int reasonCount;
  final String? reviewedAtText;

  const _ReviewSummaryPanel({
    required this.reasonCount,
    required this.reviewedAtText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.backgroundElevatedNormal,
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
        border: Border.all(color: colors.strokeStructuralBorder),
      ),
      padding: const EdgeInsets.all(AppPadding.infoCard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ReviewStatusBadge(),
          const SizedBox(height: AppSpacing.s16),
          DefaultText(
            'onboarding.profileRejected.title',
            style: typography.subtitle,
            color: colors.textStrong,
          ),
          const SizedBox(height: AppSpacing.s8),
          DefaultText(
            'onboarding.profileRejected.subtitle',
            style: typography.bodySub,
            color: colors.textAlternative,
          ),
          const SizedBox(height: AppSpacing.s16),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              _SummaryMetaChip(
                icon: Icons.fact_check_outlined,
                label: 'onboarding.profileRejected.reasonCount'.tr(
                  namedArgs: {'count': reasonCount.toString()},
                ),
              ),
              if (reviewedAtText != null)
                _SummaryMetaChip(
                  icon: Icons.schedule_rounded,
                  label: 'onboarding.profileRejected.reviewedAt'.tr(
                    namedArgs: {'date': reviewedAtText!},
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewStatusBadge extends StatelessWidget {
  const _ReviewStatusBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.componentTertiaryFilledButtonEnabled,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.buttonSmallHorizontal,
          vertical: AppSpacing.s6,
        ),
        child: DefaultText(
          'onboarding.profileRejected.statusBadge',
          style: typography.buttonMedium,
          color: colors.primaryNormal,
        ),
      ),
    );
  }
}

class _SummaryMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SummaryMetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.backgroundAlternative,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.buttonChipHorizontal,
          vertical: AppPadding.chipButtonVertical,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppIconSize.xxs, color: colors.textAlternative),
            const SizedBox(width: AppSpacing.s4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typography.bodySub.copyWith(color: colors.textNeutral),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyReasonPanel extends StatelessWidget {
  const _EmptyReasonPanel();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.backgroundElevatedNormal,
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
        border: Border.all(color: colors.strokeStructuralBorder),
      ),
      padding: const EdgeInsets.all(AppPadding.infoCard),
      child: DefaultText(
        'onboarding.profileRejected.emptyReason',
        style: typography.bodySub,
        color: colors.textNormal,
      ),
    );
  }
}

class _RejectionReasonList extends StatelessWidget {
  final List<_RejectionReasonGroup> groups;
  final ValueChanged<RouteNode> onEdit;

  const _RejectionReasonList({required this.groups, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.backgroundElevatedNormal,
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
        border: Border.all(color: colors.strokeStructuralBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < groups.length; index++) ...[
            _RejectionReasonRow(
              group: groups[index],
              index: index,
              onEdit: onEdit,
            ),
            if (index != groups.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: colors.strokeStructuralDivider,
              ),
          ],
        ],
      ),
    );
  }
}

class _RejectionReasonRow extends StatelessWidget {
  final _RejectionReasonGroup group;
  final int index;
  final ValueChanged<RouteNode> onEdit;

  const _RejectionReasonRow({
    required this.group,
    required this.index,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final categoryTitle = _categoryTitle(group.categoryDisplayName);
    final descriptions = group.items
        .map((item) => item.description.trim())
        .where((description) => description.isNotEmpty)
        .toList(growable: false);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onEdit(_routeForGroup(group)),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return colors.overlayPressed;
          }
          return null;
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.infoCard,
            vertical: AppSpacing.s20,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReasonIndexBadge(number: index + 1),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: typography.subtitle.copyWith(
                        color: colors.textStrong,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.textVerticalInternal),
                    if (descriptions.isEmpty)
                      DefaultText(
                        'onboarding.profileRejected.emptyDescription',
                        style: typography.bodySub,
                        color: colors.textAlternative,
                      )
                    else
                      for (final description in descriptions) ...[
                        _ReasonDescription(text: description),
                        if (description != descriptions.last)
                          const SizedBox(height: AppSpacing.s8),
                      ],
                    const SizedBox(height: AppSpacing.s16),
                    const _InlineEditLabel(),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Icon(
                Icons.chevron_right_rounded,
                size: AppIconSize.sm,
                color: colors.textAssistive,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryTitle(String displayName) {
    final trimmed = displayName.trim();
    if (trimmed.isNotEmpty) return trimmed;
    return 'onboarding.profileRejected.defaultCategory'.tr();
  }

  RouteNode _routeForGroup(_RejectionReasonGroup group) {
    for (final item in group.items) {
      final route = _routeForReasonCode(item.code);
      if (route != OnboardingRoutes.profileDetails) {
        return route;
      }
    }

    return OnboardingRoutes.profileDetails;
  }

  RouteNode _routeForReasonCode(String code) {
    final normalizedCode = code.trim().toUpperCase();
    if (normalizedCode == 'JOB_INFO_MISMATCH') {
      return OnboardingRoutes.basicProfileCompany;
    }
    if (normalizedCode == 'EDUCATION_INFO_MISMATCH' ||
        normalizedCode.startsWith('CERTIFICATION_')) {
      return OnboardingRoutes.basicProfileEducation;
    }
    if (normalizedCode.startsWith('SELF_INTRO_')) {
      return OnboardingRoutes.profileSelfIntroduction;
    }
    if (normalizedCode.startsWith('STYLE_PHOTO_')) {
      return OnboardingRoutes.profileStylePhotos;
    }
    if (normalizedCode.startsWith('FACE_PHOTO_')) {
      return OnboardingRoutes.profileFacePhotos;
    }

    return OnboardingRoutes.profileDetails;
  }
}

class _ReasonIndexBadge extends StatelessWidget {
  final int number;

  const _ReasonIndexBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      width: AppContainerSize.buttonChipHeight,
      height: AppContainerSize.buttonChipHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.componentTertiaryFilledButtonEnabled,
        shape: BoxShape.circle,
      ),
      child: Text(
        number.toString(),
        style: typography.buttonMedium.copyWith(color: colors.primaryNormal),
      ),
    );
  }
}

class _ReasonDescription extends StatelessWidget {
  final String text;

  const _ReasonDescription({required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.textAssistive,
              shape: BoxShape.circle,
            ),
            child: const SizedBox.square(dimension: AppSpacing.s4),
          ),
        ),
        const SizedBox(width: AppSpacing.s8),
        Expanded(
          child: Text(
            text,
            style: typography.bodySub.copyWith(color: colors.textNormal),
          ),
        ),
      ],
    );
  }
}

class _InlineEditLabel extends StatelessWidget {
  const _InlineEditLabel();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            'common.button.edit'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: typography.buttonMedium.copyWith(
              color: colors.primaryNormal,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s4),
        Icon(
          Icons.arrow_forward_rounded,
          size: AppIconSize.xxs,
          color: colors.primaryNormal,
        ),
      ],
    );
  }
}

class _RejectionReasonGroup {
  final String categoryDisplayName;
  final List<RejectionReasonItem> items;

  const _RejectionReasonGroup({
    required this.categoryDisplayName,
    required this.items,
  });
}

T? _asyncDataOrNull<T>(AsyncValue<T> value) {
  return switch (value) {
    AsyncData(value: final data) => data,
    _ => null,
  };
}
