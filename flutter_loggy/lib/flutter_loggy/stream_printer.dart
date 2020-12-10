part of flutter_loggy;

class StreamPrinter extends LogPrinter {
  StreamPrinter(this.childPrinter) : super();

  final LogPrinter childPrinter;
  final BehaviorSubject<List<LogRecord>> logRecord = BehaviorSubject<List<LogRecord>>.seeded(<LogRecord>[]);

  @override
  void onLog(LogRecord record) {
    childPrinter.onLog(record);
    logRecord.add(<LogRecord>[record, ...logRecord.value]);
  }

  void dispose() {
    logRecord.close();
  }
}
