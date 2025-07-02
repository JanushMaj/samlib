import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:kabast/data/repositories/app_user_repository.dart';
import 'package:kabast/data/services/app_user_firebase_service.dart';

import 'data/repositories/emplyee_repository.dart';
import 'data/repositories/vehicle_repository.dart';
import 'package:kabast/data/services/empleyee_firebase_service.dart';
import 'package:kabast/data/services/vehicle_firebase_service.dart';
import 'feature/auth/auth_cubit.dart';
import 'feature/grafik/cubit/grafik_cubit.dart';
import 'data/repositories/grafik_element_repository.dart';
import 'data/services/grafik_element_firebase_service.dart';
import 'domain/services/i_grafik_element_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {

  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // FIREBASE SERVICE
  getIt.registerLazySingleton<AppUserFirebaseService>(
    () => AppUserFirebaseService(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<EmployeeFirebaseService>(
    () => EmployeeFirebaseService(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<VehicleFirebaseService>(
    () => VehicleFirebaseService(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<IGrafikElementService>(
    () => GrafikElementFirebaseService(getIt<FirebaseFirestore>()),
  );

  // Repozytoria
  getIt.registerLazySingleton<AppUserRepository>(
    () => AppUserRepository(getIt<AppUserFirebaseService>()),
  );
  getIt.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepository(getIt<EmployeeFirebaseService>()),
  );
  getIt.registerLazySingleton<VehicleRepository>(
    () => VehicleRepository(getIt<VehicleFirebaseService>()),
  );
  getIt.registerLazySingleton<GrafikElementRepository>(
    () => GrafikElementRepository(getIt<IGrafikElementService>()),
  );

  //CUBIT
  // Rejestracja AuthCUBIT jako factory – przekazujemy FirebaseAuth oraz AppUserRepository
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<FirebaseAuth>(), getIt<AppUserRepository>()),
  );

  getIt.registerFactory<GrafikCubit>(
    () => GrafikCubit(
      getIt<GrafikElementRepository>(),
      getIt<VehicleRepository>(),
      getIt<EmployeeRepository>(),
    ),
  );
}
