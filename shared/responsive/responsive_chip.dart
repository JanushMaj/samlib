import 'package:flutter/material.dart';

class ResponsiveChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;

  const ResponsiveChip({
    super.key,
    required this.label,
    this.icon,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: textColor),
          ),
        ),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      labelPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
