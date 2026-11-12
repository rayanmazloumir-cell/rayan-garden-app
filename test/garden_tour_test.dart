import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/app.dart';
import 'package:rayan_garden/state/app_state.dart';

import 'fake_repository.dart';

void main() {
  testWidgets('home opens the real-photo garden tour and selects locations', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final state = AppState(repository: FakeRepository());
    await tester.pumpWidget(RayanGardenApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('گشت تصویری باغ'));
    await tester.pumpAndSettle();
    expect(find.text('نمای کلی باغ'), findsOneWidget);
    expect(find.textContaining('تصاویر واقعی رایان گاردن'), findsOneWidget);

    await tester.tap(find.text('کافه‌باغ'));
    await tester.pumpAndSettle();
    expect(find.textContaining('موقعیت انتخاب‌شده:'), findsOneWidget);
  });
}
