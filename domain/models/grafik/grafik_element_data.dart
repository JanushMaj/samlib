import '../employee.dart';
import '../vehicle.dart';
import 'task_assignment.dart';

class GrafikElementData {
  final List<Employee> assignedEmployees;
  final List<Vehicle> assignedVehicles;
  final List<TaskAssignment>? assignments;

  const GrafikElementData({
    required this.assignedEmployees,
    required this.assignedVehicles,
    this.assignments,
  });
}
