import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/app/config/theme/layout/app_breakpoints.dart';
import 'package:wingle/app/config/theme/layout/extensions/context_layout.dart';

void main() {
  testWidgets('currentGrid는 현재 breakpoint의 기본 preset을 사용한다', (tester) async {
    late AppBreakpoint breakpoint;
    late AppLayoutPreset preset;
    late int columnCount;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(390, 844)),
        child: Builder(
          builder: (context) {
            breakpoint = context.breakpoint;
            preset = context.currentGridPreset;
            columnCount = context.currentGrid.spec.columnCount;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(breakpoint, AppBreakpoint.mobileMd);
    expect(preset, AppLayoutPreset.mobileMd);
    expect(columnCount, 1);
  });

  testWidgets('currentGridSpec은 desktop breakpoint에서 desktop spec을 반환한다', (
    tester,
  ) async {
    late AppBreakpoint breakpoint;
    late AppLayoutPreset preset;
    late int columnCount;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(1280, 900)),
        child: Builder(
          builder: (context) {
            breakpoint = context.breakpoint;
            preset = context.currentGridPreset;
            columnCount = context.currentGridSpec.columnCount;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(breakpoint, AppBreakpoint.desktop);
    expect(preset, AppLayoutPreset.desktop);
    expect(columnCount, 12);
  });
}
