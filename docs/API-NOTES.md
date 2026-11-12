# API integration notes

Base URL: `https://rayangarden.com/api/`

## Documented contract (used by the app)
| Call | Notes |
|------|-------|
| `GET services.php` | Service list. Service ids are taken from this response, never guessed. |
| `GET availability.php?date=YYYY-MM-DD&service=<id>` | Date is Gregorian. |
| `POST book.php` (JSON) | Fields: `service, date, time, name, phone, notes, lang, website, elapsed` |

Rules enforced in the app:
- `website` is always sent empty (honeypot).
- `elapsed` is the real time since the customer-details form opened and is always >= 2500 ms.
- Dates shown to the customer are Jalali; dates sent to the API are Gregorian `YYYY-MM-DD`.
- The website/back-end owns ALL booking rules (hours, 30-min step, 60-min lead time, conflicts, durations, prices, deposits, active services, 24 h holding). The app only shows what the API returns; the calendar's 120-day scroll limit is the single mirrored UI value (see docs/COMPLIANCE-REPORT.md).
- A booking is shown as successful ONLY if the server returns a `ref`. Server errors are shown to the user.
- Not used yet: `track.php` (contract not confirmed).

## Confirmed by the site owner
- `services.php` returns `{ ok, services: [ { id, dur, ... } ] }`. `dur` = duration in minutes (read first).
  The service NAME key was not stated: the parser tries name/title/label/name_fa/... and, if none exists,
  shows the id instead of dropping the service.
- `ok:false` in any response is shown as an error (server message if present).

## Confirmed by browser tests (site owner, 2026-11-11)
- `GET /api/services.php` -> HTTP 200 with `ok:true`, Persian + English names, `dur`, price and deposit. The live response observed `wedding=180`, `formality=180`, `kids=60`, `family=60`, `cafe=120`, with `gateway:false` and zero price/deposit values.
- `GET /api/availability.php?date=2026-11-15&service=wedding` -> HTTP 200 with `ok:true`, `date`, `duration`, and `slots` from 06:00 to 20:00 every 30 minutes; each slot's state is the `free` field.
- HTTP 403 is caused by a production Nginx/WAF rule matching `RayanGarden` in the User-Agent. The app now sends the accepted Dart client identity and includes a regression test.

## NOT documented -> must be confirmed (nothing was guessed silently)
The exact JSON shape of these responses was not available. The parsers
(`lib/data/api/response_parsers.dart`) are tolerant and accept:

1. `services.php`: a JSON list, or an object containing the list under `services`, `data`, `items` or `result`.
   Each item needs an id (`id` / `service_id` / `slug` / `key` / `code`) and a name (`name` / `title` / `label`).
   Optional: duration (`duration` / `minutes` / `duration_min`), description (`description` / `desc`), English name (`name_en`).
2. `availability.php` (structure still NOT verified): the parser first looks under `slots/times/available/free/...`, then accepts ANY list in the response that really contains `HH:MM` values. It accepts a list of `"HH:MM"` strings or objects with `time` (and optional `available`),
   under `slots` / `times` / `available` / `data`, or a `{"06:00": true}` map.
3. `book.php`: success = a `ref` field (top level or inside `data`) and no `ok/success: false`;
   `status` is shown as received; any key containing `pay` or `deposit` is displayed as payment info;
   an error message is read from `error` / `message` / `msg`.

If a real response does not match, the app shows a friendly localized error and retry action without exposing
raw response bodies or server headers to customers. To confirm the live contract, open these read-only URLs:
- `https://rayangarden.com/api/services.php`
- `https://rayangarden.com/api/availability.php?date=<YYYY-MM-DD>&service=<id from the first link>`

There is NO local override for server duration, price, deposit or active state: those values come from the API. The local catalog supplies only bilingual presentation labels, descriptions, aliases, and imagery when the API provides an incomplete label.
