import 'package:loggy/loggy.dart';

import 'extra_loggers.dart';
import 'socket_level.dart';

void main() {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
    logOptions: const LogOptions(
      LogLevel.all,
      stackTraceLevel: LogLevel.off,
    ),
    filters: [
      BlacklistFilter([BlacklistedLoggy]),
    ],
  );

  ExampleNetworkLoggy();
  print('');
  ExampleUiLoggy();
  print('');
  ExampleBlackListedLoggy();
  print('');
  ExampleWhatLoggyCanDo();

  print('');
  logDebug('I\'m a global loggy');
  logInfo('Global loggy has less options but does not need mixins');
  logError('I share properties set in initLoggy');
}

class ExampleNetworkLoggy with NetworkLoggy {
  ExampleNetworkLoggy() {
    loggy.debug('This is log from Network logger');
    print('Test print statement, style should be reset!');
    loggy.info('This is log from Network logger');
    print('Test print statement, style should be reset!');
    loggy.warning('This is log from Network logger');
    print('Test print statement, style should be reset!');
    loggy.error('This is log from Network logger');
    print('Test print statement, style should be reset!');

    loggy.socket('This is log with custom log level in Network logger');
  }
}

class ExampleUiLoggy with UiLoggy {
  ExampleUiLoggy() {
    loggy.warning('This is log from UI logger');
    loggy.warning('This is log from UI logger');
    loggy.warning('This is log from UI logger');
    loggy.warning('This is log from UI logger');

    loggy.socket('This is log with custom log level in UI logger');
  }
}

class ExampleBlackListedLoggy with BlacklistedLoggy {
  ExampleBlackListedLoggy() {
    loggy.info('This log is from Blacklisted logger and should not be visible!');
    loggy.warning('This log is from Blacklisted logger and should not be visible!');
  }
}

class ExampleWhatLoggyCanDo with ExampleLoggy {
  ExampleWhatLoggyCanDo() {
    /// This will evaluate only if line is actually logged
    loggy.info('Loggy can do some stuff:');
    loggy.info('You can pass function to the logger, it will evaluate only if log gets shown');
    loggy.debug(() {
      /// You can log in log
      loggy.warning('Using logger inside of the logger #WeNeedToGoDeeper');

      /// Do something here maybe? function returning something (list in this case)
      const secret = 0 / 0;
      return '${List.generate(8, (_) => secret).fold<String>('', (value, e) => value += e.toString())} Batman';
    });

    final childLoggy = newLoggy('Test');

    /// Changing levels for independent loggy only works if hierarchicalLogging is set to true.
    // _logger.level = LogOptions(LogLevel.warning);
    childLoggy
        .debug('I\'m new logger called "${childLoggy.name}" and my parent logger name is "${childLoggy.parent!.name}"');
    childLoggy.debug('Even if I\'m a new logger, I still share everything with my parent');

    final detached = detachedLoggy('Detached logger');
    detached.level = const LogOptions(LogLevel.all);
    detached.printer = DefaultPrinter();
    detached.debug(
        'I\'m a detached logger. I don\'t have a parent and I have no connection or shared info with root logger!');
  }
}
