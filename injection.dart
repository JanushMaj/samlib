import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:kabast/data/repositories/app_user_repository.dart';
import 'package:kabast/data/services/app_user_firebase_service.dart';
import 'package:kabast/data/services/auth_firebase_service.dart';

import 'package:kabast/data/repositories/employee_repository.dart';
import 'package:kabast/data/repositories/vehicle_repository.dart';
import 'package:kabast/data/services/vehicle_watcher.dart';
import 'package:kabast/data/services/employee_firebase_service.dart';
import 'package:kabast/data/services/vehicle_firebase_service.dart';
import 'package:kabast/domain/services/i_app_user_service.dart';
import 'package:kabast/domain/services/i_employee_service.dart';
import 'package:kabast/domain/services/i_vehicle_service.dart';
import 'package:kabast/domain/services/i_auth_service.dart';
import 'package:kabast/feature/auth/auth_cubit.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/feature/date/date_cubit.dart';
import 'package:kabast/data/repositories/grafik_element_repository.dart';
import 'package:kabast/data/services/grafik_element_firebase_service.dart';
import 'package:kabast/domain/services/i_grafik_element_service.dart';
final getIt = GetIt.instance;

Future<void> setupLocator() async {

  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

// FIREBASE SERVICE
  getIt.registerLazySingleton<IAppUserService>(
        () => AppUserFirebaseService(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<IEmployeeService>(
    () => EmployeeFirebaseService(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<IVehicleService>(
    () => VehicleFirebaseService(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<IGrafikElementService>(
    () => GrafikElementFirebaseService(getIt<FirebaseFirestore>()),
  );

  // Repozytoria
  getIt.registerLazySingleton<AppUserRepository>(
    () => AppUserRepository(getIt<IAppUserService>()),
  );
  getIt.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepository(getIt<IEmployeeService>()),
  );
  getIt.registerLazySingleton<VehicleRepository>(
    () => VehicleRepository(getIt<IVehicleService>()),
  );
  getIt.registerLazySingleton<VehicleWatcher>(
    () => VehicleWatcher(getIt<VehicleRepository>()),
  );
  getIt.registerLazySingleton<GrafikElementRepository>(
    () => GrafikElementRepository(getIt<IGrafikElementService>()),
  );

  getIt.registerLazySingleton<IAuthService>(
    () => AuthFirebaseService(
      getIt<FirebaseAuth>(),
      getIt<AppUserRepository>(),
    ),
  );

  //CUBIT
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<IAuthService>()),
  );

  getIt.registerLazySingleton<DateCubit>(
    () => DateCubit(getIt<GrafikElementRepository>()),
  );

  getIt.registerFactory<GrafikCubit>(
    () => GrafikCubit(
      getIt<IGrafikElementService>(),
      getIt<VehicleWatcher>(),
      getIt<IEmployeeService>(),
      getIt<DateCubit>(),
    ),
  );
}
