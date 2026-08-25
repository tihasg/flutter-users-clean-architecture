import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter/core/error/exceptions.dart';
import 'package:test_flutter/core/network/api_client.dart';
import 'package:test_flutter/features/users/data/datasources/users_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late UsersRemoteDataSourceImpl dataSource;
  late MockDio dio;

  final requestOptions = RequestOptions(path: '/users');

  setUp(() {
    dio = MockDio();
    dataSource = UsersRemoteDataSourceImpl(ApiClient(dio: dio));
  });

  test('should return a list of UserModel on a 200 response', () async {
    when(() => dio.get(
          '/users',
          queryParameters: {'page': 1},
        )).thenAnswer(
      (_) async => Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: {
          'data': [
            {
              'id': 1,
              'email': 'george.bluth@reqres.in',
              'first_name': 'George',
              'last_name': 'Bluth',
              'avatar': 'https://reqres.in/img/faces/1-image.jpg',
            },
          ],
        },
      ),
    );

    final result = await dataSource.getUsers(page: 1);

    expect(result, hasLength(1));
    expect(result.first.email, 'george.bluth@reqres.in');
  });

  test('should throw ServerException on a non-200 response', () async {
    when(() => dio.get(
          '/users',
          queryParameters: {'page': 1},
        )).thenAnswer(
      (_) async => Response(
        requestOptions: requestOptions,
        statusCode: 404,
        data: {},
      ),
    );

    expect(
      () => dataSource.getUsers(page: 1),
      throwsA(isA<ServerException>()),
    );
  });

  test('should throw NetworkException on a connection error', () async {
    when(() => dio.get(
          '/users',
          queryParameters: {'page': 1},
        )).thenThrow(
      DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
      ),
    );

    expect(
      () => dataSource.getUsers(page: 1),
      throwsA(isA<NetworkException>()),
    );
  });
}