part of logger;

/// Different logger types must be mixins and they have to implement [LoggerType]
/// This will make sure that each mixin is using it's own [Logger] and that will be usefull
/// when dictating what we want to show
abstract class LoggerType {
  Logger get logger;
}

extension LoggerConstructor on LoggerType {
  Logger newLogger(String name) => Logger('${logger.fullName}.$name');
  Logger detachedLogger(String name) => Logger.detached(name);
}
