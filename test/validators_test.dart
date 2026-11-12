import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/core/utils/digits.dart';
import 'package:rayan_garden/core/utils/validators.dart';

void main() {
  test('digits normalization', () {
    expect(normalizeDigits('۰۹۱۲٣٤٥'), '0912345');
    expect(toPersianDigits('09:30'), '۰۹:۳۰');
  });

  test('phone validation and normalization', () {
    expect(isValidIranMobile('09123456789'), isTrue);
    expect(isValidIranMobile('۰۹۱۲۳۴۵۶۷۸۹'), isTrue);
    expect(isValidIranMobile('+98 912 345 6789'), isTrue);
    expect(isValidIranMobile('9123456789'), isTrue);
    expect(normalizePhone('0098 912 345 6789'), '09123456789');
    expect(isValidIranMobile('0212345678'), isFalse);
    expect(isValidIranMobile('0912345'), isFalse);
    expect(isValidIranMobile(''), isFalse);
  });

  test('name validation', () {
    expect(isValidName('علی رضایی'), isTrue);
    expect(isValidName('Sara Ahmadi'), isTrue);
    expect(isValidName('ab'), isFalse);
    expect(isValidName('12345'), isFalse);
    expect(isValidName('   '), isFalse);
    expect(cleanName('  علی    رضایی '), 'علی رضایی');
  });
}
