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

    // Home
    'home_location': 'آمل · مازندران',
    'home_tagline': 'لحظه‌های خاص،\nدر باغی متفاوت',
    'home_book': 'رزرو آنلاین',
    'home_call': 'تماس تلفنی',
    'home_contact': 'اطلاعات تماس و موقعیت باغ',
    'home_intro_title': 'تجربه‌ای برای ثبت خاطره‌ها',
    'home_intro_body':
        'باغ عکاسی و کافه رایان گاردن؛ فضایی سرسبز برای عکاسی عروس و داماد، خانواده، کودک و لحظه‌های خاص شما.',

    // Services
    'services_title': 'انتخاب خدمات',
    'services_subtitle': 'خدمت مورد نظر خود را انتخاب کنید',
    'services_empty': 'در حال حاضر خدمتی برای نمایش وجود ندارد.',
    'detail_title': 'جزئیات خدمت',
    'detail_duration': 'مدت زمان',
    'detail_about': 'توضیحات',
    'detail_price': 'قیمت',
    'detail_deposit': 'بیعانه',
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
    'err_format':
        'پاسخ سرور قابل‌تشخیص نبود. اگر در حال ثبت رزرو بودید، رزرو انجام‌شده در نظر گرفته نمی‌شود؛ لطفاً با ما تماس بگیرید.',
    'err_details': 'جزئیات فنی',
    'err_forbidden':
        'درخواست برنامه توسط سرور یا فایروال هاست رد شد (HTTP 403). جزئیات فنی یا «تشخیص اتصال» را برای مدیر هاست بفرستید.',
    'diag_button': 'تشخیص اتصال',
    'diag_running': 'در حال بررسی…',
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

    'home_location': 'Amol · Mazandaran',
    'home_tagline': 'Special moments,\nin a different garden',
    'home_book': 'Book online',
    'home_call': 'Call us',
    'home_contact': 'Contact & garden location',
    'home_intro_title': 'An experience to capture memories',
    'home_intro_body':
        'Rayan Garden is a photography garden and café: a lush setting for wedding, family and children photography and your special moments.',

    'services_title': 'Choose a service',
    'services_subtitle': 'Select the service you would like',
    'services_empty': 'No services are available right now.',
    'detail_title': 'Service details',
    'detail_duration': 'Duration',
    'detail_about': 'About',
    'detail_price': 'Price',
    'detail_deposit': 'Deposit',
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
    'err_format':
        'The server response was not recognized. If you were submitting a booking, it is NOT considered made; please contact us.',
    'err_details': 'Technical details',
    'err_forbidden':
        'The request was refused by the server or the host firewall (HTTP 403). Send the technical details or the "Connection check" result to the host administrator.',
    'diag_button': 'Connection check',
    'diag_running': 'Checking…',
  };
}
