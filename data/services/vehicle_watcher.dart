import '../repositories/vehicle_repository.dart';
import '../../domain/models/vehicle.dart';

class VehicleWatcher {
  final VehicleRepository _vehicleRepository;

  VehicleWatcher(this._vehicleRepository);

  Stream<List<Vehicle>> watchVehicles() {
    return _vehicleRepository.getVehicles();
  }
}
