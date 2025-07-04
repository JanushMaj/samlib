import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kabast/domain/models/employee.dart';
import 'package:kabast/domain/services/i_employee_service.dart';
import 'package:kabast/data/dto/employee_dto.dart';

class EmployeeFirebaseService implements IEmployeeService {
  final FirebaseFirestore _firestore;

  EmployeeFirebaseService(this._firestore);

  @override
  Stream<List<Employee>> getEmployeesStream() {
    return _firestore.collection('workers').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return EmployeeDto.fromFirestore(doc).toDomain();
      }).toList();
    });
  }

  @override
  Future<void> upsertEmployee(Employee employee) async {
    final dto = EmployeeDto.fromDomain(employee);
    if (employee.uid.isEmpty) {
      final docRef = await _firestore.collection('workers').add(dto.toJson());
      await docRef.update({'uid': docRef.id});
    } else {
      await _firestore.collection('workers').doc(employee.uid).set(dto.toJson());
    }
  }
}
