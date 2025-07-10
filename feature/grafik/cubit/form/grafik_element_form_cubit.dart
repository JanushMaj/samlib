
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repositories/grafik_element_repository.dart';
import '../../../../domain/models/grafik/grafik_element.dart';
import '../../form/grafik_element_registry.dart';
import '../../../../domain/models/grafik/impl/task_template.dart';
import '../../../../domain/models/grafik/impl/task_element.dart';
import '../../form/strategy/grafik_element_form_strategy.dart';
import 'grafik_element_form_state.dart';
import '../../../../data/repositories/task_assignment_repository.dart';
import '../../../../domain/models/grafik/task_assignment.dart';

// ───────── CUBIT ─────────
class GrafikElementFormCubit extends Cubit<GrafikElementFormState> {
  final GrafikElementRepository grafikService;
  final TaskAssignmentRepository assignmentRepository;
  late GrafikElementFormStrategy _strategy;

  GrafikElementFormCubit({
    required this.grafikService,
    required this.assignmentRepository,
  }) : super(GrafikElementFormInitial());

  // ────────────────────────────────────────────────────────────
  //  Inicjalizacja
  // ────────────────────────────────────────────────────────────
  Future<void> initialize(GrafikElement? existingElement) async {
    if (existingElement != null) {
      _strategy =
          GrafikElementRegistry.getStrategyForType(existingElement.type);
      List<TaskAssignment> assignments = [];
      if (existingElement is TaskElement) {
        assignments = await assignmentRepository
            .getAssignmentsForTask(existingElement.id)
            .first;
      }
      emit(GrafikElementFormEditing(
        element: existingElement,
        assignments: assignments,
      ));
    } else {
      _strategy = GrafikElementRegistry.getStrategyForType('TaskElement');
      final defaultElement = _strategy.createDefault();
      emit(GrafikElementFormEditing(element: defaultElement, assignments: []));
    }
  }

  // ────────────────────────────────────────────────────────────
  //  Aktualizacja pól formularza
  // ────────────────────────────────────────────────────────────
  void updateField(String field, dynamic value) {
    if (state is! GrafikElementFormEditing) return;

    final currentState = state as GrafikElementFormEditing;
    var oldElement = currentState.element;

    // zmiana typu elementu => generujemy nowy szablon tego typu
    if (field == 'type') {
      final newType = value as String;
      _strategy = GrafikElementRegistry.getStrategyForType(newType);
      final updatedElement = _strategy.createDefault();
      emit(currentState.copyWith(element: updatedElement, assignments: []));
      return;
    }

    final updatedElement = _strategy.updateField(oldElement, field, value);
    emit(currentState.copyWith(element: updatedElement));
  }

  // ────────────────────────────────────────────────────────────
  //  Wstawianie szablonu zadania (TaskTemplate)
  // ────────────────────────────────────────────────────────────
  void applyTemplate(TaskTemplate t) {
    if (state is! GrafikElementFormEditing) return;
    final s = state as GrafikElementFormEditing;
    final updated = _strategy.applyTemplate(s.element, t);
    emit(s.copyWith(element: updated));
  }

  void updateAssignments(List<TaskAssignment> assignments) {
    if (state is! GrafikElementFormEditing) return;
    final s = state as GrafikElementFormEditing;
    emit(s.copyWith(assignments: assignments));
  }

  // ────────────────────────────────────────────────────────────
  //  Zapis elementu
  // ────────────────────────────────────────────────────────────
  Future<void> saveElement() async {
    if (state is! GrafikElementFormEditing) return;

    final currentState = state as GrafikElementFormEditing;
    emit(currentState.copyWith(isSubmitting: true));

    try {
      await _strategy.save(
        grafikService,
        currentState.element,
        assignmentRepository: assignmentRepository,
        assignments: currentState.assignments,
      );
      emit(currentState.copyWith(isSubmitting: false, isSuccess: true));
    } catch (_) {
      emit(currentState.copyWith(isSubmitting: false, isFailure: true));
    }
  }
}
