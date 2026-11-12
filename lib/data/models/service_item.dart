/// A bookable service as returned by `services.php`.
/// [id] is kept exactly as the server sent it (number or string).
class ServiceItem {
  const ServiceItem({
    required this.id,
    required this.name,
    this.nameEn,
    this.durationMinutes,
    this.description,
    this.price,
    this.deposit,
  });

  final Object id;
  final String name;
  final String? nameEn;
  final int? durationMinutes;
  final String? description;

  /// Price / deposit exactly as the API sent them (display text, no currency
  /// added by the app). Null when the API does not send them.
  final String? price;
  final String? deposit;

  String displayName(bool fa) =>
      (!fa && nameEn != null && nameEn!.isNotEmpty) ? nameEn! : name;
}
