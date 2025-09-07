import 'package:alice/alice.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as log;

import '../../flavors.dart';

abstract class ILogger {
  void t(String message);
  void d(String message);
  void i(String message);
  void w(String message);
  void e(String message, {Object? error, StackTrace? stackTrace});
  void f(String message, {Object? error, StackTrace? stackTrace});
}

class AppLogger implements ILogger {
  static log.Logger? _logger;
  static Alice? _alice;

  static void setAlice(Alice alice) {
    _alice = alice;
  }

  static log.Logger get _instance {
    _logger ??= log.Logger(
      printer: log.PrefixPrinter(
        log.PrettyPrinter(),
        debug: '[${F.name.toUpperCase()}] ',
        trace: '[${F.name.toUpperCase()}] ',
        info: '[${F.name.toUpperCase()}] ',
        warning: '[${F.name.toUpperCase()}] ',
        error: '[${F.name.toUpperCase()}] ',
        fatal: '[${F.name.toUpperCase()}] ',
      ),
    );
    return _logger!;
  }

  void _sendToAlice(
    String level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_alice != null) {
      _alice!.addLog(
        AliceLog(
          message: '[$level] $message${error != null ? '\nError: $error' : ''}',
          level: _mapLogLevel(level),
          timestamp: DateTime.now(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  DiagnosticLevel _mapLogLevel(String level) {
    switch (level) {
      case 'TRACE':
        return DiagnosticLevel.fine;
      case 'DEBUG':
        return DiagnosticLevel.debug;
      case 'INFO':
        return DiagnosticLevel.info;
      case 'WARNING':
        return DiagnosticLevel.warning;
      case 'ERROR':
        return DiagnosticLevel.error;
      case 'FATAL':
        return DiagnosticLevel.error;
      default:
        return DiagnosticLevel.info;
    }
  }

  @override
  void t(String message) {
    _instance.t(message);
    _sendToAlice('TRACE', message);
  }

  @override
  void d(String message) {
    _instance.d(message);
    _sendToAlice('DEBUG', message);
  }

  @override
  void i(String message) {
    _instance.i(message);
    _sendToAlice('INFO', message);
  }

  @override
  void w(String message) {
    _instance.w(message);
    _sendToAlice('WARNING', message);
  }

  @override
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    _instance.e(message, error: error, stackTrace: stackTrace);
    _sendToAlice('ERROR', message, error: error, stackTrace: stackTrace);
  }

  @override
  void f(String message, {Object? error, StackTrace? stackTrace}) {
    _instance.f(message, error: error, stackTrace: stackTrace);
    _sendToAlice('FATAL', message, error: error, stackTrace: stackTrace);
  }
}

class Logger {
  static final ILogger _logger = AppLogger();

  static void setAlice(Alice alice) => AppLogger.setAlice(alice);

  static void t(String message) => _logger.t(message);
  static void d(String message) => _logger.d(message);
  static void i(String message) => _logger.i(message);
  static void w(String message) => _logger.w(message);
  static void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
  static void f(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.f(message, error: error, stackTrace: stackTrace);
}
