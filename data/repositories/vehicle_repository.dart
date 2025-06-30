import '../../domain/models/vehicle.dart';
import '../services/vehicle_firebase_service.dart';

class VehicleRepository {
  final VehicleFirebaseService _service;

  VehicleRepository(this._service);

  Stream<List<Vehicle>> getVehicles() {
    return _service.getVehiclesStream();
  }

  Future<void> saveVehicle(Vehicle vehicle) {
    return _service.upsertVehicle(vehicle);
  }
}
