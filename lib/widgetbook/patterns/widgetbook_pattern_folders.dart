import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/widgetbook/screens/widgetbook_placeholder_page.dart';

/// Widgetbook의 feature composition / pattern 폴더를 구성한다.
WidgetbookFolder buildPatternFolder() {
  return WidgetbookFolder(
    name: 'Patterns',
    children: [
      WidgetbookComponent(
        name: 'Onboarding',
        useCases: [
          WidgetbookUseCase(
            name: 'Composition Boundary',
            builder: (context) => const WidgetbookPlaceholderPage(
              title: 'Onboarding Patterns',
              description:
                  '온보딩 전용 조합 컴포넌트는 features/onboarding/presentation/components에 두고, 디자인 시스템 컴포넌트는 lib/app/config/theme/components에 유지합니다.',
            ),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Auth',
        useCases: [
          WidgetbookUseCase(
            name: 'Composition Boundary',
            builder: (context) => const WidgetbookPlaceholderPage(
              title: 'Auth Patterns',
              description:
                  '로그인/회원가입 플로우 조합은 feature layer에 두고, 버튼/input/AppBar 같은 반복 UI만 component layer로 승격합니다.',
            ),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Profile',
        useCases: [
          WidgetbookUseCase(
            name: 'Composition Boundary',
            builder: (context) => const WidgetbookPlaceholderPage(
              title: 'Profile Patterns',
              description:
                  '프로필 작성/심사/재심사 조합은 profile/onboarding feature 경계 안에 유지하고, 재사용 가능한 surface만 디자인 시스템으로 분리합니다.',
            ),
          ),
        ],
      ),
    ],
  );
}
