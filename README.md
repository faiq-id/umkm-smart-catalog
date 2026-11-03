# 🥐 UMKM Smart Catalog — Artisanal Storefront & Business Suite

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State-Bloc-blueviolet)](https://bloclibrary.dev)
[![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Android%20%7C%20iOS-brightgreen)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Live Demo](https://img.shields.io/badge/Live%20Demo-Online%20Preview-success?logo=google-chrome&logoColor=white)](https://faiq-id.github.io/umkm-smart-catalog/)

> 🌐 **Live Demo Website:** [https://faiq-id.github.io/umkm-smart-catalog/](https://faiq-id.github.io/umkm-smart-catalog/)

A modern, editorial-grade **Flutter Web & Mobile** commerce platform designed for artisanal MSMEs (UMKM). Featuring multi-theme interactive catalogs, frictionless WhatsApp checkout, an editorial company profile showcase, and an integrated admin command center.

---

## 🌟 Fitur Utama (Core Highlights)

### 1. 🛍️ Etalase Katalog Interaktif & Multi-Tema
- **Dukungan 3 Karakter Bisnis UMKM**:
  - 🥐 **Bakery & Deli**: *Grain & Butter Artisan Deli*
  - ☕ **Specialty Coffee**: *Micro-Roastery & Slow Bar*
  - 🐾 **Pet Care**: *Pet Hotel, Spa, & Gourmet Treats*
- **Sistem Varian Ringkas**: Pemilihan suhu (Hot/Iced), ukuran cup, tingkat manis, dan varian layanan tanpa alur modal bertingkat yang rumit.
- **Pencarian Cepat & Filter Kategori**: Filter berdasarkan kategori dan kata kunci pencarian.

### 2. ⚡ Checkout via WhatsApp
- Pengunjung tidak perlu registrasi atau login akun.
- Keranjang menghitung diskon promo dan opsi pemesanan (*Pesan Antar / Ambil di Gerai*), lalu menyusun pesanan menjadi pesan WhatsApp yang sudah terisi. Pelanggan tinggal menekan kirim.
- Tersedia pilihan pesan antar & ambil di gerai. Ongkos kirim dan jadwal dikonfirmasi oleh tim gerai lewat WhatsApp. Belum ada integrasi API kurir (GoSend/GrabExpress) maupun penerimaan pesanan otomatis.

### 3. 🏛️ Dedicated Editorial Company Profile
- Desain tipografi elegan (*Newsreader Serif* & *Plus Jakarta Sans*).
- Menampilkan filosofi merek, kurasi 4 pilar kualitas, galeri suasana atelier, dan ulasan kurator kuliner.
- **Walk-In Welcome Section**: Panduan kunjungan tanpa reservasi, dilengkapi info fasilitas, tautan petunjuk arah Google Maps, serta tombol chat WhatsApp.

### 4. 📊 Panel Admin (Pratinjau)
- Pengaturan ketersediaan stok (Tersedia / Habis Terjual) dalam satu klik.
- Pengelolaan katalog produk (*Create, Read, Update, Delete*).
- Ringkasan statistik (Total Produk, Stok Aktif, Habis Terjual, dan Jumlah Pesanan).
- Tombol pratinjau cepat langsung ke etalase publik.
- **Catatan:** data admin tersimpan di sesi browser saja dan belum memakai backend atau login. Penyimpanan permanen dan autentikasi perlu ditambahkan untuk penggunaan produksi.

### 5. 🖼️ Catatan Aset Gambar
- Foto produk dan banner pada proyek ini adalah **gambar ilustrasi/contoh** (sebagian dibuat dengan AI, sebagian dimuat dari URL eksternal) dan hanya untuk keperluan portofolio.
- Untuk penggunaan komersial, ganti dengan foto milik klien atau foto berlisensi yang jelas haknya.

---

## 📐 Arsitektur & Teknologi

- **Framework**: Flutter 3 (Web & Mobile Responsive)
- **Bahasa**: Dart 3 (Null Safety)
- **State Management**: `flutter_bloc` & BLoC pattern
- **Immutability & Models**: `freezed` & `freezed_annotation`
- **Typography & Styling**: `google_fonts` (Newsreader & Plus Jakarta Sans)
- **Device Adaptation**: Custom Breakpoint Engine (`Bp`) untuk pengalaman optimal di layar Ponsel, Tablet, hingga Desktop Layar Lebar.

---

## 🚀 Menjalankan Proyek Secara Lokal

### Prasyarat
- Flutter SDK (versi 3.22 atau lebih baru)
- Browser Chrome / Edge (untuk Flutter Web)

### Langkah Instalasi

1. **Clone repositori ini**:
   ```bash
   git clone https://github.com/faiq-id/umkm-smart-catalog.git
   cd umkm-smart-catalog
   ```

2. **Unduh dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi (Mode Web)**:
   ```bash
   flutter run -d chrome
   ```

4. **Build untuk Produksi**:
   ```bash
   flutter build web --release
   ```

---

## 📂 Struktur Direktori

```text
lib/
├── data/       # Data profil toko, katalog menu, dan preset tema UMKM
├── models/     # Model data produk, keranjang, varian, dan promo
├── pages/      # Halaman utama (StorePage, ProfilePage, AdminPage)
├── sheets/     # Bottom sheets keranjang dan modal interaktif
├── ui/         # Design token, palet warna, tipografi, dan breakpoint responsif
├── utils/      # Format mata uang Rupiah dan helper teks
└── widgets/    # Komponen UI modular (CartBar, Image loader, Card produk)
```

---

## 📄 Lisensi
Didistribusikan di bawah lisensi MIT. Silakan gunakan untuk keperluan pembelajaran dan portofolio Anda.
