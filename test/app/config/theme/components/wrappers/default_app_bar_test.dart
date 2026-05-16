import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/themes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('DefaultAppBar display subtitle height expands to text block size', () {
    final appBar = DefaultAppBar(
      layout: DefaultAppBarLayout.display,
      title: 'title',
      isTitleTranslationKey: false,
      subtitle: 'subtitle',
      isSubtitleTranslationKey: false,
    );

    expect(appBar.preferredSize.height, closeTo(83.0, 0.01));
  });

  test('DefaultAppBar without subtitle keeps minimum height', () {
    final appBar = DefaultAppBar(
      layout: DefaultAppBarLayout.display,
      title: 'title',
      isTitleTranslationKey: false,
    );

    expect(appBar.preferredSize.height, closeTo(68.0, 0.01));
  });

  testWidgets('DefaultAppBar는 뒤로갈 수 있으면 자동 back action을 표시한다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: Themes.light,
        initialRoute: '/second',
        routes: {
          '/': (_) => const Scaffold(body: Text('first')),
          '/second': (_) => const Scaffold(appBar: DefaultAppBar()),
        },
      ),
    );

    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    expect(
      tester.getCenter(find.byIcon(Icons.arrow_back_ios_new_rounded)).dx,
      closeTo(38.0, 0.01),
    );

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('first'), findsOneWidget);
  });

  testWidgets('DefaultAppBar는 root 화면에서 자동 back action을 표시하지 않는다', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: Themes.light,
        home: const Scaffold(appBar: DefaultAppBar()),
      ),
    );

    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
  });

  testWidgets('DefaultAppBar는 자동 back action을 끌 수 있다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: Themes.light,
        initialRoute: '/second',
        routes: {
          '/': (_) => const Scaffold(body: Text('first')),
          '/second': (_) => const Scaffold(
            appBar: DefaultAppBar(automaticallyImplyLeading: false),
          ),
        },
      ),
    );

    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
  });

  testWidgets('DefaultAppBar는 trailing이 없어도 title을 화면 중앙에 둔다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: Themes.light,
        initialRoute: '/second',
        routes: {
          '/': (_) => const Scaffold(body: Text('first')),
          '/second': (_) => const Scaffold(
            appBar: DefaultAppBar(
              title: 'Profile Input',
              isTitleTranslationKey: false,
            ),
          ),
        },
      ),
    );

    final appBarCenter = tester.getCenter(find.byType(DefaultAppBar));
    final titleCenter = tester.getCenter(find.text('Profile Input'));

    expect(titleCenter.dx, closeTo(appBarCenter.dx, 0.01));
  });
}
