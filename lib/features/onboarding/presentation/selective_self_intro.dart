import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/selective_tab_view.dart';

/// 선택형 자기소개 페이지
class SelectiveSelfIntro extends ConsumerStatefulWidget {
  /// 생성자
  const SelectiveSelfIntro({super.key});

  @override
  ConsumerState<SelectiveSelfIntro> createState() => _SelectiveSelfIntroState();
}

class _SelectiveSelfIntroState extends ConsumerState<SelectiveSelfIntro> {
  // TODO: Repository 패턴 구현
  final questionTypes = ['연애', '결혼', '성격', '커리어', '생활'];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('onboarding.selectiveSelfIntro.title'.tr()),
          bottom: TabBar(
            tabs: questionTypes.map((type) => Text(type)).toList(),
            splashBorderRadius: AppRadius.iosStyleRadius,
          ),
        ),
        body: TabBarView(
          children: questionTypes.map((type) => SelectiveTabView()).toList(),
        ),
        floatingActionButton: DefaultFloatingButton(
          label: 'onboarding.selectiveSelfIntro.button.next',
          onPressed: () => context.go(AppRoute.home.path),
        ),
        floatingActionButtonLocation: .centerFloat,
      ),
    );
  }
}
