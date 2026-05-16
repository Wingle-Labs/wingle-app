import 'package:wingle/features/onboarding/data/codebook/codebook_repository_impl.dart';

/// Bootstrap 전체 결과.
class BootstrapResult {
  final bool success;
  final BootstrapCodebookSyncResult codebook;

  const BootstrapResult({required this.success, required this.codebook});
}
