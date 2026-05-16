import 'package:flutter/material.dart';

/// 앱 전역 elevation shadow 토큰
@immutable
class AppElevation extends ThemeExtension<AppElevation> {
  /// 적용한 UI가 조금 더 도드라져 보이게 할 목적
  final List<BoxShadow> normal;

  /// 적용한 UI가 도드라져 보이게 할 목적
  final List<BoxShadow> strong;

  /// 적용한 UI가 다른 어떤 것들보다 확실하게 도드라져 보이게 할 목적
  final List<BoxShadow> heavy;

  /// 적용한 UI가 다른 어떤 것들보다 확실하게 도드라져 보이고, 위쪽으로 그림자가 생겨야 할 목적
  final List<BoxShadow> heavyUpside;

  /// 생성자
  const AppElevation({
    required this.normal,
    required this.strong,
    required this.heavy,
    required this.heavyUpside,
  });

  @override
  AppElevation copyWith({
    List<BoxShadow>? normal,
    List<BoxShadow>? strong,
    List<BoxShadow>? heavy,
    List<BoxShadow>? heavyUpside,
  }) {
    return AppElevation(
      normal: normal ?? this.normal,
      strong: strong ?? this.strong,
      heavy: heavy ?? this.heavy,
      heavyUpside: heavyUpside ?? this.heavyUpside,
    );
  }

  @override
  AppElevation lerp(ThemeExtension<AppElevation>? other, double t) {
    if (other is! AppElevation) {
      return this;
    }

    return AppElevation(
      normal: t < 0.5 ? normal : other.normal,
      strong: t < 0.5 ? strong : other.strong,
      heavy: t < 0.5 ? heavy : other.heavy,
      heavyUpside: t < 0.5 ? heavyUpside : other.heavyUpside,
    );
  }
}
