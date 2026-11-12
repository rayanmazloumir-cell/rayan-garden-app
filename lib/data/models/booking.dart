/// Body of `POST book.php`. Field names follow the documented contract:
/// service, date, time, name, phone, notes, lang, website, elapsed.
class BookingRequest {
  const BookingRequest({
    required this.serviceId,
    required this.date,
    required this.time,
    required this.name,
    required this.phone,
    required this.notes,
    required this.lang,
    required this.elapsedMs,
  });

  final Object serviceId;
  final String date; // Gregorian YYYY-MM-DD
  final String time; // exactly as returned by availability.php
  final String name;
  final String phone;
  final String notes;
  final String lang;
  final int elapsedMs;

  Map<String, dynamic> toJson() => {
        'service': serviceId,
        'date': date,
        'time': time,
        'name': name,
        'phone': phone,
        'notes': notes,
        'lang': lang,
        'website': '', // honeypot field: must stay empty
        'elapsed': elapsedMs,
      };
}

/// A booking the server has confirmed receiving (a `ref` was returned).
class BookingResult {
  const BookingResult({
    required this.ref,
    this.status,
    this.payment = const {},
    this.serverMessage,
  });

  final String ref;
  final String? status;
  final Map<String, String> payment;
  final String? serverMessage;
}
