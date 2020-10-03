part of logger;

/// Level class.
/// Name is used printed out to console, and priority is used as level to
/// find out severity of the log.
class Level {
  const Level(this.name, this.priority)
      : assert(name != null),
        assert(priority > 0 && priority < 100, 'Priority level cannot be less than 1 or greater than 99');

  const Level._(this.name, this.priority);

  static const Level all = Level._('All', 0);
  static const Level debug = Level('Debug', 2);
  static const Level info = Level('Info', 4);
  static const Level warning = Level('Warning', 8);
  static const Level error = Level('Error', 16);
  static const Level off = Level._('Off', 100);

  final int priority;
  final String name;

  @override
  String toString() {
    return name;
  }
}

/// Choose what and how it gets logged
///
/// Log level for the logger is set up in [Logger.initLogger] and it's used
/// for all new [Logger].
/// Unless they are [Logger.detached] or [hierarchicalLoggingEnabled]
/// is enabled. Then those loggers can choose and change [LogOptions] how/when they need it.
///
/// To get loggers caller line number and file name you should set [includeCallerInfo] to true
/// this operation is expensive so it defaults to false
class LogOptions {
  const LogOptions(
    this.logLevel, {
    this.stackTraceLevel = Level.off,
    this.includeCallerInfo = false,
  });

  final Level logLevel;
  final Level stackTraceLevel;

  final bool includeCallerInfo;
}

class LogRecord {
  LogRecord(this.level, this.message, this.loggerName,
      [this.error, this.stackTrace, this.zone, this.object, this.callerFrame])
      : time = DateTime.now(),
        sequenceNumber = LogRecord._nextNumber++;

  final Level level;
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
