import '../repositories/vehicle_repository.dart';
import '../../domain/models/vehicle.dart';
import '../../domain/services/i_vehicle_watcher_service.dart';

class VehicleWatcher implements IVehicleWatcherService {
  final VehicleRepository _vehicleRepository;

  VehicleWatcher(this._vehicleRepository);

  @override
  Stream<List<Vehicle>> watchVehicles() {
    return _vehicleRepository.getVehicles();
  }
}
