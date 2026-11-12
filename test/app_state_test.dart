import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/data/api/api_exception.dart';
import 'package:rayan_garden/state/app_state.dart';

import 'fake_repository.dart';

void main() {
  // 2026-11-09 12:00 UTC = 15:30 in Tehran.
  var now = DateTime.utc(2026, 11, 9, 12, 0);

  AppState make(FakeRepository repo) => AppState(repository: repo, clock: () => now);

  setUp(() => now = DateTime.utc(2026, 11, 9, 12, 0));

  test('Tehran date and booking window', () {
    final s = make(FakeRepository());
    expect(s.today, DateTime.utc(2026, 11, 9));
    expect(s.lastBookableDate, DateTime.utc(2027, 3, 9)); // +120 days
  });

  test('slots are exactly what the server returned (no local rules)', () async {
    final s = make(FakeRepository());
    await s.loadServices();
    s.selectService(FakeRepository.services.first);
    s.selectDate(s.today); // even "today": the server decides, the app does not filter
    await s.loadSlots();
    expect(s.slots.data!.map((t) => t.label).toList(), ['06:00', '09:30', '15:00']);
  });

  test('duration comes only from the API, never from a local table', () {
    final s = make(FakeRepository());
    expect(s.durationOf(FakeRepository.services[0]), 60);
    expect(s.durationOf(FakeRepository.services[1]), isNull);
  });

  test('submit sends elapsed >= 2500 and stores the confirmed result', () async {
    final repo = FakeRepository();
    final s = make(repo);
    await s.loadServices();
    s.selectService(FakeRepository.services.first);
    s.selectDate(s.today.add(const Duration(days: 2)));
    await s.loadSlots();
    s.selectSlot(s.slots.data!.first);
    s.setCustomer('  علی   رضایی ', '۰۹۱۲۳۴۵۶۷۸۹');
    s.markFormStarted();
    now = now.add(const Duration(seconds: 5));
    final r = await s.submit();
    expect(r.ref, 'RG-0001');
    expect(s.result, isNotNull);
    expect(repo.lastRequest!.elapsedMs, greaterThanOrEqualTo(2500));
    expect(repo.lastRequest!.phone, '09123456789');
    expect(repo.lastRequest!.name, 'علی رضایی');
    expect(repo.lastRequest!.date, '2026-11-11');
  });

  test('a rejected booking is never stored as a result', () async {
    final s = make(FakeRepository(failBooking: true));
    await s.loadServices();
    s.selectService(FakeRepository.services.first);
    s.selectDate(s.today.add(const Duration(days: 2)));
    await s.loadSlots();
    s.selectSlot(s.slots.data!.first);
    s.setCustomer('علی رضایی', '09123456789');
    s.markFormStarted();
    now = now.add(const Duration(seconds: 5));
    await expectLater(s.submit(), throwsA(isA<ApiException>()));
    expect(s.result, isNull);
    expect(s.submitting, isFalse);
  });

  test('submit refuses invalid data', () async {
    final s = make(FakeRepository());
    await expectLater(s.submit(), throwsA(isA<ApiException>()));
  });
}
