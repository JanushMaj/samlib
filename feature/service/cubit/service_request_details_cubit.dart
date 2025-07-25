import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/service_request_repository.dart';
import '../../../domain/models/grafik/enums.dart';
import '../../../domain/models/grafik/impl/service_request_element.dart';

class ServiceRequestDetailsState {
  final String id;
  final String createdBy;
  final DateTime createdAt;
  final String location;
  final String description;
  final String orderNumber;
  final ServiceUrgency urgency;
  final DateTime? suggestedDate;
  final int durationMinutes;
  final int peopleCount;
  final GrafikTaskType taskType;
  final bool isSubmitting;
  final bool success;
  final String? errorMsg;

  ServiceRequestDetailsState({
    required this.id,
    required this.createdBy,
    required this.createdAt,
    required this.location,
    required this.description,
    required this.orderNumber,
    required this.urgency,
    required this.suggestedDate,
    required this.durationMinutes,
    required this.peopleCount,
    required this.taskType,
    this.isSubmitting = false,
    this.success = false,
    this.errorMsg,
  });

  factory ServiceRequestDetailsState.fromRequest(ServiceRequestElement r) {
    return ServiceRequestDetailsState(
      id: r.id,
      createdBy: r.addedByUserId,
      createdAt: r.addedTimestamp,
      location: r.location,
      description: r.description,
      orderNumber: r.orderNumber,
      urgency: r.urgency,
      suggestedDate: r.suggestedDate,
      durationMinutes: r.estimatedDuration.inMinutes,
      peopleCount: r.requiredPeopleCount,
      taskType: r.taskType,
    );
  }

  ServiceRequestDetailsState copyWith({
    String? location,
    String? description,
    String? orderNumber,
    ServiceUrgency? urgency,
    DateTime? suggestedDate,
    int? durationMinutes,
    int? peopleCount,
    bool? isSubmitting,
    bool? success,
    String? errorMsg,
  }) {
    return ServiceRequestDetailsState(
      id: id,
      createdBy: createdBy,
      createdAt: createdAt,
      location: location ?? this.location,
      description: description ?? this.description,
      orderNumber: orderNumber ?? this.orderNumber,
      urgency: urgency ?? this.urgency,
      suggestedDate: suggestedDate ?? this.suggestedDate,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      peopleCount: peopleCount ?? this.peopleCount,
      taskType: taskType,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      errorMsg: errorMsg,
    );
  }
}

class ServiceRequestDetailsCubit extends Cubit<ServiceRequestDetailsState> {
  final ServiceRequestRepository _repo;

  ServiceRequestDetailsCubit(this._repo, ServiceRequestElement request)
      : super(ServiceRequestDetailsState.fromRequest(request));

  void setLocation(String val) => emit(state.copyWith(location: val));
  void setDescription(String val) => emit(state.copyWith(description: val));
  void setOrderNumber(String val) => emit(state.copyWith(orderNumber: val));
  void setUrgency(ServiceUrgency val) => emit(state.copyWith(urgency: val));
  void setSuggestedDate(DateTime? date) =>
      emit(state.copyWith(suggestedDate: date));
  void setDurationMinutes(int val) => emit(state.copyWith(durationMinutes: val));
  void setPeopleCount(int val) => emit(state.copyWith(peopleCount: val));

  Future<void> save() async {
    if (state.durationMinutes <= 0 || state.peopleCount < 1) {
      emit(state.copyWith(errorMsg: 'Niepoprawne dane'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, success: false, errorMsg: null));
    final element = ServiceRequestElement(
      id: state.id,
      createdBy: state.createdBy,
      createdAt: state.createdAt,
      location: state.location,
      description: state.description,
      orderNumber: state.orderNumber,
      urgency: state.urgency,
      suggestedDate: state.suggestedDate,
      estimatedDuration: Duration(minutes: state.durationMinutes),
      requiredPeopleCount: state.peopleCount,
      taskType: state.taskType,
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
