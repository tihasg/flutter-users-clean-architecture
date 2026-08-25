/// Thrown by data sources when the server responds with an error status.
class ServerException implements Exception {
  final String message;

  const ServerException([this.message = 'Server error']);
}

/// Thrown by data sources when the device has no connectivity or the
/// request fails to reach the server.
class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'No internet connection']);
}