import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class UsersRemoteDataSource {
  /// Calls the GET /users?page= endpoint.
  /// Throws a [ServerException] on a non-2xx response and a
  /// [NetworkException] when the request cannot reach the server.
  Future<List<UserModel>> getUsers({int page = 1});
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final ApiClient apiClient;

  const UsersRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<UserModel>> getUsers({int page = 1}) async {
    try {
      final response = await apiClient.dio.get(
        '/users',
        queryParameters: {'page': page},
      );

      if (response.statusCode != 200) {
        throw const ServerException();
      }

      final data = response.data['data'] as List<dynamic>;
      return data
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException();
      }
      throw const ServerException();
    }
  }
}