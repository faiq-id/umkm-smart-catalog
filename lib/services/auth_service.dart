import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  bool get isSignedIn => _auth.currentUser != null;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() => _auth.signOut();

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
        default:
          return 'Gagal masuk (${error.code}). Silakan periksa kembali akun Anda.';
      }
    }
    return 'Terjadi kesalahan saat mencoba masuk. Silakan coba lagi.';
  }
}

