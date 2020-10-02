A library for Dart and Flutter developers.

## Usage
To start using Logger you first have to init Logger, this will make `RootLogger`

```dart
import 'package:ilogger/logger.dart';

main() {
  // Call this as soon as possible (Above runApp)
  Logger.initLogger();
}
```

You can customize logger on init with following:

```dart
Logger.initLogger(
    // Different or custom printer.
    // Available printers are: DefaultPrinter, DeveloperPrinter and PrettyPrinter
    logPrinter: const PrettyPrinter(),
    
    // Set what log levels you would like to see in the app, levels are: all, debug, info, warning, error, off
    // Including caller info is expensive operation, that's why this defaults to false
    // You can also set [stackTraceLevel] that will fetch and show stack trace before the log was called
    logLevel: const LogLevel(
      Level.all,
      includeCallerInfo: true,
      stackTraceLevel: Level.warning
    ),

    // You can also blacklist some logger types, blacklisted loggers are not shown
    blacklist: [BlacklistedLogger],

    // You can also whitelist some logger types, whitelisted loggers are the ONLY ones being shown
    whitelist: [NetworkLogger],
  );
```

## Custom loggers
To make custom logger you just need to make new mixin that implements LoggerType and
returns new logger with mixin type:

```dart
mixin CustomLogger implements LoggerType {
  @override
  Logger<CustomLogger> get log => Logger<CustomLogger>('CustomLoggerName');
}
```

Then to use it just add `with CustomLogger` to class where you want to use it, and then call it with:

```dart
log.debug('DebugMessage');
log.info('InfoMessage');
log.warning('WarningMessage');
log.error('ErrorMessage');
```

If you init the Logger with `PrettyPrinter` and with default `LogLevel` then your log should look like this:
```bash
👾 15:52:16.186827 DEBUG    CustomLogger - CustomLoggerName - DebugMessage
👻 15:52:16.194803 INFO     CustomLogger - CustomLoggerName - InfoMessage
⚠️ 15:52:16.194970 WARNING  CustomLogger - CustomLoggerName - WarningMessage
‼️ 15:52:16.195113 ERROR    CustomLogger - CustomLoggerName - ErrorMessage
```


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
