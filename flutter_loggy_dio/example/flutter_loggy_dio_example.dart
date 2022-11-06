import 'package:dio/dio.dart';
import 'package:flutter_loggy_dio/flutter_loggy_dio.dart';
import 'package:loggy/loggy.dart';

void main() async {
  Loggy.initLoggy(logPrinter: PrettyPrinter());
  final Dio dio = Dio();
  dio.interceptors.add(LoggyDioInterceptor());
  await dio.get('https://infinum.com');
}
