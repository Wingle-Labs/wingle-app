import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';

/// 수정된 ElevatedButton
class DefaultElevatedButton extends ConsumerWidget {
  /// child
  final Widget child;

  /// onPressed
  final VoidCallback onPressed;

  /// 생성자
  const DefaultElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        side: BorderSide(color: theme.primaryColor),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.iosStyleRadius),
      ),
      child: child,
    );
  }
}
