import 'package:wingle/app/bootstrap/bootstrap_result.dart';
import 'package:wingle/app/bootstrap/initializers/codebook_initializer.dart';

/// 앱 bootstrap orchestration.
class BootstrapInitializer {
  final CodebookInitializer _codebookInitializer;

  const BootstrapInitializer({required CodebookInitializer codebookInitializer})
    : _codebookInitializer = codebookInitializer;

  Future<BootstrapResult> initialize() async {
    final codebookResult = await _codebookInitializer.initialize();
    return BootstrapResult(
      success: codebookResult.success,
      codebook: codebookResult,
    );
  }
}
