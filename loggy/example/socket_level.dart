import 'package:loggy/loggy.dart';

/// We can also add new [LogLevel] to the Loggy that is not in the lib.
/// Here we add new [WtfLevel] with priority of 32 (2^5), meaning it's has more
/// priority than error (16 (2^4)).
const LogLevel socketLevel = LogLevel('Socket', 32);

/// We can also add short version of log for our newly created [LogLevel]
extension SocketLoggy on Loggy {
  void socket(dynamic message, [Object? error, StackTrace? stackTrace]) =>
      log(socketLevel, message, error, stackTrace);
}

/// We can also extend our [PrettyPrinter] and add our colors and prefix to
/// new level, or even change the existing ones.
class PrettySocketPrinter extends PrettyPrinter {
  const PrettySocketPrinter({bool? showColors}) : super(showColors: showColors);

  @override
  AnsiColor? levelColor(LogLevel level) {
    if (level == socketLevel) {
      return AnsiColor(foregroundColor: 141);
    }
    return super.levelColor(level);
  }

  @override
  String? levelPrefix(LogLevel level) {
    if (level == socketLevel) {
      return '👾 ';
    }
    return super.levelPrefix(level);
  }
}
