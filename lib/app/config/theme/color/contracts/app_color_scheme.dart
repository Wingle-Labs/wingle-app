import 'package:wingle/app/config/theme/color/contracts/app_color_scheme_component.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme_elevation.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme_primary_secondary.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme_static.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme_status.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme_stroke.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme_text.dart';

/// 애플리케이션 컬러 스키마.
///
/// 모든 색상 계약을 도메인별 인터페이스로 조합한 상위 인터페이스입니다.
abstract interface class AppColorScheme
    implements
        AppColorStaticScheme,
        AppColorPrimarySecondaryScheme,
        AppColorTextScheme,
        AppColorStrokeScheme,
        AppColorStatusScheme,
        AppColorElevationScheme,
        AppColorComponentScheme {}
