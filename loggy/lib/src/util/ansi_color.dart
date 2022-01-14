part of loggy;

/// This class handles colorizing of terminal output.
class AnsiColor {
  AnsiColor({this.backgroundColor, this.foregroundColor, this.italic = false});

  /// ANSI Control Sequence Introducer, signals the terminal for new settings.
  static const ansiEsc = '\x1B[';

  /// Reset all colors and options for current SGRs to terminal defaults.
  static const ansiDefault = '${ansiEsc}0m';

  final int? foregroundColor;
  final int? backgroundColor;
  final bool italic;

  bool get color => foregroundColor != null || backgroundColor != null;

  /// Colors and styles are taken from:
  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  @override
  String toString() {
    final StringBuffer _sb = StringBuffer(ansiEsc);

    if (italic) {
      _sb.write('3;');
    }

    if (foregroundColor != null) {
      _sb.write('38;5;${foregroundColor}m');
    } else if (backgroundColor != null) {
      _sb.write('48;5;${backgroundColor}m');
    }

    if (_sb.length == ansiEsc.length) {
      return '';
    } else {
      _sb.write(ansiDefault);
      return _sb.toString();
    }
  }

  String call(String msg) {
    if (color) {
      return '${this}$msg$ansiDefault';
    } else {
      return msg;
    }
  }

  /// Defaults the terminal's foreground color without altering the background.
  String get resetForeground => color ? '${ansiEsc}39m' : '';

  /// Defaults the terminal's background color without altering the foreground.
  String get resetBackground => color ? '${ansiEsc}49m' : '';

  static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();
}
