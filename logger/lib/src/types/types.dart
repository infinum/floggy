part of logger;

mixin NetworkLogger implements LoggerType {
  @override
  Logger<NetworkLogger> get logger => Logger<NetworkLogger>('Network Logger - ${runtimeType.toString()}');
}

mixin UiLogger implements LoggerType {
  @override
  Logger<UiLogger> get logger => Logger<UiLogger>('UI Logger - ${runtimeType.toString()}');
}
