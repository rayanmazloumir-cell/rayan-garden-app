import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/core/config/app_config.dart';
import 'package:rayan_garden/data/models/service_catalog.dart';
import 'package:rayan_garden/data/models/service_item.dart';

void main() {
  test('release metadata is 1.0.1 build 2', () {
    expect(AppConfig.appVersion, '1.0.1');
    expect(AppConfig.buildNumber, 2);
    expect(AppConfig.versionLabel, '1.0.1+2');
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
}
