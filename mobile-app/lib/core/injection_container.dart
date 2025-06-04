// core/injection_container.dart
import 'package:curry_puff_master/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

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