import 'package:flutter/foundation.dart';

abstract class AppLogger {
  void info(String message, {Map<String, Object?> context = const <String, Object?>{}});
  void warning(String message, {Map<String, Object?> context = const <String, Object?>{}});
  void error(String message, {Object? error, StackTrace? stackTrace, Map<String, Object?> context = const <String, Object?>{}});
}

class DebugAppLogger implements AppLogger {
  @override
  void error(String message, {Object? error, StackTrace? stackTrace, Map<String, Object?> context = const <String, Object?>{}}) {
    debugPrint('[ERROR] $message | context=$context | error=$error');
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }

  @override
  void info(String message, {Map<String, Object?> context = const <String, Object?>{}}) {
    debugPrint('[INFO] $message | context=$context');
  }

  @override
  void warning(String message, {Map<String, Object?> context = const <String, Object?>{}}) {
    debugPrint('[WARN] $message | context=$context');
  }
}
