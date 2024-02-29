part of '../flutter_loggy_dio.dart';

mixin DioLoggy implements LoggyType {
  @override
  Loggy<DioLoggy> get loggy => Loggy<DioLoggy>('DioLoggy');
}
