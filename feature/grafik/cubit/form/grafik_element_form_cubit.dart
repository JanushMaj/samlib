
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/services/i_grafik_element_service.dart';
import '../../../../domain/models/grafik/grafik_element.dart';
import '../../form/grafik_element_registry.dart';
import '../../../../domain/models/grafik/impl/task_template.dart';
import '../../form/strategy/grafik_element_form_strategy.dart';
import 'grafik_element_form_state.dart';

// ───────── CUBIT ─────────
class GrafikElementFormCubit extends Cubit<GrafikElementFormState> {
  final IGrafikElementService grafikService;
  late GrafikElementFormStrategy _strategy;

  GrafikElementFormCubit({
    required this.grafikService,
  }) : super(GrafikElementFormInitial());

  // ────────────────────────────────────────────────────────────
  //  Inicjalizacja
  // ────────────────────────────────────────────────────────────
  void initialize(GrafikElement? existingElement) {
    if (existingElement != null) {
      _strategy =
          GrafikElementRegistry.getStrategyForType(existingElement.type);
      emit(GrafikElementFormEditing(element: existingElement));
    } else {
      _strategy = GrafikElementRegistry.getStrategyForType('TaskElement');
      final defaultElement = _strategy.createDefault();
      emit(GrafikElementFormEditing(element: defaultElement));
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
      emit(currentState.copyWith(element: updatedElement));
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

  // ────────────────────────────────────────────────────────────
  //  Zapis elementu
  // ────────────────────────────────────────────────────────────
  Future<void> saveElement() async {
    if (state is! GrafikElementFormEditing) return;

    final currentState = state as GrafikElementFormEditing;
    emit(currentState.copyWith(isSubmitting: true));

    try {
      await _strategy.save(grafikService, currentState.element);
      emit(currentState.copyWith(isSubmitting: false, isSuccess: true));
    } catch (_) {
      emit(currentState.copyWith(isSubmitting: false, isFailure: true));
    }
  }
}
