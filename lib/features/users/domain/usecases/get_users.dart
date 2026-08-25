import '../entities/user.dart';
import '../repositories/users_repository.dart';

/// Fetches a page of users. Encapsulating this as a single-purpose use
/// case keeps the BLoC free of repository/data-layer knowledge.
class GetUsers {
  final UsersRepository repository;

  const GetUsers(this.repository);

  Future<List<User>> call({int page = 1}) => repository.getUsers(page: page);
}