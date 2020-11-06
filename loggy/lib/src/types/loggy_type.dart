part of loggy;

/// Different logger types must be mixins and they have to implement [LoggerType]
/// This will make sure that each mixin is using it's own [Loggy] and that will be usefull
/// when dictating what we want to show
abstract class LoggerType {
  Loggy get logger;
}

extension LoggerConstructor on LoggerType {
  Loggy newLogger(String name) => Loggy('${logger.fullName}.$name');
  Loggy detachedLogger(String name) => Loggy.detached(name);
}
