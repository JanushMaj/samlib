import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'feature/auth/wrapper/auth_wrapper.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'feature/auth/auth_cubit.dart';
import 'feature/grafik/cubit/grafik_cubit.dart';
import 'feature/date/date_cubit.dart';
import 'data/repositories/grafik_element_repository.dart';
import 'domain/services/i_grafik_element_service.dart';
import 'app_router.dart';
import 'theme/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();
  // Example usage of the work time report
  final exampleCubit = GetIt.instance<GrafikCubit>();
  final now = DateTime.now();
  exampleCubit
      .getTotalWorkTimeForEmployee(
        workerId: 'demo-worker',
        start: now.subtract(const Duration(days: 7)),
        end: now,
      )
      .then((duration) {
        print('Demo worker time last week: ${duration.inHours}h');
        exampleCubit.close();
      });

  // Demonstrate usage of the Firestore service (now defaulting to V2)
  final v2Repo = GrafikElementRepository(
    GetIt.instance<IGrafikElementService>(),
  );
  v2Repo
      .getElementsWithinRange(
        start: now.subtract(const Duration(days: 1)),
        end: now,
        types: ['TaskElement'],
      )
      .first
      .then((elements) {
        print('V2 elements count: ${elements.length}');
      });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => GetIt.instance<AuthCubit>(),
        ),
        BlocProvider<DateCubit>(
          create: (_) => GetIt.instance<DateCubit>(),
        ),
        BlocProvider<GrafikCubit>(
          create: (_) => GetIt.instance<GrafikCubit>(),
        ),
      ],
      child: AuthWrapper(
        navigatorKey: navigatorKey,
        child: MaterialApp(
          locale: const Locale('pl', 'PL'),
          supportedLocales: const [
            Locale('pl', 'PL'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Kabast App',
          theme: AppTheme.buildTheme(),
          initialRoute: '/login',
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    );
  }
}
