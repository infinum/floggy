part of loggy;

mixin NetworkLogger implements LoggyType {
  @override
  Loggy<NetworkLogger> get logger =>
      Loggy<NetworkLogger>('Network Logger - ${runtimeType.toString()}');
}

mixin UiLogger implements LoggyType {
  @override
  Loggy<UiLogger> get logger =>
      Loggy<UiLogger>('UI Logger - ${runtimeType.toString()}');
}
