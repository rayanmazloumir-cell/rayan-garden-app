#!/usr/bin/env python3
"""Patch the Flutter-generated Android project for Rayan Garden.

Usage: python3 tool/patch_android.py <project_dir>
Idempotent. Only touches android/ (never the site, PHP or the logo asset).
"""
import re
import shutil
import sys
from pathlib import Path

root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
manifest = root / "android/app/src/main/AndroidManifest.xml"
if not manifest.exists():
    sys.exit(f"AndroidManifest.xml not found: {manifest}")

xml = manifest.read_text(encoding="utf-8")

# 1) App name
xml = re.sub(r'android:label="[^"]*"', 'android:label="Rayan Garden"', xml, count=1)

# 2) INTERNET permission (missing from the release manifest of a new project)
if "android.permission.INTERNET" not in xml:
    xml = re.sub(
        r"(<manifest[^>]*>)",
        r'\1\n    <uses-permission android:name="android.permission.INTERNET"/>',
        xml,
        count=1,
    )

# 3) Package visibility for geo:, https:, tel: and mailto: links (url_launcher)
QUERIES = """        <intent>
            <action android:name="android.intent.action.VIEW"/>
            <data android:scheme="geo"/>
        </intent>
        <intent>
            <action android:name="android.intent.action.VIEW"/>
            <data android:scheme="https"/>
        </intent>
        <intent>
            <action android:name="android.intent.action.DIAL"/>
            <data android:scheme="tel"/>
        </intent>
        <intent>
            <action android:name="android.intent.action.SENDTO"/>
            <data android:scheme="mailto"/>
        </intent>
"""
if 'android:scheme="geo"' not in xml:
    if "<queries>" in xml:
        xml = xml.replace("</queries>", QUERIES + "    </queries>", 1)
    else:
        xml = xml.replace("</manifest>", "    <queries>\n" + QUERIES + "    </queries>\n</manifest>", 1)

manifest.write_text(xml, encoding="utf-8")
print("Manifest patched:", manifest)

# 4) Launcher icons (resized copies; the original logo asset is untouched)
src = root / "android_overrides/res"
dst = root / "android/app/src/main/res"
if src.is_dir():
    for f in src.rglob("*.png"):
        target = dst / f.relative_to(src)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(f, target)
    print("Launcher icons copied")
