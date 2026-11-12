import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/core/i18n/app_strings.dart';

void main() {
  test('Persian and English tables have the same keys', () {
    expect(AppStrings.en.keys.toSet(), AppStrings.fa.keys.toSet());
  });

  test('placeholders are replaced', () {
    expect(AppStrings.get('en', 'step_of', {'n': '2', 't': '7'}), 'Step 2 of 7');
    expect(AppStrings.get('fa', 'nope'), 'nope');
  });
}
