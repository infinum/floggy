part of logger;

class DeveloperPrinter extends LogPrinter {
  const DeveloperPrinter() : super();

  @override
  void onLog(LogRecord record) {
    developer.log(
      '${record.loggerName}: ${record.message}',
      name: '${record.time.toIso8601String()}: ${record.level.toString()}',
      error: record.error,
      stackTrace: record.stackTrace,
    );
  }
}
