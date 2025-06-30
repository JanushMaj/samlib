import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (_) { // zmieniono z 7 na 5 kolumn
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: AppSpacing.borderThin,
                ),
              ),
              color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
            ),
          ),
        );
      }),
    );
  }
}
