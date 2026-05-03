/// 어플리케이션의 공통 폰트 크기 정의
class AppFontSize {
  /// 캡션 크기
  static const double caption = 12;

  /// 서브 폰트 크기
  static const double sub = 14;

  /// 버튼 텍스트 크기
  static const double button = 16;

  /// 보통 폰트 크기
  static const double body = 16;

  /// 메인 폰트 크기
  static const double main = 18;

  /// 페이지 서브 타이틀 크기
  static const double subtitle = 20;

  /// 페이지 메인 타이틀 크기
  static const double title = 22;

  /// 앱 스플래시 텍스트 크기
  static const double headline = 40;

  /// 태그 텍스트 크기
  static const double tag = 10;
}

/// 배지 텍스트 크기 정의
class AppBadgeFontSize {
  /// 작은 배지 텍스트 크기
  static const double sm = 10;

  /// 중간 배지 텍스트 크기
  static const double md = 12;

  /// 큰 배지 텍스트 크기
  static const double lg = 14;
}

/// 어플리케이션의 공통 아이콘 크기 정의
class AppIconSize {
  /// xxs 아이콘 크기
  static const double xxs = 14;

  /// 가장 작은 아이콘 크기
  static const double xs = 16;

  /// 작은 아이콘 크기
  static const double sm = 20;

  /// 중간 아이콘 크기
  static const double md = 24;

  /// 큰 아이콘 크기
  static const double lg = 28;

  /// 매우 큰 아이콘 크기
  static const double xl = 32;

  /// 라디오 버튼 내부 원 크기
  static const double radioInner = 10;

  /// Radio normal 크기
  static const double radioNormal = sm;

  /// Radio small 크기
  static const double radioSmall = xs;

  /// Radio normal 내부 원 크기
  static const double radioInnerNormal = radioInner;

  /// Radio small 내부 원 크기
  static const double radioInnerSmall = 8;

  /// 모든 아이콘 크기
  static const List<double> values = [xxs, xs, sm, md, lg, xl];
}

/// 버튼 아이콘 frame 크기 정의
class AppIconButtonFrameSize {
  /// xxs frame
  static const double xxs = 16;

  /// xs frame
  static const double xs = 20;

  /// sm frame
  static const double sm = 24;

  /// md frame
  static const double md = 26;

  /// lg frame
  static const double lg = 32;

  /// 모든 frame 크기
  static const List<double> values = [xxs, xs, sm, md, lg];
}

/// 어플리케이션의 공통 아이콘 터치 영역 정의
class AppIconTouchSize {
  /// xxs 터치 영역
  static const double xxs = 20;

  /// xs 터치 영역
  static const double xs = 26;

  /// sm 터치 영역
  static const double sm = 32;

  /// 기본 터치 영역
  static const double md = 44;

  /// 강조 터치 영역
  static const double lg = 64;

  /// xl 터치 영역
  static const double xl = 72;

  /// 접근성을 위한 최소 터치 영역
  static const double minimum = 48;

  /// 모든 터치 영역
  static const List<double> values = [xxs, xs, sm, md, lg, xl, minimum];
}

/// 아이콘 제작 가이드용 픽셀 그리드 정의
class AppIconPixelGrid {
  /// xxs 아이콘 픽셀 그리드
  static const double xxs = 18;

  /// xs 아이콘 픽셀 그리드
  static const double xs = 20;

  /// sm 아이콘 픽셀 그리드
  static const double sm = 26;

  /// md 아이콘 픽셀 그리드
  static const double md = 32;

  /// lg 아이콘 픽셀 그리드
  static const double lg = 40;

  /// xl 아이콘 픽셀 그리드
  static const double xl = 44;

  /// 모든 픽셀 그리드
  static const List<double> values = [xxs, xs, sm, md, lg, xl];
}

/// 아이콘 제작 가이드용 원형 지름 정의
class AppIconCircleDiameter {
  /// xxs 아이콘 원형 지름
  static const double xxs = 15;

  /// xs 아이콘 원형 지름
  static const double xs = 18;

  /// sm 아이콘 원형 지름
  static const double sm = 22;

  /// md 아이콘 원형 지름
  static const double md = 26;

  /// lg 아이콘 원형 지름
  static const double lg = 32;

  /// xl 아이콘 원형 지름
  static const double xl = 36;

  /// 모든 원형 지름
  static const List<double> values = [xxs, xs, sm, md, lg, xl];
}

/// 아이콘 원형 keyline 지름 정의
class AppIconCircleKeyline {
  /// xxs 아이콘 원형 keyline 지름
  static const double xxs = AppIconCircleDiameter.xxs;

  /// xs 아이콘 원형 keyline 지름
  static const double xs = AppIconCircleDiameter.xs;

  /// sm 아이콘 원형 keyline 지름
  static const double sm = AppIconCircleDiameter.sm;

  /// md 아이콘 원형 keyline 지름
  static const double md = AppIconCircleDiameter.md;

  /// lg 아이콘 원형 keyline 지름
  static const double lg = AppIconCircleDiameter.lg;

  /// xl 아이콘 원형 keyline 지름
  static const double xl = AppIconCircleDiameter.xl;

  /// 모든 원형 keyline 지름
  static const List<double> values = [xxs, xs, sm, md, lg, xl];
}

/// 아이콘 제작 가이드용 정사각형 크기 정의
class AppIconSquareSize {
  /// xxs 아이콘 정사각형 크기
  static const double xxs = 14;

  /// xs 아이콘 정사각형 크기
  static const double xs = 16;

  /// sm 아이콘 정사각형 크기
  static const double sm = 20;

  /// md 아이콘 정사각형 크기
  static const double md = 24;

  /// lg 아이콘 정사각형 크기
  static const double lg = 28;

  /// xl 아이콘 정사각형 크기
  static const double xl = 32;

  /// 모든 정사각형 크기
  static const List<double> values = [xxs, xs, sm, md, lg, xl];
}

/// 아이콘 정사각형 keyline 크기 정의
class AppIconSquareKeyline {
  /// xxs 아이콘 정사각형 keyline 크기
  static const double xxs = AppIconSquareSize.xxs;

  /// xs 아이콘 정사각형 keyline 크기
  static const double xs = AppIconSquareSize.xs;

  /// sm 아이콘 정사각형 keyline 크기
  static const double sm = AppIconSquareSize.sm;

  /// md 아이콘 정사각형 keyline 크기
  static const double md = AppIconSquareSize.md;

  /// lg 아이콘 정사각형 keyline 크기
  static const double lg = AppIconSquareSize.lg;

  /// xl 아이콘 정사각형 keyline 크기
  static const double xl = AppIconSquareSize.xl;

  /// 모든 정사각형 keyline 크기
  static const List<double> values = [xxs, xs, sm, md, lg, xl];
}

/// 배지 높이 정의
class AppBadgeHeight {
  /// 작은 배지 높이
  static const double sm = 18;

  /// 중간 배지 높이
  static const double md = 24;

  /// 큰 배지 높이
  static const double lg = 28;

  /// 모든 배지 높이
  static const List<double> values = [sm, md, lg];
}

/// 아이콘 제작 가이드용 가로 직사각형 크기 정의
class AppIconHorizontalRectSize {
  /// xxs 아이콘 가로 직사각형 너비
  static const double xxsWidth = 16;

  /// xxs 아이콘 가로 직사각형 높이
  static const double xxsHeight = 12;

  /// xs 아이콘 가로 직사각형 너비
  static const double xsWidth = 18;

  /// xs 아이콘 가로 직사각형 높이
  static const double xsHeight = 14;

  /// sm 아이콘 가로 직사각형 너비
  static const double smWidth = 25;

  /// sm 아이콘 가로 직사각형 높이
  static const double smHeight = 18;

  /// md 아이콘 가로 직사각형 너비
  static const double mdWidth = 28;

  /// md 아이콘 가로 직사각형 높이
  static const double mdHeight = 20;

  /// lg 아이콘 가로 직사각형 너비
  static const double lgWidth = 35;

  /// lg 아이콘 가로 직사각형 높이
  static const double lgHeight = 24;

  /// xl 아이콘 가로 직사각형 너비
  static const double xlWidth = 36;

  /// xl 아이콘 가로 직사각형 높이
  static const double xlHeight = 28;
}

/// 아이콘 가로 직사각형 keyline 크기 정의
class AppIconHorizontalRectKeyline {
  /// xxs 아이콘 가로 직사각형 keyline 너비
  static const double xxsWidth = AppIconHorizontalRectSize.xxsWidth;

  /// xxs 아이콘 가로 직사각형 keyline 높이
  static const double xxsHeight = AppIconHorizontalRectSize.xxsHeight;

  /// xs 아이콘 가로 직사각형 keyline 너비
  static const double xsWidth = AppIconHorizontalRectSize.xsWidth;

  /// xs 아이콘 가로 직사각형 keyline 높이
  static const double xsHeight = AppIconHorizontalRectSize.xsHeight;

  /// sm 아이콘 가로 직사각형 keyline 너비
  static const double smWidth = AppIconHorizontalRectSize.smWidth;

  /// sm 아이콘 가로 직사각형 keyline 높이
  static const double smHeight = AppIconHorizontalRectSize.smHeight;

  /// md 아이콘 가로 직사각형 keyline 너비
  static const double mdWidth = AppIconHorizontalRectSize.mdWidth;

  /// md 아이콘 가로 직사각형 keyline 높이
  static const double mdHeight = AppIconHorizontalRectSize.mdHeight;

  /// lg 아이콘 가로 직사각형 keyline 너비
  static const double lgWidth = AppIconHorizontalRectSize.lgWidth;

  /// lg 아이콘 가로 직사각형 keyline 높이
  static const double lgHeight = AppIconHorizontalRectSize.lgHeight;

  /// xl 아이콘 가로 직사각형 keyline 너비
  static const double xlWidth = AppIconHorizontalRectSize.xlWidth;

  /// xl 아이콘 가로 직사각형 keyline 높이
  static const double xlHeight = AppIconHorizontalRectSize.xlHeight;
}

/// 아이콘 제작 가이드용 세로 직사각형 크기 정의
class AppIconVerticalRectSize {
  /// xxs 아이콘 세로 직사각형 너비
  static const double xxsWidth = 12;

  /// xxs 아이콘 세로 직사각형 높이
  static const double xxsHeight = 16;

  /// xs 아이콘 세로 직사각형 너비
  static const double xsWidth = 14;

  /// xs 아이콘 세로 직사각형 높이
  static const double xsHeight = 18;

  /// sm 아이콘 세로 직사각형 너비
  static const double smWidth = 18;

  /// sm 아이콘 세로 직사각형 높이
  static const double smHeight = 25;

  /// md 아이콘 세로 직사각형 너비
  static const double mdWidth = 20;

  /// md 아이콘 세로 직사각형 높이
  static const double mdHeight = 28;

  /// lg 아이콘 세로 직사각형 너비
  static const double lgWidth = 24;

  /// lg 아이콘 세로 직사각형 높이
  static const double lgHeight = 32;

  /// xl 아이콘 세로 직사각형 너비
  static const double xlWidth = 28;

  /// xl 아이콘 세로 직사각형 높이
  static const double xlHeight = 36;
}

/// 아이콘 세로 직사각형 keyline 크기 정의
class AppIconVerticalRectKeyline {
  /// xxs 아이콘 세로 직사각형 keyline 너비
  static const double xxsWidth = AppIconVerticalRectSize.xxsWidth;

  /// xxs 아이콘 세로 직사각형 keyline 높이
  static const double xxsHeight = AppIconVerticalRectSize.xxsHeight;

  /// xs 아이콘 세로 직사각형 keyline 너비
  static const double xsWidth = AppIconVerticalRectSize.xsWidth;

  /// xs 아이콘 세로 직사각형 keyline 높이
  static const double xsHeight = AppIconVerticalRectSize.xsHeight;

  /// sm 아이콘 세로 직사각형 keyline 너비
  static const double smWidth = AppIconVerticalRectSize.smWidth;

  /// sm 아이콘 세로 직사각형 keyline 높이
  static const double smHeight = AppIconVerticalRectSize.smHeight;

  /// md 아이콘 세로 직사각형 keyline 너비
  static const double mdWidth = AppIconVerticalRectSize.mdWidth;

  /// md 아이콘 세로 직사각형 keyline 높이
  static const double mdHeight = AppIconVerticalRectSize.mdHeight;

  /// lg 아이콘 세로 직사각형 keyline 너비
  static const double lgWidth = AppIconVerticalRectSize.lgWidth;

  /// lg 아이콘 세로 직사각형 keyline 높이
  static const double lgHeight = AppIconVerticalRectSize.lgHeight;

  /// xl 아이콘 세로 직사각형 keyline 너비
  static const double xlWidth = AppIconVerticalRectSize.xlWidth;

  /// xl 아이콘 세로 직사각형 keyline 높이
  static const double xlHeight = AppIconVerticalRectSize.xlHeight;
}

/// 아이콘 크기별 디자인 시스템 제원
class AppIconSpec {
  /// 아이콘 슬롯 크기
  final double icon;

  /// 터치 영역 크기
  final double touch;

  /// 픽셀 그리드 크기
  final double pixelGrid;

  /// 원형 아이콘 지름
  final double circleDiameter;

  /// 원형 keyline 지름
  double get circleKeyline => circleDiameter;

  /// 정사각형 아이콘 크기
  final double square;

  /// 정사각형 keyline 크기
  double get squareKeyline => square;

  /// 가로 직사각형 아이콘 너비
  final double horizontalRectWidth;

  /// 가로 직사각형 keyline 너비
  double get horizontalRectKeylineWidth => horizontalRectWidth;

  /// 가로 직사각형 아이콘 높이
  final double horizontalRectHeight;

  /// 가로 직사각형 keyline 높이
  double get horizontalRectKeylineHeight => horizontalRectHeight;

  /// 세로 직사각형 아이콘 너비
  final double verticalRectWidth;

  /// 세로 직사각형 keyline 너비
  double get verticalRectKeylineWidth => verticalRectWidth;

  /// 세로 직사각형 아이콘 높이
  final double verticalRectHeight;

  /// 세로 직사각형 keyline 높이
  double get verticalRectKeylineHeight => verticalRectHeight;

  /// 생성자
  const AppIconSpec({
    required this.icon,
    required this.touch,
    required this.pixelGrid,
    required this.circleDiameter,
    required this.square,
    required this.horizontalRectWidth,
    required this.horizontalRectHeight,
    required this.verticalRectWidth,
    required this.verticalRectHeight,
  });

  /// xxs 아이콘 제원
  static const AppIconSpec xxs = AppIconSpec(
    icon: AppIconSize.xxs,
    touch: AppIconTouchSize.xxs,
    pixelGrid: AppIconPixelGrid.xxs,
    circleDiameter: AppIconCircleDiameter.xxs,
    square: AppIconSquareSize.xxs,
    horizontalRectWidth: AppIconHorizontalRectSize.xxsWidth,
    horizontalRectHeight: AppIconHorizontalRectSize.xxsHeight,
    verticalRectWidth: AppIconVerticalRectSize.xxsWidth,
    verticalRectHeight: AppIconVerticalRectSize.xxsHeight,
  );

  /// xs 아이콘 제원
  static const AppIconSpec xs = AppIconSpec(
    icon: AppIconSize.xs,
    touch: AppIconTouchSize.xs,
    pixelGrid: AppIconPixelGrid.xs,
    circleDiameter: AppIconCircleDiameter.xs,
    square: AppIconSquareSize.xs,
    horizontalRectWidth: AppIconHorizontalRectSize.xsWidth,
    horizontalRectHeight: AppIconHorizontalRectSize.xsHeight,
    verticalRectWidth: AppIconVerticalRectSize.xsWidth,
    verticalRectHeight: AppIconVerticalRectSize.xsHeight,
  );

  /// sm 아이콘 제원
  static const AppIconSpec sm = AppIconSpec(
    icon: AppIconSize.sm,
    touch: AppIconTouchSize.sm,
    pixelGrid: AppIconPixelGrid.sm,
    circleDiameter: AppIconCircleDiameter.sm,
    square: AppIconSquareSize.sm,
    horizontalRectWidth: AppIconHorizontalRectSize.smWidth,
    horizontalRectHeight: AppIconHorizontalRectSize.smHeight,
    verticalRectWidth: AppIconVerticalRectSize.smWidth,
    verticalRectHeight: AppIconVerticalRectSize.smHeight,
  );

  /// md 아이콘 제원
  static const AppIconSpec md = AppIconSpec(
    icon: AppIconSize.md,
    touch: AppIconTouchSize.md,
    pixelGrid: AppIconPixelGrid.md,
    circleDiameter: AppIconCircleDiameter.md,
    square: AppIconSquareSize.md,
    horizontalRectWidth: AppIconHorizontalRectSize.mdWidth,
    horizontalRectHeight: AppIconHorizontalRectSize.mdHeight,
    verticalRectWidth: AppIconVerticalRectSize.mdWidth,
    verticalRectHeight: AppIconVerticalRectSize.mdHeight,
  );

  /// lg 아이콘 제원
  static const AppIconSpec lg = AppIconSpec(
    icon: AppIconSize.lg,
    touch: AppIconTouchSize.lg,
    pixelGrid: AppIconPixelGrid.lg,
    circleDiameter: AppIconCircleDiameter.lg,
    square: AppIconSquareSize.lg,
    horizontalRectWidth: AppIconHorizontalRectSize.lgWidth,
    horizontalRectHeight: AppIconHorizontalRectSize.lgHeight,
    verticalRectWidth: AppIconVerticalRectSize.lgWidth,
    verticalRectHeight: AppIconVerticalRectSize.lgHeight,
  );

  /// xl 아이콘 제원
  static const AppIconSpec xl = AppIconSpec(
    icon: AppIconSize.xl,
    touch: AppIconTouchSize.xl,
    pixelGrid: AppIconPixelGrid.xl,
    circleDiameter: AppIconCircleDiameter.xl,
    square: AppIconSquareSize.xl,
    horizontalRectWidth: AppIconHorizontalRectSize.xlWidth,
    horizontalRectHeight: AppIconHorizontalRectSize.xlHeight,
    verticalRectWidth: AppIconVerticalRectSize.xlWidth,
    verticalRectHeight: AppIconVerticalRectSize.xlHeight,
  );

  /// 모든 아이콘 제원
  static const List<AppIconSpec> values = [xxs, xs, sm, md, lg, xl];

  /// 아이콘 슬롯 크기에서 제원을 찾습니다.
  static AppIconSpec fromIconSize(double iconSize) {
    return switch (iconSize) {
      AppIconSize.xxs => xxs,
      AppIconSize.xs => xs,
      AppIconSize.sm => sm,
      AppIconSize.md => md,
      AppIconSize.lg => lg,
      AppIconSize.xl => xl,
      _ => AppIconSpec(
        icon: iconSize,
        touch: iconSize,
        pixelGrid: iconSize * 1.25,
        circleDiameter: iconSize,
        square: iconSize,
        horizontalRectWidth: iconSize,
        horizontalRectHeight: iconSize,
        verticalRectWidth: iconSize,
        verticalRectHeight: iconSize,
      ),
    };
  }
}

/// 어플리케이션의 공통 높이 정의
class AppContainerSize {
  /// indicator
  static const double indicator = 6;

  /// Pagination dot 크기
  static const double paginationDot = 6;

  /// Pagination line 높이
  static const double paginationLine = 6;

  /// Pagination line 너비
  static const double paginationLineWidth = 50;

  /// 작은 높이
  static const double small = 40;

  /// 버튼 최소 길이
  static const double buttonMinimun = 54;

  /// 기본 버튼 높이
  static const double buttonHeight = 48;

  /// 가장 큰 버튼 높이
  static const double buttonXLargeHeight = 54;

  /// 중간 버튼 높이
  static const double buttonMediumHeight = 40;

  /// 작은 버튼 높이
  static const double buttonSmallHeight = 36;

  /// Chip 형태 버튼 높이
  static const double buttonChipHeight = 32;

  /// 버튼 내부 아이콘 슬롯 크기
  static const double buttonIconSlot = 16;

  /// 입력 필드 최소 높이
  static const double inputFieldMinimun = 48;

  /// 중간 높이
  static const double regular = 56;

  /// 큰 높이
  static const double large = 64;

  /// 매우 큰 높이
  static const double xl = 128;

  /// Indicator Container 높이
  static const double indicatorContainer = 44;

  /// Indicator Description Widget 높이
  static const double indicatorDescription = 180;

  /// Indicator Image Widget 높이
  static const double indicatorImage = 190;

  /// Carousel Contaier 길이
  static const double carouselContainer = 343;

  /// Carousel Image 길이
  static const double carouselImageContainer = 180;

  /// wrap
  static const double wrap = 300;

  /// vertical divider
  static const double verticalDividerHeight = 10;

  /// Divider 기본 가로 길이
  static const double dividerHorizontalLength = double.infinity;

  /// Divider 기본 세로 길이
  static const double dividerVerticalLength = 32;

  /// Bottom Sheet handle 길이
  static const double bottomSheetHandleWidth = 42;

  /// Tag 최소 너비
  static const double tagMinWidth = 44;

  /// Tag 최소 높이
  static const double tagMinHeight = 20;

  /// Card 최소 높이
  static const double cardMinHeight = 48;

  /// Toggle Switch 너비
  static const double toggleSwitchWidth = 58;

  /// Toggle Switch 높이
  static const double toggleSwitchHeight = 24;

  /// Toggle Switch thumb 크기
  static const double toggleSwitchThumb = 33;

  /// Toggle Switch 내부 여백
  static const double toggleSwitchInset = 2;

  /// Toggle Icon 크기
  static const double toggleIcon = 20;

  /// Toggle Icon 점선 간격
  static const double toggleIconDash = 4;

  /// Toggle Icon 점선 공백
  static const double toggleIconDashGap = 4;
}

/// 어플리케이션 내 선 두께 정의
class AppLineWidth {
  /// 테두리 두께
  static const double outline = 1.2;

  /// 입력 필드 테두리 두께
  static const double inputFieldOutline = 1.4;

  /// 입력 필드 커서 두께
  static const double inputFieldCursor = 1.0;

  /// Bottom Sheet handle 두께
  static const double bottomSheetHandleHeight = 4;

  /// Radio button border 두께
  static const double radioButtonBorder = 1.4;

  /// Toggle Icon border 두께
  static const double toggleIconBorder = 1.4;

  /// Divider 기본 두께
  static const double dividerNormal = 1;

  /// Divider 두꺼운 영역 두께
  static const double dividerThick = 12;
}
