const String _persianDigits = '۰۱۲۳۴۵۶۷۸۹';
const String _arabicDigits = '٠١٢٣٤٥٦٧٨٩';
const String _latinDigits = '0123456789';

/// Converts Persian and Arabic-Indic digits to ASCII digits.
String normalizeDigits(String input) {
  final b = StringBuffer();
  for (final rune in input.runes) {
    final c = String.fromCharCode(rune);
    var i = _persianDigits.indexOf(c);
    if (i < 0) i = _arabicDigits.indexOf(c);
    b.write(i >= 0 ? _latinDigits[i] : c);
  }
  return b.toString();
}

/// Converts ASCII digits to Persian digits.
String toPersianDigits(String input) {
  final b = StringBuffer();
  for (final rune in input.runes) {
    final c = String.fromCharCode(rune);
    final i = _latinDigits.indexOf(c);
    b.write(i >= 0 ? _persianDigits[i] : c);
  }
  return b.toString();
}

String localizeDigits(String input, bool fa) =>
    fa ? toPersianDigits(input) : input;
