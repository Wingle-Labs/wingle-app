import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 기본 프로필 키 입력 상태를 보관하는 Provider.
final basicProfileHeightProvider =
    NotifierProvider<BasicProfileHeightNotifier, String>(
      BasicProfileHeightNotifier.new,
    );

/// 기본 프로필 키 입력 상태 관리 Notifier.
class BasicProfileHeightNotifier extends Notifier<String> {
  @override
  String build() => '';

  /// 키 값을 갱신한다.
  void update(String value) {
    final sanitized = value.replaceAll(RegExp(r'1[^0-9]'), '');
    final trimmed = sanitized.length > 3
        ? sanitized.substring(0, 3)
        : sanitized;

    if (state == trimmed) return;

    state = trimmed;
  }

  /// 키 값을 초기화한다.
  void reset() {
    state = '';
  }
}
