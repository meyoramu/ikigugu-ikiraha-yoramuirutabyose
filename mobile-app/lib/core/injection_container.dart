// core/injection_container.dart
import 'package:curry_puff_master/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

/// Service locator instance used for dependency injection throughout the app.
/// This is a singleton instance of GetIt that manages all dependencies.
final sl = GetIt.instance;

/// Initializes the dependency injection container.
/// 
/// This function sets up all dependencies in the app using the service locator.
/// It registers:
/// * BLoCs - For state management
/// * Use cases - For business logic
/// * Repositories - For data layer abstraction
/// * Data sources - For external data access
/// * External dependencies - Like HTTP clients
Future<void> init() async {
  // Blocs
  sl.registerFactory(() => AuthBloc());
  
  // Use cases
  // sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  
  // Repositories
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  
  // Data sources
  // sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(client: sl()));
  
  // External
  // sl.registerLazySingleton(() => http.Client());
}