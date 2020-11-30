part of loggy;

/// Filter for loggy, everytime new log is added, [Loggy] will go thorough all the filters
/// and if any of them is false, that log will not be displayed.
abstract class LoggyFilter {
  const LoggyFilter();

  bool shouldLog(LogLevel level, Type type);
}
