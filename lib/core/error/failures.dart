import 'package:equatable/equatable.dart';

/// Base class for domain-level failures. Repositories translate data-layer
/// exceptions into these so the presentation layer never depends on
/// data-layer types.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}