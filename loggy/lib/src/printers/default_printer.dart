part of loggy;

class DefaultPrinter extends LoggyPrinter {
  const DefaultPrinter() : super();

  @override
  void onLog(LogRecord record) => print(record);
}
