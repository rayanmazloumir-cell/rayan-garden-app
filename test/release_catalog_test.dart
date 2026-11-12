import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/core/config/app_config.dart';
import 'package:rayan_garden/data/models/service_catalog.dart';
import 'package:rayan_garden/data/models/service_item.dart';

void main() {
  test('release metadata is 1.0.2 build 3', () {
    expect(AppConfig.appVersion, '1.0.2');
    expect(AppConfig.buildNumber, 3);
    expect(AppConfig.versionLabel, '1.0.2+3');
  });

  test('service catalog decorates API items without changing IDs', () {
    const apiItems = [
      ServiceItem(id: 'server-bride', name: 'Bride and Groom Photography'),
      ServiceItem(id: 44, name: 'عکاسی رسمی'),
      ServiceItem(id: 45, name: 'کافه‌گاردن'),
    ];
    final items = ServiceCatalog.decorate(apiItems);
    expect(items.map((item) => item.id).toList(), ['server-bride', 44, 45]);
    expect(items.map((item) => item.durationMinutes).toList(), [120, 180, 120]);
    expect(items[0].nameEn, 'Bride & Groom Photography');
  });

  test('approved catalog contains all requested experiences', () {
    expect(ServiceCatalog.entries.map((entry) => entry.minutes).toList(), [120, 180, 60, 60, 120]);
    expect(ServiceCatalog.entries.map((entry) => entry.en), containsAll([
      'Bride & Groom Photography',
      'Formal Photography',
      'Children Photography',
      'Family Photography',
      'Cafe-Garden',
    ]));
  });

  test('live API service IDs map to the correct customer-facing catalog entries', () {
    const live = [
      ServiceItem(id: 'wedding', name: 'عکاسی عروس و داماد', durationMinutes: 180),
      ServiceItem(id: 'formality', name: 'عکاسی فرمالیته', durationMinutes: 180),
      ServiceItem(id: 'kids', name: 'عکاسی کودک', durationMinutes: 60),
      ServiceItem(id: 'family', name: 'عکاسی خانوادگی', durationMinutes: 60),
      ServiceItem(id: 'cafe', name: 'کافه باغ', durationMinutes: 120),
    ];
    final mapped = ServiceCatalog.decorate(live);
    expect(mapped.map((item) => item.nameEn).toList(), [
      'Bride & Groom Photography',
      'Formal Photography',
      'Children Photography',
      'Family Photography',
      'Cafe-Garden',
    ]);
    expect(mapped.map((item) => item.durationMinutes).toList(), [180, 180, 60, 60, 120]);
  });
}
