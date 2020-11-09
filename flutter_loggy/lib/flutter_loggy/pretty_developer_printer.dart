import 'dart:developer' as developer;

import 'package:loggy/loggy.dart';

class PrettyDeveloperPrinter extends LogPrinter {
  static final _levelPrefixes = {
    LogLevel.debug: '🐛 ',
    LogLevel.info: '👻 ',
    LogLevel.warning: '⚠️ ',
    LogLevel.error: '‼️ ',
  };

  static const _defaultPrefix = '🤔 ';

  @override
  void onLog(LogRecord record) {
    final _time = record.time.toIso8601String().split('T')[1];
    final _callerFrame =
        record.callerFrame == null ? '-' : '(${record.callerFrame.location})';
    final _logLevel =
        record.level.toString().replaceAll('Level.', '').toUpperCase();

    final _prefix = levelPrefix(record.level) ?? _defaultPrefix;

    developer.log(
      '$_prefix$_time $_logLevel $_callerFrame ${record.message}',
      name: record.loggerName,
      error: record.error,
      stackTrace: record.stackTrace,
      level: record.level.priority,
      time: record.time,
      zone: record.zone,
      sequenceNumber: record.sequenceNumber,
    );
  }

  String levelPrefix(LogLevel level) {
    return _levelPrefixes[level];
  }
}
