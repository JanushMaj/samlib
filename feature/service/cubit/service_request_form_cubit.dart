import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/service_request_repository.dart';
import '../../../domain/models/grafik/impl/service_request_element.dart';
import '../../../domain/models/grafik/enums.dart';

class ServiceRequestFormState {
  final String location;
  final String description;
  final String orderNumber;
  final ServiceUrgency urgency;
  final bool isSubmitting;
  final bool success;
  final String? errorMsg;

  ServiceRequestFormState({
    required this.location,
    required this.description,
    required this.orderNumber,
    required this.urgency,
    this.isSubmitting = false,
    this.success = false,
    this.errorMsg,
  });

  factory ServiceRequestFormState.initial() => ServiceRequestFormState(
        location: '',
        description: '',
        orderNumber: '',
        urgency: ServiceUrgency.normal,
      );

  ServiceRequestFormState copyWith({
    String? location,
    String? description,
    String? orderNumber,
    ServiceUrgency? urgency,
    bool? isSubmitting,
    bool? success,
    String? errorMsg,
  }) {
    return ServiceRequestFormState(
      location: location ?? this.location,
      description: description ?? this.description,
      orderNumber: orderNumber ?? this.orderNumber,
      urgency: urgency ?? this.urgency,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      errorMsg: errorMsg,
    );
  }
}

class ServiceRequestFormCubit extends Cubit<ServiceRequestFormState> {
  final ServiceRequestRepository _repo;

  ServiceRequestFormCubit(this._repo)
      : super(ServiceRequestFormState.initial());

  void setLocation(String val) => emit(state.copyWith(location: val));
  void setDescription(String val) => emit(state.copyWith(description: val));
  void setOrderNumber(String val) => emit(state.copyWith(orderNumber: val));
  void setUrgency(ServiceUrgency val) => emit(state.copyWith(urgency: val));

  Future<void> save(String userId) async {
    if (state.description.trim().isEmpty || state.orderNumber.trim().isEmpty) {
      emit(state.copyWith(errorMsg: 'Uzupełnij wymagane pola'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, success: false, errorMsg: null));
    final element = ServiceRequestElement(
      id: '',
      createdBy: userId,
      createdAt: DateTime.now(),
      location: state.location,
      description: state.description,
      orderNumber: state.orderNumber,
      urgency: state.urgency,
      estimatedDuration: const Duration(hours: 1),
      requiredPeopleCount: 1,
    );
    try {
      await _repo.saveServiceRequest(element);
      emit(state.copyWith(isSubmitting: false, success: true));
    } catch (e) {
      emit(state.copyWith(
          isSubmitting: false, success: false, errorMsg: e.toString()));
    }
  }
}
