import '../../core/utils/digits.dart';

/// A free start time. [raw] is the exact string the server sent and is sent
/// back unchanged when booking; [label] is the normalized `HH:MM`.
class SlotTime {
  const SlotTime({required this.raw, required this.hour, required this.minute});

  final String raw;
  final int hour;
  final int minute;

  int get totalMinutes => hour * 60 + minute;

  String get label =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  static SlotTime? tryParse(String raw) {
    final m = RegExp(r'^\s*(\d{1,2}):(\d{2})').firstMatch(normalizeDigits(raw));
    if (m == null) return null;
    final h = int.parse(m.group(1)!);
    final min = int.parse(m.group(2)!);
    if (h > 23 || min > 59) return null;
    return SlotTime(raw: raw.trim(), hour: h, minute: min);
  }

  @override
  bool operator ==(Object other) =>
      other is SlotTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);
}
