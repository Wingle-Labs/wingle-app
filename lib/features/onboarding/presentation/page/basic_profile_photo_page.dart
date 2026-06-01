import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
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
import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';
import 'package:wingle/features/onboarding/presentation/models/profile_details_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_details_provider.dart';
import 'package:wingle/features/onboarding/presentation/utils/upload_image_compressor.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 기본 프로필 입력 이후 스타일 사진 등록 페이지.
class BasicProfileStylePhotoPage extends ConsumerWidget {
  /// 생성자.
  const BasicProfileStylePhotoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _BasicProfilePhotoPage(type: ProfilePhotoType.style);
  }
}

/// 기본 프로필 입력 이후 얼굴 사진 등록 페이지.
class BasicProfileFacePhotoPage extends ConsumerWidget {
  /// 생성자.
  const BasicProfileFacePhotoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _BasicProfilePhotoPage(type: ProfilePhotoType.face);
  }
}

class _BasicProfilePhotoPage extends ConsumerStatefulWidget {
  final ProfilePhotoType type;

  const _BasicProfilePhotoPage({required this.type});

  @override
  ConsumerState<_BasicProfilePhotoPage> createState() =>
      _BasicProfilePhotoPageState();
}

class _BasicProfilePhotoPageState
    extends ConsumerState<_BasicProfilePhotoPage> {
  final Map<int, Uint8List> _uploadingPreviewBytes = {};

  bool get _hasUploadingPhoto => _uploadingPreviewBytes.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileDetailsProvider);
    final notifier = ref.read(profileDetailsProvider.notifier);
    final config = _ProfilePhotoPageConfig.fromType(widget.type);
    final actionsDisabled = state.isSubmitting || _hasUploadingPhoto;

    void navigatePrevious() {
      OnboardingRouteChain.goPrevious(
        context,
        OnboardingRouteFlow.profileInput,
        config.currentRoute,
      );
    }

    return ConstrainedScrollableScaffold(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        navigatePrevious();
      },
      textScalePolicy: TextScalePolicy.cappedLarge,
      padding: EdgeInsets.zero,
      appBar: DefaultAppBar(
        title: 'onboarding.basicProfile.profilePhoto.appBarTitle',
        forceImplyLeading: true,
        onBackPressed: navigatePrevious,
      ),
      floatingActionButton: DefaultFloatingButton(
        label: 'common.button.next',
        isLoading: state.isSubmitting,
        disabled: actionsDisabled || !config.canContinue(state),
        onPressed: () => _handleNext(notifier, config),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultPageHeader(
              title: config.titleKey,
              subtitle: config.subtitleKey,
              titleStyle: context.typography.title,
              subtitleStyle: context.typography.bodySub,
              subtitleColor: context.colors.textAlternative,
              padding: const EdgeInsets.only(
                top: AppSpacing.s40,
                bottom: AppSpacing.s64,
              ),
            ),
            _PhotoSlotRow(
              photos: config.photos(state),
              uploadingPreviewBytes: _uploadingPreviewBytes,
              actionsDisabled: actionsDisabled,
              primaryIcon: config.primaryIcon,
              primaryLabelKey: config.primaryLabelKey,
              onTap: (slotIndex) => _pickPhoto(notifier, slotIndex),
              onRemove: (slotIndex) =>
                  notifier.removePhoto(type: widget.type, slotIndex: slotIndex),
            ),
            const SizedBox(height: AppSpacing.s56),
            const _PhotoGuideButton(),
            const SizedBox(height: AppSpacing.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _handleNext(
    ProfileDetails notifier,
    _ProfilePhotoPageConfig config,
  ) async {
    final success = switch (widget.type) {
      ProfilePhotoType.style => await notifier.saveStylePhotos(),
      ProfilePhotoType.face => await notifier.saveFacePhotos(),
    };
    if (!mounted) return;

    if (!success) {
      DefaultToast.show(
        context,
        ref.read(profileDetailsProvider).submitErrorMessage ??
            ApiErrorMessages.submitProfileDetailsFailed,
      );
      return;
    }

    final next = OnboardingRouteChain.nextOf(
      OnboardingRouteFlow.profileInput,
      config.currentRoute,
    );
    if (next == null) return;

    context.goNamed(next.name);
  }

  Future<void> _pickPhoto(ProfileDetails notifier, int slotIndex) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );
      if (image == null || !mounted) return;

      final originalBytes = await image.readAsBytes();
      if (!mounted) return;

      _setUploadingPreview(slotIndex, originalBytes);
      final uploadImage = await UploadImageCompressor.compressToWebp(
        bytes: originalBytes,
        originalName: image.name,
        options: FileUploadConstants.profilePhotoCompressionOptions,
      );
      if (!mounted) return;

      final success = await notifier.uploadPhoto(
        type: widget.type,
        slotIndex: slotIndex,
        name: uploadImage.name,
        contentType: uploadImage.contentType,
        bytes: uploadImage.bytes,
      );
      if (!mounted || success) return;

      DefaultToast.show(
        context,
        ref.read(profileDetailsProvider).submitErrorMessage ??
            ApiErrorMessages.uploadFileFailed,
      );
    } catch (error, stackTrace) {
      debugPrint('Failed to pick profile photo: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;

      DefaultToast.show(
        context,
        'onboarding.basicProfile.profilePhoto.pickFailed',
      );
    } finally {
      _clearUploadingPreview(slotIndex);
    }
  }

  void _setUploadingPreview(int slotIndex, Uint8List bytes) {
    setState(() {
      _uploadingPreviewBytes[slotIndex] = bytes;
    });
  }

  void _clearUploadingPreview(int slotIndex) {
    if (!mounted || !_uploadingPreviewBytes.containsKey(slotIndex)) return;

    setState(() {
      _uploadingPreviewBytes.remove(slotIndex);
    });
  }
}

class _PhotoSlotRow extends StatelessWidget {
  static const int _slotCount = 3;

  final List<ProfilePhotoInput> photos;
  final Map<int, Uint8List> uploadingPreviewBytes;
  final bool actionsDisabled;
  final IconData primaryIcon;
  final String primaryLabelKey;
  final ValueChanged<int> onTap;
  final ValueChanged<int> onRemove;

  const _PhotoSlotRow({
    required this.photos,
    required this.uploadingPreviewBytes,
    required this.actionsDisabled,
    required this.primaryIcon,
    required this.primaryLabelKey,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileSize =
            (constraints.maxWidth - AppSpacing.s12 * (_slotCount - 1)) /
            _slotCount;

        return Row(
          children: [
            for (var index = 0; index < _slotCount; index++) ...[
              SizedBox.square(
                dimension: tileSize,
                child: _PhotoSlotTile(
                  photo: index < photos.length ? photos[index] : null,
                  uploadingPreviewBytes: uploadingPreviewBytes[index],
                  actionsDisabled: actionsDisabled,
                  isRequired: index == 0,
                  icon: index == 0 ? primaryIcon : Icons.add_rounded,
                  labelKey: index == 0 ? primaryLabelKey : null,
                  onTap: () => onTap(index),
                  onRemove: index < photos.length
                      ? () => onRemove(index)
                      : null,
                ),
              ),
              if (index != _slotCount - 1)
                const SizedBox(width: AppSpacing.s12),
            ],
          ],
        );
      },
    );
  }
}

class _PhotoSlotTile extends StatelessWidget {
  final ProfilePhotoInput? photo;
  final Uint8List? uploadingPreviewBytes;
  final bool actionsDisabled;
  final bool isRequired;
  final IconData icon;
  final String? labelKey;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const _PhotoSlotTile({
    required this.photo,
    required this.uploadingPreviewBytes,
    required this.actionsDisabled,
    required this.isRequired,
    required this.icon,
    required this.labelKey,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final selectedPhoto = photo;
    final previewBytes = uploadingPreviewBytes ?? selectedPhoto?.previewBytes;
    final isUploading = uploadingPreviewBytes != null;

    return Material(
      color: colors.componentSecondaryFilledButtonEnabled,
      borderRadius: BorderRadius.circular(AppRadius.iosStyle),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: actionsDisabled ? null : onTap,
        splashColor: colors.overlayPressed,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (previewBytes != null)
              Image.memory(previewBytes, fit: BoxFit.cover)
            else
              _PhotoSlotContent(
                icon: icon,
                labelKey: labelKey,
                hasPhoto: selectedPhoto != null,
              ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _DashedRRectBorderPainter(
                    color: colors.textAlternative,
                    radius: AppRadius.iosStyle,
                  ),
                ),
              ),
            ),
            if (isRequired)
              Positioned(
                top: AppSpacing.s12,
                left: AppSpacing.s12,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.primaryNormal,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s8,
                      vertical: AppSpacing.s6,
                    ),
                    child: _ScaledText(
                      text:
                          'onboarding.basicProfile.profilePhoto.requiredBadge',
                      maxWidth: 48,
                      style: typography.caption.copyWith(
                        color: colors.backgroundNormal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            if (isUploading) const _PhotoUploadingOverlay(),
            if (onRemove != null && !isUploading)
              Positioned(
                top: AppSpacing.s8,
                right: AppSpacing.s8,
                child: _PhotoRemoveButton(onPressed: onRemove as VoidCallback),
              ),
          ],
        ),
      ),
    );
  }
}

class _PhotoUploadingOverlay extends StatelessWidget {
  const _PhotoUploadingOverlay();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Positioned.fill(
      child: ColoredBox(
        color: colors.overlayLoading,
        child: Center(
          child: AnimationProgressIndicator(color: colors.staticWhite),
        ),
      ),
    );
  }
}

class _PhotoSlotContent extends StatelessWidget {
  final IconData icon;
  final String? labelKey;
  final bool hasPhoto;

  const _PhotoSlotContent({
    required this.icon,
    required this.labelKey,
    required this.hasPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final resolvedIcon = hasPhoto ? Icons.check_rounded : icon;
    final resolvedColor = hasPhoto ? colors.primaryNormal : colors.textNeutral;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultIcon(
            icon: resolvedIcon,
            size: AppIconSize.xl,
            color: resolvedColor,
          ),
          if (labelKey != null) ...[
            const SizedBox(height: AppSpacing.s12),
            _ScaledText(
              text: labelKey as String,
              maxWidth: 78,
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
          ],
        ],
      ),
    );
  }
}

class _ScaledText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double maxWidth;

  const _ScaledText({
    required this.text,
    required this.style,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: DefaultText(text, style: style),
      ),
    );
  }
}

class _PhotoRemoveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PhotoRemoveButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.backgroundElevatedNormal,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox.square(
          dimension: AppIconTouchSize.sm,
          child: Center(
            child: DefaultIcon(
              icon: Icons.close_rounded,
              size: AppIconSize.xs,
              color: colors.textAlternative,
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoGuideButton extends StatelessWidget {
  const _PhotoGuideButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Material(
      color: colors.componentSecondaryFilledButtonEnabled,
      borderRadius: BorderRadius.circular(AppRadius.iosStyle),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
        onTap: () {
          DefaultToast.show(
            context,
            'onboarding.basicProfile.profilePhoto.guideUnavailable',
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.buttonMediumHorizontal,
            vertical: AppPadding.buttonSmallVertical,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ScaledText(
                text: 'onboarding.basicProfile.profilePhoto.guide',
                maxWidth: 232,
                style: typography.bodySub.copyWith(
                  color: colors.textAlternative,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
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

class _DashedRRectBorderPainter extends CustomPainter {
  static const double _dash = 8;
  static const double _gap = 6;

  final Color color;
  final double radius;

  const _DashedRRectBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = AppLineWidth.outline
      ..style = PaintingStyle.stroke;
    final rect = Offset.zero & size;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + _dash;
        canvas.drawPath(
          metric.extractPath(distance, nextDistance.clamp(0, metric.length)),
          paint,
        );
        distance += _dash + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

class _ProfilePhotoPageConfig {
  final RouteNode currentRoute;
  final String titleKey;
  final String? subtitleKey;
  final IconData primaryIcon;
  final String primaryLabelKey;
  final bool Function(ProfileDetailsModel state) canContinue;
  final List<ProfilePhotoInput> Function(ProfileDetailsModel state) photos;

  const _ProfilePhotoPageConfig({
    required this.currentRoute,
    required this.titleKey,
    required this.subtitleKey,
    required this.primaryIcon,
    required this.primaryLabelKey,
    required this.canContinue,
    required this.photos,
  });

  factory _ProfilePhotoPageConfig.fromType(ProfilePhotoType type) {
    return switch (type) {
      ProfilePhotoType.style => _ProfilePhotoPageConfig(
        currentRoute: OnboardingRoutes.profileStylePhotos,
        titleKey: 'onboarding.basicProfile.profilePhoto.styleTitle',
        subtitleKey: null,
        primaryIcon: Icons.checkroom_outlined,
        primaryLabelKey: 'onboarding.basicProfile.profilePhoto.styleLabel',
        canContinue: (state) => state.canContinueStylePhotos,
        photos: (state) => state.stylePhotos,
      ),
      ProfilePhotoType.face => _ProfilePhotoPageConfig(
        currentRoute: OnboardingRoutes.profileFacePhotos,
        titleKey: 'onboarding.basicProfile.profilePhoto.faceTitle',
        subtitleKey: 'onboarding.basicProfile.profilePhoto.faceSubtitle',
        primaryIcon: Icons.tag_faces_outlined,
        primaryLabelKey: 'onboarding.basicProfile.profilePhoto.faceLabel',
        canContinue: (state) => state.canContinueFacePhotos,
        photos: (state) => state.facePhotos,
      ),
    };
  }
}
