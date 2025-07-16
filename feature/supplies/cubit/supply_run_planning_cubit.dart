import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/grafik/impl/supply_run_element.dart';
import '../../../domain/models/supply_order.dart';
import '../../../data/repositories/grafik_element_repository.dart';
import '../../../domain/services/i_supply_repository.dart';
import 'supply_run_planning_state.dart';

class SupplyRunPlanningCubit extends Cubit<SupplyRunPlanningState> {
  final ISupplyRepository _supplyRepository;
  final GrafikElementRepository _grafikRepository;
  SupplyRunPlanningCubit(
    this._supplyRepository,
    this._grafikRepository,
  ) : super(SupplyRunPlanningState.initial());

  Stream<List<SupplyOrder>> streamSupplyOrders() {
    return _supplyRepository
        .watchOrders()
        .map((orders) => orders.where((o) => o.status == 'pending').toList());
  }

  void toggleSelection(String orderId) {
    final newSet = Set<String>.from(state.selectedIds);
    if (newSet.contains(orderId)) {
      newSet.remove(orderId);
    } else {
      newSet.add(orderId);
    }
    emit(state.copyWith(selectedIds: newSet));
  }

  void setRouteDescription(String desc) {
    emit(state.copyWith(routeDescription: desc));
  }

  void setAdditionalInfo(String info) {
    emit(state.copyWith(additionalInfo: info));
  }

  void setStartTime(DateTime start) {
    emit(state.copyWith(startTime: start));
  }

  void setEndTime(DateTime end) {
    emit(state.copyWith(endTime: end));
  }

  Future<void> createSupplyRun(String userId) async {
    emit(state.copyWith(isSubmitting: true, isSuccess: false, error: null));
    final element = SupplyRunElement(
      id: '',
      startDateTime: state.startTime,
      endDateTime: state.endTime,
      additionalInfo: state.additionalInfo,
      supplyOrderIds: state.selectedIds.toList(),
      routeDescription: state.routeDescription,
      addedByUserId: userId,
      addedTimestamp: DateTime.now(),
      closed: false,
    );
    try {
      await _grafikRepository.saveGrafikElement(element);
      // Optional: mark orders as assigned
      await Future.wait(state.selectedIds
          .map((id) => _supplyRepository.updateOrderStatus(id, 'assigned')));
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
          isSubmitting: false, isSuccess: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
