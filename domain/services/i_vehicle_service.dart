import '../models/vehicle.dart';

abstract class IVehicleService {
  Stream<List<Vehicle>> getVehiclesStream();
  Future<void> upsertVehicle(Vehicle vehicle);
}
