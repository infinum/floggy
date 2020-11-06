# Logger

Customizable logger for dart


## Usage
To start using Logger you first have to init Logger, this will make `RootLogger` without a name and set up 
all the options that other loggers in the app will follow.
```dart
import 'package:logger/loggy.dart';

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
    // You can also set [stackTraceLogLevel] that will fetch and show stack trace before the log was called
    logOptions: const LogLevel(
      LogLevel.all,
      includeCallerInfo: true,
      stackTraceLogLevel: LogLevel.warning
    ),
    
    // You can also blacklist some logger types, blacklisted loggers are not shown
    blacklist: [BlacklistedLogger],

    // You can also whitelist some logger types, whitelisted loggers are the ONLY ones being shown
    whitelist: [NetworkLogger],
  );
```

After that you can start using logger in your app, lib will provide you with 2 predefined LoggerTypes, you can 
also make custom one and use that instead.
```dart
class MyAppScreen with UiLogger{
  MyAppScreen(){
    logger.debug('DebugMessage');
    logger.info('InfoMessage');
    logger.warning('WarningMessage');
    logger.error('ErrorMessage');
  }
}
```

If you have initialized the Logger just with `PrettyPrinter` then your log should look something like this:
```bash
🐛 15:52:16.186827 DEBUG    UI Logger - MyAppScreen - DebugMessage
👻 15:52:16.194803 INFO     UI Logger - MyAppScreen - InfoMessage
⚠️ 15:52:16.194970 WARNING  UI Logger - MyAppScreen - WarningMessage
‼️ 15:52:16.195113 ERROR    UI Logger - MyAppScreen - ErrorMessage
```

You can pass closure to the Logger as well, closure will get evaluated only if/when log gets
called and should be shown.
```dart
logger.info(() {
  /// You can do what you want here!
  const _s = 0 / 0;
  return List.generate(10, (_) => _s)
          .fold<String>('', (previousValue, element) => previousValue += element.toString()) +
      ' Batman';
});
```

## Custom loggers
You can have as many custom loggers as you want, by default you are provided with 2 types:
`NetworkLogger` and `UiLogger`

To make custom logger you just need to make new mixin that implements `LoggerType` and
returns new logger with mixin type:

```dart
mixin CustomLogger implements LoggerType {
  @override
  Logger<CustomLogger> get log => Logger<CustomLogger>('My Custom Logger');
}
```

Then to use it just add `with CustomLogger` to class where you want to use it.

## Custom log levels and expanding existing printers
You can add new LogLevel to log like this:
```dart
extension WtfLevel on LogLevel {
  // LogLevel is just a class with `name` and `priority`. Priority can go from 1 - 99 inclusive.
  static const LogLevel wtf = LogLevel('WTF', 32);
}
```
When adding a new level it's also recommended extending the Logger class as well to add quick function for that level.
```dart
extension WtfLogger on Logger {
  void wtf(dynamic message, [Object error, StackTrace stackTrace]) => log(WtfLevel.wtf, message, error, stackTrace);
}
```

## More loggers?
Do you need more loggers? No problem!
When you include `with LoggerA` you can make new loggers with `logger(name)` or `detachedLogger(name)`.

#### Child logger
`logger(name)` will create new child logger that will be connected to parent logger and share the same options.

#### Detached logger
`detachedLogger(name)` is logger that has nothing to do with our `RootLogger` and all options will be ignored.
This can be helpful if you have small part of code you want to log but don't want to depend on other options or LogLevels. 

## Features and bugs
Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/infinum/flutter-logger/issues
