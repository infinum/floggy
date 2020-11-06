part of loggy;

/// Printer used to show logs, this can be easily swapped or replaced
abstract class LogPrinter {
  const LogPrinter();

  void onLog(LogRecord record);
}
