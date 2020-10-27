import 'package:logger/logger.dart';

/// Different logger types
/// This is how user can make custom logger type that can easily later get put to
/// blacklist or whitelist and it will show it's tag along with class that called it
/// if used added [runtimeType] to Logger's name.
mixin BlacklistedLogger implements LoggerType {
  @override
  Logger<BlacklistedLogger> get logger => Logger<BlacklistedLogger>('Blacklisted Logger - ${runtimeType.toString()}');
}

/// Custom logger type can have any name
mixin ExampleLogger implements LoggerType {
  @override
  Logger<ExampleLogger> get logger => Logger<ExampleLogger>('Example');
}
