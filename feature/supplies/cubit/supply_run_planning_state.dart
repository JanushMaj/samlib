import '../../../domain/models/supply_order.dart';

class SupplyRunPlanningState {
  final List<SupplyOrder> availableOrders;
  final Set<String> selectedOrderIds;
  final Set<String> selectedVehicleIds;
  final Set<String> selectedDriverIds;
  final String routeDescription;
  final String additionalInfo;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final bool isSubmitting;
  final bool success;
  final String? errorMsg;

  SupplyRunPlanningState({
    required this.availableOrders,
    required this.selectedOrderIds,
    required this.selectedVehicleIds,
    required this.selectedDriverIds,
    required this.routeDescription,
    required this.additionalInfo,
    required this.startDateTime,
    required this.endDateTime,
    this.isSubmitting = false,
    this.success = false,
    this.errorMsg,
  });

  factory SupplyRunPlanningState.initial() {
    final now = DateTime.now();
    return SupplyRunPlanningState(
      availableOrders: const [],
      selectedOrderIds: {},
      selectedVehicleIds: {},
      selectedDriverIds: {},
      routeDescription: '',
      additionalInfo: '',
      startDateTime: now.add(const Duration(hours: 1)),
      endDateTime: now.add(const Duration(hours: 2)),
      isSubmitting: false,
      success: false,
      errorMsg: null,
    );
  }

  SupplyRunPlanningState copyWith({
    List<SupplyOrder>? availableOrders,
    Set<String>? selectedOrderIds,
    Set<String>? selectedVehicleIds,
    Set<String>? selectedDriverIds,
    String? routeDescription,
    String? additionalInfo,
    DateTime? startDateTime,
    DateTime? endDateTime,
    bool? isSubmitting,
    bool? success,
    String? errorMsg,
  }) {
    return SupplyRunPlanningState(
      availableOrders: availableOrders ?? this.availableOrders,
      selectedOrderIds: selectedOrderIds ?? this.selectedOrderIds,
      selectedVehicleIds: selectedVehicleIds ?? this.selectedVehicleIds,
      selectedDriverIds: selectedDriverIds ?? this.selectedDriverIds,
      routeDescription: routeDescription ?? this.routeDescription,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
