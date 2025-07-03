import 'package:flutter/material.dart';
import 'domain/models/grafik/grafik_element.dart';
import 'feature/auth/screen/login_screen.dart';
import 'feature/extra_options/extra_options_screen.dart';
import 'feature/grafik/form/grafik_element_form_screen.dart';
import 'feature/grafik/grafik_wrapper.dart';
import 'feature/grafik/widget/week/week_grafik_view.dart';

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
      case '/extras':
        return MaterialPageRoute(builder: (_) => const ExtraOptionsScreen());
      case '/addGrafik':
        final existingElement = settings.arguments as GrafikElement?;
        return MaterialPageRoute(
          builder: (_) => GrafikElementFormScreen(
            existingElement: existingElement,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
