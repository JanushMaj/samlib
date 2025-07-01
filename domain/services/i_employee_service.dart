import '../models/emplyee.dart';

abstract class IEmployeeService {
  Stream<List<Employee>> getEmployeesStream();
  Future<void> upsertEmployee(Employee employee);
}
