# Safety Portal — Next setup steps

## 1) Create the Supabase backend
1. Create a Supabase project.
2. Open SQL Editor and run `supabase/schema.sql` in one go.
3. In Authentication > Providers, enable Email.
4. Create the first user from Authentication > Users (or sign up through an auth screen once added).
5. Promote that account to owner from the SQL Editor, replacing the UUID:

```sql
update public.profiles
set role = 'owner', is_active = true
where id = 'PASTE_AUTH_USER_UUID_HERE';
```

The first owner must be bootstrapped by a trusted project owner in the Supabase dashboard. Do not allow public clients to promote themselves.

## 2) Configure the web Control Center
1. Copy `admin-web/config.example.js` to `admin-web/config.js`.
2. Set `SUPABASE_URL` and the anon/publishable key from Project Settings > API.
3. Open `admin-web/index.html` through a local static web server or deploy the folder to a static host. Avoid opening it as a `file://` URL if the browser blocks module/CDN requests.
4. Sign in with the owner/admin account.

The Control Center now supports live module listing, enable/disable, create, XLSX export, and preview + explicitly approved XLSX/CSV upsert. Its account must have owner/admin role. Other dashboard totals are read-only counts.

## 3) Configure Flutter
Run from `flutter_app`:

```bash
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_OR_PUBLISHABLE_KEY
```

Build a test APK:

```bash
flutter build apk --debug \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_OR_PUBLISHABLE_KEY
```

The Flutter screen is still a UI scaffold; authentication and full mobile CRUD screens are the next development phase. Do not distribute it as a production app yet.

## Security notes
- Never put the Supabase `service_role` key in Flutter, browser JavaScript, or any client-side file.
- Keep Row Level Security enabled. Review policies against your actual company roles and workflows before production.
- Use Edge Functions or a trusted server for privileged AI actions, admin invitations, audit log writes, and destructive operations.
- Configure backups, recovery, and audit logging before live company data is loaded.
