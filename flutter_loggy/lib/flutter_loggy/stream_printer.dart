part of '../flutter_loggy.dart';

/// Stream printer will take another [LoggyPrinter] as it's [childPrinter] all logs will
/// pass through [childPrinter] as well.
///
/// This allows [LoggyStreamWidget] to display logs as well.
class StreamPrinter extends LoggyPrinter {
  StreamPrinter(this.childPrinter) : super();

  final LoggyPrinter childPrinter;
  final ValueNotifier<List<LogRecord>> logRecord = ValueNotifier<List<LogRecord>>(<LogRecord>[]);

  @override
  void onLog(LogRecord record) {
    late List<LogRecord> existingRecord;
    existingRecord = logRecord.value;

    childPrinter.onLog(record);
    logRecord.value = [
      record,
      ...existingRecord,
    ];
  }

  void dispose() {
    logRecord.dispose();
  }
}
