# Loggy
![Loggy icon][loggy_image]

Highly customizable logger for dart that uses mixins to show all the needed info.

## Setup
Add logger package to your project:
```yaml
dependencies:
    loggy: ^2.0.1+1
```

## Usage
Now once you added loggy to your project you can start using it. First, you need to initialize it:
```dart
import 'package:loggy/loggy.dart';

main() {
  Loggy.initLoggy();
}
```

In case you just want to log something without adding mixin you can use `GlobalLoggy` that is accessible everywhere, and it will follow the rules set in `initLoggy` method

 ```dart
 import 'package:loggy/loggy.dart';
 
 class DoSomeWork {
  DoSomeWork() {
    logDebug('This is debug message');
    logInfo('This is info message');
    logWarning('This is warning message');
    logError('This is error message');
  }
 }
 ```
While global loggy is easier to use, it cannot be easily filtered, and it cannot fetch the calling class.
 
By using mixins to access our logger, you can get more info from loggy, now I will show you how to use default types (**UiLoggy**, **NetworkLoggy**). Later in the customizing loggy part, I will show you how you can easily add more types depending on the specific use case.
```dart
import 'package:loggy/loggy.dart';

class DoSomeWork with UiLoggy {
 DoSomeWork() {
   loggy.debug('This is debug message');
   loggy.info('This is info message');
   loggy.warning('This is warning message');
   loggy.error('This is error message');
 }
}
```

As you can see with the magic of mixins you already know the class name from where the log has been called as well as which logger made the call. Now you can use loggy through the app.
```bash
[D] UI Loggy - DoSomeWork: This is debug message
[I] UI Loggy - DoSomeWork: This is info message
[W] UI Loggy - DoSomeWork: This is warning message
[E] UI Loggy - DoSomeWork: This is error message
```

Loggy can take anything as it's log message, even closures (they are evaluated only if the log has been shown)
```dart
loggy.info(() {
  /// You can do what you want here!
  const _s = 0 / 0;
  return List.generate(10, (_) => _s)
          .fold<String>('', (previousValue, element) => previousValue += element.toString()) +
      ' Batman';
});
```

## Customization
### Printer
Printer or how our log is displayed can be customized a lot, by default loggy will use **DefaultPrinter**, you can replace this by specifying different `logPrinter` on initialization, you can use **PrettyPrinter** that is already included in loggy. You can also easily make your printer by extending the **LoggyPrinter** class.

You can customize logger on init with the following:
```dart
import 'package:loggy/loggy.dart';

void main() {
 // Call this as soon as possible (Above runApp)
 Loggy.initLoggy(
  logPrinter: const PrettyPrinter(),
 );
}

```
Loggy with **PrettyPrinter**:
```bash
🐛 12:22:49.712326 DEBUG    UI Loggy - DoSomeWork - This is debug message
👻 12:22:49.712369 INFO     UI Loggy - DoSomeWork - This is info message
⚠️ 12:22:49.712403 WARNING  UI Loggy - DoSomeWork - This is warning message
‼️ 12:22:49.712458 ERROR    UI Loggy - DoSomeWork - This is error message
```

One useful thing is specifying different printer for release that logs to Crashlytics/Sentry instead of console. 

You could create your own `CrashlyticsPrinter` by extending `Printer` and use it like:

```dart
  Loggy.initLoggy(
    logPrinter: (kReleaseMode) ? CrashlyticsPrinter() : PrettyPrinter(),
    ...
  );
```

### Log options
By providing **LogOptions** you need to specify **LogLevel** that will make sure only levels above what is specified will be shown.

Here you can also control some logging options by changing the `stackTraceLevel`, by specifying level will extract stack trace before the log has been invoked, for all **LogLevel** severities above the specified one.

Setting `stackTraceLevel` to `LogLevel.error`:
```shell
🐛 12:26:48.432602 DEBUG    UI Loggy - DoSomeWork - This is debug message
👻 12:26:48.432642 INFO     UI Loggy - DoSomeWork - This is info message
⚠️ 12:26:48.432676 WARNING  UI Loggy - DoSomeWork - This is warning message
‼️ 12:26:48.432715 ERROR    UI Loggy - DoSomeWork - This is error message
#0      Loggy.log (package:loggy/src/loggy.dart:195:33)
#1      Loggy.error (package:loggy/src/loggy.dart:233:73)
#2      new DoSomeWork (.../loggy/example/loggy_example.dart:29:11)
#3      main (.../loggy/example/loggy_example.dart:21:3)
#4      _startIsolate.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:301:19)
#5      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:168:12)
```

### Custom loggers
You can have as many custom loggers as you want, by default you are provided with 2 types:
**NetworkLoggy** and **UiLoggy**

To make a custom logger you just need to make a new mixin that implements **LoggyType** and
returns new logger with mixin type:
```dart
import 'package:loggy/loggy.dart';

mixin CustomLoggy implements LoggyType {
  @override
  Loggy<CustomLoggy> get loggy => Loggy<CustomLoggy>('Custom Loggy - $runtimeType');
}
```

Then to use it just add `with CustomLoggy` to the class where you want to use it.

### Custom log levels
You can add new LogLevel to log like this:
```dart
// LogLevel is just a class with `name` and `priority`. Priority can go from 1 - 99 inclusive.
const LogLevel socketLevel = LogLevel('socket', 32);
```

When adding a new level it's also recommended extending the Loggy class as well to add quick function for that level.
```dart
extension SocketLoggy on Loggy {
  void socket(dynamic message, [Object error, StackTrace stackTrace]) => log(socketLevel, message, error, stackTrace);
}
```

You can now use new log level in the app:
```dart
loggy.socket('This is log with socket log level');
```

### Filtering
Now you have a lot of different types and levels how to find what you need? You may need to filter some of them. We have **WhitelistFilter**, **BlacklistFilter** and **CustomLevelFilter**. 

Filtering is a way to limit log output without actually changing or removing existing loggers. Whitelisting some logger types will make sure only logs from that specific type are shown. Blacklisting will do the exact opposite of that. This is useful if your loggers log ton of data and pollute the console so it's hard to see valuable information.

```dart
  Loggy.initLoggy(
    ... // other stuff
    filters: [
      BlacklistFilter([SocketLoggy]) // Don't log logs from SocketLoggy
    ],
  );
```

### More loggers?
Do you need more loggers? No problem!

Any class using Loggy mixin can make new child loggers with `newLoggy(name)` or `detachedLoggy(name)`.

#### Child logger
`newLoggy(name)` will create a new child logger that will be connected to the parent logger and share the same options.
Child loggy will have parent name included as the prefix on a child's name, divided by `.`.

#### Detached logger
`detachedLoggy(name)` is a logger that has nothing to do with the parent loggy and all options will be ignored.
If you want to see those logs you need to attach a printer to it.
```dart
final _logger = detachedLoggy('Detached logger', logPrinter: DefaultPrinter());
_logger.level = const LogOptions(LogLevel.all);
// Add printer
```

## Loggy 💙 Flutter
Extensions that you can use in Flutter to make our logs look nicer. In order to fully use Loggy features in flutter make sure you are importing `flutter_loggy` pub package. In it you can find printer for flutter console `PrettyDeveloperPrinter` and widget that can show you all the logs: `LoggyStreamWidget`
### Pretty developer printer
```
Loggy.initLoggy(
  logPrinter: PrettyDeveloperPrinter(),
);
```
This printer uses `dart:developer` and can write error messages in red, and it gives us more flexibility. This way you can modify this log a bit more and remove log prefixes (ex. `[        ] I/flutter (21157)`)

To see logs in-app you can use `StreamPrinter` and pass any other printer to it. Now you can use `LoggyStreamWidget` to show logs in a list. 

## Loggy 💙 Dio as well!
Extension for loggy. Includes the interceptor and pretty printer to use with Dio.
In order to use Dio with Loggy you will have to import `flutter_loggy_dio` package, that will include an interceptor and new loggy type for Dio calls. 
### Usage
For Dio you included special `DioLoggy` that can be filtered, and `LoggyDioInterceptor` that will connect to Dio and print out requests and responses.
```dart
Dio dio = Dio();
dio.interceptors.add(LoggyDioInterceptor());
```
That will use Loggy options and levels, you can change the default `LogLevel` for request, response, and error.

### Setup
In IntelliJ/Studio you can collapse the request/response body:
![Gif showing collapsible body][show_body]


Set up this is by going to `Preferences -> Editor -> General -> Console` and under `Fold console lines that contain` add these 3 rules: `║`, `╔` and `╚`.
![Settings][settings]
 
## Features and bugs
Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/infinum/floggy/issues
[loggy_image]: https://github.com/infinum/floggy/raw/master/assets/loggy_image.png
[show_body]: https://github.com/infinum/floggy/raw/master/assets/2020-10-28%2010.38.39.gif 
[settings]: https://github.com/infinum/floggy/raw/master/assets/screenshot_settings.png

<p align="center">
  <a href='https://infinum.com'>
    <picture>
        <source srcset="https://assets.infinum.com/brand/logo/static/white.svg" media="(prefers-color-scheme: dark)">
        <img src="https://assets.infinum.com/brand/logo/static/default.svg">
    </picture>
  </a>
</p>
