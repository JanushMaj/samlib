import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

import 'standard_form_field.dart';

class StandardFormSection extends StatelessWidget {
  final String? header;
  final List<StandardFormField> fields;

  const StandardFormSection({
    Key? key,
    this.header,
    required this.fields,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final children = <Widget>[];
    if (header != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(header!, style: theme.textTheme.bodyLarge),
        ),
      );
    }

    for (var i = 0; i < fields.length; i++) {
      if (i > 0) {
        children.add(const SizedBox(height: AppSpacing.sm));
      }
      children.add(fields[i]);
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
