abstract class AppConfig {
  String get baseUrl;
  String get appVersion;
  bool get showNetworkInterceptors;
}

class DefaultAppConfig implements AppConfig {
  @override
  String get baseUrl => const String.fromEnvironment('API_BASE_URL');

  @override
  String get appVersion => const String.fromEnvironment('APP_VERSION');

  @override
  bool get showNetworkInterceptors =>
      const bool.fromEnvironment('SHOW_NETWORK_INTERCEPTORS');
}
