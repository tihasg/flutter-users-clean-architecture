import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around [Dio] configured for the app's REST backend.
/// Centralizing this makes it easy to swap the base URL, add interceptors
/// (auth, logging) or mock the client in tests.
class ApiClient {
  final Dio dio;

  ApiClient({Dio? dio}) : dio = dio ?? _buildDio();

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://reqres.in/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Prints every request/response to the console (visible via `flutter
    // logs` / logcat), mirroring what Android Studio's Network Inspector
    // would show for a native app. Kept out of release builds since it
    // logs full request/response bodies.
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    return dio;
  }
}