part of loggy;

/// Printer used to show logs, this can be easily swapped or replaced
abstract class LoggyPrinter {
  const LoggyPrinter();

  void onLog(LogRecord record);
}
