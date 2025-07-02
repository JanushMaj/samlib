
import '../../domain/models/employee.dart';
import '../services/employee_firebase_service.dart';

class EmployeeRepository {
  final EmployeeFirebaseService _service;

  EmployeeRepository(this._service);

  Stream<List<Employee>> getEmployees() {
    return _service.getEmployeesStream();
  }

  Future<void> saveEmployee(Employee employee) {
    return _service.upsertEmployee(employee);
  }
}
