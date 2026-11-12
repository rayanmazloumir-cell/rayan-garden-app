import 'package:url_launcher/url_launcher.dart';

/// Builds and opens external navigation apps without requiring a customer login.
class MapRouting {
  MapRouting._();

  static const double latitude = 36.3290299;
  static const double longitude = 52.3573811;
  static const String placeName = 'Rayan Garden';

  static Uri get geoUri => Uri.parse(
        'geo:${latitude.toStringAsFixed(7)},${longitude.toStringAsFixed(7)}'
        '?q=${latitude.toStringAsFixed(7)},${longitude.toStringAsFixed(7)}'
        '(Rayan+Garden)',
      );

  static Uri get webUri => Uri.https(
        'www.google.com',
        '/maps/search/',
        <String, String>{
          'api': '1',
          'query': '${latitude.toStringAsFixed(7)},${longitude.toStringAsFixed(7)}',
        },
      );

  /// Returns true when either native navigation or web fallback was opened.
  static Future<bool> open() async {
    try {
      if (await launchUrl(geoUri, mode: LaunchMode.externalApplication)) return true;
    } catch (_) {
      // Fall through to the browser URL when no native map handler exists.
    }
    try {
      return await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
