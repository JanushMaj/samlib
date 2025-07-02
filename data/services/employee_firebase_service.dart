import 'package:cloud_firestore/cloud_firestore.dart';

<<<<<<< HEAD:data/services/empleyee_firebase_service.dart
import '../../domain/models/emplyee.dart';
import '../../domain/services/i_employee_service.dart';
=======
import '../../domain/models/employee.dart';
>>>>>>> f31b4e4f21ac90b05b7d56404f5fa23e7a182d8e:data/services/employee_firebase_service.dart

class EmployeeFirebaseService implements IEmployeeService {
  final FirebaseFirestore _firestore;

  EmployeeFirebaseService(this._firestore);

  /// Strumień pracowników z kolekcji 'workers'
  Stream<List<Employee>> getEmployeesStream() {
    return _firestore.collection('workers').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return Employee.fromJson(data);
      }).toList();
    });
  }

  /// Zapisuje lub nadpisuje pracownika
  Future<void> upsertEmployee(Employee employee) async {
    if (employee.uid.isEmpty) {
      final docRef = await _firestore.collection('workers').add(employee.toJson());
      await docRef.update({'uid': docRef.id});
    } else {
      await _firestore.collection('workers').doc(employee.uid).set(employee.toJson());
    }
  }
}
