import 'package:loggy/loggy.dart';

mixin DioLoggy implements LoggyType {
  @override
  Loggy<DioLoggy> get logger => Loggy<DioLoggy>('DioLogger');
}
