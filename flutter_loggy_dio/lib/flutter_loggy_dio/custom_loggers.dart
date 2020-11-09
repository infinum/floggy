import 'package:loggy/loggy.dart';

mixin DioLoggy implements LoggyType {
  @override
  Loggy<DioLoggy> get loggy => Loggy<DioLoggy>('DioLoggy');
}
