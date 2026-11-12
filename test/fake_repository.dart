import 'package:rayan_garden/data/api/api_exception.dart';
import 'package:rayan_garden/data/models/booking.dart';
import 'package:rayan_garden/data/models/service_item.dart';
import 'package:rayan_garden/data/models/slot_time.dart';
import 'package:rayan_garden/data/repositories/booking_repository.dart';

class FakeRepository implements BookingRepository {
  FakeRepository({this.failBooking = false});

  final bool failBooking;
  BookingRequest? lastRequest;

  static const services = [
    ServiceItem(id: 1, name: 'عکاسی عروس و داماد'),
    ServiceItem(id: 2, name: 'عکاسی رسمی'),
    ServiceItem(id: 3, name: 'عکاسی کودک'),
    ServiceItem(id: 4, name: 'عکاسی خانوادگی'),
    ServiceItem(id: 5, name: 'کافه‌گاردن'),
  ];

  @override
  Future<List<ServiceItem>> fetchServices() async => services;

  @override
  Future<List<SlotTime>> fetchAvailability(DateTime date, Object serviceId) async => [
        SlotTime.tryParse('06:00')!,
        SlotTime.tryParse('09:30')!,
        SlotTime.tryParse('15:00')!,
      ];

  @override
  Future<String> diagnose() async => 'fake diagnostics';

  @override
  Future<BookingResult> submitBooking(BookingRequest request) async {
    lastRequest = request;
    if (failBooking) {
      throw const ApiException(ApiErrorKind.rejected, serverMessage: 'ساعت پر شده است');
    }
    return const BookingResult(ref: 'RG-0001', status: 'pending');
  }
}
