/// Central place for fixed business rules and contact details.
/// Nothing secret lives here: only public information and booking rules.
class AppConfig {
  AppConfig._();

  static const String apiBase = 'https://rayangarden.com/api/';
  static const Duration requestTimeout = Duration(seconds: 20);

  // The website/back-end is the ONLY authority for booking rules (open hours,
  // 30-minute step, minimum lead time, conflicts, durations, prices, deposits,
  // active services, 24-hour holding of unconfirmed requests). The app does not
  // generate, filter or enforce any of them: it shows what the API returns and
  // shows the server's own message when a booking is refused.
  //
  // The ONLY mirrored value: how far the calendar lets the user scroll. It is
  // pure navigation (the owner stated the site allows 120 days ahead); the server
  // still decides. Replace it with an API value as soon as the API exposes one.
  static const int maxAheadDays = 120;

  // Anti-bot protocol of book.php: `elapsed` (ms) must look human.
  static const int minElapsedMs = 2500;

  // Iran uses a fixed UTC+03:30 offset (no daylight saving since 2022).
  static const Duration tehranOffset = Duration(hours: 3, minutes: 30);

  // Public contact details.
  static const String phone = '09126605578';
  static const String email = 'Rayan.Garden.ir@gmail.com';
  static const String instagramUser = 'rayangarden';
  static const String mapsUrl = 'https://maps.app.goo.gl/xgQ83dKfkBsaJPL26';
}
