import '../grafik_element_form_adapter.dart';
import '../../../../data/repositories/grafik_element_repository.dart';
import '../../../../injection.dart';
import '../../../../domain/models/grafik/enums.dart';
import '../../../../domain/models/grafik/grafik_element.dart';
import '../../../../domain/models/grafik/impl/task_element.dart';
import 'grafik_element_form_strategy.dart';

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
      workerIds: const [],
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
  GrafikElement applyTemplate(GrafikElement element, GrafikElement template) {
    if (template is! TaskElement) return element;
    TaskElement task = element is TaskElement
        ? element
        : createDefault() as TaskElement;
    final overrides = getIt<GrafikElementRepository>().toJson(template)
      ..remove('id');
    return _adapter.copyWithOverrides(task, overrides);
  }

  @override
  Future<void> save(GrafikElementRepository repo, GrafikElement element) async {
    if (element is! TaskElement) return;
    var task = element;
    if (task.id.isEmpty) {
      final newId = repo.generateNewTaskId();
      task = task.copyWithId(newId);
    }
    await repo.saveGrafikElement(task);
  }
}
