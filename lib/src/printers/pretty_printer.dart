part of logger;

/// Format log and add emoji to represent the color.
///
/// [showColors] - default:false
/// This uses ANSI escape characters and it will be visible only in terminal.
/// IDE-s mostly don't support them and you will only end up with log that has
/// weird prefix and suffix.
///
/// Format:
/// [] *TIME* *LOG PRIORITY*  *LOGGER NAME* - *CLASS NAME* - *LOG MESSAGE*
class PrettyPrinter extends LogPrinter {
  const PrettyPrinter({
    this.showColors,
  }) : super();

  final bool showColors;

  bool get _colorize => showColors ?? false;

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

    final _color = _colorize ? levelColor(record.level) ?? AnsiColor() : AnsiColor();
    final _prefix = levelPrefix(record.level) ?? _defaultPrefix;

    print(_color('$_prefix$_time $_logLevel ${record.loggerName} $_callerFrame ${record.message}'));

    if (record.stackTrace != null) {
      print(record.stackTrace);
    }
  }

  String levelPrefix(Level level) {
    return _levelPrefixes[level];
  }

  AnsiColor levelColor(Level level) {
    return _levelColors[level];
  }
}
