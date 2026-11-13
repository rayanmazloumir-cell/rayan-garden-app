import '../../core/utils/validators.dart';

class LocalOffer {
  const LocalOffer({
    required this.id,
    required this.titleFa,
    required this.titleEn,
    required this.descriptionFa,
    required this.descriptionEn,
    required this.discount,
    required this.code,
    required this.badge,
  });

  final String id;
  final String titleFa;
  final String titleEn;
  final String descriptionFa;
  final String descriptionEn;
  final String discount;
  final String code;
  final String badge;

  String title(String lang) => lang == 'fa' ? titleFa : titleEn;
  String description(String lang) => lang == 'fa' ? descriptionFa : descriptionEn;
}

class LocalCustomer {
  const LocalCustomer({required this.name, required this.phone, required this.registeredAt});

  final String name;
  final String phone;
  final DateTime registeredAt;
}

class LocalOtpResult {
  const LocalOtpResult({required this.phone, required this.testCode});

  final String phone;
  final String testCode;
}

class LocalSmsResult {
  const LocalSmsResult({required this.recipientCount, required this.offerTitle});

  final int recipientCount;
  final String offerTitle;
}

/// A deterministic, offline-only backend used until the production auth/SMS APIs are connected.
class LocalSimulatedBackend {
  LocalSimulatedBackend({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final Map<String, LocalCustomer> _customers = <String, LocalCustomer>{};
  final Map<String, String> _pendingOtps = <String, String>{};

  static const offers = <LocalOffer>[
    LocalOffer(
      id: 'autumn-vip',
      titleFa: 'آفر پاییزی باشگاه VIP',
      titleEn: 'VIP Autumn Experience',
      descriptionFa: 'با ثبت‌نام در باشگاه مشتریان، از آفرهای اختصاصی عکاسی پاییزی بهره‌مند شوید.',
      descriptionEn: 'Join the VIP Club for an exclusive seasonal photography experience.',
      discount: '۱۵٪ تخفیف',
      code: 'VIP15',
      badge: 'VIP',
    ),
    LocalOffer(
      id: 'family-day',
      titleFa: 'جشنواره عکاسی خانوادگی',
      titleEn: 'Family Photography Festival',
      descriptionFa: 'ثبت خاطره خانوادگی در فضای سبز رایان گاردن با پکیج ویژه.',
      descriptionEn: 'Capture family memories at Rayan Garden with a special package.',
      discount: '۱۰٪ تخفیف',
      code: 'FAMILY10',
      badge: 'SEASONAL',
    ),
    LocalOffer(
      id: 'cafe-garden',
      titleFa: 'پکیج کافه‌گاردن',
      titleEn: 'Cafe-Garden Package',
      descriptionFa: 'یک تجربه آرام از عکاسی و کافه در یک رزرو اختصاصی.',
      descriptionEn: 'A relaxed photography and cafe experience in one booking.',
      discount: 'هدیه ویژه',
      code: 'GARDENCAFE',
      badge: 'NEW',
    ),
  ];

  List<LocalCustomer> get customers => List.unmodifiable(_customers.values);
  bool get hasCustomers => _customers.isNotEmpty;
  LocalCustomer? customerFor(String phone) => _customers[normalizePhone(phone)];

  LocalOtpResult requestOtp(String rawPhone) {
    final phone = normalizePhone(rawPhone);
    if (!isValidIranMobile(phone)) throw const FormatException('invalid_phone');
    const code = '1234';
    _pendingOtps[phone] = code;
    return LocalOtpResult(phone: phone, testCode: code);
  }

  LocalCustomer verifyOtp({required String rawPhone, required String name, required String code}) {
    final phone = normalizePhone(rawPhone);
    if (_pendingOtps[phone] != code) throw const FormatException('invalid_otp');
    final customer = LocalCustomer(
      name: cleanName(name).isEmpty ? 'Rayan Garden VIP' : cleanName(name),
      phone: phone,
      registeredAt: _clock(),
    );
    _customers[phone] = customer;
    _pendingOtps.remove(phone);
    return customer;
  }

  LocalSmsResult sendPromotionalSms() {
    return LocalSmsResult(
      recipientCount: _customers.length,
      offerTitle: offers.first.titleEn,
    );
  }
}
