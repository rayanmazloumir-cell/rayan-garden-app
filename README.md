# Rayan Garden — اپلیکیشن رزرو (Flutter)

اپلیکیشن رزرو خدمات عکاسی و باغ رایان گاردن؛ فارسی (راست‌چین) و انگلیسی.

## امکانات
- صفحه اصلی، انتخاب خدمات، جزئیات خدمت
- تقویم شمسی (امروز تا ۱۲۰ روز آینده)، ساعت‌های آزاد (فقط از سرور)
- فرم نام و موبایل (اعتبارسنجی)، یادداشت، تأیید نهایی
- نتیجه رزرو با کد پیگیری (`ref`)، وضعیت (`status`) و اطلاعات پرداخت در صورت ارسال سرور
- تماس، مسیریابی، ایمیل و اینستاگرام (همگی فعال)
- رزرو **هرگز** بدون تأیید سرور موفق اعلام نمی‌شود. پرداخت آنلاین پیاده‌سازی نشده است.

## ساخت APK با GitHub Actions (فقط با موبایل)
1. فایل `Rayan-Garden-Fixed.zip` را بدون باز کردن در ریشه ریپو آپلود کنید.
2. فایل `.github/workflows/main.yml` را با محتوای `main.yml` همراه این پروژه جایگزین کنید.
3. تب **Actions** ← **Build Rayan Garden Android APK** ← **Run workflow**.
4. پس از تیک سبز، در پایین صفحه اجرا بخش **Artifacts** را باز کنید و `Rayan-Garden-Android-APK` را دانلود کنید.

راهنمای کامل اجرا: `docs/GITHUB-ACTIONS-GUIDE.md`. اگر فایل‌های پروژه در ریشه ریپو باشند، workflow مستقیم از آن‌ها استفاده می‌کند و ZIP را باز نمی‌کند.
workflow پوشه اندروید را می‌سازد، دسترسی اینترنت، باز کردن تماس/ایمیل/لینک و آیکن برنامه را
(با `tool/patch_android.py`) اضافه می‌کند، سلامت لوگو را با `tool/assets.sha256` می‌سنجد و
`flutter analyze` و `flutter test` را اجرا می‌کند ؛ شکست هرکدام ساخت APK را متوقف می‌کند و لاگ‌ها در آرتیفکت `Rayan-Garden-Logs` می‌ماند.
APK نهایی با کلید debug امضا می‌شود (برای نصب مستقیم مناسب است، نه انتشار در مارکت).

## ساخت روی کامپیوتر
```
flutter create --platforms=android --org com.rayangarden --project-name rayan_garden .
python3 tool/patch_android.py .
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```
خروجی: `build/app/outputs/flutter-apk/app-release.apk`

## ساختار کد
```
lib/
  core/        config، رنگ و تم، متن‌های فارسی/انگلیسی، تقویم شمسی، اعتبارسنجی
  data/        api_client (HTTP)، response_parsers (تحلیل پاسخ)، models، repository
  state/       AppState (زبان + جریان رزرو)، AppScope
  widgets/     اجزای مشترک رابط کاربری
  screens/     ۱۰ صفحه اپلیکیشن
test/          تست‌های واحد و ویجت
docs/API-NOTES.md   قرارداد API و موارد تأییدنشده
```
رابط کاربری، منطق رزرو و ارتباط با API از هم جدا هستند. برای تغییر ساختار پاسخ سرور فقط
`lib/data/api/response_parsers.dart` را ویرایش کنید.

## نکته مهم API
ساختار JSON پاسخ `services.php` و `availability.php` در مستندات نبود؛ جزئیات و راه تأیید در
`docs/API-NOTES.md` آمده است. هیچ API یا پارامتر مستندنشده‌ای در اپ استفاده نشده است.


خطای HTTP 403: `docs/HTTP-403-REPORT.md` (تحلیل، دکمه «تشخیص اتصال» و متن پیشنهادی برای مدیر هاست).
