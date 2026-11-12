/// Gregorian <-> Jalali (Solar Hijri) conversion.
///
/// All Gregorian "date only" values in the app are `DateTime.utc(y, m, d)`
/// so that no time-zone or daylight-saving shift can change the day.
class JalaliDate {
  const JalaliDate(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;

  static JalaliDate fromGregorian(DateTime g) {
    final gy = g.year;
    final gm = g.month;
    final gd = g.day;
    const gdm = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    final gy2 = gm > 2 ? gy + 1 : gy;
    var days = 355666 +
        (365 * gy) +
        ((gy2 + 3) ~/ 4) -
        ((gy2 + 99) ~/ 100) +
        ((gy2 + 399) ~/ 400) +
        gd +
        gdm[gm - 1];
    var jy = -1595 + (33 * (days ~/ 12053));
    days %= 12053;
    jy += 4 * (days ~/ 1461);
    days %= 1461;
    if (days > 365) {
      jy += (days - 1) ~/ 365;
      days = (days - 1) % 365;
    }
    final jm = days < 186 ? 1 + (days ~/ 31) : 7 + ((days - 186) ~/ 30);
    final jd = 1 + (days < 186 ? days % 31 : (days - 186) % 30);
    return JalaliDate(jy, jm, jd);
  }

  /// Returns the Gregorian date as `DateTime.utc(y, m, d)`.
  DateTime toGregorian() {
    final jy = year + 1595;
    var days = -355668 +
        (365 * jy) +
        ((jy ~/ 33) * 8) +
        (((jy % 33) + 3) ~/ 4) +
        day +
        (month < 7 ? (month - 1) * 31 : ((month - 7) * 30) + 186);
    var gy = 400 * (days ~/ 146097);
    days %= 146097;
    if (days > 36524) {
      days--;
      gy += 100 * (days ~/ 36524);
      days %= 36524;
      if (days >= 365) days++;
    }
    gy += 4 * (days ~/ 1461);
    days %= 1461;
    if (days > 365) {
      gy += (days - 1) ~/ 365;
      days = (days - 1) % 365;
    }
    var gd = days + 1;
    final leap = (gy % 4 == 0 && gy % 100 != 0) || gy % 400 == 0;
    final sal = [0, 31, leap ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var gm = 0;
    while (gm < 13 && gd > sal[gm]) {
      gd -= sal[gm];
      gm++;
    }
    return DateTime.utc(gy, gm, gd);
  }

  static int monthLength(int year, int month) {
    if (month <= 6) return 31;
    if (month <= 11) return 30;
    final start = JalaliDate(year, 12, 1).toGregorian();
    final next = JalaliDate(year + 1, 1, 1).toGregorian();
    return next.difference(start).inDays;
  }

  /// Saturday = 0 ... Friday = 6.
  static int weekdayIndex(DateTime g) => (g.weekday + 1) % 7;

  @override
  bool operator ==(Object other) =>
      other is JalaliDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);
}

const List<String> jalaliMonthsFa = [
  'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
  'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند',
];
const List<String> jalaliMonthsEn = [
  'Farvardin', 'Ordibehesht', 'Khordad', 'Tir', 'Mordad', 'Shahrivar',
  'Mehr', 'Aban', 'Azar', 'Dey', 'Bahman', 'Esfand',
];
// Saturday-first.
const List<String> weekdaysFa = [
  'شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه',
];
const List<String> weekdaysEn = [
  'Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
];
const List<String> weekdaysShortFa = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];
const List<String> weekdaysShortEn = [
  'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri',
];

/// `YYYY-MM-DD` (Gregorian) — the format required by the booking API.
String isoDate(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

bool sameDay(DateTime? a, DateTime? b) =>
    a != null && b != null && a.year == b.year && a.month == b.month && a.day == b.day;

/// e.g. "یکشنبه 19 آبان 1405" (digits are localized by the caller).
String jalaliLongDate(DateTime gregorian, bool fa) {
  final j = JalaliDate.fromGregorian(gregorian);
  final wd = JalaliDate.weekdayIndex(gregorian);
  final weekday = fa ? weekdaysFa[wd] : weekdaysEn[wd];
  final month = fa ? jalaliMonthsFa[j.month - 1] : jalaliMonthsEn[j.month - 1];
  return '$weekday ${j.day} $month ${j.year}';
}
