import 'failures.dart';

String mapFailureToMessage(Failure failure) {
  switch (failure.code) {
    case FailureCode.network:
      return 'Network issue. Check your connection.';
    case FailureCode.timeout:
      return 'Request timed out. Please retry.';
    case FailureCode.tooManyRequests:
      return 'Too many requests. Slow down a bit.';
    case FailureCode.server:
      return 'Server error. Try again later.';
    case FailureCode.unauthorized:
      return 'Session expired. Please log in again.';
    case FailureCode.forbidden:
      return 'You are not allowed to do this.';
    case FailureCode.notFound:
      return 'Resource not found.';
    case FailureCode.badRequest:
      return 'Invalid request.';
    case FailureCode.conflict:
      return 'Conflict occurred.';
    case FailureCode.parsing:
      return 'Data error. Please contact support.';
    case FailureCode.emptyResponse:
      return 'Empty response from server.';
    case FailureCode.ssl:
      return 'Secure connection failed.';
    case FailureCode.cancelled:
      return 'Operation cancelled.';
    case FailureCode.unknown:
      return 'An unexpected error occurred.';
  }
}
