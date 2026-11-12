import '../../core/utils/jalali.dart';
import '../api/api_client.dart';
import '../api/response_parsers.dart';
import '../models/booking.dart';
import '../models/service_item.dart';
import '../models/slot_time.dart';

/// All server operations used by the app. Nothing here touches the UI.
abstract class BookingRepository {
  Future<List<ServiceItem>> fetchServices();
  Future<List<SlotTime>> fetchAvailability(DateTime date, Object serviceId);
  Future<BookingResult> submitBooking(BookingRequest request);

  /// Read-only connection check (see ApiClient.diagnose).
  Future<String> diagnose();
}

class ApiBookingRepository implements BookingRepository {
  ApiBookingRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<ServiceItem>> fetchServices() async {
    final r = await _api.get('services.php');
    return parseServices(r.json, rawBody: r.rawBody);
  }

  @override
  Future<List<SlotTime>> fetchAvailability(DateTime date, Object serviceId) async {
    final r = await _api.get('availability.php', query: {
      'date': isoDate(date),
      'service': serviceId.toString(),
    });
    return parseAvailability(r.json, rawBody: r.rawBody);
  }

  @override
  Future<String> diagnose() => _api.diagnose('services.php');

  @override
  Future<BookingResult> submitBooking(BookingRequest request) async {
    final r = await _api.post('book.php', request.toJson());
    return parseBookingResponse(r.json, rawBody: r.rawBody, statusCode: r.statusCode);
  }
}
