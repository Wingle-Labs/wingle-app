import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/app/config/theme/layout/app_breakpoints.dart';

void main() {
  group('AppLayoutResolver.resolveBreakpoint', () {
    test('7단계 breakpoint를 min-width 기준으로 반환한다', () {
      expect(AppLayoutResolver.resolveBreakpoint(320), AppBreakpoint.mobileSm);
      expect(AppLayoutResolver.resolveBreakpoint(390), AppBreakpoint.mobileMd);
      expect(AppLayoutResolver.resolveBreakpoint(430), AppBreakpoint.mobileLg);
      expect(AppLayoutResolver.resolveBreakpoint(744), AppBreakpoint.tabletSm);
      expect(AppLayoutResolver.resolveBreakpoint(882), AppBreakpoint.tabletMd);
      expect(AppLayoutResolver.resolveBreakpoint(1024), AppBreakpoint.tabletLg);
      expect(AppLayoutResolver.resolveBreakpoint(1280), AppBreakpoint.desktop);
    });
  });

  group('AppLayoutResolver.resolvePreset', () {
    test('breakpoint별 grid spec을 반환한다', () {
      expect(
        AppLayoutResolver.resolvePreset(AppLayoutPreset.mobileSm).columnCount,
        1,
      );
      expect(
        AppLayoutResolver.resolvePreset(AppLayoutPreset.tabletSm).columnCount,
        2,
      );
      expect(
        AppLayoutResolver.resolvePreset(AppLayoutPreset.tabletLg).columnCount,
        4,
      );
      expect(
        AppLayoutResolver.resolvePreset(AppLayoutPreset.desktop).columnCount,
        12,
      );
    });
  });
}
