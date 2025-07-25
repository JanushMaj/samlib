import 'package:flutter/material.dart';
import 'domain/models/grafik/grafik_element.dart';
import 'feature/auth/screen/login_screen.dart';
import 'feature/extra_options/extra_options_screen.dart';
import 'feature/grafik/form/grafik_element_form_screen.dart';
import 'feature/grafik/grafik_wrapper.dart';
import 'feature/grafik/widget/week/week_grafik_view.dart';
import 'feature/auth/screen/no_access_screen.dart';
import 'feature/my_tasks/my_tasks_screen.dart';
import 'feature/supplies/supply_list_screen.dart';
import 'feature/supplies/supply_run_planning_screen.dart';
import 'feature/supplies/supply_run_approval_screen.dart';
import 'feature/assign_employee/assign_employee_screen.dart';
import 'feature/my_tasks/assign_employee_screen.dart';
import 'feature/admin/admin_panel_screen.dart';
import 'feature/service/screens/service_request_form_screen.dart';
import 'feature/service/screens/service_request_list_screen.dart';
import 'feature/service/screens/service_request_details_screen.dart';
import 'domain/models/grafik/impl/service_request_element.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/grafik':
        return MaterialPageRoute(
          builder: (_) => const GrafikWrapper(),
        );
      case '/weekGrafik':
        return MaterialPageRoute(
          builder: (_) => const WeekGrafikView(),
        );
      case '/myTasks':
        return MaterialPageRoute(builder: (_) => const MyTasksScreen());
      case '/assignEmployee':
        return MaterialPageRoute(builder: (_) => const AssignEmployeeScreen());
      case '/myTasksAssignEmployee':
        return MaterialPageRoute(
            builder: (_) => const MyTasksAssignEmployeeScreen());
      case '/noAccess':
        return MaterialPageRoute(builder: (_) => const NoAccessScreen());
      case '/extras':
        return MaterialPageRoute(builder: (_) => const ExtraOptionsScreen());
      case '/supplies':
        return MaterialPageRoute(builder: (_) => const SupplyListScreen());
      case '/planSupplyRun':
        return MaterialPageRoute(
            builder: (_) => const SupplyRunPlanningScreen());
      case '/approveSupplyRuns':
        return MaterialPageRoute(
            builder: (_) => const SupplyRunApprovalScreen());
      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminPanelScreen());
      case '/serviceRequests':
        return MaterialPageRoute(
          builder: (_) => const ServiceRequestListScreen(),
        );
      case '/serviceRequest/new':
        return MaterialPageRoute(
          builder: (_) => const ServiceRequestFormScreen(),
        );
      case '/addGrafik':
        final existingElement = settings.arguments as GrafikElement?;
        return MaterialPageRoute(
          builder: (_) => GrafikElementFormScreen(
            existingElement: existingElement,
          ),
        );
      default:
        final name = settings.name ?? '';
        final match = RegExp(r'^/serviceRequest/([^/]+)$').firstMatch(name);
        if (match != null) {
          final request = settings.arguments as ServiceRequestElement;
          return MaterialPageRoute(
            builder: (_) => ServiceRequestDetailsScreen(request: request),
          );
        }
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
