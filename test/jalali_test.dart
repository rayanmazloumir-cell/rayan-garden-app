import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/core/utils/jalali.dart';

void main() {
  group('Jalali conversion', () {
    test('Nowruz dates match the official calendar', () {
      final nowruz = <int, DateTime>{
        1399: DateTime.utc(2020, 3, 20),
        1400: DateTime.utc(2021, 3, 21),
        1401: DateTime.utc(2022, 3, 21),
        1402: DateTime.utc(2023, 3, 21),
        1403: DateTime.utc(2024, 3, 20),
        1404: DateTime.utc(2025, 3, 21),
        1405: DateTime.utc(2026, 3, 21),
        1406: DateTime.utc(2027, 3, 21),
        1407: DateTime.utc(2028, 3, 20),
      };
      nowruz.forEach((year, g) {
        expect(JalaliDate(year, 1, 1).toGregorian(), g, reason: 'toGregorian $year');
        expect(JalaliDate.fromGregorian(g), JalaliDate(year, 1, 1),
            reason: 'fromGregorian $year');
      });
    });

    test('round trip over many days', () {
      var d = DateTime.utc(2024, 1, 1);
      final end = DateTime.utc(2030, 1, 1);
      while (d.isBefore(end)) {
        final j = JalaliDate.fromGregorian(d);
        expect(j.toGregorian(), d);
        d = d.add(const Duration(days: 1));
      }
    });

    test('month lengths and leap years', () {
      expect(JalaliDate.monthLength(1405, 1), 31);
      expect(JalaliDate.monthLength(1405, 7), 30);
      expect(JalaliDate.monthLength(1405, 12), 29);
      expect(JalaliDate.monthLength(1403, 12), 30); // leap year
      expect(JalaliDate.monthLength(1408, 12), 30); // leap year
    });

    test('weekday index is Saturday-first', () {
      expect(JalaliDate.weekdayIndex(DateTime.utc(2026, 11, 7)), 0); // Saturday
      expect(JalaliDate.weekdayIndex(DateTime.utc(2026, 11, 13)), 6); // Friday
    });

    test('formatting', () {
      expect(isoDate(DateTime.utc(2026, 3, 5)), '2026-03-05');
      expect(jalaliLongDate(DateTime.utc(2026, 11, 9), true), 'دوشنبه 18 آبان 1405');
    });
  });
}
