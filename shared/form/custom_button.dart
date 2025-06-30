import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDisabled;
  final double maxFontSize;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isDisabled = false,
    this.maxFontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: TextButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: AutoSizeText(
          text,
          maxFontSize: maxFontSize,
          minFontSize: 8,
          maxLines: 1,
          style: TextStyle(
            color: isPrimary ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
