/// Failure hierarchy used across the app for error handling & presentation mapping.
/// Each concrete failure has a distinct [code] to simplify UI mapping.
abstract class Failure {
  const Failure(this.code, {this.message, this.cause});

  /// Stable machine-friendly code for switch/case mapping in UI layer.
  final FailureCode code;

  /// Optional human / debug message (do NOT rely on this for logic).
  final String? message;

  /// Underlying error object if any (not for serialization).
  final Object? cause;

  @override
  String toString() => 'Failure(code: ${code.name}, message: $message)';
}

enum FailureCode {
  // Generic / Unknown
  unknown,
  cancelled,
  // Network layer
  network,
  timeout,
  ssl,
  // HTTP status related
  badRequest, // 400
  unauthorized, // 401
  forbidden, // 403
  notFound, // 404
  conflict, // 409
  tooManyRequests, // 429
  server, // 500-599
  // Data layer
  parsing,
  emptyResponse,
}

class UnknownFailure extends Failure {
  const UnknownFailure({String? message, Object? cause})
    : super(FailureCode.unknown, message: message, cause: cause);
}

class CancelledFailure extends Failure {
  const CancelledFailure({String? message})
    : super(FailureCode.cancelled, message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String? message, Object? cause})
    : super(FailureCode.network, message: message, cause: cause);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({String? message})
    : super(FailureCode.timeout, message: message);
}

class SSLFailure extends Failure {
  const SSLFailure({String? message, Object? cause})
    : super(FailureCode.ssl, message: message, cause: cause);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure({String? message})
    : super(FailureCode.badRequest, message: message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String? message})
    : super(FailureCode.unauthorized, message: message);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({String? message})
    : super(FailureCode.forbidden, message: message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({String? message})
    : super(FailureCode.notFound, message: message);
}

class ConflictFailure extends Failure {
  const ConflictFailure({String? message})
    : super(FailureCode.conflict, message: message);
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({String? message})
    : super(FailureCode.tooManyRequests, message: message);
}

class ServerFailure extends Failure {
  const ServerFailure({String? message})
    : super(FailureCode.server, message: message);
}

class ParsingFailure extends Failure {
  const ParsingFailure({String? message, Object? cause})
    : super(FailureCode.parsing, message: message, cause: cause);
}

class EmptyResponseFailure extends Failure {
  const EmptyResponseFailure({String? message})
    : super(FailureCode.emptyResponse, message: message);
}
