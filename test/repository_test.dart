import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rayan_garden/data/api/api_client.dart';
import 'package:rayan_garden/data/api/api_exception.dart';
import 'package:rayan_garden/data/models/booking.dart';
import 'package:rayan_garden/data/repositories/booking_repository.dart';

http.Response _json(Object body, [int status = 200]) => http.Response.bytes(
      utf8.encode(jsonEncode(body)),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

void main() {
  test('availability sends date and service as query parameters', () async {
    late Uri seen;
    final repo = ApiBookingRepository(ApiClient(
      client: MockClient((req) async {
        seen = req.url;
        return _json({'slots': ['06:00']});
      }),
    ));
    final r = await repo.fetchAvailability(DateTime.utc(2026, 11, 10), 5);
    expect(seen.toString(),
        'https://rayangarden.com/api/availability.php?date=2026-11-10&service=5');
    expect(r.single.label, '06:00');
  });

  test('booking posts the documented fields as JSON', () async {
    late Map<String, dynamic> sent;
    final repo = ApiBookingRepository(ApiClient(
      client: MockClient((req) async {
        expect(req.url.path, '/api/book.php');
        expect(req.method, 'POST');
        sent = jsonDecode(req.body) as Map<String, dynamic>;
        return _json({'ref': 'ABC123', 'status': 'pending'});
      }),
    ));
    final r = await repo.submitBooking(const BookingRequest(
      serviceId: 4,
      date: '2026-11-10',
      time: '06:00',
      name: 'علی رضایی',
      phone: '09123456789',
      notes: '',
      lang: 'fa',
      elapsedMs: 3000,
    ));
    expect(r.ref, 'ABC123');
    expect(sent.keys.toSet(), {
      'service', 'date', 'time', 'name', 'phone', 'notes', 'lang', 'website', 'elapsed'
    });
    expect(sent['website'], '');
    expect(sent['elapsed'], 3000);
    expect(sent['service'], 4);
  });

  test('server error message is surfaced', () async {
    final repo = ApiBookingRepository(ApiClient(
      client: MockClient((req) async => _json({'error': 'تکراری است'}, 409)),
    ));
    expect(
      () => repo.fetchServices(),
      throwsA(isA<ApiException>()
          .having((e) => e.serverMessage, 'message', 'تکراری است')
          .having((e) => e.statusCode, 'status', 409)),
    );
  });

  test('non-JSON body is a format error, not a success', () async {
    final repo = ApiBookingRepository(ApiClient(
      client: MockClient((req) async => http.Response('<html>oops</html>', 200)),
    ));
    expect(
      () => repo.fetchServices(),
      throwsA(isA<ApiException>().having((e) => e.kind, 'kind', ApiErrorKind.format)),
    );
  });

  test('network failure maps to a network error', () async {
    final repo = ApiBookingRepository(ApiClient(
      client: MockClient((req) async => throw http.ClientException('offline')),
    ));
    expect(
      () => repo.fetchServices(),
      throwsA(isA<ApiException>().having((e) => e.kind, 'kind', ApiErrorKind.network)),
    );
  });
}
