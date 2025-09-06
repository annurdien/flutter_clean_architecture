import 'app_config.dart';

class AppConfigProvider {
  static final AppConfig _instance = DefaultAppConfig();
  static AppConfig get instance => _instance;
}
