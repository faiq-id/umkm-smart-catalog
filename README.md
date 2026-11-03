# 🥐 UMKM Smart Catalog — Artisanal Storefront & Business Suite

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State-Bloc-blueviolet)](https://bloclibrary.dev)
[![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Android%20%7C%20iOS-brightgreen)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A modern, editorial-grade **Flutter Web & Mobile** commerce platform designed for artisanal MSMEs (UMKM). Featuring multi-theme interactive catalogs, frictionless WhatsApp checkout, an editorial company profile showcase, and an integrated admin command center.

---

## 🌟 Fitur Utama (Core Highlights)

### 1. 🛍️ Etalase Katalog Interaktif & Multi-Tema
- **Dukungan 3 Karakter Bisnis UMKM**:
  - 🥐 **Bakery & Deli**: *Grain & Butter Artisan Deli*
  - ☕ **Specialty Coffee**: *Micro-Roastery & Slow Bar*
  - 🐾 **Pet Care**: *Pet Hotel, Spa, & Gourmet Treats*
- **Sistem Varian Ringkas**: Pemilihan suhu (Hot/Iced), ukuran cup, tingkat manis, dan varian layanan tanpa alur modal bertingkat yang rumit.
- **Pencarian Cepat & Filter Kategori**: Navigasi real-time berdasarkan kategori dan kata kunci pencarian.

### 2. ⚡ Frictionless WhatsApp Direct Checkout
- Pengunjung tidak perlu registrasi atau login akun yang rumit.
- Sistem otomatis menghitung diskon promo harian, opsi pemesanan (*Pickup / Dine-in / Delivery*), dan merangkum pesanan secara rapi ke format pesan WhatsApp siap kirim.

### 3. 🏛️ Dedicated Editorial Company Profile
- Desain tipografi elegan (*Newsreader Serif* & *Plus Jakarta Sans*).
- Menampilkan filosofi merek, kurasi 4 pilar kualitas, galeri suasana atelier, dan ulasan kurator kuliner.
- **Walk-In Welcome Section**: Panduan kunjungan tanpa reservasi yang ramah, dilengkapi info fasilitas (Wi-Fi kencang, stopkontak kerja, area parkir, jadwal keluar oven), rute navigasi Google Maps instan, serta integrasi concierge WhatsApp.

### 4. 📊 Command Center Panel Admin
- Pengaturan ketersediaan stok *live* (Tersedia / Habis Terjual) dalam satu klik.
- Pengelolaan katalog produk lengkap (*Create, Read, Update, Delete*).
- Ringkasan statistik performa real-time (Total Produk, Stok Aktif, Habis Terjual, dan Jumlah Pesanan Masuk).
- Tombol pratinjau cepat langsung ke etalase publik.

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
   git clone https://github.com/USERNAME-ANDA/umkm-smart-catalog.git
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
