import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_outlined_input_field.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 프로필 입력 플로우에서 사용하는 검색형 입력 필드.
class ProfileInputSearchField extends StatelessWidget {
  /// 힌트 텍스트
  final String hintText;

  /// 입력 값 변경 콜백
  final ValueChanged<String>? onChanged;

  /// 입력 컨트롤러
  final TextEditingController? controller;

  /// 입력 필드 초기값
  final String? initialValue;

  /// 에러 텍스트
  final String? errorText;

  /// 입력 포맷터
  final List<TextInputFormatter>? inputFormatters;

  /// 비활성화 여부
  final bool isDisabled;

  /// 읽기 전용 여부
  final bool readOnly;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 클리어 버튼 표시 여부
  final bool showClearButton;

  /// 클리어 버튼 콜백
  final VoidCallback? onClear;

  /// 생성자
  const ProfileInputSearchField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.errorText,
    this.inputFormatters,
    this.isDisabled = false,
    this.readOnly = false,
    this.onTap,
    this.showClearButton = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DefaultOutlinedInputField(
      controller: controller,
      initialValue: initialValue,
      hintText: hintText,
      errorText: errorText,
      keyboardType: TextInputType.text,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      isDisabled: isDisabled,
      readOnly: readOnly,
      onTap: onTap,
      showClearButton: showClearButton,
      onClear: onClear,
      policy: .cappedMedium,
      prefix: Icon(
        Icons.search_rounded,
        applyTextScaling: true,
        size: AppIconSize.md,
        color: colors.textNeutral,
      ),
    );
  }
}
