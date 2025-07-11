import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// Nowy import
import 'package:kabast/theme/app_tokens.dart';

import '../../domain/models/employee.dart';

class EmployeeTile extends StatelessWidget {
  final Employee employee;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;

  const EmployeeTile({
    Key? key,
    required this.employee,
    required this.isSelected,
    required this.onTap,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Splitting fullName => "Nazwisko Imię"
    final parts = employee.fullName.split(' ');
    final surname = parts.isNotEmpty ? parts[0] : employee.fullName;
    final initial = parts.length > 1 ? parts[1].substring(0, 1) : '';
    final displayText = initial.isNotEmpty ? '$initial $surname' : surname;

    // Tło i ramka zależne od isSelected
    final bgColor = isDisabled
        ? Theme.of(context).disabledColor.withAlpha(AppSpacing.alphaLow)
        : isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).cardColor;

    final borderColor = isDisabled
        ? Colors.transparent
        : isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs), // 2.0
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.md), // 4.0
          border: Border.all(
            color: borderColor,
            width: AppSpacing.borderMedium,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              child: AutoSizeText(
                displayText,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                minFontSize: 8,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ),
      ),
    );
  }
}
