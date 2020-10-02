part of logger;

mixin NetworkLogger implements LoggerType {
  @override
  Logger<NetworkLogger> get log => Logger<NetworkLogger>('NetworkLogger - ${runtimeType.toString()}');
}

mixin UiLogger implements LoggerType {
  @override
  Logger<UiLogger> get log => Logger<UiLogger>('UI Logger - ${runtimeType.toString()}');
}

mixin BlacklistedLogger implements LoggerType {
  @override
  Logger<BlacklistedLogger> get log => Logger<BlacklistedLogger>('Blacklisted Logger - ${runtimeType.toString()}');
}

mixin ExampleLogger implements LoggerType {
  @override
  Logger<ExampleLogger> get log => Logger<ExampleLogger>('Example');
}
