import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'domain/models/grafik/grafik_element.dart';
import 'feature/auth/screen/login_screen.dart';
import 'feature/extra_options/extra_options_screen.dart';
import 'feature/grafik/cubit/grafik_cubit.dart';
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
          builder: (_) => BlocProvider(
            create: (_) => GetIt.instance<GrafikCubit>(),
            child: const GrafikWrapper(),
          ),
        );
      case '/weekGrafik':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => GetIt.instance<GrafikCubit>(),
            child: const WeekGrafikView(),
          ),
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
