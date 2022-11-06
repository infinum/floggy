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
    final StringBuffer sb = StringBuffer(ansiEsc);

    if (italic) {
      sb.write('3;');
    }

    if (foregroundColor != null) {
      sb.write('38;5;${foregroundColor}m');
    } else if (backgroundColor != null) {
      sb.write('48;5;${backgroundColor}m');
    }

    if (sb.length == ansiEsc.length) {
      return '';
    } else {
      sb.write(ansiDefault);
      return sb.toString();
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
