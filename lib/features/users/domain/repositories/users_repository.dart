import '../entities/user.dart';

abstract class UsersRepository {
  Future<List<User>> getUsers({int page = 1});
}