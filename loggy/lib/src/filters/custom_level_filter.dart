part of loggy;

/// Define custom levels for logging custom types, [LoggyType]s added here can define higher level for logging.
///
/// Setting [logLevel] lower that current level set in root will not do anything. Root level is still one being
/// validated first (Before any filters)
class CustomLevelFilter extends LoggyFilter {
  CustomLevelFilter(this.logLevel, this._types);

  final List<Type> _types;
  final LogLevel logLevel;

  @override
  bool shouldLog(LogLevel level, Type type) {
    if (logLevel.priority > level.priority) {
      return _types.isEmpty || !_types.contains(type);
    }

    return true;
  }
}
