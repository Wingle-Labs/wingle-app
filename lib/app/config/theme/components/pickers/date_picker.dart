import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/providers/localization_provider.dart';

/// 커스텀 날짜 선택 컴포넌트
class DatePicker extends ConsumerWidget {
  /// 현재 날짜
  final DateTime selectedDate;

  /// 최대 날짜
  final DateTime maximumDate;

  /// 최소 날짜
  final DateTime minimumDate;

  /// 날짜 변경 콜백
  final Function(DateTime) onDateTimeChanged;

  /// 생성자
  const DatePicker({
    super.key,
    required this.selectedDate,
    required this.maximumDate,
    required this.minimumDate,
    required this.onDateTimeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(localizationProvider);
    return SmoothRectWrapper(
      child: SizedBox(
        height: AppContainerSize.xl,
        child: ScrollDatePicker(
          selectedDate: selectedDate,
          maximumDate: maximumDate,
          minimumDate: minimumDate,
          onDateTimeChanged: onDateTimeChanged,
          options: DatePickerOptions(
            backgroundColor: theme.scaffoldBackgroundColor,
            isLoop: false,
          ),
          scrollViewOptions: DatePickerScrollViewOptions(
            mainAxisAlignment: .spaceEvenly,
            year: ScrollViewDetailOptions(
              selectedTextStyle: TextStyle(
                fontSize: AppFontSize.large,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
              textStyle: TextStyle(fontSize: AppFontSize.medium),
            ),
            month: ScrollViewDetailOptions(
              selectedTextStyle: TextStyle(
                fontSize: AppFontSize.large,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
              textStyle: TextStyle(fontSize: AppFontSize.medium),
            ),
            day: ScrollViewDetailOptions(
              selectedTextStyle: TextStyle(
                fontSize: AppFontSize.large,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
              textStyle: TextStyle(fontSize: AppFontSize.medium),
            ),
          ),
          locale: locale,
        ),
      ),
    );
  }
}
