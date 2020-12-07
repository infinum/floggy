part of flutter_loggy;

class HistoryPrinter extends LogPrinter {
  HistoryPrinter(this.childPrinter) : super();

  final LogPrinter childPrinter;
  final BehaviorSubject<List<LogRecord>> logRecord = BehaviorSubject<List<LogRecord>>.seeded(<LogRecord>[]);

  @override
  void onLog(LogRecord record) {
    childPrinter.onLog(record);
    logRecord.add([record, ...logRecord.value]);
  }

  void dispose() {
    logRecord.close();
  }
}
