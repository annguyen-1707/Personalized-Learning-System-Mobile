class AppConfig {
  const AppConfig._();

  static const String defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
    // defaultValue: 'http://localhost:8080',
  );
}
