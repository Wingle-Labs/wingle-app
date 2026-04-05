import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 기본 프로필 체형 선택 상태를 보관하는 Provider.
final basicProfileBodyShapeProvider =
    NotifierProvider<BasicProfileBodyShapeNotifier, String?>(
      BasicProfileBodyShapeNotifier.new,
    );

/// 기본 프로필 체형 선택 상태 관리 Notifier.
class BasicProfileBodyShapeNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  /// 체형 코드를 갱신한다.
  void select(String code) {
    if (state == code) return;
    state = code;
  }

  /// 선택을 초기화한다.
  void reset() {
    state = null;
  }
}
