// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

enum AppPaletteGroup {
  common,
  neutral,
  warmNeutral,
  gray,
  brown,
  asheBrown,
  red,
  orange,
  yellow,
  green,
  blue,
  purple,
  pink,
  opacities,
}

class AppPaletteToken {
  final AppPaletteGroup group;
  final String name; // Figma 기준 토큰명
  final Color color;

  const AppPaletteToken({
    required this.name,
    required this.color,
    required this.group,
  });
}

/// Figma에서 정의된 컬러 팔레트 구현
final class AppColorPalette {
  // ! =========================================================
  // ! Common
  // ! =========================================================
  static const common0 = AppPaletteToken(
    name: 'color-global-common-0',
    color: Color(0xFFFFFFFF),
    group: AppPaletteGroup.common,
  );
  static const common100 = AppPaletteToken(
    name: 'color-global-common-100',
    color: Color(0xFF000000),
    group: AppPaletteGroup.common,
  );

  // ! =========================================================
  // ! Neutral
  // ! =========================================================
  static const neutral2 = AppPaletteToken(
    name: 'color-global-neutral-2',
    color: Color(0xFFFCFCFC),
    group: AppPaletteGroup.neutral,
  );
  static const neutral4 = AppPaletteToken(
    name: 'color-global-neutral-4',
    color: Color(0xFFFAFAFA),
    group: AppPaletteGroup.neutral,
  );
  static const neutral6 = AppPaletteToken(
    name: 'color-global-neutral-6',
    color: Color(0xFFF1F1F1),
    group: AppPaletteGroup.neutral,
  );
  static const neutral8 = AppPaletteToken(
    name: 'color-global-neutral-8',
    color: Color(0xFFEAEAEA),
    group: AppPaletteGroup.neutral,
  );
  static const neutral10 = AppPaletteToken(
    name: 'color-global-neutral-10',
    color: Color(0xFFDFDFDF),
    group: AppPaletteGroup.neutral,
  );
  static const neutral20 = AppPaletteToken(
    name: 'color-global-neutral-20',
    color: Color(0xFFC1C1C1),
    group: AppPaletteGroup.neutral,
  );
  static const neutral30 = AppPaletteToken(
    name: 'color-global-neutral-30',
    color: Color(0xFFA5A5A5),
    group: AppPaletteGroup.neutral,
  );
  static const neutral40 = AppPaletteToken(
    name: 'color-global-neutral-40',
    color: Color(0xFF8B8B8B),
    group: AppPaletteGroup.neutral,
  );
  static const neutral50 = AppPaletteToken(
    name: 'color-global-neutral-50',
    color: Color(0xFF6F6F6F),
    group: AppPaletteGroup.neutral,
  );
  static const neutral60 = AppPaletteToken(
    name: 'color-global-neutral-60',
    color: Color(0xFF565656),
    group: AppPaletteGroup.neutral,
  );
  static const neutral70 = AppPaletteToken(
    name: 'color-global-neutral-70',
    color: Color(0xFF3D3D3D),
    group: AppPaletteGroup.neutral,
  );
  static const neutral80 = AppPaletteToken(
    name: 'color-global-neutral-80',
    color: Color(0xFF222222),
    group: AppPaletteGroup.neutral,
  );
  static const neutral85 = AppPaletteToken(
    name: 'color-global-neutral-85',
    color: Color(0xFF1C1C1C),
    group: AppPaletteGroup.neutral,
  );
  static const neutral90 = AppPaletteToken(
    name: 'color-global-neutral-90',
    color: Color(0xFF121212),
    group: AppPaletteGroup.neutral,
  );
  static const neutral95 = AppPaletteToken(
    name: 'color-global-neutral-95',
    color: Color(0xFF0C0C0C),
    group: AppPaletteGroup.neutral,
  );

  // ! =========================================================
  // ! WarmNeutral
  // ! =========================================================
  static const warmNeutral5 = AppPaletteToken(
    name: 'color-global-warm-neutral-5',
    color: Color(0xFFEBEBEB),
    group: AppPaletteGroup.warmNeutral,
  );
  static const warmNeutral10 = AppPaletteToken(
    name: 'color-global-warm-neutral-10',
    color: Color(0xFFC2C1C1),
    group: AppPaletteGroup.warmNeutral,
  );
  static const warmNeutral20 = AppPaletteToken(
    name: 'color-global-warm-neutral-20',
    color: Color(0xFFA4A3A3),
    group: AppPaletteGroup.warmNeutral,
  );
  static const warmNeutral30 = AppPaletteToken(
    name: 'color-global-warm-neutral-30',
    color: Color(0xFF7B7A78),
    group: AppPaletteGroup.warmNeutral,
  );
  static const warmNeutral40 = AppPaletteToken(
    name: 'color-global-warm-neutral-40',
    color: Color(0xFF61605E),
    group: AppPaletteGroup.warmNeutral,
  );
  static const warmNeutral50 = AppPaletteToken(
    name: 'color-global-warm-neutral-50',
    color: Color(0xFF3A3836),
    group: AppPaletteGroup.warmNeutral,
  );
  static const warmNeutral60 = AppPaletteToken(
    name: 'color-global-warm-neutral-60',
    color: Color(0xFF353331),
    group: AppPaletteGroup.warmNeutral,
  );
  static const warmNeutral70 = AppPaletteToken(
    name: 'color-global-warm-neutral-70',
    color: Color(0xFF292826),
    group: AppPaletteGroup.warmNeutral,
  );
  static const warmNeutral80 = AppPaletteToken(
    name: 'color-global-warm-neutral-80',
    color: Color(0xFF201F1E),
    group: AppPaletteGroup.warmNeutral,
  );
  static const warmNeutral90 = AppPaletteToken(
    name: 'color-global-warm-neutral-90',
    color: Color(0xFF181817),
    group: AppPaletteGroup.warmNeutral,
  );

  // ! =========================================================
  // ! Gray
  // ! =========================================================
  static const gray5 = AppPaletteToken(
    name: 'color-global-gray-5',
    color: Color(0xFFFCFCFC),
    group: AppPaletteGroup.gray,
  );
  static const gray10 = AppPaletteToken(
    name: 'color-global-gray-10',
    color: Color(0xFFF6F6F6),
    group: AppPaletteGroup.gray,
  );
  static const gray20 = AppPaletteToken(
    name: 'color-global-gray-20',
    color: Color(0xFFF2F2F2),
    group: AppPaletteGroup.gray,
  );
  static const gray30 = AppPaletteToken(
    name: 'color-global-gray-30',
    color: Color(0xFFECECEC),
    group: AppPaletteGroup.gray,
  );
  static const gray40 = AppPaletteToken(
    name: 'color-global-gray-40',
    color: Color(0xFFE8E8E8),
    group: AppPaletteGroup.gray,
  );
  static const gray50 = AppPaletteToken(
    name: 'color-global-gray-50',
    color: Color(0xFFE2E2E2),
    group: AppPaletteGroup.gray,
  );
  static const gray60 = AppPaletteToken(
    name: 'color-global-gray-60',
    color: Color(0xFFCECECE),
    group: AppPaletteGroup.gray,
  );
  static const gray70 = AppPaletteToken(
    name: 'color-global-gray-70',
    color: Color(0xFFA0A0A0),
    group: AppPaletteGroup.gray,
  );
  static const gray80 = AppPaletteToken(
    name: 'color-global-gray-80',
    color: Color(0xFF7C7C7C),
    group: AppPaletteGroup.gray,
  );
  static const gray90 = AppPaletteToken(
    name: 'color-global-gray-90',
    color: Color(0xFF5F5F5F),
    group: AppPaletteGroup.gray,
  );

  // ! =========================================================
  // ! Brown
  // ! =========================================================
  static const brown10 = AppPaletteToken(
    name: 'color-global-brown-10',
    color: Color(0xFFEFECEA),
    group: AppPaletteGroup.brown,
  );
  static const brown20 = AppPaletteToken(
    name: 'color-global-brown-20',
    color: Color(0xFFCDC4BE),
    group: AppPaletteGroup.brown,
  );
  static const brown30 = AppPaletteToken(
    name: 'color-global-brown-30',
    color: Color(0xFFB5A79E),
    group: AppPaletteGroup.brown,
  );
  static const brown35 = AppPaletteToken(
    name: 'color-global-brown-35',
    color: Color(0xFF937F72),
    group: AppPaletteGroup.brown,
  );
  static const brown40 = AppPaletteToken(
    name: 'color-global-brown-40',
    color: Color(0xFF7E6657),
    group: AppPaletteGroup.brown,
  );
  static const brown50 = AppPaletteToken(
    name: 'color-global-brown-50',
    color: Color(0xFF5E402D),
    group: AppPaletteGroup.brown,
  );
  static const brown60 = AppPaletteToken(
    name: 'color-global-brown-60',
    color: Color(0xFF563A29),
    group: AppPaletteGroup.brown,
  );
  static const brown70 = AppPaletteToken(
    name: 'color-global-brown-70',
    color: Color(0xFF432D20),
    group: AppPaletteGroup.brown,
  );
  static const brown80 = AppPaletteToken(
    name: 'color-global-brown-80',
    color: Color(0xFF342319),
    group: AppPaletteGroup.brown,
  );
  static const brown90 = AppPaletteToken(
    name: 'color-global-brown-90',
    color: Color(0xFF271B13),
    group: AppPaletteGroup.brown,
  );

  // ! =========================================================
  // ! Ashe Brown
  // ! =========================================================
  static const asheBrown5 = AppPaletteToken(
    name: 'color-global-ashe-brown-5',
    color: Color(0xFFFAF8F8),
    group: AppPaletteGroup.asheBrown,
  );
  static const asheBrown10 = AppPaletteToken(
    name: 'color-global-ashe-brown-10',
    color: Color(0xFFEEEBE8),
    group: AppPaletteGroup.asheBrown,
  );
  static const asheBrown20 = AppPaletteToken(
    name: 'color-global-ashe-brown-20',
    color: Color(0xFFE6E1DD),
    group: AppPaletteGroup.asheBrown,
  );
  static const asheBrown30 = AppPaletteToken(
    name: 'color-global-ashe-brown-30',
    color: Color(0xFFDAD3CE),
    group: AppPaletteGroup.asheBrown,
  );
  static const asheBrown40 = AppPaletteToken(
    name: 'color-global-ashe-brown-40',
    color: Color(0xFFD3CAC5),
    group: AppPaletteGroup.asheBrown,
  );
  static const asheBrown50 = AppPaletteToken(
    name: 'color-global-ashe-brown-50',
    color: Color(0xFFC8BDB6),
    group: AppPaletteGroup.asheBrown,
  );
  static const asheBrown60 = AppPaletteToken(
    name: 'color-global-ashe-brown-60',
    color: Color(0xFFB6ACA6),
    group: AppPaletteGroup.asheBrown,
  );
  static const asheBrown70 = AppPaletteToken(
    name: 'color-global-ashe-brown-70',
    color: Color(0xFF8E8681),
    group: AppPaletteGroup.asheBrown,
  );
  static const asheBrown80 = AppPaletteToken(
    name: 'color-global-ashe-brown-80',
    color: Color(0xFF6E6864),
    group: AppPaletteGroup.asheBrown,
  );
  static const asheBrown90 = AppPaletteToken(
    name: 'color-global-ashe-brown-90',
    color: Color(0xFF544F4C),
    group: AppPaletteGroup.asheBrown,
  );
  static const asheBrown95 = AppPaletteToken(
    name: 'color-global-ashe-brown-95',
    color: Color(0xFF3C3936),
    group: AppPaletteGroup.asheBrown,
  );

  // ! =========================================================
  // ! Red
  // ! =========================================================
  static const red5 = AppPaletteToken(
    name: 'color-global-red-5',
    color: Color(0xFFFBECEC),
    group: AppPaletteGroup.red,
  );
  static const red10 = AppPaletteToken(
    name: 'color-global-red-10',
    color: Color(0xFFF2C5C5),
    group: AppPaletteGroup.red,
  );
  static const red20 = AppPaletteToken(
    name: 'color-global-red-20',
    color: Color(0xFFECA9A9),
    group: AppPaletteGroup.red,
  );
  static const red30 = AppPaletteToken(
    name: 'color-global-red-30',
    color: Color(0xFFE48282),
    group: AppPaletteGroup.red,
  );
  static const red40 = AppPaletteToken(
    name: 'color-global-red-40',
    color: Color(0xFFDE6A6A),
    group: AppPaletteGroup.red,
  );
  static const red50 = AppPaletteToken(
    name: 'color-global-red-50',
    color: Color(0xFFD64545),
    group: AppPaletteGroup.red,
  );
  static const red60 = AppPaletteToken(
    name: 'color-global-red-60',
    color: Color(0xFFC33F3F),
    group: AppPaletteGroup.red,
  );
  static const red70 = AppPaletteToken(
    name: 'color-global-red-70',
    color: Color(0xFF983131),
    group: AppPaletteGroup.red,
  );
  static const red80 = AppPaletteToken(
    name: 'color-global-red-80',
    color: Color(0xFF762626),
    group: AppPaletteGroup.red,
  );
  static const red90 = AppPaletteToken(
    name: 'color-global-red-90',
    color: Color(0xFF5A1D1D),
    group: AppPaletteGroup.red,
  );

  // ! =========================================================
  // ! Blue
  // ! =========================================================
  static const blue5 = AppPaletteToken(
    name: 'color-global-blue-5',
    color: Color(0xFFEBF2FB),
    group: AppPaletteGroup.blue,
  );
  static const blue10 = AppPaletteToken(
    name: 'color-global-blue-10',
    color: Color(0xFFC2D6F2),
    group: AppPaletteGroup.blue,
  );
  static const blue20 = AppPaletteToken(
    name: 'color-global-blue-20',
    color: Color(0xFFA4C2EC),
    group: AppPaletteGroup.blue,
  );
  static const blue30 = AppPaletteToken(
    name: 'color-global-blue-30',
    color: Color(0xFF7BA7E3),
    group: AppPaletteGroup.blue,
  );
  static const blue40 = AppPaletteToken(
    name: 'color-global-blue-40',
    color: Color(0xFF6195DD),
    group: AppPaletteGroup.blue,
  );
  static const blue50 = AppPaletteToken(
    name: 'color-global-blue-50',
    color: Color(0xFF3A7BD5),
    group: AppPaletteGroup.blue,
  );
  static const blue60 = AppPaletteToken(
    name: 'color-global-blue-60',
    color: Color(0xFF3570C2),
    group: AppPaletteGroup.blue,
  );
  static const blue70 = AppPaletteToken(
    name: 'color-global-blue-70',
    color: Color(0xFF295797),
    group: AppPaletteGroup.blue,
  );
  static const blue80 = AppPaletteToken(
    name: 'color-global-blue-80',
    color: Color(0xFF204475),
    group: AppPaletteGroup.blue,
  );
  static const blue90 = AppPaletteToken(
    name: 'color-global-blue-90',
    color: Color(0xFF183459),
    group: AppPaletteGroup.blue,
  );

  // ! =========================================================
  // ! Green
  // ! =========================================================
  static const green5 = AppPaletteToken(
    name: 'color-global-green-5',
    color: Color(0xFFE4F3EF),
    group: AppPaletteGroup.green,
  );
  static const green10 = AppPaletteToken(
    name: 'color-global-green-10',
    color: Color(0xFFBBE0D2),
    group: AppPaletteGroup.green,
  );
  static const green20 = AppPaletteToken(
    name: 'color-global-green-20',
    color: Color(0xFF9CC3B3),
    group: AppPaletteGroup.green,
  );
  static const green30 = AppPaletteToken(
    name: 'color-global-green-30',
    color: Color(0xFF73A890),
    group: AppPaletteGroup.green,
  );
  static const green40 = AppPaletteToken(
    name: 'color-global-green-40',
    color: Color(0xFF589978),
    group: AppPaletteGroup.green,
  );
  static const green50 = AppPaletteToken(
    name: 'color-global-green-50',
    color: Color(0xFF2E7D5A),
    group: AppPaletteGroup.green,
  );
  static const green60 = AppPaletteToken(
    name: 'color-global-green-60',
    color: Color(0xFF225D42),
    group: AppPaletteGroup.green,
  );
  static const green70 = AppPaletteToken(
    name: 'color-global-green-70',
    color: Color(0xFF1E5940),
    group: AppPaletteGroup.green,
  );
  static const green80 = AppPaletteToken(
    name: 'color-global-green-80',
    color: Color(0xFF194532),
    group: AppPaletteGroup.green,
  );
  static const green90 = AppPaletteToken(
    name: 'color-global-green-90',
    color: Color(0xFF133526),
    group: AppPaletteGroup.green,
  );

  // ! =========================================================
  // ! Yellow
  // ! =========================================================
  static const yellow5 = AppPaletteToken(
    name: 'color-global-yellow-5',
    color: Color(0xFFFDF6EC),
    group: AppPaletteGroup.yellow,
  );
  static const yellow10 = AppPaletteToken(
    name: 'color-global-yellow-10',
    color: Color(0xFFF7E2C3),
    group: AppPaletteGroup.yellow,
  );
  static const yellow20 = AppPaletteToken(
    name: 'color-global-yellow-20',
    color: Color(0xFFF4D4A5),
    group: AppPaletteGroup.yellow,
  );
  static const yellow30 = AppPaletteToken(
    name: 'color-global-yellow-30',
    color: Color(0xFFECC17C),
    group: AppPaletteGroup.yellow,
  );
  static const yellow40 = AppPaletteToken(
    name: 'color-global-yellow-40',
    color: Color(0xFFFFC06E),
    group: AppPaletteGroup.yellow,
  );
  static const yellow50 = AppPaletteToken(
    name: 'color-global-yellow-50',
    color: Color(0xFFE6A23C),
    group: AppPaletteGroup.yellow,
  );
  static const yellow60 = AppPaletteToken(
    name: 'color-global-yellow-60',
    color: Color(0xFFD19337),
    group: AppPaletteGroup.yellow,
  );
  static const yellow70 = AppPaletteToken(
    name: 'color-global-yellow-70',
    color: Color(0xFFA3732B),
    group: AppPaletteGroup.yellow,
  );
  static const yellow80 = AppPaletteToken(
    name: 'color-global-yellow-80',
    color: Color(0xFF7F5921),
    group: AppPaletteGroup.yellow,
  );
  static const yellow90 = AppPaletteToken(
    name: 'color-global-yellow-90',
    color: Color(0xFF614419),
    group: AppPaletteGroup.yellow,
  );

  // ! =========================================================
  // ! Opacity
  // ! =========================================================
  static const opacity0 = 0.0;
  static const opacity4 = 0.04;
  static const opacity6 = 0.06;
  static const opacity8 = 0.08;
  static const opacity12 = 0.12;
  static const opacity16 = 0.16;
  static const opacity22 = 0.22;
  static const opacity28 = 0.28;
  static const opacity35 = 0.35;
  static const opacity43 = 0.43;
  static const opacity52 = 0.52;
  static const opacity61 = 0.61;
  static const opacity74 = 0.74;
  static const opacity88 = 0.88;
  static const opacity97 = 0.97;
  static const opacity100 = 1.0;

  // ! =========================================================
  // ! Widgetbook 출력용 리스트
  // ! =========================================================
  /// 모든 컬러 토큰을 포함한 리스트
  static const List<AppPaletteToken> allColors = [
    // ! commons
    common0,
    common100,

    // ! neutrals
    neutral2,
    neutral4,
    neutral6,
    neutral8,
    neutral10,
    neutral20,
    neutral30,
    neutral40,
    neutral50,
    neutral60,
    neutral70,
    neutral80,
    neutral90,
    neutral95,

    // ! grays
    gray5,
    gray10,
    gray20,
    gray30,
    gray40,
    gray50,
    gray60,
    gray70,
    gray80,
    gray90,

    // ! browns
    brown10,
    brown20,
    brown30,
    brown40,
    brown50,
    brown60,
    brown70,
    brown80,
    brown90,

    // ! ashe browns
    asheBrown5,
    asheBrown10,
    asheBrown20,
    asheBrown30,
    asheBrown40,
    asheBrown50,
    asheBrown60,
    asheBrown70,
    asheBrown80,
    asheBrown90,
    asheBrown95,

    // ! reds
    red5,
    red10,
    red20,
    red30,
    red40,
    red50,
    red60,
    red70,
    red80,
    red90,

    // ! blues
    blue5,
    blue10,
    blue20,
    blue30,
    blue40,
    blue50,
    blue60,
    blue70,
    blue80,
    blue90,

    // ! greens
    green5,
    green10,
    green20,
    green30,
    green40,
    green50,
    green60,
    green70,
    green80,
    green90,

    // ! yellows
    yellow5,
    yellow10,
    yellow20,
    yellow30,
    yellow40,
    yellow50,
    yellow60,
    yellow70,
    yellow80,
    yellow90,
  ];

  // ! group by
  /// 모든 컬러 토큰을 순회하며 그룹별로 분류하여 반환합니다.
  static List<AppPaletteToken> groupBy(AppPaletteGroup group) {
    return allColors.where((token) => token.group == group).toList();
  }

  // ! Opacities
  /// 투명도 값들
  static const List<double> opacities = [
    opacity0,
    opacity4,
    opacity6,
    opacity8,
    opacity12,
    opacity16,
    opacity22,
    opacity28,
    opacity35,
    opacity43,
    opacity52,
    opacity61,
    opacity74,
    opacity88,
    opacity97,
    opacity100,
  ];
}
