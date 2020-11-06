part of loggy;

mixin NetworkLoggy implements LoggyType {
  @override
  Loggy<NetworkLoggy> get logger =>
      Loggy<NetworkLoggy>('Network Loggy - ${runtimeType.toString()}');
}

mixin UiLoggy implements LoggyType {
  @override
  Loggy<UiLoggy> get logger =>
      Loggy<UiLoggy>('UI Loggy - ${runtimeType.toString()}');
}
