part of loggy;

class StdErrPrinter extends PrettyPrinter {
  const StdErrPrinter() : super();

  @override
  @override
  void onLog(LogRecord record) {
    final time = record.time.toIso8601String().split('T')[1];

    final callerFrame =
        record.callerFrame == null ? '-' : '(${record.callerFrame?.location})';

    final logLevel = record.level
        .toString()
        .replaceAll('Level.', '')
        .toUpperCase()
        .padRight(8);

    final color =
        colorize ? levelColor(record.level) ?? AnsiColor() : AnsiColor();

    final prefix = levelPrefix(record.level) ?? PrettyPrinter.defaultPrefix;

    stderr.writeln(color(
        '$prefix$time $logLevel ${record.loggerName} $callerFrame ${record.message}'));

    if (record.stackTrace != null) {
      stderr.writeln('${record.stackTrace}\n');
    }
  }
}
