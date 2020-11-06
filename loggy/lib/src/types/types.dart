part of loggy;

mixin NetworkLoggy implements LoggyType {
  @override
  Loggy<NetworkLoggy> get loggy =>
      Loggy<NetworkLoggy>('Network Loggy - ${runtimeType.toString()}');
}

mixin UiLoggy implements LoggyType {
  @override
  Loggy<UiLoggy> get loggy =>
      Loggy<UiLoggy>('UI Loggy - ${runtimeType.toString()}');
}
