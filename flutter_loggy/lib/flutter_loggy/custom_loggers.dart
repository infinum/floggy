import 'package:loggy/loggy.dart';

mixin ProviderLogger implements LoggyType {
  @override
  Loggy<ProviderLogger> get logger =>
      Loggy<ProviderLogger>('Provider: $runtimeType');
}
