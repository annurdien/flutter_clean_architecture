import 'dart:io';

import 'package:dio/dio.dart';

import 'failures.dart';

/// Maps any thrown [Object] (esp. Dio errors) to a domain [Failure].
class ErrorMapper {
  const ErrorMapper._();

  static Failure map(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) return error;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          return const CancelledFailure(message: 'Request cancelled');
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return const TimeoutFailure(message: 'Network timeout');
        case DioExceptionType.badCertificate:
          return SSLFailure(message: 'Bad SSL certificate', cause: error);
        case DioExceptionType.connectionError:
          return NetworkFailure(
            message: 'No internet connection',
            cause: error,
          );
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return NetworkFailure(message: 'Socket exception', cause: error);
          }
        case DioExceptionType.badResponse:
          break;
      }

      final Response<dynamic>? response = error.response;
      if (response != null) {
        final int status = response.statusCode ?? -1;
        if (status >= 500) {
          return ServerFailure(message: 'Server error ($status)');
        }
        switch (status) {
          case 400:
            return BadRequestFailure(
              message: _extractMessage(response.data) ?? 'Bad request',
            );
          case 401:
            return const UnauthorizedFailure(message: 'Unauthorized');
          case 403:
            return const ForbiddenFailure(message: 'Forbidden');
          case 404:
            return const NotFoundFailure(message: 'Not found');
          case 409:
            return const ConflictFailure(message: 'Conflict');
          case 429:
            return const TooManyRequestsFailure(message: 'Too many requests');
        }
      }

      // Fallback unknown for DioException
      return UnknownFailure(message: error.message, cause: error);
    }

    if (error is FormatException) {
      return ParsingFailure(message: error.message, cause: error);
    }

    if (error is SocketException) {
      return NetworkFailure(message: error.message, cause: error);
    }

    return UnknownFailure(message: error.toString(), cause: error);
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is String) return data;
    if (data is Map) {
      final List<String> keys = <String>[
        'message',
        'error',
        'detail',
        'description',
      ];
      for (final String k in keys) {
        if (data[k] is String) return data[k] as String;
      }
    }
    return null;
  }
}
