import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

enum ControlDirection { increase, decrease }

class SmallNumberControls extends StatelessWidget {
  final ControlDirection direction;
  final int current;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const SmallNumberControls({
    Key? key,
    required this.direction,
    required this.current,
    required this.min,
    required this.max,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deltas = direction == ControlDirection.decrease ? [-3, -2, -1] : [1, 2, 3];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: deltas.map((delta) {
        final newValue = (current + delta).clamp(min, max);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          child: ElevatedButton(
            onPressed: () => onChanged(newValue),
            child: Text(delta > 0 ? '+$delta' : '$delta'),
          ),
        );
      }).toList(),
    );
  }
}
