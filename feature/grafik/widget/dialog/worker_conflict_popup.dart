import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showWorkerConflictDialog(BuildContext context, List<String> workerIds) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Konflikt zadań'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Niektórzy pracownicy są już przypisani w tym czasie.'),
            const SizedBox(height: 12),
            Text('UID-y konfliktów:\n${workerIds.join(', ')}'),
            const SizedBox(height: 12),
            const Text('Czy chcesz dodać TimeIssue typu "Przeniesienie"?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Dodaj Przeniesienie'),
          ),
        ],
      );
    },
  );
}