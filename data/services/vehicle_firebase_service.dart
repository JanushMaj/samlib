import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/vehicle.dart';

class VehicleFirebaseService {
  final FirebaseFirestore _firestore;

  VehicleFirebaseService(this._firestore);

  Stream<List<Vehicle>> getVehiclesStream() {
    return _firestore.collection('vehicles').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Vehicle.fromJson(doc.data());
      }).toList();
    });
  }

  Future<void> upsertVehicle(Vehicle vehicle) async {
    if (vehicle.id.isEmpty) {
      final docRef = await _firestore.collection('vehicles').add(vehicle.toJson());
      await docRef.update({'id': docRef.id});
    } else {
      await _firestore.collection('vehicles').doc(vehicle.id).set(vehicle.toJson());
    }
  }
}
