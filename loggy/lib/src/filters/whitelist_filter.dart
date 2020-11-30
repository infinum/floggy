part of loggy;

/// White list filter will log only [Type] of loggy that is passed.
/// You should pass only [Type] that is from [LoggyType] otherwise no effect will take place.
class WhitelistFilter extends LoggyFilter {
  const WhitelistFilter(this._types);

  final List<Type> _types;

  @override
  bool shouldLog(LogLevel level, Type type) {
    return _types == null || _types.contains(type);
  }
}
