part of logger;

class PrettyPrinter extends LogPrinter {
  const PrettyPrinter() : super();

  @override
  void onLog(LogRecord record) {
    final _time = record.time.toIso8601String().split('T')[1];
    final _callerFrame = record.callerFrame == null ? '-' : '(${record.callerFrame.location})';
    final _logLevel = record.level.toString().replaceAll('Level.', '').toUpperCase().padRight(8);

    print('${_levelPrefix(record.level)}$_time $_logLevel ${record.loggerName} $_callerFrame ${record.message}');

    // if (record.callerFrame != null) {
    //   print('${record.callerFrame.location} Here?');
    // }

    if (record.stackTrace != null) {
      print(record.stackTrace);
    }
  }

  String _levelPrefix(Level level) {
    switch (level) {
      case Level.debug:
        return '👾 ';
      case Level.info:
        return '👻 ';
      case Level.warning:
        return '⚠️ ';
      case Level.error:
        return '‼️ ';
      case Level.all:
      case Level.off:
        return null;
    }

    return null;
  }
}
