part of logger;

/// Different logger types must be mixins and they have to implement [LoggerType]
/// This will make sure that each mixin is using it's own [Logger] and that will be usefull
/// when dictating what we want to show
abstract class LoggerType {
  Logger get log;
}

extension LoggerConstructor on LoggerType {
  Logger logger(String name) => Logger('${log.fullName}.$name');
  Logger detachedLogger(String name) => Logger.detached(name);
}
