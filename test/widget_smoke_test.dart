import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/app.dart';
import 'package:rayan_garden/state/app_state.dart';

import 'fake_repository.dart';

void main() {
  testWidgets('home -> services -> detail -> calendar', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final state = AppState(repository: FakeRepository());
    await tester.pumpWidget(RayanGardenApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('رایان گاردن'), findsWidgets);
    await tester.tap(find.text('رزرو آنلاین'));
    await tester.pumpAndSettle();

    expect(find.text('انتخاب خدمات'), findsOneWidget);
    expect(find.text('عکاسی کودک'), findsOneWidget);

    await tester.tap(find.text('عکاسی کودک'));
    await tester.pumpAndSettle();
    expect(find.text('رزرو این خدمت'), findsOneWidget);

    await tester.tap(find.text('رزرو این خدمت'));
    await tester.pumpAndSettle();
    expect(find.text('انتخاب تاریخ'), findsOneWidget);
  });

  testWidgets('language toggle switches to English', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final state = AppState(repository: FakeRepository());
    await tester.pumpWidget(RayanGardenApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();
    expect(find.text('Book online'), findsOneWidget);
  });
}
