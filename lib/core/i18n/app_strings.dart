/// Persian (primary) and English (secondary) UI strings.
/// Placeholders use `{name}` and are replaced by [AppStrings.get].
class AppStrings {
  AppStrings._();

  static String get(String lang, String key, [Map<String, String>? params]) {
    final table = lang == 'en' ? en : fa;
    var s = table[key] ?? fa[key] ?? key;
    if (params != null) {
      params.forEach((k, v) => s = s.replaceAll('{$k}', v));
    }
    return s;
  }

  static const Map<String, String> fa = {
    'app_name': 'رایان گاردن',
    'lang_switch': 'EN',
    'continue': 'ادامه',
    'retry': 'تلاش دوباره',
    'loading': 'در حال بارگذاری…',
    'step_of': 'مرحله {n} از {t}',
    'duration_min': '{n} دقیقه',
    'launch_failed': 'امکان باز کردن این گزینه روی دستگاه شما وجود ندارد.',
    'about_title': 'درباره و تنظیمات',
    'about_tagline': 'باغی برای لحظه‌های ماندگار',
    'about_version': 'نسخه برنامه',
    'about_hours': 'ساعت کاری',
    'about_language': 'زبان و چیدمان',
    'about_management_title': 'مدیریت رزرو و تقویم',
    'about_management_body': 'رزروها، ساعت‌های آزاد و وضعیت پرداخت از طریق سامانه مدیریت وب‌سایت و تقویم هماهنگ می‌شوند.',
    'about_backend_preserved': 'اتصال امن به سامانه رزرو رایان گاردن فعال است.',
    'about_switch_language': 'تغییر زبان',

    // Home
    'home_location': 'آمل · مازندران',
    'home_tagline': 'لحظه‌های خاص،\nدر باغی متفاوت',
    'home_book': 'رزرو آنلاین',
    'home_call': 'تماس تلفنی',
    'home_contact': 'اطلاعات تماس و موقعیت باغ',
    'home_intro_title': 'تجربه‌ای برای ثبت خاطره‌ها',
    'home_intro_body':
        'باغ عکاسی و کافه رایان گاردن؛ فضایی سرسبز برای عکاسی عروس و داماد، خانواده، کودک و لحظه‌های خاص شما.',
    'home_overline': 'PHOTOGRAPHY · CAFE · GARDEN',
    'home_badge': 'تجربه‌ای اختصاصی در طبیعت',
    'home_contact_short': 'موقعیت',
    'home_explore_garden': 'گشت تصویری باغ',
    'home_services_title': 'انتخاب تجربه شما',
    'home_view_all': 'رزرو آسان',
    'home_service_bride': 'عروس و داماد',
    'home_service_formal': 'عکاسی رسمی',
    'home_service_children': 'عکاسی کودک',
    'home_service_family': 'عکاسی خانوادگی',
    'home_service_cafe': 'کافه‌گاردن',
    'tour_title': 'گشت تصویری باغ',
    'tour_subtitle': 'فضای واقعی رایان گاردن را با عکس‌های ثبت‌شده از باغ و کافه ببینید.',
    'tour_real_assets_note': 'این گشت از تصاویر واقعی رایان گاردن استفاده می‌کند. برای ساخت یک تجربه سه‌بعدی واقعی، فایل مدل یا ویدیوی ۳۶۰ درجه هنوز لازم است.',
    'tour_selected': 'موقعیت انتخاب‌شده: {location}',
    'tour_hero': 'نمای کلی باغ',
    'tour_wedding': 'فضای عکاسی عروس و داماد',
    'tour_formal': 'فضای عکاسی رسمی',
    'tour_children': 'فضای عکاسی کودک',
    'tour_family': 'فضای عکاسی خانوادگی',
    'tour_cafe': 'کافه‌باغ',

    // Services
    'services_title': 'انتخاب خدمات',
    'services_subtitle': 'خدمت مورد نظر خود را انتخاب کنید',
    'services_hours': 'هر روز حتی جمعه‌ها · {from} تا {to}',
    'services_backend_note': 'ساعت‌های آزاد و جلوگیری از رزرو هم‌زمان توسط سامانه اصلی و API وب‌سایت کنترل می‌شود.',
    'service_payment_available': 'امکان ثبت بیعانه طبق پاسخ سامانه',
    'service_payment_pending': 'جزئیات بیعانه پس از هماهنگی اعلام می‌شود',
    'services_empty': 'در حال حاضر خدمتی برای نمایش وجود ندارد.',
    'detail_title': 'جزئیات خدمت',
    'detail_duration': 'مدت زمان',
    'detail_about': 'توضیحات',
    'detail_price': 'قیمت',
    'detail_deposit': 'بیعانه',
    'detail_payment_pending': 'در حال حاضر مبلغ یا درگاه پرداختی از سامانه اعلام نشده است؛ هماهنگی پرداخت پس از ثبت درخواست انجام می‌شود.',
    'detail_default_desc':
        'برای مشاهده ساعت‌های آزاد و ثبت رزرو این خدمت ادامه دهید.',
    'detail_book': 'رزرو این خدمت',

    // Calendar
    'calendar_title': 'انتخاب تاریخ',
    'calendar_hint':
        'امکان رزرو از امروز تا {n} روز آینده وجود دارد. تاریخ‌ها شمسی هستند.',
    'calendar_selected': 'تاریخ انتخابی: {d}',
    'calendar_none': 'هنوز تاریخی انتخاب نشده است.',
    'prev_month': 'ماه قبل',
    'next_month': 'ماه بعد',

    // Slots
    'slots_title': 'ساعت‌های آزاد',
    'slots_for': 'ساعت‌های آزاد برای {d}',
    'slots_hint': 'ساعت شروع را از میان ساعت‌های آزاد اعلام‌شده توسط سیستم انتخاب کنید.',
    'slots_empty':
        'برای این روز ساعت آزادی وجود ندارد. لطفاً روز دیگری را انتخاب کنید.',
    'change_date': 'تغییر تاریخ',

    // Customer form
    'form_title': 'اطلاعات شما',
    'form_name': 'نام و نام خانوادگی',
    'form_phone': 'شماره موبایل',
    'form_phone_hint': '09123456789',
    'form_name_err': 'نام و نام خانوادگی را وارد کنید (حداقل ۳ حرف).',
    'form_phone_err': 'شماره موبایل معتبر نیست. نمونه: 09123456789',
    'form_no_login': 'برای رزرو نیازی به ثبت‌نام یا ورود نیست.',

    // Notes
    'notes_title': 'توضیحات',
    'notes_label': 'یادداشت یا توضیحات (اختیاری)',
    'notes_hint': 'مثلاً تعداد نفرات، نوع مراسم یا درخواست خاص شما',

    // Confirm
    'confirm_title': 'تأیید نهایی',
    'confirm_service': 'خدمت',
    'confirm_duration': 'مدت زمان',
    'confirm_date': 'تاریخ',
    'confirm_time': 'ساعت',
    'confirm_name': 'نام',
    'confirm_phone': 'موبایل',
    'confirm_notes': 'توضیحات',
    'confirm_payment_pending': 'جزئیات پرداخت پس از هماهنگی اعلام می‌شود',
    'confirm_none': '—',
    'confirm_notice':
        'رزرو فقط پس از ثبت توسط سرور اعلام می‌شود. وضعیت و تأیید نهایی را همان سیستم رزرو وب‌سایت تعیین می‌کند.',
    'confirm_uncertain':
        'اگر خطا بعد از ارسال درخواست رخ داده باشد، ممکن است رزرو ثبت شده باشد. پیش از ثبت دوباره، لطفاً با ما تماس بگیرید.',
    'confirm_submit': 'ثبت رزرو',
    'confirm_submitting': 'در حال ثبت رزرو…',

    // Result
    'result_title': 'نتیجه رزرو',
    'result_success': 'درخواست رزرو شما ثبت شد',
    'result_ref': 'کد پیگیری',
    'result_status': 'وضعیت',
    'result_payment': 'اطلاعات پرداخت',
    'result_copy': 'کپی کد پیگیری',
    'result_copied': 'کد پیگیری کپی شد.',
    'result_keep': 'لطفاً کد پیگیری را نزد خود نگه دارید.',
    'result_home': 'بازگشت به صفحه اصلی',
    'status_pending': 'در انتظار تأیید',
    'status_confirmed': 'تأیید شده',
    'status_cancelled': 'لغو شده',

    // Contact
    'contact_title': 'تماس و موقعیت باغ',
    'contact_call': 'تماس تلفنی',
    'contact_map': 'مسیریابی در نقشه',
    'contact_email': 'ارسال ایمیل',
    'contact_instagram': 'اینستاگرام',
    'contact_address_label': 'نشانی',
    'contact_address':
        'مازندران، آمل، کیلومتر ۱۲ جاده هراز، بعد از رستوران آریا، رزکه، ۲۰۰ متر بعد از پاسگاه جنگلبانی، جاده امامزاده هجده تن',
    'contact_hours': 'برای هماهنگی ساعت‌های رزرو، از بخش رزرو آنلاین استفاده کنید.',
    'contact_copy_address': 'کپی نشانی',
    'contact_copied': 'نشانی کپی شد.',

    // Errors
    'err_network':
        'اتصال به سرور برقرار نشد. اینترنت خود را بررسی کنید و دوباره تلاش کنید.',
    'err_timeout': 'پاسخ سرور طولانی شد. لطفاً دوباره تلاش کنید.',
    'err_server': 'سرور نتوانست درخواست را انجام دهد. لطفاً کمی بعد دوباره تلاش کنید.',
    'error_recovery_hint': 'لطفاً اتصال اینترنت را بررسی کنید و دوباره تلاش کنید. اگر مشکل ادامه داشت، با باغ تماس بگیرید.',
    'err_format':
        'پاسخ سرور قابل‌تشخیص نبود. اگر در حال ثبت رزرو بودید، رزرو انجام‌شده در نظر گرفته نمی‌شود؛ لطفاً با ما تماس بگیرید.',
    'err_forbidden': 'دسترسی موقتاً برقرار نشد. لطفاً دوباره تلاش کنید یا با باغ تماس بگیرید.',
  };

  static const Map<String, String> en = {
    'app_name': 'Rayan Garden',
    'lang_switch': 'فا',
    'continue': 'Continue',
    'retry': 'Try again',
    'loading': 'Loading…',
    'step_of': 'Step {n} of {t}',
    'duration_min': '{n} min',
    'launch_failed': 'This option cannot be opened on your device.',
    'about_title': 'About & settings',
    'about_tagline': 'A garden for lasting moments',
    'about_version': 'App version',
    'about_hours': 'Opening hours',
    'about_language': 'Language & layout',
    'about_management_title': 'Booking & calendar management',
    'about_management_body': 'Bookings, availability and deposit status stay synchronized with the website administration and calendar system.',
    'about_backend_preserved': 'Secure connection to the Rayan Garden booking system is active.',
    'about_switch_language': 'Switch language',

    'home_location': 'Amol · Mazandaran',
    'home_tagline': 'Special moments,\nin a different garden',
    'home_book': 'Book online',
    'home_call': 'Call us',
    'home_contact': 'Contact & garden location',
    'home_intro_title': 'An experience to capture memories',
    'home_intro_body':
        'Rayan Garden is a photography garden and café: a lush setting for wedding, family and children photography and your special moments.',
    'home_overline': 'PHOTOGRAPHY · CAFE · GARDEN',
    'home_badge': 'A private experience in nature',
    'home_contact_short': 'Location',
    'home_explore_garden': 'Explore the garden',
    'home_services_title': 'Choose your experience',
    'home_view_all': 'Book easily',
    'home_service_bride': 'Bride & groom',
    'home_service_formal': 'Formal photography',
    'home_service_children': 'Children photography',
    'home_service_family': 'Family photography',
    'home_service_cafe': 'Cafe-Garden',
    'tour_title': 'Garden photo tour',
    'tour_subtitle': 'Explore Rayan Garden through real photographs of the garden and café.',
    'tour_real_assets_note': 'This tour uses real Rayan Garden imagery. A genuine 3D experience still requires an original model or 360-degree walkthrough video.',
    'tour_selected': 'Selected location: {location}',
    'tour_hero': 'Garden overview',
    'tour_wedding': 'Bride & groom area',
    'tour_formal': 'Formal photography area',
    'tour_children': 'Children photography area',
    'tour_family': 'Family photography area',
    'tour_cafe': 'Cafe-Garden',

    'services_title': 'Choose a service',
    'services_subtitle': 'Select the service you would like',
    'services_hours': 'Every day, including Fridays · {from} to {to}',
    'services_backend_note': 'Availability and double-booking prevention are controlled by the website system and its existing API.',
    'service_payment_available': 'Deposit support follows the server response',
    'service_payment_pending': 'Deposit details will be provided after coordination',
    'services_empty': 'No services are available right now.',
    'detail_title': 'Service details',
    'detail_duration': 'Duration',
    'detail_about': 'About',
    'detail_price': 'Price',
    'detail_deposit': 'Deposit',
    'detail_payment_pending': 'The live system currently reports no amount or payment gateway; payment coordination follows the booking request.',
    'detail_default_desc':
        'Continue to see the available times and book this service.',
    'detail_book': 'Book this service',

    'calendar_title': 'Choose a date',
    'calendar_hint':
        'You can book from today up to {n} days ahead. Dates are shown in the Persian (Jalali) calendar.',
    'calendar_selected': 'Selected date: {d}',
    'calendar_none': 'No date selected yet.',
    'prev_month': 'Previous month',
    'next_month': 'Next month',

    'slots_title': 'Available times',
    'slots_for': 'Available times for {d}',
    'slots_hint':
        'Pick a start time from the free times reported by the booking system.',
    'slots_empty':
        'There are no free times on this day. Please choose another date.',
    'change_date': 'Change date',

    'form_title': 'Your details',
    'form_name': 'Full name',
    'form_phone': 'Mobile number',
    'form_phone_hint': '09123456789',
    'form_name_err': 'Enter your full name (at least 3 letters).',
    'form_phone_err': 'The mobile number is not valid. Example: 09123456789',
    'form_no_login': 'No sign-up or login is needed to book.',

    'notes_title': 'Notes',
    'notes_label': 'Notes or requests (optional)',
    'notes_hint': 'For example number of people, type of event or a special request',

    'confirm_title': 'Final confirmation',
    'confirm_service': 'Service',
    'confirm_duration': 'Duration',
    'confirm_date': 'Date',
    'confirm_time': 'Time',
    'confirm_name': 'Name',
    'confirm_phone': 'Mobile',
    'confirm_notes': 'Notes',
    'confirm_payment_pending': 'Payment details will be provided after coordination',
    'confirm_none': '—',
    'confirm_notice':
        'A booking is announced only after the server records it. Its status and final confirmation are decided by the website booking system.',
    'confirm_uncertain':
        'If the error happened after the request was sent, the booking may have been recorded. Please contact us before submitting again.',
    'confirm_submit': 'Submit booking',
    'confirm_submitting': 'Submitting booking…',

    'result_title': 'Booking result',
    'result_success': 'Your booking request was recorded',
    'result_ref': 'Tracking code',
    'result_status': 'Status',
    'result_payment': 'Payment information',
    'result_copy': 'Copy tracking code',
    'result_copied': 'Tracking code copied.',
    'result_keep': 'Please keep your tracking code.',
    'result_home': 'Back to home',
    'status_pending': 'Pending confirmation',
    'status_confirmed': 'Confirmed',
    'status_cancelled': 'Cancelled',

    'contact_title': 'Contact & location',
    'contact_call': 'Call us',
    'contact_map': 'Open in maps',
    'contact_email': 'Send an email',
    'contact_instagram': 'Instagram',
    'contact_address_label': 'Address',
    'contact_address':
        'Mazandaran, Amol, km 12 of Haraz Road, after Aria Restaurant, Razakeh, 200 m past the forestry guard post, Imamzadeh Hejdah Tan road',
    'contact_hours': 'Use online booking to see the available times.',
    'contact_copy_address': 'Copy address',
    'contact_copied': 'Address copied.',

    'err_network':
        'Could not reach the server. Check your internet connection and try again.',
    'err_timeout': 'The server took too long to respond. Please try again.',
    'err_server': 'The server could not complete the request. Please try again shortly.',
    'error_recovery_hint': 'Check your internet connection and try again. If the problem continues, please contact the garden.',
    'err_format':
        'The server response was not recognized. If you were submitting a booking, it is NOT considered made; please contact us.',
    'err_forbidden': 'Access was temporarily unavailable. Please try again or contact the garden.',
  };
}
