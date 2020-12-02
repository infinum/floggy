part of loggy;

/// Different logger types must be mixins and they have to implement [LoggyType]
/// This will make sure that each mixin is using it's own [Loggy] and that will be usefull
/// when dictating what we want to show
abstract class LoggyType {
  Loggy get loggy;
}

extension LoggySpawner on LoggyType {
  Loggy newLoggy(String name) => Loggy('${loggy.fullName}.$name');
  Loggy detachedLoggy(String name) => Loggy.detached(name);
}
