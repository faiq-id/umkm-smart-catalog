import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    this.initError,
  }) : _injectedAuth = auth;

  final FirebaseAuth? _injectedAuth;
  final String? initError;

  bool get isFirebaseReady =>
      _injectedAuth != null || Firebase.apps.isNotEmpty;

  FirebaseAuth? get _safeAuth {
    if (_injectedAuth != null) return _injectedAuth;
    if (Firebase.apps.isEmpty) return null;
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  Stream<User?> get authStateChanges {
    final auth = _safeAuth;
    if (auth == null) {
      return Stream<User?>.value(null);
    }
    try {
      return auth.authStateChanges();
    } catch (_) {
      return Stream<User?>.value(null);
    }
  }

  User? get currentUser {
    try {
      return _safeAuth?.currentUser;
    } catch (_) {
      return null;
    }
  }

  bool get isSignedIn => currentUser != null;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final auth = _safeAuth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'service-unavailable',
        message: initError ??
            'Layanan autentikasi belum siap. Periksa koneksi internet Anda lalu muat ulang halaman.',
      );
    }
    return auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() async {
    final auth = _safeAuth;
    if (auth != null) {
      await auth.signOut();
    }
  }

  static String friendlyError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'Email atau password salah. Pastikan akun sudah terdaftar di Firebase Authentication.';
        case 'invalid-email':
          return 'Format alamat email tidak valid.';
        case 'user-disabled':
          return 'Akun admin ini sedang dinonaktifkan.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan gagal. Silakan tunggu beberapa menit lalu coba lagi.';
        case 'network-request-failed':
          return 'Koneksi internet terputus. Periksa jaringan Anda lalu coba lagi.';
        case 'unauthorized-domain':
          return 'Domain web ini belum diizinkan di Firebase Authentication → Settings → Authorized domains.';
        case 'service-unavailable':
          return error.message ??
              'Koneksi ke server Firebase gagal dimuat. Coba refresh halaman (Ctrl+Shift+R).';
        default:
          return 'Gagal masuk (${error.code}). Silakan periksa kembali akun Anda.';
      }
    }
    return 'Terjadi kesalahan saat mencoba masuk. Silakan coba lagi.';
  }
}
