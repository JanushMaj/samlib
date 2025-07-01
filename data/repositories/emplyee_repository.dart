
import '../../domain/models/emplyee.dart';
import '../../domain/services/i_employee_service.dart';

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
