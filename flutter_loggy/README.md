# Flutter loggy
Extensions that we can use in Flutter to make logs prettier.

```
  Loggy.initLoggy(
    logPrinter: PrettyDeveloperPrinter(),
    logOptions: LogOptions(minimumLogLevel),
  );
```

## Pretty developer printer
This printer uses `dart:developer` and can write error messages in red, and it gives us more flexibility, so we can modify this log a bit more.

## How to use
For documentation refer to [loggy](https://github.com/infinum/floggy/blob/master/loggy/README.md)

## Using dio? Check out:
[flutter_loggy_dio](https://github.com/infinum/floggy/blob/master/flutter_loggy_dio/README.md)
