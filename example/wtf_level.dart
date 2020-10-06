import 'package:logger/logger.dart';

/// We can also add new [Level] to the Logger that is not in the lib.
/// Here we add new [WtfLevel] with priority of 32 (2^5), meaning it's has more
/// priority than error (16 (2^4)).
extension WtfLevel on Level {
  static const Level wtf = Level('WTF', 32);
}

/// We can also add short version of log for our newly created [Level]
extension WtfLogger on Logger {
  void wtf(dynamic message, [Object error, StackTrace stackTrace]) => log(WtfLevel.wtf, message, error, stackTrace);
}

/// We can also extend our [PrettyPrinter] and add our colors and prefix to
/// new level, or even change the existing ones.
class PrettyWtfPrinter extends PrettyPrinter {
  const PrettyWtfPrinter({bool showColors}) : super(showColors: showColors);

  @override
  AnsiColor levelColor(Level level) {
    if (level == WtfLevel.wtf) {
      return AnsiColor(foregroundColor: 141);
    }
    return super.levelColor(level);
  }

  @override
  String levelPrefix(Level level) {
    if (level == WtfLevel.wtf) {
      return '👾 ';
    }
    return super.levelPrefix(level);
  }
}
