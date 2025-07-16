class SupplyRunPlanningState {
  final Set<String> selectedIds;
  final String routeDescription;
  final String additionalInfo;
  final DateTime startTime;
  final DateTime endTime;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;

  SupplyRunPlanningState({
    required this.selectedIds,
    required this.routeDescription,
    required this.additionalInfo,
    required this.startTime,
    required this.endTime,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.error,
  });

  factory SupplyRunPlanningState.initial() {
    final now = DateTime.now();
    return SupplyRunPlanningState(
      selectedIds: {},
      routeDescription: '',
      additionalInfo: '',
      startTime: now.add(const Duration(hours: 1)),
      endTime: now.add(const Duration(hours: 2)),
      isSubmitting: false,
      isSuccess: false,
      error: null,
    );
  }

  SupplyRunPlanningState copyWith({
    Set<String>? selectedIds,
    String? routeDescription,
    String? additionalInfo,
    DateTime? startTime,
    DateTime? endTime,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
  }) {
    return SupplyRunPlanningState(
      selectedIds: selectedIds ?? this.selectedIds,
      routeDescription: routeDescription ?? this.routeDescription,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }
}
