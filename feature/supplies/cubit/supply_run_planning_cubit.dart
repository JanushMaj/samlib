import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/grafik/impl/supply_run_element.dart';
import '../../../domain/models/grafik/impl/supply_run_to_task_extension.dart';
import '../../../domain/models/grafik/enums.dart';
import '../../../domain/models/supply_order.dart';
import '../../../data/repositories/grafik_element_repository.dart';
import '../../../domain/services/i_supply_repository.dart';
import 'supply_run_planning_state.dart';

class SupplyRunPlanningCubit extends Cubit<SupplyRunPlanningState> {
  final ISupplyRepository _supplyRepository;
  final GrafikElementRepository _grafikRepository;
  late final StreamSubscription<List<SupplyOrder>> _ordersSub;
  SupplyRunPlanningCubit(
    this._supplyRepository,
    this._grafikRepository,
  ) : super(SupplyRunPlanningState.initial()) {
    _ordersSub = _supplyRepository.watchOrders().listen((orders) {
      final pending = orders.where((o) => o.status == 'pending').toList();
      emit(state.copyWith(availableOrders: pending));
    });
  }

  void toggleSelection(String orderId) {
    final newSet = Set<String>.from(state.selectedOrderIds);
    if (newSet.contains(orderId)) {
      newSet.remove(orderId);
    } else {
      newSet.add(orderId);
    }
    emit(state.copyWith(selectedOrderIds: newSet));
  }

  void setRouteDescription(String desc) {
    emit(state.copyWith(routeDescription: desc));
  }

  void setAdditionalInfo(String info) {
    emit(state.copyWith(additionalInfo: info));
  }

  void setVehicleIds(List<String> ids) {
    emit(state.copyWith(selectedVehicleIds: ids.toSet()));
  }

  void setDriverIds(List<String> ids) {
    emit(state.copyWith(selectedDriverIds: ids.toSet()));
  }

  void setStartDateTime(DateTime start) {
    emit(state.copyWith(startDateTime: start));
  }

  void setEndDateTime(DateTime end) {
    emit(state.copyWith(endDateTime: end));
  }

  Future<void> createSupplyRun(String userId) async {
    emit(state.copyWith(isSubmitting: true, success: false, errorMsg: null));
    final element = SupplyRunElement(
      id: '',
      startDateTime: state.startDateTime,
      endDateTime: state.endDateTime,
      additionalInfo: state.additionalInfo,
      supplyOrderIds: state.selectedOrderIds.toList(),
      routeDescription: state.routeDescription,
      vehicleIds: state.selectedVehicleIds.toList(),
      driverIds: state.selectedDriverIds.toList(),
      addedByUserId: userId,
      addedTimestamp: DateTime.now(),
      closed: false,
    );
    try {
      await _grafikRepository.saveGrafikElement(element);
      // Optional: mark orders as assigned
      await Future.wait(state.selectedOrderIds
          .map((id) => _supplyRepository.updateOrderStatus(id, 'assigned')));
      emit(state.copyWith(isSubmitting: false, success: true));
    } catch (e) {
      emit(state.copyWith(
          isSubmitting: false, success: false, errorMsg: e.toString()));
    }
  }

  /// Close an existing [run] by converting it to a [TaskElement].
  /// The resulting task is saved via [_grafikRepository] and all related
  /// [SupplyOrder]s are marked as delivered.
  Future<void> closeSupplyRun(
    SupplyRunElement run, {
    required String orderId,
    List<String> carIds = const [],
  }) async {
    emit(state.copyWith(isSubmitting: true, success: false, errorMsg: null));
    final task = run.toTaskElement(
      orderId: orderId,
      status: GrafikStatus.Zakonczone,
      carIds: carIds,
    );
    try {
      await _grafikRepository.saveGrafikElement(task);
      await _grafikRepository.saveGrafikElement(run.copyWith(closed: true));
      await Future.wait(
        run.supplyOrderIds.map(
          (id) => _supplyRepository.updateOrderStatus(id, 'delivered'),
        ),
      );
      emit(state.copyWith(isSubmitting: false, success: true));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        success: false,
        errorMsg: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _ordersSub.cancel();
    return super.close();
  }
}
