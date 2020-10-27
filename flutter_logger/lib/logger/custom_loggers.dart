import 'package:logger/logger.dart';

mixin ProviderLogger implements LoggerType {
  @override
  Logger<ProviderLogger> get logger => Logger<ProviderLogger>('Provider: $runtimeType');
}

mixin DioLogger implements LoggerType {
  @override
  Logger<DioLogger> get logger => Logger<DioLogger>('DioLogger');
}
