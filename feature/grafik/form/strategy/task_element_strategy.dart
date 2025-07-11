import '../grafik_element_form_adapter.dart';
import '../../../../data/repositories/grafik_element_repository.dart';
import '../../../../injection.dart';
import '../../../../domain/models/grafik/enums.dart';
import '../../../../domain/models/grafik/grafik_element.dart';
import '../../../../domain/models/grafik/impl/task_element.dart';
import '../../../../domain/models/grafik/impl/task_template.dart';
import 'grafik_element_form_strategy.dart';
import '../../../../data/repositories/task_assignment_repository.dart';
import '../../../../domain/models/grafik/task_assignment.dart';

class TaskElementStrategy implements GrafikElementFormStrategy {
  final GrafikElementFormAdapter _adapter =
      GrafikElementFormAdapter(repo: getIt<GrafikElementRepository>());

  @override
  GrafikElement createDefault() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final start = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 7);
    final end = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 15);
    return TaskElement(
      id: '',
      startDateTime: start,
      endDateTime: end,
      additionalInfo: '',
      orderId: '',
      status: GrafikStatus.Realizacja,
      taskType: GrafikTaskType.Inne,
      carIds: const [],
      addedByUserId: '',
      addedTimestamp: DateTime.now(),
      closed: false,
    );
  }

  @override
  GrafikElement updateField(GrafikElement element, String field, dynamic value) {
    return _adapter.updateField(element, field, value);
  }

  @override
  GrafikElement applyTemplate(GrafikElement element, TaskTemplate template) {
    return element;
  }

  @override
  Future<void> save(
    GrafikElementRepository repo,
    GrafikElement element, {
    TaskAssignmentRepository? assignmentRepository,
    List<TaskAssignment> assignments = const [],
  }) async {
    if (element is! TaskElement) return;
    var task = element;
    var localAssignments = List<TaskAssignment>.from(assignments);
    if (task.id.isEmpty) {
      final newId = repo.generateNewTaskId();
      task = task.copyWithId(newId);
      localAssignments =
          localAssignments.map((a) => a.copyWith(taskId: newId)).toList();
    }
    await repo.saveGrafikElement(task);
    if (assignmentRepository != null) {
      for (final a in localAssignments) {
        await assignmentRepository.saveTaskAssignment(a);
      }
    }
  }
}
