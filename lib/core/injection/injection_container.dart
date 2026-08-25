import 'package:get_it/get_it.dart';

import '../../features/users/data/datasources/users_local_data_source.dart';
import '../../features/users/data/datasources/users_remote_data_source.dart';
import '../../features/users/data/repositories/users_repository_impl.dart';
import '../../features/users/domain/repositories/users_repository.dart';
import '../../features/users/domain/usecases/get_users.dart';
import '../../features/users/presentation/bloc/users_bloc.dart';
import '../database/app_database.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

/// Registers every dependency the app needs. Call once before `runApp`.
Future<void> init() async {
  // Features - users
  sl.registerFactory(() => UsersBloc(sl()));

  sl.registerLazySingleton(() => GetUsers(sl()));

  sl.registerLazySingleton<UsersRepository>(
    () => UsersRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<UsersRemoteDataSource>(
    () => UsersRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<UsersLocalDataSource>(
    () => UsersLocalDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => AppDatabase());
}