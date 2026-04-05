import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/features/onboarding/presentation/components/input/basic_profile_height_input.dart';

void main() {
  testWidgets('BasicProfileHeightInput은 세 자리 입력값을 조합해 전달한다', (tester) async {
    var latestValue = '';
    var completedCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: Themes.light,
        home: Scaffold(
          body: Center(
            child: BasicProfileHeightInput(
              onChanged: (value) {
                latestValue = value;
              },
              onCompleted: () {
                completedCount += 1;
              },
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), '1');
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(1), '7');
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(2), '5');
    await tester.pump();

    expect(latestValue, '175');
    expect(completedCount, 1);
  });
}
