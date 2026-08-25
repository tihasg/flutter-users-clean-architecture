import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_local_data_source.dart';
import '../datasources/users_remote_data_source.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;
  final UsersLocalDataSource localDataSource;

  const UsersRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<User>> getUsers({int page = 1}) async {
    try {
      final users = await remoteDataSource.getUsers(page: page);
      await localDataSource.cacheUsers(users, page: page);
      return users;
    } on ServerException catch (error) {
      final cached = await localDataSource.getCachedUsers(page: page);
      if (cached.isNotEmpty) return cached;
      throw ServerFailure(error.message);
    } on NetworkException catch (error) {
      final cached = await localDataSource.getCachedUsers(page: page);
      if (cached.isNotEmpty) return cached;
      throw NetworkFailure(error.message);
    }
  }
}