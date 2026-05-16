import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/app/config/theme/constants/component_tokens.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';

void main() {
  group('AppComponent tokens', () {
    test('AppBar semantic tokens map to primitive tokens', () {
      expect(AppComponentPadding.appBarHorizontal, AppPadding.horizontal);
      expect(AppComponentPadding.appBarVertical, AppPadding.vertical);
      expect(AppComponentSpacing.appBarActionGap, AppSpacing.s4);
      expect(AppComponentSpacing.appBarTitleGap, AppSpacing.s12);
      expect(AppComponentSpacing.appBarDisplayTextGap, AppSpacing.s6);
      expect(AppComponentSize.appBarAction, AppIconSize.xl);
      expect(AppComponentSize.appBarActionHit, AppIconPixelGrid.xl);
      expect(
        AppComponentSize.appBarMinHeight,
        AppPadding.vertical * 2 + AppIconPixelGrid.xl,
      );
    });

    test('Input semantic tokens map to primitive tokens', () {
      expect(AppComponentPadding.inputHorizontal, AppPadding.textfield);
      expect(AppComponentPadding.inputVertical, AppPadding.textfieldVertical);
      expect(AppComponentPadding.inputSuffixGap, AppPadding.textfieldSuffix);
      expect(
        AppComponentSpacing.inputLabelGap,
        AppSpacing.inputFieldLabelInternal,
      );
      expect(AppComponentRadius.input, AppRadius.iosStyle);
      expect(
        AppComponentSize.inputMinHeight,
        AppContainerSize.inputFieldMinimun,
      );
    });
  });
}
