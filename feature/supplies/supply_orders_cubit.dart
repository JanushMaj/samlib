import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../domain/models/supply_order.dart';
import '../../domain/services/i_supply_repository.dart';

class SupplyOrdersCubit extends Cubit<List<SupplyOrder>> {
  final ISupplyRepository _repository;
  late final StreamSubscription<List<SupplyOrder>> _sub;

  SupplyOrdersCubit(this._repository) : super(const []) {
    _sub = _repository.watchOrders().listen((orders) {
      final pending = orders.where((o) => o.status == 'pending').toList();
      emit(pending);
    });
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
