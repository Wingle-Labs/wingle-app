import 'package:wingle/features/onboarding/data/codebook/codebook_repository_impl.dart';

/// 코드북 bootstrap initializer.
class CodebookInitializer {
  final CodebookRepositoryImpl _repository;

  const CodebookInitializer({required CodebookRepositoryImpl repository})
    : _repository = repository;

  Future<BootstrapCodebookSyncResult> initialize() {
    return _repository.sync();
  }
}
