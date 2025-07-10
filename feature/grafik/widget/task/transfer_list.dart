import 'package:flutter/material.dart';
import 'package:kabast/shared/responsive/responsive_single_line_text.dart';
import 'package:kabast/theme/theme.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';

class TransferList extends StatelessWidget {
  final List<String> transferInfo;

  const TransferList({
    Key? key,
    required this.transferInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: transferInfo.map((info) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppTheme.sizeFor(context.breakpoint, 2.0),
          ),
          child: ResponsiveSingleLineText(
            text: info,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: AppTheme.sizeFor(context.breakpoint, 12),
              fontStyle: FontStyle.italic,
              color: Colors.purple,
            ),
          ),
        );
      }).toList(),
    );
  }
}
