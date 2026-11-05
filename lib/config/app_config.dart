/// Konfigurasi utama template multi-klien IQ WebDev.
///
/// Saat mendeploy untuk klien nyata:
/// 1. Ganti `firebase_options.dart` dengan project Firebase milik klien.
/// 2. Ubah [isDemoShowcase] menjadi `false` dan sesuaikan [defaultStoreId].
/// 3. Pastikan [allowGuestAdminPreview] bernilai `false` agar hanya pemilik
///    resmi yang bisa masuk ke Panel Admin.
class AppConfig {
  const AppConfig._();

  /// `true` untuk portofolio demo 3 tema (Bakery, Coffee, Pet Shop).
  /// Ubah ke `false` saat dipakai untuk 1 toko klien nyata.
  static const bool isDemoShowcase = true;

  /// ID toko utama yang dimuat pertama kali (`bakery`, `coffee`, atau `pet`).
  static const String defaultStoreId = 'bakery';

  /// Mengizinkan pengunjung demo mengintip UI Panel Admin dalam mode simulasi
  /// lokal (tanpa akses tulis ke database server).
  /// Otomatis nonaktif bila [isDemoShowcase] bernilai `false`.
  static const bool allowGuestAdminPreview = true;

  static bool get canUseGuestPreview =>
      isDemoShowcase && allowGuestAdminPreview;
}

