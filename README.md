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
    // Including caller info could slow down your app a bit since it is expensive operation, that's why this defaults to false
    // You can also set [stackTraceLevel] that will fetch and show stack trace before the log was called
    logLevel: const LogLevel(
      Level.all,
      includeCallerInfo: true,
    ),

    // You can also blacklist some logger types, blacklisted loggers are not shown
    blacklist: [BlacklistedLogger],

    // You can also whitelist some logger types, whitelisted loggers are the ONLY ones being shown
    whitelist: [NetworkLogger],
  );
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
