import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/component_tokens.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';

/// 디자인 시스템 foundation 사용 규칙을 설명하는 Widgetbook 페이지.
class FoundationUsagePage extends StatelessWidget {
  /// 생성자
  const FoundationUsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      const _UsageSection(
        title: 'Color',
        role: 'context.colors semantic token을 통해 화면 의미를 표현합니다.',
        useWhen: '공용 컴포넌트, 화면, 상태 색상을 지정할 때 사용합니다.',
        avoid: '컴포넌트 내부에서 AppColorPalette를 직접 참조하지 않습니다.',
      ),
      const _UsageSection(
        title: 'Typography',
        role: 'context.typography와 DefaultText로 텍스트 계층을 유지합니다.',
        useWhen: '본문, 제목, caption, AppBar subtitle 계층을 지정할 때 사용합니다.',
        avoid: '화면마다 TextStyle을 새로 조합해 계층을 분산하지 않습니다.',
      ),
      const _UsageSection(
        title: 'Spacing / Padding',
        role:
            'AppSpacing/AppPadding은 primitive, AppComponent*는 역할 기반 token입니다.',
        useWhen: '반복되는 컴포넌트 간격은 AppComponentSpacing부터 검토합니다.',
        avoid: 'Figma 제원에 해당하는 숫자를 위젯에 직접 넣지 않습니다.',
      ),
      const _UsageSection(
        title: 'Radius / Size',
        role: 'corner radius, touch target, component height를 일관되게 관리합니다.',
        useWhen: 'input/card/sheet/button처럼 역할이 명확하면 AppComponent*를 사용합니다.',
        avoid: '동일 역할의 radius와 height를 private magic number로 복제하지 않습니다.',
      ),
      const _UsageSection(
        title: 'Elevation',
        role: 'surface 계층과 overlay 방향을 ThemeExtension으로 표현합니다.',
        useWhen: '카드, floating surface, modal처럼 계층이 필요한 surface에 사용합니다.',
        avoid: 'BoxShadow를 공용 컴포넌트 내부에 직접 정의하지 않습니다.',
      ),
      const _UsageSection(
        title: 'Grid',
        role: 'breakpoint와 grid preset을 분리해 responsive composition을 만듭니다.',
        useWhen: '화면 폭에 따라 column span이나 content width가 바뀔 때 사용합니다.',
        avoid: 'context.isTablet 같은 imperative 분기를 화면에 반복하지 않습니다.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Foundation Usage Guide')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        itemCount: sections.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _TokenSummaryCard();
          }
          return sections[index - 1];
        },
      ),
    );
  }
}

class _TokenSummaryCard extends StatelessWidget {
  const _TokenSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppComponentPadding.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Semantic Token Policy',
              style: TextStyle(
                fontSize: AppFontSize.title,
                fontWeight: AppFontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.s8),
            Text(
              'Primitive token은 foundation 문서와 token 구현부에서 사용하고, reusable component는 AppComponentPadding/Spacing/Radius/Size 같은 역할 기반 token을 우선 사용합니다.',
            ),
          ],
        ),
      ),
    );
  }
}

class _UsageSection extends StatelessWidget {
  final String title;
  final String role;
  final String useWhen;
  final String avoid;

  const _UsageSection({
    required this.title,
    required this.role,
    required this.useWhen,
    required this.avoid,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppComponentPadding.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: AppFontSize.main,
                fontWeight: AppFontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            _UsageLine(label: '역할', value: role),
            _UsageLine(label: '사용 시점', value: useWhen),
            _UsageLine(label: '금지 케이스', value: avoid),
          ],
        ),
      ),
    );
  }
}

class _UsageLine extends StatelessWidget {
  final String label;
  final String value;

  const _UsageLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s6),
      child: Text('$label: $value'),
    );
  }
}
