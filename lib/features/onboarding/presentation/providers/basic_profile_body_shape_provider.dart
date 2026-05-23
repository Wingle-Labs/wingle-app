import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'basic_profile_body_shape_provider.g.dart';

/// 기본 프로필 체형 선택 상태 관리 Notifier.
@Riverpod(keepAlive: true)
class BasicProfileBodyShape extends _$BasicProfileBodyShape {
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
