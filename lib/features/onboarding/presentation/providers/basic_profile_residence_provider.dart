import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/presentation/models/basic_profile_residence_model.dart';

/// 기본 프로필 거주지 입력 상태를 보관하는 Provider.
final basicProfileResidenceProvider =
    NotifierProvider<BasicProfileResidenceNotifier, BasicProfileResidenceModel>(
      BasicProfileResidenceNotifier.new,
    );

/// 기본 프로필 거주지 입력 상태 관리 Notifier.
class BasicProfileResidenceNotifier
    extends Notifier<BasicProfileResidenceModel> {
  @override
  BasicProfileResidenceModel build() => const BasicProfileResidenceModel();

  /// 거주지 검색어를 갱신한다.
  ///
  /// 현재는 실제 주소 코드북이 연결되기 전이므로,
  /// 입력 문자열을 기반으로 한 안정적인 목업 코드를 함께 만든다.
  void updateQuery(String value) {
    final trimmed = value.trim();
    final nextResidenceCode = trimmed.isEmpty
        ? null
        : _mockResidenceCodeFromQuery(trimmed);

    if (state.query == value && state.residenceCode == nextResidenceCode) {
      return;
    }

    state = state.copyWith(query: value, residenceCode: nextResidenceCode);
  }

  /// 거주지 선택을 초기화한다.
  void clear() {
    state = const BasicProfileResidenceModel();
  }

  /// 거주지 코드를 직접 설정한다.
  void selectResidenceCode(ResidenceCode residenceCode, {String? query}) {
    state = state.copyWith(
      query: query ?? state.query,
      residenceCode: residenceCode,
    );
  }

  ResidenceCode _mockResidenceCodeFromQuery(String query) {
    final seed = query.runes.fold<int>(0, (sum, rune) => sum + rune);
    return ResidenceCode(
      level1: _mockDigits(seed: seed, multiplier: 3, width: 3),
      level2: _mockDigits(seed: seed, multiplier: 31, width: 5),
      level3: _mockDigits(seed: seed, multiplier: 131, width: 8),
    );
  }

  String _mockDigits({
    required int seed,
    required int multiplier,
    required int width,
  }) {
    final max = math.pow(10, width).toInt();
    final value = (seed * multiplier).abs() % max;
    return value.toString().padLeft(width, '0');
  }
}
