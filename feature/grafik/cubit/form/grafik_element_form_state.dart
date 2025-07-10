import '../../../../domain/models/grafik/grafik_element.dart';
import '../../../../domain/models/grafik/task_assignment.dart';

abstract class GrafikElementFormState {}

class GrafikElementFormInitial extends GrafikElementFormState {}

class GrafikElementFormEditing extends GrafikElementFormState {
  final GrafikElement element;
  final List<TaskAssignment> assignments;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  GrafikElementFormEditing({
    required this.element,
    required this.assignments,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFailure = false,
  });

  GrafikElementFormEditing copyWith({
    GrafikElement? element,
    List<TaskAssignment>? assignments,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return GrafikElementFormEditing(
      element: element ?? this.element,
      assignments: assignments ?? this.assignments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
