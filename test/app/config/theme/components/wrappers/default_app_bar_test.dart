import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';

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
}
