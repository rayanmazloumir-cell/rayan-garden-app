import 'service_item.dart';

/// Approved public service catalogue. IDs and server-provided prices remain authoritative.
class ServiceCatalog {
  ServiceCatalog._();

  static const entries = <CatalogEntry>[
    CatalogEntry('bride_groom', 'عکاسی عروس و داماد', 'Bride & Groom Photography', 120, 'عکاسی رمانتیک و حرفه‌ای برای ثبت آغاز یک زندگی مشترک.'),
    CatalogEntry('formal', 'عکاسی رسمی', 'Formal Photography', 180, 'یک تجربه کامل برای پرتره‌های رسمی و تصاویر ماندگار.'),
    CatalogEntry('children', 'عکاسی کودک', 'Children Photography', 60, 'لحظه‌های بازیگوشانه و طبیعی کودک شما در باغ.'),
    CatalogEntry('family', 'عکاسی خانوادگی', 'Family Photography', 60, 'قاب‌های گرم خانوادگی در فضای سبز و آرام رایان گاردن.'),
    CatalogEntry('cafe_garden', 'کافه‌گاردن', 'Cafe-Garden', 120, 'ترکیبی دلنشین از کافه، باغ و یک خاطره متفاوت.'),
  ];

  static List<ServiceItem> decorate(List<ServiceItem> serverItems) {
    return serverItems.map((item) {
      final match = _find(item);
      if (match == null) return item;
      return ServiceItem(
        id: item.id,
        name: match.fa,
        nameEn: match.en,
        durationMinutes: item.durationMinutes ?? match.minutes,
        description: item.description?.isNotEmpty == true ? item.description : match.description,
        price: item.price,
        deposit: item.deposit,
      );
    }).toList(growable: false);
  }

  static CatalogEntry? _find(ServiceItem item) {
    final haystack = '${item.id} ${item.name} ${item.nameEn ?? ''}'.toLowerCase();
    for (final entry in entries) {
      final tokens = [entry.key, entry.fa, entry.en];
      if (tokens.any((token) => haystack.contains(token.toLowerCase()))) return entry;
    }
    if (haystack.contains('عروس') || haystack.contains('bride') || haystack.contains('groom')) return entries[0];
    if (haystack.contains('رسم') || haystack.contains('formal')) return entries[1];
    if (haystack.contains('کودک') || haystack.contains('child')) return entries[2];
    if (haystack.contains('خانواد') || haystack.contains('family')) return entries[3];
    if (haystack.contains('کافه') || haystack.contains('cafe')) return entries[4];
    return null;
  }
}

class CatalogEntry {
  const CatalogEntry(this.key, this.fa, this.en, this.minutes, this.description);
  final String key;
  final String fa;
  final String en;
  final int minutes;
  final String description;
}
