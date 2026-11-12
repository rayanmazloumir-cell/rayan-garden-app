import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rayan_garden/data/api/api_client.dart';
import 'package:rayan_garden/data/api/api_exception.dart';
import 'package:rayan_garden/data/api/response_parsers.dart';

void main() {
  group('request shape (compared with the working browser URLs)', () {
    test('services.php is a plain GET to the same URL as the browser', () async {
      late http.Request seen;
      final api = ApiClient(client: MockClient((req) async {
        seen = req;
        return http.Response(
            jsonEncode({'ok': true, 'services': []}), 200,
            headers: {'content-type': 'application/json'});
      }));
      await api.get('services.php');
      expect(seen.method, 'GET');
      expect(seen.url.toString(), 'https://rayangarden.com/api/services.php');
      final userAgent = seen.headers.entries
          .firstWhere((e) => e.key.toLowerCase() == 'user-agent')
          .value;
      expect(userAgent, 'Dart/3.0 (dart:io)');
      expect(userAgent, isNot(contains('RayanGarden')));
    });

    test('availability.php query matches the browser URL', () async {
      late http.Request seen;
      final api = ApiClient(client: MockClient((req) async {
        seen = req;
        return http.Response(jsonEncode({'ok': true, 'slots': []}), 200);
      }));
      await api.get('availability.php',
          query: {'date': '2026-11-12', 'service': 'wedding'});
      expect(seen.url.toString(),
          'https://rayangarden.com/api/availability.php?date=2026-11-12&service=wedding');
    });
  });

  group('HTTP errors', () {
    test('an HTML 403 is an HTTP error with evidence kept, never JSON', () async {
      final api = ApiClient(client: MockClient((req) async => http.Response(
          '<html><body><h1>Forbidden</h1></body></html>', 403,
          headers: {'server': 'Apache', 'content-type': 'text/html'},
          request: req)));
      try {
        await api.get('services.php');
        fail('should throw');
      } on ApiException catch (e) {
        expect(e.kind, ApiErrorKind.server);
        expect(e.statusCode, 403);
        expect(e.rawBody, contains('Forbidden'));
        expect(e.rawBody, contains('server: Apache'));
        expect(e.rawBody, contains('https://rayangarden.com/api/services.php'));
      }
    });

    test('a JSON 403 keeps the server message', () async {
      final api = ApiClient(client: MockClient((req) async =>
          http.Response.bytes(
              utf8.encode(jsonEncode({'ok': false, 'error': 'ممنوع'})), 403,
              request: req)));
      try {
        await api.get('services.php');
        fail('should throw');
      } on ApiException catch (e) {
        expect(e.kind, ApiErrorKind.rejected);
        expect(e.statusCode, 403);
        expect(e.serverMessage, 'ممنوع');
      }
    });

    test('a 200 response that is not JSON is a format error', () async {
      final api = ApiClient(
          client: MockClient((req) async => http.Response('<html></html>', 200)));
      expect(
        () => api.get('services.php'),
        throwsA(isA<ApiException>()
            .having((e) => e.kind, 'kind', ApiErrorKind.format)),
      );
    });
  });

  group('connection check', () {
    test('reports every variant with its status, redirects not followed', () async {
      final api = ApiClient(client: MockClient((req) async {
        if (req.url.host.startsWith('www.')) {
          return http.Response('', 301,
              headers: {'location': 'https://rayangarden.com/api/services.php'});
        }
        final ua = req.headers['User-Agent'];
        return ua == null
            ? http.Response('{"ok":true}', 200)
            : http.Response('Forbidden', 403, headers: {'server': 'Apache'});
      }));
      final text = await api.diagnose('services.php');
      expect(text, contains('A) app request'));
      expect(text, contains('B) library default headers'));
      expect(text, contains('HTTP 403'));
      expect(text, contains('HTTP 200'));
      expect(text, contains('HTTP 301'));
      expect(text, contains('server: Apache'));
    });
  });

  group('response shapes reported by the site owner', () {
    test('services: ok, id, Persian + English names, dur, price, deposit', () {
      final r = parseServices({
        'ok': true,
        'services': [
          {
            'id': 'wedding',
            'name_fa': 'عکاسی عروس و داماد',
            'name_en': 'Wedding',
            'dur': 180,
            'price': 5000000,
            'deposit': 1000000,
          }
        ]
      });
      expect(r.single.id, 'wedding');
      expect(r.single.name, 'عکاسی عروس و داماد');
      expect(r.single.nameEn, 'Wedding');
      expect(r.single.durationMinutes, 180);
      expect(r.single.price, '5,000,000');
      expect(r.single.deposit, '1,000,000');
    });

    test('availability: ok, date, duration, slots with a free flag', () {
      final r = parseAvailability({
        'ok': true,
        'date': '2026-11-12',
        'duration': 180,
        'slots': [
          {'time': '06:00', 'free': true},
          {'time': '06:30', 'free': false},
          {'start': '07:00', 'free': 1},
          {'t': '07:30', 'free': 0},
          {'label': 'x', 'at': '08:00', 'free': true},
        ]
      });
      expect(r.map((s) => s.label).toList(), ['06:00', '07:00', '08:00']);
    });
  });
}
