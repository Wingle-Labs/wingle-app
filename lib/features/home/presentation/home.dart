import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';

/// 홈 화면
class Home extends ConsumerStatefulWidget {
  /// 생성자
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
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
                HiveUtil.delete(HiveLoginBox.userId);
                HiveUtil.delete(HiveLoginBox.accessToken);
                HiveUtil.delete(HiveLoginBox.refreshToken);
              },
            ),
          ],
        ),
      ],
    );
  }
}
