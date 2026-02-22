import 'package:flutter/material.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 컬러 스타일을 확인할 수 있는 페이지
class ColorPage extends StatelessWidget {
  /// 생성자
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Color Foundation')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Caption
          Text(
            """색상 값: onColor 쌍이 있는 경우, 명시된 onColor가 텍스트에 적용됩니다.
그렇지 않은 경우 autoContrast를 적용한 텍스트가 보여집니다.""",
            style: TextStyle(color: context.colors.textSecondary),
          ),
          _section(
            title: 'Primary',
            children: _buildPairTiles([
              _ColorInfo(
                name: 'primary',
                color: colors.primary,
                explicitOnColor: colors.onPrimary,
              ),
              _ColorInfo(
                name: 'secondary',
                color: colors.secondary,
                explicitOnColor: colors.onSecondary,
              ),
            ]),
          ),
          _section(
            title: 'Text',
            children: [
              _singleTile(name: 'textPrimary', onColor: colors.textPrimary),
              _singleTile(name: 'textSecondary', onColor: colors.textSecondary),
              _singleTile(name: 'textTertiary', onColor: colors.textTertiary),
              _singleTile(name: 'textDisabled', onColor: colors.textDisabled),
              _singleTile(name: 'textInactive', onColor: colors.textInactive),
              _singleTile(
                name: 'textDisabledStrong',
                onColor: colors.textDisabledStrong,
              ),
            ],
          ),
          _section(
            title: 'Surface',
            children: _buildPairTiles([
              _ColorInfo(name: 'background', color: colors.background),
              _ColorInfo(name: 'surface', color: colors.surface),
              _ColorInfo(name: 'surfaceVariant', color: colors.surfaceVariant),
              _ColorInfo(
                name: 'surfaceElevated',
                color: colors.surfaceElevated,
              ),
              _ColorInfo(
                name: 'surfaceDisabled',
                color: colors.surfaceDisabled,
              ),
              _ColorInfo(
                name: 'surfaceDisabledSubtle',
                color: colors.surfaceDisabledSubtle,
              ),
            ]),
          ),
          _section(
            title: 'Feedback',
            children: _buildPairTiles([
              _ColorInfo(
                name: 'error',
                color: colors.error,
                explicitOnColor: colors.onError,
              ),
              _ColorInfo(
                name: 'success',
                color: colors.success,
                explicitOnColor: colors.onSuccess,
              ),
              _ColorInfo(
                name: 'warning',
                color: colors.warning,
                explicitOnColor: colors.onWarning,
              ),
              _ColorInfo(
                name: 'info',
                color: colors.info,
                explicitOnColor: colors.onInfo,
              ),
              _ColorInfo(
                name: 'cancel',
                color: colors.cancel,
                explicitOnColor: colors.onCancel,
              ),
            ]),
          ),
          _section(
            title: 'Overlay & Border',
            children: _buildPairTiles([
              _ColorInfo(name: 'border', color: colors.border),
              _ColorInfo(name: 'divider', color: colors.divider),
              _ColorInfo(name: 'scrim', color: colors.scrim),
              _ColorInfo(name: 'overlayPressed', color: colors.overlayPressed),
              _ColorInfo(
                name: 'overlayDisabled',
                color: colors.overlayDisabled,
              ),
              _ColorInfo(name: 'overlayLoading', color: colors.overlayLoading),
            ]),
          ),
          _section(
            title: 'State Button',
            children: _buildPairTiles([
              _ColorInfo(
                name: 'stateBtnSelected',
                color: colors.stateBtnSelected,
              ),
              _ColorInfo(
                name: 'stateBtnUnselected',
                color: colors.stateBtnUnselected,
              ),
              _ColorInfo(
                name: 'stateBtnDisabled',
                color: colors.stateBtnDisabled,
              ),
            ]),
          ),
          _section(
            title: 'Button',
            children: _buildPairTiles([
              _ColorInfo(name: 'btnDefault', color: colors.btnDefault),
              _ColorInfo(name: 'btnDisabled', color: colors.btnDisabled),
            ]),
          ),
          _section(
            title: 'Profile Badge',
            children: _buildPairTiles([
              _ColorInfo(
                name: 'profileStatusBadgeDefault',
                color: colors.profileStatusBadgeDefault,
              ),
              _ColorInfo(
                name: 'profileStatusBadgeDisabled',
                color: colors.profileStatusBadgeDisabled,
              ),
            ]),
          ),
          _section(
            title: 'Primary Scale',
            children: _buildPairTiles([
              _ColorInfo(name: 'primaryScale90', color: colors.primaryScale90),
              _ColorInfo(name: 'primaryScale70', color: colors.primaryScale70),
              _ColorInfo(name: 'primaryScale50', color: colors.primaryScale50),
              _ColorInfo(name: 'primaryScale30', color: colors.primaryScale30),
              _ColorInfo(name: 'primaryScale10', color: colors.primaryScale10),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  List<Widget> _buildPairTiles(List<_ColorInfo> colorInfos) {
    return colorInfos.map((info) {
      final hasExplicitOnColor = info.explicitOnColor != null;
      final onColor = info.explicitOnColor ?? _autoContrast(info.color);

      return _ColorTile(
        name: hasExplicitOnColor
            ? '${info.name} : on${_capitalize(info.name)}'
            : info.name,
        color: info.color,
        onColor: onColor,
      );
    }).toList();
  }

  Widget _singleTile({required String name, required Color onColor}) {
    final color = _autoContrast(onColor);

    return _ColorTile(name: name, color: color, onColor: onColor, isText: true);
  }

  Color _autoContrast(Color background) {
    final brightness = ThemeData.estimateBrightnessForColor(background);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}

class _ColorInfo {
  final String name;
  final Color color;
  final Color? explicitOnColor;

  _ColorInfo({required this.name, required this.color, this.explicitOnColor});
}

class _ColorTile extends StatelessWidget {
  final String name;
  final Color color;
  final Color onColor;
  final bool isText;

  const _ColorTile({
    required this.name,
    required this.color,
    required this.onColor,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    final hex =
        """#${(isText ? onColor : color).toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}""";

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isText ? context.colors.surfaceElevated : color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: onColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(name), Text(hex)],
        ),
      ),
    );
  }
}
