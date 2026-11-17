# Safety Portal — bilingual mobile MVP + web admin starter

This starter contains an Arabic/English Flutter Android app, a static web admin prototype, and a Supabase SQL schema.

## Current mobile demo
The Flutter app can be built as a demo APK without Supabase credentials. It shows a bilingual dashboard, application modules, sample requests, and a profile/language screen. It uses sample data and does not yet provide real authentication or database operations.

## Build the APK
The repository includes `.github/workflows/build-android-apk.yml` to build the APK in GitHub Actions. Follow `BUILD_APK_ON_GITHUB.md`.

## Supabase setup (later phase)
1. Create a Supabase project.
2. Run `supabase/schema.sql` in the SQL Editor.
3. Configure Project URL and publishable/anon key when live integration is implemented.
4. Never put a service-role key in the app or browser.

## Web admin
Open `admin-web/index.html` in a browser. It is a prototype and is not yet connected to Supabase. Import is preview-only; CSV export currently produces a starter template.

## Production gaps
Authentication, role enforcement, server-side validation, full import/export, audit workflow, secure AI change approvals, backups, and production signing/deployment remain to be implemented and tested before operational use.
