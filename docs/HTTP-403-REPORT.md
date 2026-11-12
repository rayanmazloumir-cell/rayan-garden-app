# Verified HTTP 403 report — Rayan Garden Android app

## Verified status

On 12 November 2026, the production API was tested read-only from the build environment. The endpoint itself is reachable:

- `GET https://rayangarden.com/api/services.php` → HTTP 200 JSON
- `GET https://rayangarden.com/api/availability.php?date=2026-11-15&service=wedding` → HTTP 200 JSON
- `GET https://rayangarden.com/api/book.php` → HTTP 405 JSON, which is the expected response for an invalid GET method
- `GET https://rayangarden.com/api/` → HTTP 403 HTML, which is expected directory-access protection and is not the endpoint used by the app

The reported app failure was reproduced exactly when the request used a `User-Agent` containing `RayanGarden`:

```text
User-Agent: RayanGardenApp/1.0 (Android) → HTTP 403 HTML
User-Agent: RayanGardenApp/1.0.1 (Android) → HTTP 403 HTML
User-Agent: RayanGarden/1.0 Android → HTTP 403 HTML
User-Agent: Dart/3.0 (dart:io) → HTTP 200 for services.php
User-Agent: Mozilla/5.0 → HTTP 200 for services.php
No custom User-Agent → HTTP 200 for services.php
```

The same User-Agent behavior was observed for `services.php`, `availability.php`, and `book.php`. This proves the immediate trigger is a server-side Nginx/WAF rule matching the application identifier, not a wrong URL, TLS problem, bad JSON parser, or unavailable endpoint.

## Client-side correction implemented

`lib/data/api/api_client.dart` no longer sends `RayanGardenApp/1.0 (Android)`. It uses the accepted Dart client identity:

```text
Dart/3.0 (dart:io)
```

A regression test verifies that the blocked `RayanGarden` identifier is not sent. Customer-facing error cards no longer expose raw HTML, headers, request URLs, or technical diagnostic output. Users receive a localized recovery message and a retry action.

## Production-server limitation

No SSH, SFTP, hosting-panel, Nginx, WAF, PHP, or database credentials were available in the authorized environment. Therefore, no production server files, logs, PHP code, Nginx rules, WAF rules, or customer data were modified or accessed.

The permanent server-side remediation still needs to be performed by the hosting administrator:

1. Inspect Nginx, ModSecurity/WAF, and hosting-security logs for the matching rule ID.
2. Allow the app’s API requests for `/api/*.php` or permit a documented application identifier.
3. Keep directory listing disabled and preserve the existing firewall protections.
4. Verify GET services, GET availability, and POST book requests from an Android network after the rule change.

Do not disable the WAF globally and do not whitelist an entire IP range without reviewing the matching rule.

## Live API observations requiring backend-owner confirmation

The live service response currently reports:

- `wedding`: duration 180 minutes
- `formality`: duration 180 minutes
- `kids`: duration 60 minutes
- `family`: duration 60 minutes
- `cafe`: duration 120 minutes
- `gateway`: false
- price and deposit: zero for the observed services

The app preserves the server’s duration and payment values rather than silently overriding production booking rules. The requested 120-minute bride-and-groom duration and a real deposit payment workflow require a backend/API owner decision and cannot be safely fabricated in the Android client.
