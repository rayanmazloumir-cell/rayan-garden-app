# راهنمای اجرای GitHub Actions برای Rayan Garden

## ۱) قرار دادن پروژه در ریپو (یکی از دو روش)
**روش الف: فایل ZIP.** فایل ZIP را در ریشه ریپو آپلود کنید. نام‌های قابل قبول:
`Rayan-Garden-Fixed.zip` و `Rayan-Garden-Fixed (4).zip` (و شکل‌هایی که GitHub خودش اسم را تغییر می‌دهد، مثل
`Rayan-Garden-Fixed.(4).zip` یا `Rayan-Garden-Fixed-4.zip`). فایل‌های دیگر (مثلاً `Rayan-Garden-Source-Download.zip`) نادیده گرفته می‌شوند.

اگر چند ZIP وجود داشته باشد:
1. بزرگ‌ترین شماره داخل پرانتز اول بررسی می‌شود (`(10)` قبل از `(9)`؛ فایل بدون شماره آخر).
2. هر ZIP فقط وقتی پذیرفته می‌شود که واقعاً پروژه Rayan Garden باشد (`pubspec.yaml` با `name: rayan_garden` و `lib/main.dart`).
   ZIP نامعتبر رد می‌شود و ZIP بعدی بررسی می‌شود.
3. نام ZIP انتخاب‌شده و ZIPهای ردشده در لاگ مرحله «Locate the project» نوشته می‌شود.

**روش ب: فایل‌های پروژه در ریشه ریپو.** اگر `pubspec.yaml` (با `name: rayan_garden`) و `lib/main.dart` در ریشه باشند،
workflow مستقیم از همان استفاده می‌کند و هیچ ZIP را باز نمی‌کند، حتی اگر ZIP هم در ریپو باشد.

## ۲) فایل workflow
محتوای `main.yml` را در مسیر `.github/workflows/main.yml` قرار دهید (اگر پروژه را با روش ب گذاشته‌اید،
همین فایل داخل پروژه هم هست).

## ۳) اجرا
صفحه **Actions** ← **Build Rayan Garden Android APK** ← **Run workflow** (یا با هر push به شاخه `main`).

## ۴) ترتیب مراحل
پیدا کردن پروژه ← بررسی هش لوگو ← ساخت پوشه اندروید ← patch اندروید ← `flutter pub get` ← `flutter analyze` ←
`flutter test` ← `flutter build apk --release`.

- `flutter analyze` و `flutter test` گزینه ادامه‌دادن بعد از شکست ندارند. اگر هرکدام شکست بخورد، همان‌جا کار متوقف می‌شود و APK ساخته نمی‌شود.
- `flutter analyze` با `--no-fatal-infos --no-fatal-warnings` اجرا می‌شود: فقط خطای واقعی (error) باعث شکست می‌شود. برای سخت‌گیری بیشتر این دو گزینه را از مرحله Analyze بردارید.
- APK با کلید debug امضا می‌شود (برای نصب مستقیم مناسب است، نه انتشار در مارکت).

## ۵) خروجی‌ها (Artifacts)
در پایین صفحه همان اجرا:
- **Rayan-Garden-Android-APK**: فایل `Rayan-Garden.apk` (فقط وقتی همه مراحل موفق باشند).
- **Rayan-Garden-Logs**: لاگ تمام مراحل (`01-locate.log` تا `08-build-apk.log`). حتی وقتی اجرا شکست بخورد ساخته و آپلود می‌شود.

همچنین آخرین ۳۰ خط هر لاگ در بخش **Summary** همان اجرا دیده می‌شود.

## ۶) اگر قرمز شد
فایل لاگ مرحله شکست‌خورده را از Artifact `Rayan-Garden-Logs` دانلود کنید و متن آن را بفرستید:
- `01-locate.log`: ZIP پیدا نشد یا معتبر نبود.
- `06-analyze.log`: خطای تحلیل کد. `07-test.log`: تست شکست‌خورده. `08-build-apk.log`: خطای ساخت.

## ۷) وضعیت راستی‌آزمایی
در محیطی که این فایل‌ها آماده شدند Flutter و اینترنت نبود؛ `flutter analyze`، `flutter test` و ساخت APK هرگز اجرا نشده‌اند.
منطق انتخاب ZIP (مرحله Locate) روی ریپوهای نمونه با bash واقعاً آزموده شده است. بقیه مراحل فقط در اولین اجرای GitHub Actions آزموده می‌شوند.
