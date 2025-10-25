import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/theme/theme_bloc.dart';
import '../../core/utils/app_utils.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => SharedPreferences.getInstance());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuth: sl(),
      googleSignIn: sl(),
      firestore: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => AuthUseCases(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(authUseCases: sl()));
  sl.registerFactory(() => ThemeBloc());

  // Utils
  sl.registerLazySingleton(() => AppUtils());
}

// Navigation helper
class NavigationService {
  static void navigateTo(String routeName, {Object? arguments}) {
    // This will be implemented with named routes
  }

  static void navigateAndReplace(String routeName, {Object? arguments}) {
    // This will be implemented with named routes
  }

  static void navigateAndClear(String routeName, {Object? arguments}) {
    // This will be implemented with named routes
  }
}
