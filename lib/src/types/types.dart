part of logger;

mixin NetworkLogger implements LoggerType {
  @override
  Logger<NetworkLogger> get log => Logger<NetworkLogger>('NetworkLogger - ${runtimeType.toString()}');
}

mixin UiLogger implements LoggerType {
  @override
  Logger<UiLogger> get log => Logger<UiLogger>('UI Logger - ${runtimeType.toString()}');
}
