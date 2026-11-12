/// Public business rules and configuration. The PHP backend remains authoritative
/// for conflicts, prices, deposits and final booking acceptance.
class AppConfig {
  AppConfig._();

  static const String apiBase = 'https://rayangarden.com/api/';
  static const Duration requestTimeout = Duration(seconds: 20);
  static const String appVersion = '1.0.3';
  static const int buildNumber = 4;
  static const String versionLabel = '$appVersion+$buildNumber';
  static const int maxAheadDays = 120;
  static const String openingTime = '06:00';
  static const String closingTime = '20:00';
  static const int minElapsedMs = 2500;
  static const Duration tehranOffset = Duration(hours: 3, minutes: 30);

  static const String phone = '09126605578';
  static const String email = 'Rayan.Garden.ir@gmail.com';
  static const String instagramUser = 'rayangarden';
  static const String mapsUrl = 'https://maps.app.goo.gl/xgQ83dKfkBsaJPL26';
}
