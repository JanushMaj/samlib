import 'dart:math';
import 'package:kabast/domain/models/emplyee.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';

Map<String, List<String>> calculateTaskTimeIssueDisplayMapping({
  required List<TaskElement> tasks,
  required List<TimeIssueElement> issues,
  required List<Employee> employees,
}) {
  final mapping = <String, List<String>>{};

  for (var task in tasks) {
    final displayStrings = <String>[];

    // Zostawiamy tylko kwestie czasowe które potencjalnie mają coś wspólnego z taskiem
    for (var issue in issues) {
      final overlapStart = max(
        task.startDateTime.millisecondsSinceEpoch,
        issue.startDateTime.millisecondsSinceEpoch,
      );
      final overlapEnd = min(
        task.endDateTime.millisecondsSinceEpoch,
        issue.endDateTime.millisecondsSinceEpoch,
      );
      final overlapDuration = Duration(milliseconds: overlapEnd - overlapStart);
      if (overlapDuration.inMinutes <= 0) continue;

      final workerId = issue.workerId;
      if (!task.workerIds.contains(workerId)) continue;

      try {
        final employee = employees.firstWhere((e) => e.uid == workerId);
        final surname = employee.fullName.split(' ').first;
        final typeDisplay = issue.issueType.name;
        final start = issue.startDateTime;
        final end = issue.endDateTime;
        final timeRange =
            "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}-"
            "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}";
        final displayText = "$surname $typeDisplay $timeRange";
        displayStrings.add(displayText);
      } catch (_) {
        continue;
      }
    }

    mapping[task.id] = displayStrings;
  }

  return mapping;
}


/// NOWA METODA – calculateTaskTransferDisplayMapping (tylko na TaskElementach)
/// Dla każdego pracownika szukamy wszystkich tasków, w których jest przypisany.
/// Jeśli dla danego pracownika kolejny task zaczyna się, zanim poprzedni się skończy,
/// dodajemy komunikat transferowy do wcześniejszego taska.
/// Format komunikatu: "Przeniesienie <surname> na <ID Taska docelowego> o godzinie XX:XX"
Map<String, List<String>> calculateTaskTransferDisplayMapping({
  required List<TaskElement> tasks,
  required List<Employee> employees,
}) {
  final mapping = <String, List<String>>{};

  // Dla każdego pracownika sprawdzamy, w jakich taskach jest obecny
  for (var employee in employees) {
    // Filtrujemy taski, w których pracownik jest przypisany
    final workerTasks = tasks.where((task) => task.workerIds.contains(employee.uid)).toList();
    if (workerTasks.isEmpty) continue;
    // Sortujemy taski wg. czasu rozpoczęcia
    workerTasks.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

    // Dla kolejnych tasków (w obrębie tego samego pracownika) sprawdzamy, czy występuje pokrycie czasu
    for (int i = 0; i < workerTasks.length - 1; i++) {
      final earlierTask = workerTasks[i];
      final laterTask = workerTasks[i + 1];

      // Jeśli wcześniejszy task nie zakończył się przed rozpoczęciem kolejnego – pokrycie występuje
      if (earlierTask.endDateTime.isAfter(laterTask.startDateTime)) {
        final surname = employee.fullName.split(' ').first;
        final message = "Przeniesienie $surname na ${laterTask.orderId}";
        // Dodajemy komunikat do wcześniejszego taska – jeśli już jakieś istnieją, dołączamy, inaczej tworzymy nową listę
        if (mapping.containsKey(earlierTask.id)) {
          mapping[earlierTask.id]!.add(message);
        } else {
          mapping[earlierTask.id] = [message];
        }
      }
    }
  }
  return mapping;
}