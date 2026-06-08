import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:wingle/features/onboarding/presentation/providers/profile_photo_picker_provider.dart';
import 'package:wingle/features/onboarding/presentation/utils/onboarding_rejection_edit_mode.dart';
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
  final List<_PhotoSlotEntry> _slotEntries = [];
  int _nextSlotEntryId = 0;

  bool get _hasUploadingPhoto => _slotEntries.any((entry) => entry.isUploading);

  List<ProfilePhotoInput> get _uploadedPhotos => _slotEntries
      .map((entry) => entry.photo ?? entry.previousPhoto)
      .whereType<ProfilePhotoInput>()
      .toList(growable: false);

  List<ProfilePhotoInput> get _persistablePhotos {
    final photos = <ProfilePhotoInput>[];
    for (final entry in _slotEntries) {
      final photo = entry.photo ?? entry.previousPhoto;
      if (photo != null) {
        photos.add(photo);
        continue;
      }

      if (entry.isUploading && photos.isEmpty) {
        return const <ProfilePhotoInput>[];
      }
    }

    return List<ProfilePhotoInput>.unmodifiable(photos);
  }

  bool get _canContinue => !_hasUploadingPhoto && _uploadedPhotos.isNotEmpty;

  @override
  void initState() {
    super.initState();
    final config = _ProfilePhotoPageConfig.fromType(widget.type);
    final photos = config.photos(ref.read(profileDetailsProvider));
    _appendUploadedPhotoEntries(photos);

    if (photos.isEmpty) {
      unawaited(_syncInitialPhotosFromServer());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileDetailsProvider);
    final notifier = ref.read(profileDetailsProvider.notifier);
    final config = _ProfilePhotoPageConfig.fromType(widget.type);
    final actionsDisabled = state.isSubmitting;
    final isRejectionEditMode = isOnboardingRejectionEditMode();

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
        label: isRejectionEditMode
            ? 'common.button.saveEdit'
            : 'common.button.next',
        isLoading: state.isSubmitting,
        disabled: actionsDisabled || !_canContinue,
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
              entries: _slotEntries,
              actionsDisabled: actionsDisabled,
              primaryIcon: config.primaryIcon,
              primaryLabelKey: config.primaryLabelKey,
              onTap: (slotIndex) => _pickPhotos(notifier, slotIndex),
              onRemove: (slotIndex) => _removePhoto(notifier, slotIndex),
              onReorder: (fromIndex, toIndex) =>
                  _reorderPhoto(notifier, fromIndex, toIndex),
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
    if (_hasUploadingPhoto || _uploadedPhotos.isEmpty) return;

    final committed = await _commitUploadedPhotos(notifier);
    if (!mounted) return;

    if (!committed) {
      DefaultToast.show(
        context,
        ref.read(profileDetailsProvider).submitErrorMessage ??
            ApiErrorMessages.submitProfileDetailsFailed,
      );
      return;
    }

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

    if (isOnboardingRejectionEditMode()) {
      final submitted = await notifier.submitProfileDetails(forceUpdate: true);
      if (!mounted) return;

      if (!submitted) {
        DefaultToast.show(
          context,
          ref.read(profileDetailsProvider).submitErrorMessage ??
              ApiErrorMessages.submitProfileDetailsFailed,
        );
        return;
      }

      goRejectedReviewOrNamed(context, OnboardingRoutes.profileRejected.name);
      return;
    }

    final next = OnboardingRouteChain.nextOf(
      OnboardingRouteFlow.profileInput,
      config.currentRoute,
    );
    if (next == null) return;

    goRejectedReviewOrNamed(context, next.name);
  }

  Future<void> _pickPhotos(ProfileDetails notifier, int slotIndex) async {
    final targetSlotIndices = _targetSlotIndicesFrom(slotIndex);
    if (targetSlotIndices.isEmpty) return;

    try {
      final pickedImages = await ref.read(profilePhotoPickerProvider)(
        targetSlotIndices.length,
      );
      if (pickedImages.isEmpty || !mounted) return;

      final selectedImages = pickedImages
          .take(targetSlotIndices.length)
          .toList(growable: false);
      for (var index = 0; index < selectedImages.length; index++) {
        await _startPickedPhotoUpload(
          notifier: notifier,
          slotIndex: targetSlotIndices[index],
          image: selectedImages[index],
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Failed to pick profile photos: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;

      DefaultToast.show(
        context,
        'onboarding.basicProfile.profilePhoto.pickFailed',
      );
    }
  }

  List<int> _targetSlotIndicesFrom(int slotIndex) {
    final startIndex = slotIndex < _slotEntries.length
        ? slotIndex
        : _slotEntries.length;
    final targetSlotIndices = <int>[];

    for (var index = startIndex; index < _PhotoSlotRow.slotCount; index += 1) {
      final isUploading = index < _slotEntries.length
          ? _slotEntries[index].isUploading
          : false;
      if (!isUploading) {
        targetSlotIndices.add(index);
      }
    }

    return List<int>.unmodifiable(targetSlotIndices);
  }

  Future<void> _startPickedPhotoUpload({
    required ProfileDetails notifier,
    required int slotIndex,
    required XFile image,
  }) async {
    late final Uint8List originalBytes;
    try {
      originalBytes = await image.readAsBytes();
    } catch (error, stackTrace) {
      debugPrint('Failed to read profile photo: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;

      DefaultToast.show(
        context,
        'onboarding.basicProfile.profilePhoto.pickFailed',
      );
      return;
    }
    if (!mounted) return;

    final uploadingEntryId = _startUploadingPhoto(slotIndex, originalBytes);
    unawaited(
      _uploadPreparedPhoto(
        notifier: notifier,
        entryId: uploadingEntryId,
        image: image,
        originalBytes: originalBytes,
      ),
    );
  }

  Future<void> _uploadPreparedPhoto({
    required ProfileDetails notifier,
    required int entryId,
    required XFile image,
    required Uint8List originalBytes,
  }) async {
    try {
      final uploadImage = await UploadImageCompressor.compressToWebp(
        bytes: originalBytes,
        originalName: image.name,
        options: FileUploadConstants.profilePhotoCompressionOptions,
        compressor: ref.read(profilePhotoUploadImageCompressorProvider),
      );
      if (!mounted) return;

      final uploadedPhoto = await notifier.uploadPhotoFile(
        type: widget.type,
        name: uploadImage.name,
        contentType: uploadImage.contentType,
        bytes: uploadImage.bytes,
      );
      if (!mounted) return;

      if (uploadedPhoto != null) {
        _finishUploadingPhoto(entryId, uploadedPhoto);
        unawaited(_commitUploadedPhotos(notifier));
        return;
      }

      _restoreUploadingPhoto(entryId);

      DefaultToast.show(
        context,
        ref.read(profileDetailsProvider).submitErrorMessage ??
            ApiErrorMessages.uploadFileFailed,
      );
    } catch (error, stackTrace) {
      debugPrint('Failed to upload prepared profile photo: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;

      _restoreUploadingPhoto(entryId);

      DefaultToast.show(
        context,
        'onboarding.basicProfile.profilePhoto.pickFailed',
      );
    }
  }

  int _startUploadingPhoto(int slotIndex, Uint8List previewBytes) {
    final entryId = _createSlotEntryId();
    final normalizedIndex = slotIndex < _slotEntries.length
        ? slotIndex
        : _slotEntries.length;
    final previousPhoto = normalizedIndex < _slotEntries.length
        ? _slotEntries[normalizedIndex].photo
        : null;

    setState(() {
      final entry = _PhotoSlotEntry.uploading(
        id: entryId,
        previewBytes: previewBytes,
        previousPhoto: previousPhoto,
      );
      if (normalizedIndex < _slotEntries.length) {
        _slotEntries[normalizedIndex] = entry;
      } else if (_slotEntries.length < _PhotoSlotRow.slotCount) {
        _slotEntries.add(entry);
      }
    });

    return entryId;
  }

  void _finishUploadingPhoto(int entryId, ProfilePhotoInput photo) {
    final entryIndex = _slotEntries.indexWhere((entry) => entry.id == entryId);
    if (entryIndex == -1) return;

    setState(() {
      _slotEntries[entryIndex] = _PhotoSlotEntry.uploaded(
        id: entryId,
        photo: photo,
      );
    });
  }

  void _restoreUploadingPhoto(int entryId) {
    final entryIndex = _slotEntries.indexWhere((entry) => entry.id == entryId);
    if (entryIndex == -1) return;

    final entry = _slotEntries[entryIndex];
    setState(() {
      final previousPhoto = entry.previousPhoto;
      if (previousPhoto == null) {
        _slotEntries.removeAt(entryIndex);
      } else {
        _slotEntries[entryIndex] = _PhotoSlotEntry.uploaded(
          id: entryId,
          photo: previousPhoto,
        );
      }
    });
  }

  void _removePhoto(ProfileDetails notifier, int slotIndex) {
    if (slotIndex < 0 || slotIndex >= _slotEntries.length) return;
    if (_slotEntries[slotIndex].isUploading) return;

    setState(() {
      _slotEntries.removeAt(slotIndex);
    });
    unawaited(_commitUploadedPhotos(notifier));
  }

  void _reorderPhoto(ProfileDetails notifier, int fromIndex, int toIndex) {
    if (fromIndex < 0 || fromIndex >= _slotEntries.length) return;
    if (_slotEntries.length < 2) return;

    final normalizedTarget = toIndex >= _slotEntries.length
        ? _slotEntries.length - 1
        : toIndex;
    if (normalizedTarget < 0 || normalizedTarget == fromIndex) return;

    setState(() {
      final entry = _slotEntries.removeAt(fromIndex);
      _slotEntries.insert(normalizedTarget, entry);
    });
    unawaited(_commitUploadedPhotos(notifier));
  }

  Future<bool> _commitUploadedPhotos(ProfileDetails notifier) {
    return notifier.replacePhotos(
      type: widget.type,
      photos: _persistablePhotos,
    );
  }

  Future<void> _syncInitialPhotosFromServer() async {
    final synced = await ref
        .read(profileDetailsProvider.notifier)
        .syncProfileDetailsFromServer();
    if (!mounted || !synced || _slotEntries.isNotEmpty) return;

    final config = _ProfilePhotoPageConfig.fromType(widget.type);
    final photos = config.photos(ref.read(profileDetailsProvider));
    if (photos.isEmpty) return;

    setState(() {
      _appendUploadedPhotoEntries(photos);
    });
  }

  void _appendUploadedPhotoEntries(List<ProfilePhotoInput> photos) {
    final availableSlotCount = _PhotoSlotRow.slotCount - _slotEntries.length;
    if (availableSlotCount <= 0) return;

    _slotEntries.addAll(
      photos
          .take(availableSlotCount)
          .map(
            (photo) => _PhotoSlotEntry.uploaded(
              id: _createSlotEntryId(),
              photo: photo,
            ),
          ),
    );
  }

  int _createSlotEntryId() => _nextSlotEntryId++;
}

class _PhotoSlotRow extends StatelessWidget {
  static const int slotCount = 3;

  final List<_PhotoSlotEntry> entries;
  final bool actionsDisabled;
  final IconData primaryIcon;
  final String primaryLabelKey;
  final ValueChanged<int> onTap;
  final ValueChanged<int> onRemove;
  final void Function(int fromIndex, int toIndex) onReorder;

  const _PhotoSlotRow({
    required this.entries,
    required this.actionsDisabled,
    required this.primaryIcon,
    required this.primaryLabelKey,
    required this.onTap,
    required this.onRemove,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableTileWidth =
            (constraints.maxWidth - AppSpacing.s12 * (slotCount - 1)) /
            slotCount;
        final tileWidth =
            availableTileWidth > AppContainerSize.profilePhotoSlotWidth
            ? AppContainerSize.profilePhotoSlotWidth
            : availableTileWidth;
        final tileHeight =
            tileWidth *
            AppContainerSize.profilePhotoSlotHeight /
            AppContainerSize.profilePhotoSlotWidth;

        return Row(
          children: [
            for (var index = 0; index < slotCount; index++) ...[
              SizedBox(
                width: tileWidth,
                height: tileHeight,
                child: _PhotoSlotDragTarget(
                  slotIndex: index,
                  entry: index < entries.length ? entries[index] : null,
                  dragEnabled: !actionsDisabled && entries.length > 1,
                  actionsDisabled: actionsDisabled,
                  isRequired: index == 0,
                  icon: index == 0 ? primaryIcon : Icons.add_rounded,
                  labelKey: index == 0 ? primaryLabelKey : null,
                  onTap: () => onTap(index),
                  onRemove: index < entries.length
                      ? () => onRemove(index)
                      : null,
                  onReorder: onReorder,
                  width: tileWidth,
                  height: tileHeight,
                ),
              ),
              if (index != slotCount - 1) const SizedBox(width: AppSpacing.s12),
            ],
          ],
        );
      },
    );
  }
}

class _PhotoSlotDragTarget extends StatelessWidget {
  final int slotIndex;
  final _PhotoSlotEntry? entry;
  final bool dragEnabled;
  final bool actionsDisabled;
  final bool isRequired;
  final IconData icon;
  final String? labelKey;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final void Function(int fromIndex, int toIndex) onReorder;
  final double width;
  final double height;

  const _PhotoSlotDragTarget({
    required this.slotIndex,
    required this.entry,
    required this.dragEnabled,
    required this.actionsDisabled,
    required this.isRequired,
    required this.icon,
    required this.labelKey,
    required this.onTap,
    required this.onRemove,
    required this.onReorder,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<_PhotoDragPayload>(
      onWillAcceptWithDetails: (details) => details.data.fromIndex != slotIndex,
      onAcceptWithDetails: (details) {
        onReorder(details.data.fromIndex, slotIndex);
      },
      builder: (context, candidateData, rejectedData) {
        final isDragTargetActive = candidateData.isNotEmpty;
        final tile = _PhotoSlotTile(
          entry: entry,
          actionsDisabled: actionsDisabled,
          isRequired: isRequired,
          icon: icon,
          labelKey: labelKey,
          onTap: onTap,
          onRemove: onRemove,
        );
        final decoratedTile = Stack(
          fit: StackFit.expand,
          children: [
            tile,
            if (isDragTargetActive)
              const Positioned.fill(child: _PhotoSlotDragOverlay()),
          ],
        );

        if (entry == null || !dragEnabled) {
          return decoratedTile;
        }

        return LongPressDraggable<_PhotoDragPayload>(
          data: _PhotoDragPayload(fromIndex: slotIndex),
          feedback: SizedBox(
            width: width,
            height: height,
            child: Opacity(opacity: 0.92, child: tile),
          ),
          childWhenDragging: Opacity(opacity: 0.36, child: decoratedTile),
          child: decoratedTile,
        );
      },
    );
  }
}

class _PhotoSlotDragOverlay extends StatelessWidget {
  const _PhotoSlotDragOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.overlayPressed,
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
      ),
    );
  }
}

class _PhotoDragPayload {
  final int fromIndex;

  const _PhotoDragPayload({required this.fromIndex});
}

class _PhotoSlotEntry {
  final int id;
  final ProfilePhotoInput? photo;
  final Uint8List? previewBytes;
  final ProfilePhotoInput? previousPhoto;

  const _PhotoSlotEntry._({
    required this.id,
    required this.photo,
    required this.previewBytes,
    required this.previousPhoto,
  });

  factory _PhotoSlotEntry.uploaded({
    required int id,
    required ProfilePhotoInput photo,
  }) {
    return _PhotoSlotEntry._(
      id: id,
      photo: photo,
      previewBytes: null,
      previousPhoto: null,
    );
  }

  factory _PhotoSlotEntry.uploading({
    required int id,
    required Uint8List previewBytes,
    ProfilePhotoInput? previousPhoto,
  }) {
    return _PhotoSlotEntry._(
      id: id,
      photo: null,
      previewBytes: previewBytes,
      previousPhoto: previousPhoto,
    );
  }

  bool get isUploading => previewBytes != null;
}

class _PhotoSlotTile extends StatelessWidget {
  final _PhotoSlotEntry? entry;
  final bool actionsDisabled;
  final bool isRequired;
  final IconData icon;
  final String? labelKey;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const _PhotoSlotTile({
    required this.entry,
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
    final selectedPhoto = entry?.photo;
    final previewBytes = entry?.previewBytes ?? selectedPhoto?.previewBytes;
    final isUploading = entry?.isUploading ?? false;

    return Material(
      color: colors.componentProfilePhotoSlotBackground,
      borderRadius: BorderRadius.circular(AppRadius.iosStyle),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: actionsDisabled || isUploading ? null : onTap,
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
                    color: colors.componentProfilePhotoSlotBorder,
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

  static const double _width = AppContainerSize.profilePhotoGuideButtonWidth;
  static const double _height = AppContainerSize.buttonChipHeight;
  static const double _iconSize = AppIconSize.xs;
  static const double _horizontalPadding = AppPadding.buttonChipHorizontal;
  static const double _labelIconGap = AppSpacing.s6;
  static const double _labelMaxWidth =
      _width - (_horizontalPadding * 2) - _labelIconGap - _iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return SizedBox(
      width: _width,
      height: _height,
      child: Material(
        color: colors.secondaryNormal,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
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
          onTap: () {
            DefaultToast.show(
              context,
              'onboarding.basicProfile.profilePhoto.guideUnavailable',
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
              vertical: AppPadding.buttonSmallVertical,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ScaledText(
                  text: 'onboarding.basicProfile.profilePhoto.guide',
                  maxWidth: _labelMaxWidth,
                  style: typography.buttonSmall.copyWith(
                    color: colors.onSecondaryNormal,
                  ),
                ),
                const SizedBox(width: _labelIconGap),
                DefaultIcon(
                  icon: Icons.chevron_right_rounded,
                  size: _iconSize,
                  color: colors.onSecondaryNormal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedRRectBorderPainter extends CustomPainter {
  static const double _dash = AppContainerSize.profilePhotoSlotDash;
  static const double _gap = AppContainerSize.profilePhotoSlotDashGap;

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
