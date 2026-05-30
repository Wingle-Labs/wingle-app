import 'package:wingle/app/bootstrap/initializers/auth_session_initializer.dart';
import 'package:wingle/app/bootstrap/initializers/codebook_initializer.dart';

/// 앱 시작 시 필요한 선행 작업을 순서대로 실행한다.
class BootstrapInitializer {
  /// 인증 세션 초기화 작업.
  final AuthSessionInitializer authSessionInitializer;

  /// 코드북 초기화 작업.
  final CodebookInitializer codebookInitializer;

  /// 생성자.
  const BootstrapInitializer({
    required this.authSessionInitializer,
    required this.codebookInitializer,
  });

  /// 전체 부트스트랩 초기화를 실행한다.
  Future<BootstrapInitializeResult> initialize() async {
    final authSessionResult = await authSessionInitializer.initialize();
    final codebookResult = await codebookInitializer.initialize();

    return BootstrapInitializeResult(
      authSession: authSessionResult,
      codebook: codebookResult,
    );
  }
}

/// 앱 부트스트랩 초기화 결과.
class BootstrapInitializeResult {
  /// 인증 세션 초기화 결과.
  final AuthSessionInitializeResult authSession;

  /// 코드북 초기화 결과.
  final CodebookInitializeResult codebook;

  /// 생성자.
  const BootstrapInitializeResult({
    required this.authSession,
    required this.codebook,
  });

  /// 전체 초기화 성공 여부.
  bool get success => codebook.success;
}
