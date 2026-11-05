/// Konfigurasi utama template multi-klien IQ WebDev.
///
/// Saat mendeploy untuk klien nyata:
/// 1. Ganti `firebase_options.dart` dengan project Firebase milik klien.
/// 2. Ubah [isDemoShowcase] menjadi `false` dan sesuaikan [defaultStoreId].
/// 3. Pastikan [allowGuestAdminPreview] bernilai `false` agar hanya pemilik
///    resmi yang bisa masuk ke Panel Admin.
/// 4. Biarkan [enableOrdersAndReports] bernilai `false` untuk Paket Standar,
///    atau ubah menjadi `true` jika klien mengambil add-on Pesanan & Laporan.
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

  /// Menampilkan tab "Pesanan" & "Laporan Penjualan" di Panel Admin.
  /// - `false` (Default Paket Standar): disembunyikan agar fokus pada kelola
  ///   katalog, stok cepat, status buka/tutup, dan banner promo nyata.
  /// - `true` (Add-on / Paket Lengkap): menampilkan modul pesanan & laporan.
  static const bool enableOrdersAndReports = false;

  static bool get canUseGuestPreview =>
      isDemoShowcase && allowGuestAdminPreview;
}
