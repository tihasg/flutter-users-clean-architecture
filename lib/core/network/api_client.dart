import 'package:dio/dio.dart';

/// Thin wrapper around [Dio] configured for the app's REST backend.
/// Centralizing this makes it easy to swap the base URL, add interceptors
/// (auth, logging) or mock the client in tests.
class ApiClient {
  final Dio dio;

  ApiClient({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://reqres.in/api',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );
}