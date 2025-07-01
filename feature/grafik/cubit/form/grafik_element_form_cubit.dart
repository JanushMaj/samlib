
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repositories/grafik_element_repository.dart';
import '../../../../domain/models/grafik/grafik_element.dart';
import '../../../../domain/models/grafik/grafik_element_registry.dart';
import '../../../../domain/models/grafik/enums.dart';
import '../../../../domain/models/grafik/impl/task_element.dart';
import '../../../../domain/models/grafik/impl/task_template.dart';
import '../../../../domain/models/grafik/impl/time_issue_element.dart';
import '../../../../main.dart';
import '../../widget/dialog/worker_conflict_popup.dart';
import 'grafik_element_form_state.dart';

// ───────── CUBIT ─────────
class GrafikElementFormCubit extends Cubit<GrafikElementFormState> {
  final GrafikElementRepository grafikService;

  GrafikElementFormCubit({required this.grafikService})
      : super(GrafikElementFormInitial());

  // ────────────────────────────────────────────────────────────
  //  Inicjalizacja
  // ────────────────────────────────────────────────────────────
  void initialize(GrafikElement? existingElement) {
    if (existingElement != null) {
      emit(GrafikElementFormEditing(element: existingElement));
    } else {
      final defaultJson =
      GrafikElementRegistry.createDefaultJsonForType('TaskElement');
      final defaultElement = GrafikElementRegistry.fromJson(defaultJson);
      emit(GrafikElementFormEditing(element: defaultElement));
    }
  }

  // ────────────────────────────────────────────────────────────
  //  Aktualizacja pól formularza
  // ────────────────────────────────────────────────────────────
  void updateField(String field, dynamic value) {
    if (state is! GrafikElementFormEditing) return;

    final currentState = state as GrafikElementFormEditing;
    final oldElement = currentState.element;

    // zmiana typu elementu => generujemy nowy szablon tego typu
    if (field == 'type') {
      final newType = value as String;
      final newJson = GrafikElementRegistry.createDefaultJsonForType(newType);
      final oldJson = oldElement.toJson();

      newJson['id'] = oldJson['id'];
      newJson['startDateTime'] = oldJson['startDateTime'];
      newJson['endDateTime'] = oldJson['endDateTime'];
      newJson['additionalInfo'] = oldJson['additionalInfo'];

      final updatedElement = GrafikElementRegistry.fromJson(newJson);
      emit(currentState.copyWith(element: updatedElement));
      return;
    }

    // zwykła zamiana pola
    final elementMap = oldElement.toJson();
    if (field == 'startDateTime' || field == 'endDateTime') {
      final dt = value as DateTime;
      elementMap[field] = Timestamp.fromDate(dt);
    } else {
      elementMap[field] = value;
    }

    final updatedElement = GrafikElementRegistry.fromJson(elementMap);
    emit(currentState.copyWith(element: updatedElement));
  }

  // ────────────────────────────────────────────────────────────
  //  Aktualizacja pracowników (TaskElement / TimeIssueElement)
  // ────────────────────────────────────────────────────────────
  void updateSelectedWorkerIds(List<String> ids) {
    if (state is! GrafikElementFormEditing) return;

    final current = state as GrafikElementFormEditing;
    var updatedElement = current.element;

    // Jeżeli to TimeIssueElement – zaktualizuj workerId
    if (updatedElement is TimeIssueElement && ids.length == 1) {
      final json = updatedElement.toJson();
      json['workerId'] = ids.first;
      updatedElement = GrafikElementRegistry.fromJson(json);
    }

    emit(current.copyWith(
      selectedWorkerIds: ids,
      element: updatedElement,
    ));
  }

  // ────────────────────────────────────────────────────────────
  //  Wstawianie szablonu zadania (TaskTemplate)
  // ────────────────────────────────────────────────────────────
  void applyTemplate(TaskTemplate t) {
    if (state is! GrafikElementFormEditing) return;
    final s = state as GrafikElementFormEditing;

    // upewnij się, że to TaskElement
    TaskElement task = s.element is TaskElement
        ? (s.element as TaskElement)
        : GrafikElementRegistry
        .fromJson(
        GrafikElementRegistry.createDefaultJsonForType('TaskElement'))
    as TaskElement;

    // zachowujemy ID i dzień/miesiąc/rok
    final day = task.startDateTime;
    final newStart = DateTime(day.year, day.month, day.day, t.startHour);
    final newEnd = DateTime(day.year, day.month, day.day, t.endHour);

    task = task.copyWith(
      startDateTime: newStart,
      endDateTime: newEnd,
      taskType: t.taskType,
      status: t.status,
      orderId: t.orderId,
      workerIds: t.workerIds,
      carIds: t.carIds,
      additionalInfo: t.additionalInfo,
    );

    emit(s.copyWith(element: task));
  }

  // ────────────────────────────────────────────────────────────
  //  Zapis elementu
  // ────────────────────────────────────────────────────────────
  Future<void> saveElement() async {
    if (state is! GrafikElementFormEditing) return;

    final currentState = state as GrafikElementFormEditing;
    emit(currentState.copyWith(isSubmitting: true));

    final String userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

    // ✨ upewnij się, że meta‑dane są wpisane
    GrafikElement element = currentState.element.fillMeta(userId);

    // Jeśli to nowe zadanie – generujemy ID (tylko TaskElement)
    if (element is TaskElement && element.id.isEmpty) {
      final newId = FirebaseFirestore.instance
          .collection('grafikElements')
          .doc()
          .id;
      element = element.copyWithId(newId);
    }

    List<TimeIssueElement> transfers = [];

    try {
      // konflikt pracowników – pokazujemy popup
      if (element is TaskElement) {
        final taskElement = element;

        final existingTasks = await grafikService
            .getElementsWithinRange(
          start: taskElement.startDateTime,
          end: taskElement.endDateTime,
          types: ['TaskElement'],
        )
            .first;

        final overlapping = existingTasks.whereType<TaskElement>().where(
              (e) =>
          e.id != taskElement.id &&
              e.workerIds.any((id) => taskElement.workerIds.contains(id)),
        );

        final conflictWorkerIds = overlapping
            .expand((e) => e.workerIds)
            .where((id) => taskElement.workerIds.contains(id))
            .toSet()
            .toList();

        if (conflictWorkerIds.isNotEmpty) {
          final userDecision = await showWorkerConflictDialog(
            navigatorKey.currentContext!,
            conflictWorkerIds,
          );

          if (userDecision != true) {
            emit(currentState.copyWith(isSubmitting: false));
            return;
          }

          transfers = conflictWorkerIds.map((workerId) {
            final fromTask =
            overlapping.firstWhere((task) => task.workerIds.contains(workerId));
            return TimeIssueElement(
              id: '',
              startDateTime: taskElement.startDateTime,
              endDateTime: taskElement.endDateTime,
              additionalInfo: 'Przeniesienie z ${fromTask.id} do ${taskElement.id}',
              issueType: TimeIssueType.Przeniesienie,
              issuePaymentType: PaymentType.zero,
              workerId: workerId,
              taskId: taskElement.id,
              fromTaskId: fromTask.id,
              toTaskId: taskElement.id,
              makeupForIds: [],
              addedByUserId: userId,
              addedTimestamp: DateTime.now(),
              closed: false,
            );
          }).toList();
        }
      }

      // zapis głównego elementu
      await grafikService.saveGrafikElement(element);

      // zapis transferów, jeśli powstały
      if (transfers.isNotEmpty) {
        await grafikService.saveManyGrafikElements(transfers);
      }

      // splitowanie TimeIssueElement jeśli wybrano wielu pracowników
      if (element is TimeIssueElement && currentState.selectedWorkerIds.length > 1) {
        final List<GrafikElement> splitted = currentState.selectedWorkerIds.map((workerId) {
          final json = Map<String, dynamic>.from(element.toJson());
          json['workerId'] = workerId;
          json['id'] = '';
          return GrafikElementRegistry.fromJson(json).fillMeta(userId);
        }).toList();

        await grafikService.saveManyGrafikElements(splitted);
      }

      emit(currentState.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(currentState.copyWith(isSubmitting: false, isFailure: true));
    }
  }
}

// ────────────────────────────────────────────────────────────────
//  Extension: automatyczne wypełnianie meta‑danych
// ────────────────────────────────────────────────────────────────
extension _GrafikMeta on GrafikElement {
  /// Zwraca kopię elementu, w której wypełniono
  ///   • addedByUserId – jeśli było puste
  ///   • addedTimestamp – jeśli null lub < 1970
  GrafikElement fillMeta(String userId) {
    final needUser = (addedByUserId ?? '').isEmpty;
    final needTs = addedTimestamp == null ||
        addedTimestamp!.isBefore(DateTime(1970));

    if (!needUser && !needTs) return this;

    final json = toJson();
    if (needUser) json['addedByUserId'] = userId;
    if (needTs) json['addedTimestamp'] = Timestamp.fromDate(DateTime.now());

    return GrafikElementRegistry.fromJson(json);
  }
}
