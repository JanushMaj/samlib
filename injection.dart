import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:kabast/data/repositories/app_user_repository.dart';
import 'package:kabast/data/services/app_user_firebase_service.dart';
import 'package:kabast/data/services/auth_firebase_service.dart';

import 'package:kabast/data/repositories/employee_repository.dart';
import 'package:kabast/data/repositories/vehicle_repository.dart';
import 'package:kabast/data/services/vehicle_watcher.dart';
import 'package:kabast/data/services/grafik_resolver.dart';
import 'package:kabast/data/services/employee_firebase_service.dart';
import 'package:kabast/data/services/vehicle_firebase_service.dart';
import 'package:kabast/domain/services/i_app_user_service.dart';
import 'package:kabast/domain/services/i_employee_service.dart';
import 'package:kabast/domain/services/i_vehicle_service.dart';
import 'package:kabast/domain/services/i_vehicle_watcher_service.dart';
import 'package:kabast/domain/services/i_grafik_resolver.dart';
import 'package:kabast/domain/services/i_auth_service.dart';
import 'package:kabast/feature/auth/auth_cubit.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/feature/date/date_cubit.dart';
import 'package:kabast/data/repositories/grafik_element_repository.dart';
import 'package:kabast/data/services/grafik_element_firebase_service.dart';
import 'package:kabast/domain/services/i_grafik_element_service.dart';

import 'package:kabast/data/services/assignment_firebase_service.dart';
import 'package:kabast/data/repositories/assignment_repository.dart';
import 'package:kabast/domain/services/i_assignment_service.dart';

import 'package:kabast/data/services/task_assignment_firebase_service.dart';
import 'package:kabast/data/repositories/task_assignment_repository.dart';
import 'package:kabast/domain/services/i_task_assignment_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // FIREBASE SERVICES
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
  getIt.registerLazySingleton<IAssignmentService>(
    () => AssignmentFirebaseService(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<ITaskAssignmentService>(
    () => TaskAssignmentFirebaseService(getIt<FirebaseFirestore>()),
  );

  // REPOSITORIES
  getIt.registerLazySingleton<AppUserRepository>(
    () => AppUserRepository(getIt<IAppUserService>()),
  );
  getIt.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepository(getIt<IEmployeeService>()),
  );
  getIt.registerLazySingleton<VehicleRepository>(
    () => VehicleRepository(getIt<IVehicleService>()),
  );
  getIt.registerLazySingleton<IVehicleWatcherService>(
    () => VehicleWatcher(getIt<VehicleRepository>()),
  );
  getIt.registerLazySingleton<GrafikElementRepository>(
    () => GrafikElementRepository(getIt<IGrafikElementService>()),
  );
  getIt.registerLazySingleton<AssignmentRepository>(
    () => AssignmentRepository(getIt<IAssignmentService>()),
  );
  getIt.registerLazySingleton<TaskAssignmentRepository>(
    () => TaskAssignmentRepository(getIt<ITaskAssignmentService>()),
  );
  getIt.registerLazySingleton<IGrafikResolver>(
    () => GrafikResolver(getIt<GrafikElementRepository>()),
  );

  getIt.registerLazySingleton<IAuthService>(
    () => AuthFirebaseService(
      getIt<FirebaseAuth>(),
      getIt<AppUserRepository>(),
    ),
  );

  // CUBITS
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<IAuthService>()),
  );

  getIt.registerLazySingleton<DateCubit>(
    () => DateCubit(getIt<IGrafikResolver>()),
  );

  getIt.registerFactory<GrafikCubit>(
    () => GrafikCubit(
      getIt<GrafikElementRepository>(),
      getIt<IVehicleWatcherService>(),
      getIt<EmployeeRepository>(),
      getIt<AssignmentRepository>(),
      getIt<DateCubit>(),
    ),
  );
}
