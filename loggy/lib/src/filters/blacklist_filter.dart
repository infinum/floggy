part of loggy;

/// Black list filter, opposite of [WhitelistFilter]
class BlacklistFilter extends WhitelistFilter {
  BlacklistFilter(List<Type> types) : super(types);

  @override
  bool shouldLog(LogLevel level, Type type) {
    return !super.shouldLog(level, type);
  }
}
