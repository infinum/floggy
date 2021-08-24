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

void logDebug(String message) => _globalLoggy.debug(message);
void logInfo(String message) => _globalLoggy.info(message);
void logWarning(String message) => _globalLoggy.warning(message);
void logError(String message) => _globalLoggy.error(message);
