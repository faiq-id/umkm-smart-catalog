import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Konfigurasi Firebase untuk aplikasi ini.
///
/// Saat mendeploy untuk klien baru, cukup ganti nilai di bawah ini dengan
/// `firebaseConfig` dari project Firebase milik klien tersebut.
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
    apiKey: 'AIzaSyA3mBynXfDQs0Uilfa8P7ZuoIyEZDTPhUw',
    appId: '1:897358440406:web:4ef0433b8e8c467bc52677',
    messagingSenderId: '897358440406',
    projectId: 'web-umkm-demo',
    authDomain: 'web-umkm-demo.firebaseapp.com',
    storageBucket: 'web-umkm-demo.firebasestorage.app',
    measurementId: 'G-HZ017MD39V',
  );
}

