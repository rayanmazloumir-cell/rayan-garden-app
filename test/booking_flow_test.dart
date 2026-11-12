import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/app.dart';
import 'package:rayan_garden/state/app_state.dart';

import 'fake_repository.dart';

void main() {
  testWidgets('full booking flow ends with the server tracking code',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repo = FakeRepository();
    // 2026-11-09 15:30 Tehran; tomorrow is 19 Aban 1405.
    final state = AppState(
      repository: repo,
      clock: () => DateTime.utc(2026, 11, 9, 12, 0),
    );
    await tester.pumpWidget(RayanGardenApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('رزرو آنلاین'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('عکاسی کودک'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('رزرو این خدمت'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('۱۹'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ادامه'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('۰۹:۳۰'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ادامه'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'علی رضایی');
    await tester.enterText(find.byType(TextFormField).at(1), '09123456789');
    await tester.tap(find.text('ادامه'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ادامه')); // notes are optional
    await tester.pumpAndSettle();

    await tester.tap(find.text('ثبت رزرو'));
    await tester.pumpAndSettle();

    expect(find.text('RG-0001'), findsOneWidget);
    expect(repo.lastRequest!.time, '09:30');
    expect(repo.lastRequest!.date, '2026-11-10');
    expect(repo.lastRequest!.phone, '09123456789');
  });
}
