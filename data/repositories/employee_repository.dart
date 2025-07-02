
<<<<<<< HEAD:data/repositories/emplyee_repository.dart
import '../../domain/models/emplyee.dart';
import '../../domain/services/i_employee_service.dart';
=======
import '../../domain/models/employee.dart';
import '../services/employee_firebase_service.dart';
>>>>>>> f31b4e4f21ac90b05b7d56404f5fa23e7a182d8e:data/repositories/employee_repository.dart

class EmployeeRepository {
  final IEmployeeService _service;

  EmployeeRepository(this._service);

  Stream<List<Employee>> getEmployees() {
    return _service.getEmployeesStream();
  }

  Future<void> saveEmployee(Employee employee) {
    return _service.upsertEmployee(employee);
  }
}
