import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'basic_profile_height_provider.g.dart';

/// 기본 프로필 키 입력 상태 관리 Notifier.
@Riverpod(keepAlive: true)
class BasicProfileHeight extends _$BasicProfileHeight {
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
