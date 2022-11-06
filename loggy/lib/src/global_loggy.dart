part of loggy;

/// Separate class for Global loggy.
///
/// Global loggy cannot access calling class name, but it can be called from anywhere in the app
/// without adding mixins to the class.
class GlobalLoggy implements LoggyType {
  @override
  Loggy<GlobalLoggy> get loggy =>
      Loggy<GlobalLoggy>('Global Loggy - ${runtimeType.toString()}');
}

Loggy get _globalLoggy => Loggy<GlobalLoggy>('Global Loggy');

final logDebug = _globalLoggy.debug;
final logInfo = _globalLoggy.info;
final logWarning = _globalLoggy.warning;
final logError = _globalLoggy.error;
