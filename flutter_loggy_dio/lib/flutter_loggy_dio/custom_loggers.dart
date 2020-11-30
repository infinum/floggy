part of flutter_loggy_dio;

mixin DioLoggy implements LoggyType {
  @override
  Loggy<DioLoggy> get loggy => Loggy<DioLoggy>('DioLoggy');
}
