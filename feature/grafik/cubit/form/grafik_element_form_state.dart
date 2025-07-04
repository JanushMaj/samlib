import '../../../../domain/models/grafik/grafik_element.dart';

abstract class GrafikElementFormState {}

class GrafikElementFormInitial extends GrafikElementFormState {}

class GrafikElementFormEditing extends GrafikElementFormState {
  final GrafikElement element;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final List<String> selectedWorkerIds;

  GrafikElementFormEditing({
    required this.element,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.selectedWorkerIds = const [],
  });

  GrafikElementFormEditing copyWith({
    GrafikElement? element,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    List<String>? selectedWorkerIds,
  }) {
    return GrafikElementFormEditing(
      element: element ?? this.element,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      selectedWorkerIds: selectedWorkerIds ?? this.selectedWorkerIds,
    );
  }
}
