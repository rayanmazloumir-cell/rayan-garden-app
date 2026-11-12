import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/config/app_config.dart';
import '../core/i18n/app_strings.dart';
import '../core/utils/digits.dart';
import '../core/utils/jalali.dart';
import '../core/utils/validators.dart';
import '../data/api/api_exception.dart';
import '../data/models/booking.dart';
import '../data/models/service_catalog.dart';
import '../data/models/service_item.dart';
import '../data/models/slot_time.dart';
import '../data/repositories/booking_repository.dart';
import 'loadable.dart';

/// Holds language and the whole booking flow. UI-free and unit-testable.
class AppState extends ChangeNotifier {
  AppState({required this.repository, DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final BookingRepository repository;
  final DateTime Function() _clock;

  // ----------------------------- language ----------------------------------
  String lang = 'fa';
  bool get isFa => lang == 'fa';

  void toggleLanguage() {
    lang = isFa ? 'en' : 'fa';
    notifyListeners();
  }

  String tr(String key, [Map<String, String>? params]) =>
      AppStrings.get(lang, key, params);

  String digits(String s) => localizeDigits(s, isFa);

  // ------------------------------ time -------------------------------------
  /// Current wall-clock time in Iran, stored in a UTC `DateTime`.
  DateTime get tehranNow => _clock().toUtc().add(AppConfig.tehranOffset);

  DateTime get today {
    final n = tehranNow;
    return DateTime.utc(n.year, n.month, n.day);
  }

  DateTime get lastBookableDate =>
      today.add(const Duration(days: AppConfig.maxAheadDays));

  // ------------------------------ services ---------------------------------
  Loadable<List<ServiceItem>> services = const Loadable.idle();

  Future<void> loadServices({bool force = false}) async {
    if (services.isLoading || (services.isSuccess && !force)) return;
    services = const Loadable.loading();
    notifyListeners();
    try {
      final list = await repository.fetchServices();
      services = Loadable.success(ServiceCatalog.decorate(list));
    } on ApiException catch (e) {
      services = Loadable.failure(e);
    } catch (_) {
      services = const Loadable.failure(ApiException(ApiErrorKind.network));
    }
    notifyListeners();
  }

  // --------------------------- booking selection ---------------------------
  ServiceItem? service;
  DateTime? date;
  SlotTime? slot;
  String name = '';
  String phone = '';
  String notes = '';

  void selectService(ServiceItem s) {
    if (service?.id.toString() != s.id.toString()) {
      date = null;
      slot = null;
      slots = const Loadable.idle();
    }
    service = s;
    notifyListeners();
  }

  void selectDate(DateTime d) {
    date = DateTime.utc(d.year, d.month, d.day);
    slot = null;
    slots = const Loadable.idle();
    notifyListeners();
  }

  void selectSlot(SlotTime s) {
    slot = s;
    notifyListeners();
  }

  void setCustomer(String newName, String newPhone) {
    name = cleanName(newName);
    phone = normalizePhone(newPhone);
  }

  void setNotes(String value) {
    notes = value.trim();
  }

  /// Read-only connection check for troubleshooting (HTTP 403 etc.).
  Future<String> runDiagnostics() => repository.diagnose();

  /// Duration comes ONLY from the API (`dur`); the app has no duration table.
  int? durationOf(ServiceItem s) => s.durationMinutes;

  // ------------------------------- slots -----------------------------------
  Loadable<List<SlotTime>> slots = const Loadable.idle();
  int _slotsToken = 0;

  Future<void> loadSlots() async {
    final s = service;
    final d = date;
    if (s == null || d == null) return;
    final token = ++_slotsToken;
    slot = null;
    slots = const Loadable.loading();
    notifyListeners();
    Loadable<List<SlotTime>> next;
    try {
      final all = await repository.fetchAvailability(d, s.id);
      next = Loadable.success(all); // exactly what the server returned
    } on ApiException catch (e) {
      next = Loadable.failure(e);
    } catch (_) {
      next = const Loadable.failure(ApiException(ApiErrorKind.network));
    }
    if (token != _slotsToken) return; // a newer request replaced this one
    slots = next;
    notifyListeners();
  }

  // ------------------------------ submit -----------------------------------
  DateTime? _formStartedAt;
  bool submitting = false;
  BookingResult? result;

  /// Starts the "human filling the form" timer (sent to the API as `elapsed`).
  void markFormStarted() {
    _formStartedAt ??= _clock();
  }

  bool get canSubmit =>
      service != null &&
      date != null &&
      slot != null &&
      isValidName(name) &&
      isValidIranMobile(phone);

  /// Sends the booking. Returns the result ONLY when the server confirmed it;
  /// otherwise throws [ApiException]. Nothing is ever marked successful locally.
  Future<BookingResult> submit() async {
    if (submitting) {
      throw const ApiException(ApiErrorKind.server);
    }
    final s = service, d = date, t = slot;
    if (!canSubmit || s == null || d == null || t == null) {
      throw const ApiException(ApiErrorKind.format);
    }
    submitting = true;
    notifyListeners();
    try {
      final started = _formStartedAt ?? _clock();
      var elapsed = _clock().difference(started).inMilliseconds;
      if (elapsed < AppConfig.minElapsedMs) {
        await Future<void>.delayed(
            Duration(milliseconds: AppConfig.minElapsedMs - elapsed + 100));
        elapsed = _clock().difference(started).inMilliseconds;
      }
      final request = BookingRequest(
        serviceId: s.id,
        date: isoDate(d),
        time: t.raw,
        name: name,
        phone: phone,
        notes: notes,
        lang: lang,
        elapsedMs: math.max(elapsed, AppConfig.minElapsedMs),
      );
      final r = await repository.submitBooking(request);
      result = r;
      return r;
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(ApiErrorKind.network);
    } finally {
      submitting = false;
      notifyListeners();
    }
  }

  /// Clears the current booking (keeps the loaded services and language).
  void resetBooking() {
    service = null;
    date = null;
    slot = null;
    name = '';
    phone = '';
    notes = '';
    slots = const Loadable.idle();
    result = null;
    submitting = false;
    _formStartedAt = null;
    _slotsToken++;
    notifyListeners();
  }
}
