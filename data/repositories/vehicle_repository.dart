import 'package:kabast/domain/models/vehicle.dart';
import 'package:kabast/domain/services/i_vehicle_service.dart';

class VehicleRepository {
  final IVehicleService _service;

  VehicleRepository(this._service);

  Stream<List<Vehicle>> getVehicles() {
    return _service.getVehiclesStream();
  }

  Future<void> saveVehicle(Vehicle vehicle) {
    return _service.upsertVehicle(vehicle);
  }
}
