# Flutter Supabase Gmail Login App (TopAi24.com assignment)

This is a Flutter app where users can login with Gmail. After login, it shows their email and some info from Google. Then they can fill out details like address, phone, age etc. and it saves to Supabase.

There’s a home screen for entering info, a profile screen to logout, and a delete screen to remove the info (just clears personal data like address, phone etc., not the whole account). When you login again, the info comes back if it was saved.



https://github.com/user-attachments/assets/79941e7d-2722-46f4-8123-bf465c021035



## Download APK

You can download the APK from the releases section, direct link: [download APK](https://github.com/imhemish/fl-supa-gmail/releases/download/0.1/app-release.apk)

## Configuration

Rename the env.dart.example in lib filder to env.dart (ignored by git) and fill these:

```
const String supabaseUrl = 'YOUR_SUPABASE_URL';
const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
const webClientId = 'my-web.apps.googleusercontent.com';
const androidClientId = 'my-android.apps.googleusercontent.com';
```

You get the Supabase keys from the Supabase project > Settings > API.
Google IDs are from Google Cloud Console (OAuth credentials).

## Project Structure (inside lib)

- main.dart - starting point
- app.dart - theme and app layout
- env.dart.example - for putting your API keys (copy to env.dart)

### folders:

- config - theme, constants, routes
- data - models, providers, and supabase stuff
- presentation - UI screens and widgets
