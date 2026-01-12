import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'carousel_index_provider.g.dart';

/// Carousel의 현재 인덱스를 관리하는 Provider
@riverpod
class CarouselIndex extends _$CarouselIndex {
  @override
  int build() => 0;

  /// Carousel의 현재 인덱스를 업데이트하는 메소드
  void updateIndex(int index) {
    state = index;
  }

  /// Carousel의 현재 인덱스를 증가하는 메소드
  void incrementIndex() {
    state++;
  }
}
