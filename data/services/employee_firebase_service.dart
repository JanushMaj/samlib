import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/employee.dart';

class EmployeeFirebaseService {
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
