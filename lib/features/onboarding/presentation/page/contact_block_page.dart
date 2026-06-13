import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/home/route/home_routes.dart';
import 'package:wingle/features/onboarding/domain/model/contact_block_contact.dart';
import 'package:wingle/features/onboarding/presentation/models/contact_block_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/contact_block_provider.dart';

/// 온보딩 마지막 연락처 지인 제외 화면.
class ContactBlockPage extends ConsumerWidget {
  /// 생성자.
  const ContactBlockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contactBlockControllerProvider);

    return ConstrainedScrollableScaffold(
      appBar: DefaultAppBar(
        title: 'onboarding.contactBlock.appBarTitle',
        forceImplyLeading: false,
        trailing: _SkipAction(
          isDisabled: state.isBusy,
          onPressed: () => _completeWithoutBlocking(context, ref),
        ),
      ),
      textScalePolicy: TextScalePolicy.cappedLarge,
      floatingActionButton: _ContactBlockActions(
        state: state,
        onLaterPressed: () => _completeWithoutBlocking(context, ref),
        onBlockPressed: () => _openContactSelection(context, ref),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _ContactBlockHeader(),
            SizedBox(height: AppSpacing.s48),
            _ContactBlockImagePlaceholder(),
            SizedBox(height: AppSpacing.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _openContactSelection(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final loaded = await ref
        .read(contactBlockControllerProvider.notifier)
        .loadContacts();
    if (!context.mounted) return;

    if (!loaded) {
      _showCurrentError(context, ref);
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.colors.backgroundNormal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        return _ContactSelectionSheet(
          onComplete: () => context.goNamed(HomeRoutes.root.name),
        );
      },
    );
  }

  Future<void> _completeWithoutBlocking(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final success = await ref
        .read(contactBlockControllerProvider.notifier)
        .completeWithoutBlocking();
    if (!context.mounted) return;

    if (success) {
      context.goNamed(HomeRoutes.root.name);
      return;
    }

    _showCurrentError(context, ref);
  }

  void _showCurrentError(BuildContext context, WidgetRef ref) {
    final errorMessage = ref.read(contactBlockControllerProvider).errorMessage;
    if (errorMessage == null) return;
    DefaultToast.show(context, errorMessage);
  }
}

class _ContactBlockHeader extends StatelessWidget {
  const _ContactBlockHeader();

  @override
  Widget build(BuildContext context) {
    return DefaultPageHeader(
      title: 'onboarding.contactBlock.title',
      subtitle: 'onboarding.contactBlock.subtitle',
      titleStyle: context.typography.display.copyWith(
        color: context.colors.textNormal,
        fontSize: 30,
      ),
      subtitleStyle: context.typography.mainSub.copyWith(
        color: context.colors.textAlternative,
      ),
      padding: const EdgeInsets.only(
        top: AppSpacing.s48,
        bottom: AppSpacing.s8,
      ),
    );
  }
}

class _ContactBlockImagePlaceholder extends StatelessWidget {
  static const double _height = 280;
  static const double _iconSize = 88;

  const _ContactBlockImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Container(
        width: double.infinity,
        height: _height,
        decoration: BoxDecoration(
          color: colors.backgroundAlternative,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Icon(
          Icons.contact_page_outlined,
          size: _iconSize,
          color: colors.textAssistive,
        ),
      ),
    );
  }
}

class _ContactBlockActions extends StatelessWidget {
  final ContactBlockModel state;
  final VoidCallback onLaterPressed;
  final VoidCallback onBlockPressed;

  const _ContactBlockActions({
    required this.state,
    required this.onLaterPressed,
    required this.onBlockPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.scaffold),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultFilledButton(
            label: 'onboarding.contactBlock.later',
            variant: DefaultButtonVariant.fullWidth,
            theme: DefaultFilledButtonTheme.secondary,
            isDisabled: state.isBusy,
            onPressed: onLaterPressed,
          ),
          const SizedBox(height: AppSpacing.s12),
          DefaultFilledButton(
            label: 'onboarding.contactBlock.block',
            variant: DefaultButtonVariant.fullWidth,
            isLoading: state.isLoadingContacts,
            isDisabled: state.isUploading,
            onPressed: onBlockPressed,
          ),
        ],
      ),
    );
  }
}

class _ContactSelectionSheet extends ConsumerWidget {
  final VoidCallback onComplete;

  const _ContactSelectionSheet({required this.onComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contactBlockControllerProvider);
    final colors = context.colors;
    final typography = context.typography;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: FractionallySizedBox(
        heightFactor: 0.86,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppPadding.scaffold,
                AppSpacing.s24,
                AppPadding.scaffold,
                AppSpacing.s12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'onboarding.contactBlock.sheetTitle'.tr(),
                    style: typography.title.copyWith(
                      color: colors.textNormal,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    'onboarding.contactBlock.sheetSubtitle'.tr(),
                    style: typography.body.copyWith(
                      color: colors.textAlternative,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.scaffold,
                  vertical: AppSpacing.s8,
                ),
                itemCount: state.contacts.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.s8),
                itemBuilder: (context, index) {
                  final contact = state.contacts[index];
                  return _ContactSelectionTile(
                    contact: contact,
                    isSelected: state.isSelected(contact.id),
                    onPressed: () {
                      ref
                          .read(contactBlockControllerProvider.notifier)
                          .toggleContact(contact.id);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppPadding.scaffold,
                AppSpacing.s12,
                AppPadding.scaffold,
                AppSpacing.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'onboarding.contactBlock.selectedCount'.tr(
                      namedArgs: {
                        'count': state.selectedContactCount.toString(),
                      },
                    ),
                    style: typography.bodySub.copyWith(
                      color: colors.textAlternative,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  DefaultFilledButton(
                    label: 'onboarding.contactBlock.uploadSelected',
                    variant: DefaultButtonVariant.fullWidth,
                    isLoading: state.isUploading,
                    isDisabled: !state.hasSelectedContacts,
                    onPressed: () => _uploadSelected(context, ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadSelected(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(contactBlockControllerProvider.notifier)
        .uploadSelectedContacts();
    if (!context.mounted) return;

    if (success) {
      Navigator.of(context).pop();
      onComplete();
      return;
    }

    final errorMessage = ref.read(contactBlockControllerProvider).errorMessage;
    if (errorMessage != null) {
      DefaultToast.show(context, errorMessage);
    }
  }
}

class _ContactSelectionTile extends StatelessWidget {
  final ContactBlockContact contact;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ContactSelectionTile({
    required this.contact,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.standard),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return colors.overlayPressed;
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return colors.overlayInactive;
          }
          return null;
        }),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.backgroundNormal,
            borderRadius: BorderRadius.circular(AppRadius.standard),
            border: Border.all(color: colors.strokeStructuralBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.card),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: typography.main.copyWith(
                          color: colors.textNormal,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      Text(
                        contact.phoneNumbers.join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: typography.bodySub.copyWith(
                          color: colors.textAlternative,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: AppIconSize.lg,
                  color: isSelected
                      ? colors.primaryNormal
                      : colors.textAssistive,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkipAction extends StatelessWidget {
  final bool isDisabled;
  final VoidCallback onPressed;

  const _SkipAction({required this.isDisabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colors.textAlternative,
        disabledForegroundColor: colors.textAssistive,
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.xxs),
      ),
      child: Text(
        'onboarding.contactBlock.skip'.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: typography.mainSub.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
