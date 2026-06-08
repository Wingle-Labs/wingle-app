import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
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
      floatingActionButton: DefaultFilledButton(
        label: 'common.button.reapply',
        variant: .fullWidth,
        isLoading: isSubmitting,
        isDisabled: currentState == null || isSubmitting,
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
        if (groups.isEmpty)
          SizedBox(
            width: double.infinity,
            child: DefaultCard(
              child: DefaultText(
                'onboarding.profileRejected.emptyReason',
                style: typography.bodySub,
                color: colors.textNormal,
              ),
            ),
          )
        else
          for (final group in groups) ...[
            _RejectionReasonGroupCard(group: group, onEdit: onEdit),
            const SizedBox(height: AppSpacing.s16),
          ],
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
}

class _RejectionReasonGroupCard extends StatelessWidget {
  final _RejectionReasonGroup group;
  final ValueChanged<RouteNode> onEdit;

  const _RejectionReasonGroupCard({required this.group, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return SizedBox(
      width: double.infinity,
      child: DefaultCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (group.categoryDisplayName.isEmpty)
              DefaultText(
                'onboarding.profileRejected.defaultCategory',
                style: typography.subtitle,
                color: colors.textStrong,
              )
            else
              DefaultText(
                group.categoryDisplayName,
                style: typography.subtitle,
                color: colors.textStrong,
                isTranslationKey: false,
              ),
            const SizedBox(height: AppSpacing.s16),
            for (final item in group.items)
              if (item.description.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                  child: DefaultText(
                    item.description.trim(),
                    style: typography.bodySub,
                    color: colors.textNormal,
                    isTranslationKey: false,
                  ),
                ),
            const SizedBox(height: AppSpacing.s8),
            _RejectionEditChip(onPressed: () => onEdit(_routeForGroup(group))),
          ],
        ),
      ),
    );
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

class _RejectionEditChip extends StatelessWidget {
  final VoidCallback onPressed;

  const _RejectionEditChip({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final borderRadius = BorderRadius.circular(AppRadius.md);

    return Material(
      color: colors.componentTertiaryFilledButtonEnabled,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return colors.overlayPressed;
          }
          return null;
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.buttonMediumHorizontal,
            vertical: AppPadding.buttonSmallVertical,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'common.button.edit'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typography.buttonMedium.copyWith(
                    color: colors.textNormal,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s6),
              Icon(
                Icons.chevron_right_rounded,
                size: AppIconSize.xs,
                color: colors.textNormal,
              ),
            ],
          ),
        ),
      ),
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
