import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'color_choice_chip.dart';

class ColorPicker extends StatefulWidget {
  final String label;
  final Map<String, Color> colorMap;
  final String? initialColorName;
  final ValueChanged<String> onColorSelected;

  const ColorPicker({
    Key? key,
    required this.label,
    required this.colorMap,
    this.initialColorName,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late String? _selectedColorName;

  @override
  void initState() {
    super.initState();
    _selectedColorName =
        widget.initialColorName ?? widget.colorMap.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: AppSpacing.xxs),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.colorMap.entries.map((entry) {
              final colorName = entry.key;
              final color = entry.value;
              final isSelected = colorName == _selectedColorName;

              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: ColorChoiceChip(
                  label: colorName,
                  color: color,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() => _selectedColorName = colorName);
                    widget.onColorSelected(colorName);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
