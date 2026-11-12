import 'digits.dart';

/// Normalizes an Iranian mobile number to the local `09XXXXXXXXX` form.
String normalizePhone(String raw) {
  var s = normalizeDigits(raw).replaceAll(RegExp(r'[\s\-()]'), '');
  if (s.startsWith('+98')) {
    s = '0${s.substring(3)}';
  } else if (s.startsWith('0098')) {
    s = '0${s.substring(4)}';
  } else if (s.startsWith('98') && s.length == 12) {
    s = '0${s.substring(2)}';
  } else if (s.startsWith('9') && s.length == 10) {
    s = '0$s';
  }
  return s;
}

bool isValidIranMobile(String raw) =>
    RegExp(r'^09\d{9}$').hasMatch(normalizePhone(raw));

String cleanName(String raw) => raw.trim().replaceAll(RegExp(r'\s+'), ' ');

bool isValidName(String raw) {
  final s = cleanName(raw);
  if (s.length < 3 || s.length > 80) return false;
  return RegExp(r'\p{L}', unicode: true).allMatches(s).length >= 3;
}
