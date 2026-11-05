import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Contoh template konfigurasi Firebase.
///
/// Salin file ini menjadi `lib/config/firebase_options.dart` (yang sudah masuk
/// ke dalam `.gitignore`), lalu isi dengan konfigurasi dari Firebase Console.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return web;
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions belum dikonfigurasi untuk platform fuchsia.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'GANTI_DENGAN_FIREBASE_API_KEY',
    appId: 'GANTI_DENGAN_FIREBASE_APP_ID',
    messagingSenderId: 'GANTI_DENGAN_MESSAGING_SENDER_ID',
    projectId: 'GANTI_DENGAN_PROJECT_ID',
    authDomain: 'GANTI_DENGAN_PROJECT_ID.firebaseapp.com',
    storageBucket: 'GANTI_DENGAN_PROJECT_ID.firebasestorage.app',
    measurementId: 'GANTI_DENGAN_MEASUREMENT_ID',
  );
}

