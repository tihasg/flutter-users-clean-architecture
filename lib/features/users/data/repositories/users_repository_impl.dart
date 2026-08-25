import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_remote_data_source.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  const UsersRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<User>> getUsers({int page = 1}) async {
    try {
      return await remoteDataSource.getUsers(page: page);
    } on ServerException catch (error) {
      throw ServerFailure(error.message);
    } on NetworkException catch (error) {
      throw NetworkFailure(error.message);
    }
  }
}