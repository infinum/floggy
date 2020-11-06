part of loggy;

/// Level class.
/// Name is used printed out to console, and priority is used as level to
/// find out severity of the log.
///
/// [priority] can go from 1 - 99 inclusive. 0 is reserved for `All` and 100 is reserved for `Off`
class LogLevel {
  const LogLevel(this.name, this.priority)
      : assert(name != null),
        assert(priority > 0 && priority < 100,
            'Priority level cannot be less than 1 or greater than 99');

  const LogLevel._(this.name, this.priority);

  /// Reserved levels
  static const LogLevel all = LogLevel._('All', 0);
  static const LogLevel off = LogLevel._('Off', 100);

  /// Default levels
  static const LogLevel debug = LogLevel('Debug', 2);
  static const LogLevel info = LogLevel('Info', 4);
  static const LogLevel warning = LogLevel('Warning', 8);
  static const LogLevel error = LogLevel('Error', 16);

  final int priority;
  final String name;

  @override
  String toString() {
    return name;
  }
}

/// Choose what and how it gets logged
///
/// Log level for the logger is set up in [Loggy.initLogger] and it's used
/// for all new [Loggy].
/// Unless they are [Loggy.detached] or [hierarchicalLoggingEnabled]
/// is enabled. Then those loggers can choose and change [LogOptions] how/when they need it.
///
/// To get loggers caller line number and file name you should set [includeCallerInfo] to true
/// this operation is expensive so it defaults to false
class LogOptions {
  const LogOptions(
    this.logLevel, {
    this.stackTraceLevel = LogLevel.off,
    this.includeCallerInfo = false,
  });

  final LogLevel logLevel;
  final LogLevel stackTraceLevel;

  final bool includeCallerInfo;
}

/// This is sent to the [LogPrinter] and there printer can choose what and how to show it
class LogRecord {
  LogRecord(this.level, this.message, this.loggerName,
      [this.error, this.stackTrace, this.zone, this.object, this.callerFrame])
      : time = DateTime.now(),
        sequenceNumber = LogRecord._nextNumber++;

  final LogLevel level;
  final String message;
  final Object object;
  final String loggerName;
  final DateTime time;
  final int sequenceNumber;
  static int _nextNumber = 0;
  final Object error;
  final StackTrace stackTrace;
  final Zone zone;
  final Frame callerFrame;

  @override
  String toString() => '[${level.toString()}] $loggerName: $message';
}
