# Build the Safety Portal demo APK

This repository includes a GitHub Actions workflow that builds the Android APK in GitHub's cloud runner. No Supabase project is required for the demo build; the app opens in demo mode with sample dashboard data.

## One-time setup
1. Create a GitHub account and a new empty repository named `safety-portal`.
2. Upload the contents of this project ZIP to the repository (keep the `.github` folder; enable showing hidden files if needed).
3. Open the repository's **Actions** tab.
4. Select **Build Safety Portal APK** and press **Run workflow**. Alternatively, pushing to `main` starts the workflow automatically.
5. Wait for the workflow to finish successfully.
6. Open the completed workflow run, scroll to **Artifacts**, and download `safety-portal-demo-apk`.
7. Extract the downloaded artifact ZIP. Install `app-release.apk` on your Android phone. If Android asks, allow installation from that source.

## Notes
- This is a demo APK with sample data. Login, live database, and server-side actions are not implemented yet.
- The build is unsigned for Play Store publication (Android can install a release APK locally, but a production signing setup is still needed for distribution).
- Never add Supabase service-role or database passwords to the mobile app or GitHub repository.
