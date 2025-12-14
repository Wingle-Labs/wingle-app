import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';

/// 콘텐츠의 최소 높이를 화면 높이로 보장하면서
/// 화면을 초과하는 경우에는 스크롤로 수용하는 Scaffold.
///
/// 내용이 적을 때는 화면을 꽉 채우고,
/// 내용이 많을 때는 자연스럽게 스크롤됩니다.
class ConstrainedScrollableScaffold extends ConsumerWidget {
  /// 스크롤 영역 안에 배치될 Widget
  final Widget child;

  /// 스크롤 가능한 제약형 Scaffold를 생성합니다.
  const ConstrainedScrollableScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // 컨텐츠의 최소 높이를 화면 높이로 맞춘다.
                // 내용이 적을 경우에도 하단이 떠 보이지 않게 한다.
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.scaffold),
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
