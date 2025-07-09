import '../models/vehicle.dart';

abstract class IVehicleWatcherService {
  Stream<List<Vehicle>> watchVehicles();
}
