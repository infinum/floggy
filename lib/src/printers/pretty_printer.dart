part of logger;

class PrettyPrinter extends LogPrinter {
  const PrettyPrinter({
    this.showColors = true,
  }) : super();

  final bool showColors;

  static final _levelColors = {
    Level.debug: AnsiColor(foregroundColor: AnsiColor.grey(0.5), italic: true),
    Level.info: AnsiColor(foregroundColor: 35),
    Level.warning: AnsiColor(foregroundColor: 214),
    Level.error: AnsiColor(foregroundColor: 196),
  };

  static final _levelPrefixes = {
    Level.debug: '🐛 ',
    Level.info: '👻 ',
    Level.warning: '⚠️ ',
    Level.error: '‼️ ',
  };

  static const _defaultPrefix = '🤔 ';

  @override
  void onLog(LogRecord record) {
    final _time = record.time.toIso8601String().split('T')[1];
    final _callerFrame = record.callerFrame == null ? '-' : '(${record.callerFrame.location})';
    final _logLevel = record.level.toString().replaceAll('Level.', '').toUpperCase().padRight(8);

    final _color = levelColor(record.level) ?? AnsiColor();
    final _prefix = levelPrefix(record.level) ?? _defaultPrefix;

    print(_color('$_prefix$_time $_logLevel ${record.loggerName} $_callerFrame ${record.message}'));

    // if (record.callerFrame != null) {
    //   print('${record.callerFrame.location} Here?');
    // }

    if (record.stackTrace != null) {
      print(record.stackTrace);
    }
  }

  String levelPrefix(Level level) {
    return _levelPrefixes[level];
  }

  AnsiColor levelColor(Level level) {
    if (!showColors) {
      return null;
    }

    return _levelColors[level];
  }
}
