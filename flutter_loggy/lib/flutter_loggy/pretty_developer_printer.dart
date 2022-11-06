part of flutter_loggy;

/// Pretty printer that uses developer.log to show log messages
class PrettyDeveloperPrinter extends LoggyPrinter {
  const PrettyDeveloperPrinter();

  static final Map<LogLevel, String> _levelPrefixes = <LogLevel, String>{
    LogLevel.debug: '🐛 ',
    LogLevel.info: '👻 ',
    LogLevel.warning: '⚠️ ',
    LogLevel.error: '‼️ ',
  };

  // For undefined log levels
  static const String _defaultPrefix = '🤔 ';

  @override
  void onLog(LogRecord record) {
    final String time = record.time.toIso8601String().split('T')[1];
    final String callerFrame =
        record.callerFrame == null ? '-' : '(${record.callerFrame?.location})';
    final String logLevel =
        record.level.toString().replaceAll('Level.', '').toUpperCase();

    final String prefix = levelPrefix(record.level) ?? _defaultPrefix;

    developer.log(
      '$prefix$time $logLevel $callerFrame ${record.message}',
      name: record.loggerName,
      error: record.error,
      stackTrace: record.stackTrace,
      level: record.level.priority,
      time: record.time,
      zone: record.zone,
      sequenceNumber: record.sequenceNumber,
    );
  }

  /// Get prefix for level
  String? levelPrefix(LogLevel level) {
    return _levelPrefixes[level];
  }
}
