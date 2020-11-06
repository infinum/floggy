part of logger;

mixin NetworkLogger implements LoggerType {
  @override
  Loggy<NetworkLogger> get logger =>
      Loggy<NetworkLogger>('Network Logger - ${runtimeType.toString()}');
}

mixin UiLogger implements LoggerType {
  @override
  Loggy<UiLogger> get logger =>
      Loggy<UiLogger>('UI Logger - ${runtimeType.toString()}');
}
