part of '../../loggy.dart';

class DefaultPrinter extends LoggyPrinter {
  const DefaultPrinter() : super();

  @override
  void onLog(LogRecord record) => print(record);
}
