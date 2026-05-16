import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/states/pagination.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';

/// Carousel, ListView 등에서 현재 인덱스를 표시하는 컴포넌트
class Indicator extends StatelessWidget {
  /// 현재 인덱스
  final int currentIndex;

  /// 전체 길이
  final int length;

  /// const 생성자
  const Indicator({
    super.key,
    required this.currentIndex,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .all(AppPadding.indicator),
      child: Pagination(
        currentIndex: currentIndex,
        length: length,
        variant: PaginationVariant.dot,
      ),
    );
  }
}
