import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/common/utils/auth_session_state.dart';

/// 홈 화면
class Home extends StatelessWidget {
  /// 생성자
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollableScaffold(
      title: 'home.title',
      body: <Widget>[
        Column(
          children: [
            DefaultText('home.placeholder'),
            DefaultFilledButton(
              label: "로그아웃",
              onPressed: () {
                unawaited(AuthSessionState.clearLoginInfo());
              },
            ),
          ],
        ),
      ],
    );
  }
}
