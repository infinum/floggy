import 'package:loggy/loggy.dart';

mixin DioLogger implements LoggyType {
  @override
  Loggy<DioLogger> get logger => Loggy<DioLogger>('DioLogger');
}
