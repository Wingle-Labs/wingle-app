import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/features/home/route/home_routes.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/selective_tab_view.dart';
import 'package:wingle/features/onboarding/presentation/data/selective_self_intro_mock_data.dart';

/// 선택형 자기소개 페이지
class SelectiveSelfIntro extends ConsumerStatefulWidget {
  /// 생성자
  const SelectiveSelfIntro({super.key});

  @override
  ConsumerState<SelectiveSelfIntro> createState() => _SelectiveSelfIntroState();
}

class _SelectiveSelfIntroState extends ConsumerState<SelectiveSelfIntro> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: selectiveSelfIntroTabKeys.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('onboarding.selectiveSelfIntro.title'.tr()),
          bottom: TabBar(
            tabs: selectiveSelfIntroTabKeys
                .map((type) => Text(type.tr()))
                .toList(),
            splashBorderRadius: AppRadius.iosStyleRadius,
          ),
        ),
        body: TabBarView(
          children: selectiveSelfIntroTabKeys
              .map((type) => SelectiveTabView())
              .toList(),
        ),
        floatingActionButton: DefaultFloatingButton(
          label: 'onboarding.selectiveSelfIntro.button.next',
          onPressed: () => context.goNamed(HomeRoutes.root.name),
        ),
        floatingActionButtonLocation: .centerFloat,
      ),
    );
  }
}
