import '../../core/utils/digits.dart';
import '../models/booking.dart';
import '../models/service_item.dart';
import '../models/slot_time.dart';
import 'api_exception.dart';

// ---------------------------------------------------------------------------
// Confirmed by the site owner for services.php: { ok, services: [ { id, dur,
// ... } ] }. The shape of availability.php is NOT confirmed, so it is located
// structurally (any list that really contains HH:MM values).
// Earlier note: the exact JSON shape of services.php / availability.php was not
// documented. These parsers are deliberately tolerant and isolated in this one
// file. If a real response does not match, an ApiException(format) is raised
// carrying the raw body so the shape can be confirmed and fixed here only.
// The only response fields taken from the documented contract are `ref` and
// `status` of book.php.
// ---------------------------------------------------------------------------

const List<String> _serviceListKeys = [
  'services', 'data', 'items', 'result', 'results',
];

// Preferred containers for free times; any other list that really contains
// HH:MM values is also found (see _findSlots).
const List<String> _slotKeys = [
  'slots', 'times', 'available', 'availability', 'free', 'open', 'hours',
  'starts', 'data', 'result', 'results', 'items',
];

dynamic _firstOf(Map map, List<String> keys) {
  for (final k in keys) {
    if (map.containsKey(k) && map[k] != null) return map[k];
  }
  return null;
}

String? _firstString(Map map, List<String> keys) {
  for (final k in keys) {
    final v = map[k];
    if (v is String && v.trim().isNotEmpty) return v.trim();
    if (v is num) return v.toString();
  }
  return null;
}

List? _extractList(dynamic json, List<String> keys, [int depth = 0]) {
  if (json is List) return json;
  if (json is Map && depth < 3) {
    for (final k in keys) {
      final v = json[k];
      if (v is List) return v;
    }
    for (final k in keys) {
      final v = json[k];
      if (v is Map) {
        final inner = _extractList(v, keys, depth + 1);
        if (inner != null) return inner;
      }
    }
  }
  return null;
}

int? _toInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.round();
  if (v is String) return int.tryParse(normalizeDigits(v).trim());
  return null;
}

bool _isFalse(dynamic v) =>
    v == false || v == 0 || v == '0' || (v is String && v.toLowerCase() == 'false');

bool _isTrue(dynamic v) =>
    v == true || v == 1 || v == '1' || (v is String && v.toLowerCase() == 'true');

// ------------------------------ services -----------------------------------

/// Throws a "rejected" error when the server flags `ok:false` / `success:false`.
void _throwIfNotOk(dynamic json, {String? rawBody}) {
  if (json is Map) {
    final flag = _firstOf(json, ['ok', 'success']);
    if (flag != null && _isFalse(flag)) {
      throw ApiException(
        ApiErrorKind.rejected,
        serverMessage: extractServerMessage(json),
        rawBody: rawBody,
      );
    }
  }
}

int? _positive(int? v) => (v != null && v > 0) ? v : null;

/// Price/deposit as display text: strings unchanged, numbers grouped.
String? _display(dynamic v) {
  if (v == null || v is bool) return null;
  if (v is num) {
    if (v == v.truncate()) {
      final digits = v.truncate().abs().toString();
      final grouped = digits.replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
      return v < 0 ? '-$grouped' : grouped;
    }
    return v.toString();
  }
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

String? _serviceName(Map e) {
  final direct = _firstString(
      e, ['name', 'title', 'label', 'name_fa', 'title_fa', 'label_fa', 'fa']);
  if (direct != null) return direct;
  for (final k in ['name', 'title', 'label']) {
    final v = e[k];
    if (v is Map) {
      final s = _firstString(v, ['fa', 'en']);
      if (s != null) return s;
    }
  }
  for (final entry in e.entries) {
    final k = '${entry.key}'.toLowerCase();
    final v = entry.value;
    if (v is String &&
        v.trim().isNotEmpty &&
        (k.contains('name') || k.contains('title') || k.contains('label')) &&
        !_isEnglishKey(k)) {
      return v.trim();
    }
  }
  return null;
}

bool _isEnglishKey(String k) =>
    k == 'en' ||
    k.endsWith('_en') ||
    k.startsWith('en_') ||
    k.contains('english');

String? _serviceNameEn(Map e) {
  final direct = _firstString(e, ['name_en', 'title_en', 'label_en', 'en']);
  if (direct != null) return direct;
  for (final entry in e.entries) {
    final k = '${entry.key}'.toLowerCase();
    final v = entry.value;
    if (v is String &&
        v.trim().isNotEmpty &&
        _isEnglishKey(k) &&
        (k.contains('name') || k.contains('title') || k.contains('label') ||
            k.contains('english'))) {
      return v.trim();
    }
  }
  for (final k in ['name', 'title', 'label']) {
    final v = e[k];
    if (v is Map) {
      final s = _firstString(v, ['en']);
      if (s != null) return s;
    }
  }
  return null;
}

bool _allInactive(List? list) {
  if (list == null || list.isEmpty) return false;
  return list.every((e) {
    if (e is! Map) return false;
    final f = _firstOf(e, ['active', 'enabled', 'is_active', 'enable']);
    return f != null && _isFalse(f);
  });
}

List<ServiceItem> parseServices(dynamic json, {String? rawBody}) {
  _throwIfNotOk(json, rawBody: rawBody);
  Iterable<MapEntry<String?, dynamic>> entries;
  final list = _extractList(json, _serviceListKeys);
  if (list != null) {
    entries = list.map((e) => MapEntry<String?, dynamic>(null, e));
  } else if (json is Map &&
      json.isNotEmpty &&
      json.values.every((v) => v is Map)) {
    // { "<id>": { ...service... } }
    entries = json.entries
        .map((e) => MapEntry<String?, dynamic>('${e.key}', e.value));
  } else {
    throw ApiException(ApiErrorKind.format, rawBody: rawBody);
  }

  final out = <ServiceItem>[];
  for (final entry in entries) {
    final e = entry.value;
    if (e is! Map) continue;
    final rawId =
        _firstOf(e, ['id', 'service_id', 'slug', 'key', 'code']) ?? entry.key;
    if (rawId == null) continue;
    // A service the API marks inactive is never offered.
    final activeFlag = _firstOf(e, ['active', 'enabled', 'is_active', 'enable']);
    if (activeFlag != null && _isFalse(activeFlag)) continue;
    final Object id =
        (rawId is num || rawId is String) ? rawId as Object : rawId.toString();
    // The name key is not confirmed: fall back to the id rather than dropping
    // a bookable service.
    final name = _serviceName(e) ?? id.toString();
    out.add(ServiceItem(
      id: id,
      name: name,
      nameEn: _serviceNameEn(e),
      durationMinutes: _positive(_toInt(_firstOf(
          e, ['dur', 'duration', 'minutes', 'duration_min', 'duration_minutes']))),
      description: _firstString(
          e, ['description', 'desc', 'details', 'description_fa', 'about']),
      price: _display(_firstOf(e, ['price', 'cost', 'fee', 'amount'])),
      deposit: _display(
          _firstOf(e, ['deposit', 'deposit_amount', 'prepay', 'advance'])),
    ));
  }
  if (out.isEmpty && list != null && list.isEmpty) return out;
  if (out.isEmpty && (list == null || list.isNotEmpty) && !_allInactive(list)) {
    throw ApiException(ApiErrorKind.format, rawBody: rawBody);
  }
  return out;
}

// ----------------------------- availability --------------------------------

class _Entry {
  const _Entry(this.slot, this.free);
  final SlotTime slot;
  final bool free;
}

_Entry? _entryFrom(dynamic e) {
  if (e is String || e is num) {
    final s = SlotTime.tryParse('$e');
    return s == null ? null : _Entry(s, true);
  }
  if (e is Map) {
    var t = _firstString(
        e, ['time', 'start', 'from', 'label', 'value', 'slot', 'hour']);
    var s = t == null ? null : SlotTime.tryParse(t);
    if (s == null) {
      // The time may sit under any other key: take the first value that is a time.
      for (final v in e.values) {
        if (v is String) {
          final c = SlotTime.tryParse(v);
          if (c != null) {
            s = c;
            break;
          }
        }
      }
    }
    if (s == null) return null;
    var free = true;
    final flag = _firstOf(e, ['available', 'free', 'is_available', 'open']);
    if (flag != null && _isFalse(flag)) free = false;
    final taken = _firstOf(e, ['booked', 'taken', 'reserved', 'busy']);
    if (taken != null && _isTrue(taken)) free = false;
    return _Entry(s, free);
  }
  return null;
}

/// Free times of a list; null when the list has entries but none is a time.
List<SlotTime>? _slotsFromList(List list) {
  if (list.isEmpty) return <SlotTime>[];
  var recognized = 0;
  final free = <SlotTime>[];
  for (final e in list) {
    final entry = _entryFrom(e);
    if (entry == null) continue;
    recognized++;
    if (entry.free) free.add(entry.slot);
  }
  return recognized == 0 ? null : free;
}

List<SlotTime>? _findSlots(dynamic node, [int depth = 0]) {
  if (node is List) return _slotsFromList(node);
  if (node is! Map || depth > 3) return null;
  for (final k in _slotKeys) {
    final v = node[k];
    if (v is List) {
      final r = _slotsFromList(v);
      if (r != null) return r;
    } else if (v is Map) {
      final r = _findSlots(v, depth + 1);
      if (r != null) return r;
    }
  }
  for (final entry in node.entries) {
    if (_slotKeys.contains(entry.key)) continue;
    final v = entry.value;
    if (v is List && v.isNotEmpty) {
      final r = _slotsFromList(v);
      if (r != null) return r;
    } else if (v is Map) {
      final r = _findSlots(v, depth + 1);
      if (r != null) return r;
    }
  }
  // { "06:00": true, "06:30": false, ... }
  var sawTimeKey = false;
  final out = <SlotTime>[];
  node.forEach((k, v) {
    final s = SlotTime.tryParse('$k');
    if (s == null) return;
    sawTimeKey = true;
    var free = true;
    if (v is Map) {
      final e = _entryFrom({'time': '$k', ...v});
      free = e == null ? true : e.free;
    } else {
      free = v != null && !_isFalse(v);
    }
    if (free) out.add(s);
  });
  return sawTimeKey ? out : null;
}

List<SlotTime> parseAvailability(dynamic json, {String? rawBody}) {
  _throwIfNotOk(json, rawBody: rawBody);
  final found = _findSlots(json);
  if (found == null) {
    throw ApiException(ApiErrorKind.format, rawBody: rawBody);
  }
  final unique = <SlotTime>{...found}.toList()
    ..sort((a, b) => a.totalMinutes.compareTo(b.totalMinutes));
  return unique;
}

// ------------------------------- booking -----------------------------------

/// Best-effort extraction of a human-readable message from an error body.
String? extractServerMessage(dynamic json) {
  if (json is Map) {
    for (final k in ['error', 'message', 'msg', 'errors', 'detail']) {
      final v = json[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
      if (v is List && v.isNotEmpty) {
        final parts = v.whereType<String>().where((s) => s.trim().isNotEmpty);
        if (parts.isNotEmpty) return parts.join('\n');
      }
      if (v is Map) {
        final inner = extractServerMessage(v);
        if (inner != null) return inner;
      }
    }
  }
  return null;
}

Map<String, String> _extractPayment(Map json) {
  final out = <String, String>{};
  void collect(String prefix, dynamic v) {
    if (v == null) return;
    if (v is Map) {
      v.forEach((k, inner) => collect(prefix.isEmpty ? '$k' : '$prefix.$k', inner));
    } else if (v is List) {
      for (var i = 0; i < v.length; i++) {
        collect('$prefix[$i]', v[i]);
      }
    } else {
      final s = v.toString().trim();
      if (s.isNotEmpty) out[prefix] = s;
    }
  }

  json.forEach((k, v) {
    final key = '$k'.toLowerCase();
    if (key.contains('pay') || key.contains('deposit')) collect('$k', v);
  });
  return out;
}

/// Turns a 2xx `book.php` response into a [BookingResult]. A booking counts as
/// made ONLY if the server returned a `ref` and did not flag a failure.
BookingResult parseBookingResponse(dynamic json, {String? rawBody, int? statusCode}) {
  if (json is! Map) {
    throw ApiException(ApiErrorKind.format, rawBody: rawBody, statusCode: statusCode);
  }
  final okFlag = _firstOf(json, ['ok', 'success']);
  if (okFlag != null && _isFalse(okFlag)) {
    throw ApiException(
      ApiErrorKind.rejected,
      serverMessage: extractServerMessage(json),
      rawBody: rawBody,
      statusCode: statusCode,
    );
  }
  Map source = json;
  var ref = _firstString(source, ['ref']);
  if (ref == null) {
    for (final k in ['data', 'booking', 'result']) {
      final inner = json[k];
      if (inner is Map) {
        final r = _firstString(inner, ['ref']);
        if (r != null) {
          source = inner;
          ref = r;
          break;
        }
      }
    }
  }
  if (ref == null) {
    final msg = extractServerMessage(json);
    throw ApiException(
      msg != null ? ApiErrorKind.rejected : ApiErrorKind.format,
      serverMessage: msg,
      rawBody: rawBody,
      statusCode: statusCode,
    );
  }
  return BookingResult(
    ref: ref,
    status: _firstString(source, ['status']) ?? _firstString(json, ['status']),
    payment: _extractPayment(source),
    serverMessage: _firstString(json, ['message', 'msg']),
  );
}
