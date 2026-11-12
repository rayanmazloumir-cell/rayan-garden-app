import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/data/api/api_exception.dart';
import 'package:rayan_garden/data/api/response_parsers.dart';

void main() {
  group('parseServices', () {
    test('plain list', () {
      final r = parseServices([
        {'id': 3, 'name': 'عکاسی کودک', 'duration': 60},
        {'id': '7', 'title': 'کافه باغ', 'minutes': '120'},
      ]);
      expect(r.length, 2);
      expect(r[0].id, 3);
      expect(r[0].durationMinutes, 60);
      expect(r[1].id, '7');
      expect(r[1].durationMinutes, 120);
    });

    test('wrapped list', () {
      final r = parseServices({
        'ok': true,
        'services': [
          {'id': 1, 'name': 'بازدید'}
        ]
      });
      expect(r.single.name, 'بازدید');
      expect(r.single.durationMinutes, isNull);
    });

    test('confirmed shape: ok + services with id and dur', () {
      final r = parseServices({
        'ok': true,
        'services': [
          {'id': 'wedding', 'name': 'عکاسی عروس', 'dur': 120},
          {'id': 2, 'dur': '60'},
        ]
      });
      expect(r[0].id, 'wedding');
      expect(r[0].durationMinutes, 120);
      expect(r[1].id, 2);
      expect(r[1].durationMinutes, 60);
      expect(r[1].name, '2'); // no name key: falls back to the id
    });

    test('price, deposit and active come from the API; inactive is hidden', () {
      final r = parseServices({
        'ok': true,
        'services': [
          {'id': 1, 'name': 'A', 'dur': 60, 'price': 1500000, 'deposit': '300,000'},
          {'id': 2, 'name': 'B', 'dur': 30, 'active': 0},
          {'id': 3, 'name': 'C', 'dur': 30, 'active': 1},
        ]
      });
      expect(r.map((s) => s.id).toList(), [1, 3]);
      expect(r[0].price, '1,500,000');
      expect(r[0].deposit, '300,000');
      expect(r[1].price, isNull);
    });

    test('ok:false is rejected', () {
      expect(
        () => parseServices({'ok': false, 'error': 'خطا'}),
        throwsA(isA<ApiException>()
            .having((e) => e.kind, 'kind', ApiErrorKind.rejected)),
      );
    });

    test('unknown shape raises a format error', () {
      expect(() => parseServices({'hello': 'world'}),
          throwsA(isA<ApiException>()));
    });
  });

  group('parseAvailability', () {
    test('list of strings is sorted and de-duplicated', () {
      final r = parseAvailability({
        'slots': ['07:30', '06:00', '06:00:00']
      });
      expect(r.map((s) => s.label).toList(), ['06:00', '07:30']);
    });

    test('objects with availability flag', () {
      final r = parseAvailability([
        {'time': '06:00', 'available': true},
        {'time': '06:30', 'available': false},
      ]);
      expect(r.map((s) => s.label).toList(), ['06:00']);
    });

    test('empty list is valid (no free times)', () {
      expect(parseAvailability({'slots': []}), isEmpty);
    });

    test('free-times list under an unlisted key is found structurally', () {
      final r = parseAvailability({
        'ok': true,
        'date': '2026-11-10',
        'service': 5,
        'foo': ['09:00', '08:00']
      });
      expect(r.map((s) => s.label).toList(), ['08:00', '09:00']);
    });

    test('nested data.slots with start objects', () {
      final r = parseAvailability({
        'ok': true,
        'data': {
          'slots': [
            {'start': '10:00'},
            {'start': '10:30', 'booked': true},
          ]
        }
      });
      expect(r.map((s) => s.label).toList(), ['10:00']);
    });

    test('ok:false and unknown shapes never become slots', () {
      expect(() => parseAvailability({'ok': false, 'error': 'x'}),
          throwsA(isA<ApiException>()));
      expect(() => parseAvailability({'hello': 'world'}),
          throwsA(isA<ApiException>()));
    });

    test('time to bool map', () {
      final r = parseAvailability({'06:00': true, '06:30': false, '07:00': true});
      expect(r.map((s) => s.label).toList(), ['06:00', '07:00']);
    });
  });

  group('parseBookingResponse', () {
    test('success needs ref', () {
      final r = parseBookingResponse(
          {'ok': true, 'ref': 'RG-1234', 'status': 'pending', 'payment': {'amount': 500}});
      expect(r.ref, 'RG-1234');
      expect(r.status, 'pending');
      expect(r.payment['payment.amount'], '500');
    });

    test('ok:false is rejected with the server message', () {
      expect(
        () => parseBookingResponse({'ok': false, 'error': 'ساعت پر شده است'}),
        throwsA(isA<ApiException>()
            .having((e) => e.kind, 'kind', ApiErrorKind.rejected)
            .having((e) => e.serverMessage, 'msg', 'ساعت پر شده است')),
      );
    });

    test('200 without ref is never a success', () {
      expect(() => parseBookingResponse({'ok': true}),
          throwsA(isA<ApiException>()));
      expect(() => parseBookingResponse('text'), throwsA(isA<ApiException>()));
    });
  });
}
