import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:wingle/app/app.dart';
import 'package:wingle/app/bootstrap/bootstrap_controller.dart';
import 'package:wingle/app/bootstrap/bootstrap_initializer.dart';
import 'package:wingle/app/bootstrap/initializers/auth_session_initializer.dart';
import 'package:wingle/app/bootstrap/initializers/codebook_initializer.dart';
import 'package:wingle/app/config/app_localization_wrapper.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  tearDown(() {
    SharedPreferencesAsyncPlatform.instance = null;
  });

  testWidgets('앱이 온보딩 화면을 렌더링한다', (WidgetTester tester) async {
    await EasyLocalization.ensureInitialized();
    tester.view
      ..physicalSize = const Size(430, 932)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bootstrapControllerProvider.overrideWith(
            _ReadyBootstrapController.new,
          ),
        ],
        child: AppLocalizationWrapper(child: const App()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('건너뛰기'), findsOneWidget);
    expect(find.text('다음'), findsOneWidget);
  });
}

class _ReadyBootstrapController extends BootstrapController {
  @override
  Future<BootstrapInitializeResult> build() async {
    return BootstrapInitializeResult(
      authSession: const AuthSessionInitializeResult(
        status: AuthSessionInitializeStatus.noSession,
      ),
      codebook: CodebookInitializeResult(
        syncResult: BootstrapCodebookSyncResult.success(
          localVersions: CodebookVersionMap.empty(),
          remoteVersions: CodebookVersionMap.empty(),
          syncedGroups: [],
          localChoiceVersions: {},
          remoteChoiceVersions: {},
          syncedChoiceCategories: [],
          usedOfflineCache: false,
        ),
      ),
    );
  }
}
