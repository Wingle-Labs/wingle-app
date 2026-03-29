import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';

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
      body: <Widget>[Center(child: DefaultText('home.placeholder'))],
    );
  }
}
