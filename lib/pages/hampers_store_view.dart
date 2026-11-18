import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_event.dart';
import '../bloc/store_state.dart';
import '../models/models.dart';
import '../ui/common.dart';
import '../utils/format.dart';
import '../widgets/cart_bar.dart';

enum HamperSeason { newYear, eid }

// ---------------------------------------------------------------------------
// Colors & Typography — Maison Cadeaux Atelier (New Year & Idul Fitri Swap)
// Sampel 1: Soft Porcelain White (#F7F4EE) & Warm Alabaster (#ECE7DF)
// ---------------------------------------------------------------------------
const _kPrimary = Color(0xFF0B1220);
const _kPrimaryDark = Color(0xFF060A12);
const _kPrimaryContainer = Color(0xFF141E30);

// Royal Emerald Palette for Idul Fitri 1448 H Edition
const _kEidPrimary = Color(0xFF072219);
const _kEidPrimaryDark = Color(0xFF04140E);
const _kEidPrimaryContainer = Color(0xFF0E3427);
const _kSecondary = Color(0xFF926E3E);
const _kTertiaryFixed = Color(0xFFE3BE80);
const _kGoldAccent = Color(0xFFDAB880);
const _kGoldDark = Color(0xFF926E3E);
const _kSurface = Color(0xFFECE7DF);
const _kSurfaceLow = Color(0xFFE5DFD5);
const _kCardSurface = Color(0xFFF7F4EE);
const _kCardInner = Color(0xFFEFEAE0);
const _kCardBorder = Color(0xFFD8C8AE);
const _kCardTextPrimary = Color(0xFF181E2A);
const _kCardTextMuted = Color(0xFF444850);
const _kBadgeGlass = Color(0xF5F2ECE1);
const _kBadgeText = Color(0xFF181E2A);
const _kNavSurface = Color(0xFFF3EFE8);
const _kSurfaceHigh = Color(0xFFDAD2C4);
const _kOnSurface = Color(0xFF181E2A);
const _kOnSurfaceVariant = Color(0xFF4A505A);
const _kOutlineVariant = Color(0xFFCBC1B0);

final String? _kCormorantFamily = GoogleFonts.cormorantGaramond().fontFamily;
final String? _kJakartaFamily = GoogleFonts.plusJakartaSans().fontFamily;

const List<BoxShadow> _kCardShadow = [
  BoxShadow(
    color: Color(0x0F0B1220),
    blurRadius: 16,
    offset: Offset(0, 6),
  ),
];

TextStyle _cormorant(
  double size, {
  FontWeight weight = FontWeight.w500,
  Color color = _kPrimary,
  double? height,
  double? spacing,
  FontStyle style = FontStyle.normal,
}) =>
    TextStyle(
      fontFamily: _kCormorantFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: spacing,
      fontStyle: style,
    );

TextStyle _jakarta(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color color = _kOnSurface,
  double? height,
  double? spacing,
  FontStyle style = FontStyle.normal,
  TextDecoration? decoration,
}) =>
    TextStyle(
      fontFamily: _kJakartaFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: spacing,
      fontStyle: style,
      decoration: decoration,
    );

String _formatHotline(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty || digits == '6281198247700') {
    return '+62 811-9824-7700';
  }
  if (digits.startsWith('62') && digits.length >= 11) {
    final rest = digits.substring(2);
    if (rest.length >= 9) {
      return '+62 ${rest.substring(0, 3)}-${rest.substring(3, 7)}-${rest.substring(7)}';
    }
  }
  return '+$digits';
}

/// Builds a fast single-pass multi-column grid (no IntrinsicHeight overhead)
/// with RepaintBoundary per cell for 60fps/120fps scrolling.
Widget _buildEqualHeightGrid({
  required List<Widget> children,
  required int columns,
  double spacing = 24,
  double runSpacing = 24,
}) {
  if (children.isEmpty) return const SizedBox.shrink();
  if (columns <= 1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: runSpacing),
          RepaintBoundary(child: children[i]),
        ],
      ],
    );
  }

  final rows = <Widget>[];
  for (int i = 0; i < children.length; i += columns) {
    final rowItems = <Widget>[];
    for (int j = 0; j < columns; j++) {
      if (j > 0) rowItems.add(SizedBox(width: spacing));
      final idx = i + j;
      if (idx < children.length) {
        rowItems.add(
          Expanded(
            child: RepaintBoundary(child: children[idx]),
          ),
        );
      } else {
        rowItems.add(const Expanded(child: SizedBox.shrink()));
      }
    }
    if (rows.isNotEmpty) rows.add(SizedBox(height: runSpacing));
    rows.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rowItems,
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: rows,
  );
}

// ---------------------------------------------------------------------------
// Extra metadata per Hamper ID (curated items, sub-badge, full material spec)
// ---------------------------------------------------------------------------
class _HamperSpec {
  const _HamperSpec({
    required this.subBadge,
    required this.sashLabel,
    required this.dimensions,
    required this.shortMaterial,
    required this.fullMaterial,
    required this.items,
  });

  final String subBadge;
  final String sashLabel;
  final String dimensions;
  final String shortMaterial;
  final String fullMaterial;
  final List<String> items;
}

const Map<String, _HamperSpec> _kHamperSpecs = {
  'p1': _HamperSpec(
    subBadge: 'Box Kayu Jati & Velvet Hitam',
    sashLabel: 'VIP',
    dimensions: '42 x 32 x 18 cm',
    shortMaterial: 'Solid Teak Wood 14mm',
    fullMaterial:
        'Solid Teak Wood 14mm dengan Finishing Velvet Midnight Navy & Plat Kuningan Grafir Tahun Baru 2027',
    items: [
      '1x Kopi Luwak Liar Gayo & Geisha Reserve Gold Tin (250g)',
      '2x Cangkir Espresso Porselen Fine Bone China Emas 24K',
      '1x Valrhona Gold Artisan Pralines Box (12 Pcs)',
      '1x Royal Manuka Honey UMF 20+ (250g) & Kartu Foil Emas 2027',
    ],
  ),
  'p2': _HamperSpec(
    subBadge: 'Midnight Hardbox & Gold Buckle',
    sashLabel: 'VIP',
    dimensions: '38 x 28 x 15 cm',
    shortMaterial: 'Rigid 3.5mm Greyboard',
    fullMaterial:
        'Hardbox Greyboard 3.5mm Lapis Linen Champagne Gold dengan Kunci Klip Kuningan & Pita Emas 2027',
    items: [
      '1x Single Origin Mandheling Gold Roast Beans Canister (250g)',
      '1x Brass Pour-Over V60 Dripper & Server Kaca Borosilikat',
      '1x Artisan French Butter Cookies Gold Tin 300g',
      '1x Tin Imperial Oolong Loose Leaf Tea & Hangtag 2027',
    ],
  ),
  'p3': _HamperSpec(
    subBadge: 'Pine Wood & Akrilik Grafir 2027',
    sashLabel: 'Best Seller',
    dimensions: '34 x 24 x 12 cm',
    shortMaterial: 'Pinewood 10mm + Akrilik',
    fullMaterial:
        'Solid Pine Wood dengan Tutup Sliding Akrilik Transparan Grafir Laser Logo PT & Tahun Baru 2027',
    items: [
      '1x Belgian Dark Chocolate Truffle Cookies 220g',
      '1x Tin White Peony Artisan Tea & Clover Honey 210g',
      '1x Executive Leather Notebook 2027 Grafir Emas',
      '1x Kartu Ucapan Foil Emas Custom Kop PT',
    ],
  ),
  'p4': _HamperSpec(
    subBadge: 'Textured Matte & Gold Wax Seal',
    sashLabel: 'Favorit',
    dimensions: '30 x 22 x 10 cm',
    shortMaterial: 'Doff Rigid Greyboard 3mm',
    fullMaterial:
        'Rigid Hardbox Doff Midnight Black dengan Custom Emboss Logo Emas & Segel Lilin Emas (Gold Wax Seal)',
    items: [
      '1x Single Origin Arabica Gayo Gold Tin 200g',
      '1x Roasted Almond & Vanilla Bean Biscotti 180g',
      '1x Matte Black Ceramic Mug with Gold Rim',
      '1x Hand-stamped Gold Wax Seal Initial Card 2027',
    ],
  ),
  'p5': _HamperSpec(
    subBadge: 'Dual Gold Tin & Navy Sleeve',
    sashLabel: 'Populer',
    dimensions: '26 x 18 x 9 cm',
    shortMaterial: 'Gold Foil Navy Sleeve',
    fullMaterial:
        'Tin Canister Brushed Gold Food-Grade Ganda dengan Kemasan Sleeve Luar Midnight Navy Hot Foil Gold 350gsm',
    items: [
      '1x Tin Canister French Butter Shortbread 150g',
      '1x Tin Canister Belgian Dark Chocochip Cookies 150g',
      '1x Custom Sleeve Full Color Logo Korporat',
      '1x Hangtag Ucapan Selamat Tahun Baru 2027',
    ],
  ),
  // --- KOLEKSI IDUL FITRI 1448 H / 2027 ---
  'eid_p1': _HamperSpec(
    subBadge: 'Box Kayu Jati & Velvet Emerald',
    sashLabel: 'VIP',
    dimensions: '42 x 32 x 18 cm',
    shortMaterial: 'Solid Teak Wood 14mm',
    fullMaterial:
        'Solid Teak Wood 14mm dengan Interior Velvet Royal Emerald & Plat Kuningan Grafir Idul Fitri 1448 H',
    items: [
      '1x Kurma Royal Ajwa & Medjool VIP Gold Tin (350g)',
      '1x Lapis Legit Prune Wisman Signature Whole Box',
      '1x Kopi Luwak Gayo Gold Tin & Madu Yaman Sidr (250g)',
      '2x Cangkir Porselen Emas 24K & Kartu Lebaran Foil Emas',
    ],
  ),
  'eid_p2': _HamperSpec(
    subBadge: 'Emerald Hardbox & Brass Buckle',
    sashLabel: 'VIP',
    dimensions: '38 x 28 x 15 cm',
    shortMaterial: 'Rigid 3.5mm Linen Box',
    fullMaterial:
        'Hardbox Greyboard 3.5mm Lapis Linen Emerald & Champagne Gold dengan Kunci Kuningan & Pita Satin Raya',
    items: [
      '1x Nastar Wisman & Kastengel Keju Edam Gold Tin (600g)',
      '1x Kurma Medjool Palestine Jumbo Selection (300g)',
      '1x Tin Imperial Moroccan Mint Tea & Sajadah Travel Sutra',
      '1x Kartu Ucapan Idul Fitri 1448 H & Hangtag Logo PT',
    ],
  ),
  'eid_p3': _HamperSpec(
    subBadge: 'Pine Wood & Akrilik Grafir Raya',
    sashLabel: 'Best Seller',
    dimensions: '34 x 24 x 12 cm',
    shortMaterial: 'Pinewood 10mm + Akrilik',
    fullMaterial:
        'Solid Pine Wood dengan Tutup Sliding Akrilik Grafir Laser Kaligrafi Idul Fitri 1448 H & Logo Perusahaan',
    items: [
      '1x Lapis Legit Spesial Wisman Artisan Half-Loaf',
      '1x Tin Kastengel Keju Tua & Lidah Kucing Wisman (250g)',
      '1x Single Origin Arabica Gayo Gold Tin (200g)',
      '1x Kartu Ucapan Idul Fitri Foil Emas Custom Kop PT',
    ],
  ),
  'eid_p4': _HamperSpec(
    subBadge: 'Emerald Matte & Gold Wax Seal',
    sashLabel: 'Favorit',
    dimensions: '30 x 22 x 10 cm',
    shortMaterial: 'Doff Rigid Emerald 3mm',
    fullMaterial:
        'Rigid Hardbox Doff Royal Emerald dengan Emboss Logo Emas & Segel Lilin Emas (Gold Wax Seal) Idul Fitri',
    items: [
      '1x Tin Nastar Klasik Wisman Golden Pineapple (250g)',
      '1x Kurma Sukkari Royal Al-Qassim Gold Box (250g)',
      '1x Emerald Ceramic Mug with 24K Gold Rim',
      '1x Amplop & Kartu Lebaran Segel Lilin Emas (Wax Seal)',
    ],
  ),
  'eid_p5': _HamperSpec(
    subBadge: 'Parcel Biskuit Kaleng & Sirup Raya',
    sashLabel: 'Paket Praktis',
    dimensions: '32 x 24 x 14 cm',
    shortMaterial: 'Festive Parcel Box + Handle',
    fullMaterial:
        'Box Parcel Lebaran Praktis Corrugated E-Flute Lapis Art Carton Emerald & Gold Foil (Cocok untuk THR Karyawan & Pembagian Massal)',
    items: [
      '1x Kaleng Besar Royal Butter Cookies Assorted (450g)',
      '2x Botol Sirup Spesial Lebaran (Cocopandan & Jeruk 750ml)',
      '1x Kotak Kurma Pilihan Spesial Raya (250g)',
      '1x Kaleng Gold Wafer Roll Cokelat & Kartu Ucapan Lebaran',
    ],
  ),
  'eid_p6': _HamperSpec(
    subBadge: 'Dual Gold Tin & Emerald Sleeve',
    sashLabel: 'Populer',
    dimensions: '26 x 18 x 9 cm',
    shortMaterial: 'Gold Foil Emerald Sleeve',
    fullMaterial:
        'Tin Canister Brushed Gold Food-Grade Ganda dengan Kemasan Sleeve Luar Royal Emerald Hot Foil Gold 350gsm',
    items: [
      '1x Tin Canister Nastar Mentega Wisman (180g)',
      '1x Tin Canister Putri Salju & Kacang Mede (180g)',
      '1x Custom Sleeve Emerald Full Color Logo Korporat',
      '1x Hangtag Ucapan Selamat Idul Fitri 1448 H',
    ],
  ),
};

const List<Product> _kEidProducts = [
  Product(
    id: 'eid_p1',
    name: 'The Sultanate Royal Raya Reserve',
    desc:
        'Mahakarya bingkisan VVIP Idul Fitri dalam peti kayu jati solid berbalut beludru zamrud, menyajikan Lapis Legit Wisman, Kurma Ajwa VIP, dan Kopi Luwak.',
    price: 2650000,
    originalPrice: 2950000,
    category: 'vip',
    emoji: '🕌',
    image: 'assets/images/eid_hamper_vip1.jpg',
    badge: 'VVIP Raya',
    rating: 5.0,
    reviews: 84,
    featureLabel: '42 x 32 x 18 cm • Solid Teak Wood 14mm',
    featureIcon: Icons.workspace_premium_outlined,
  ),
  Product(
    id: 'eid_p2',
    name: 'Al-Mubarak Golden Lantern Hardbox',
    desc:
        'Hardbox linen zamrud dan emas beraksen kunci kuningan untuk jajaran direksi & komisaris, lengkap dengan Nastar Edam Gold Tin dan Kurma Medjool.',
    price: 1850000,
    originalPrice: 2100000,
    category: 'vip',
    emoji: '🌙',
    image: 'assets/images/eid_hamper_vip2.jpg',
    badge: 'Best Seller VIP',
    rating: 4.98,
    reviews: 142,
    featureLabel: '38 x 28 x 15 cm • Rigid 3.5mm Linen Box',
    featureIcon: Icons.card_giftcard_rounded,
  ),
  Product(
    id: 'eid_p3',
    name: 'Raya Heritage & Lapis Legit Box',
    desc:
        'Kotak kayu pinus dengan tutup akrilik grafir laser kaligrafi Idul Fitri dan logo perusahaan, berisi Lapis Legit Wisman, Kastengel, & Kopi Gayo.',
    price: 850000,
    originalPrice: 950000,
    category: 'standard',
    emoji: '🎁',
    image: 'assets/images/eid_hamper_std1.jpg',
    badge: 'Favorit B2B',
    rating: 4.96,
    reviews: 215,
    featureLabel: '34 x 24 x 12 cm • Pinewood 10mm + Akrilik',
    featureIcon: Icons.inventory_2_outlined,
  ),
  Product(
    id: 'eid_p4',
    name: 'Noor Kareem Velvet & Wax Seal',
    desc:
        'Apresiasi hangat untuk klien dan manajemen menengah dengan segel lilin emas (Gold Wax Seal), Nastar Wisman, Kurma Sukkari, dan Mug Rim Emas.',
    price: 620000,
    category: 'standard',
    emoji: '✨',
    image: 'assets/images/eid_hamper_std2.jpg',
    badge: 'Corporate Standard',
    rating: 4.95,
    reviews: 178,
    featureLabel: '30 x 22 x 10 cm • Doff Rigid Emerald 3mm',
    featureIcon: Icons.verified_outlined,
  ),
  Product(
    id: 'eid_p5',
    name: 'Paket Lebaran Biskuit Kaleng & Sirup',
    desc:
        'Paket Raya praktis & meriah bergaya parcel ritel modern (Kaleng Besar Butter Cookies, 2 Botol Sirup Lebaran, Kurma, & Wafer Roll) untuk THR karyawan.',
    price: 285000,
    originalPrice: 325000,
    category: 'smart',
    emoji: '🍪',
    image: 'assets/images/eid_hamper_smart1.jpg',
    badge: 'Paket THR Praktis',
    rating: 4.99,
    reviews: 410,
    featureLabel: '32 x 24 x 14 cm • Festive Parcel Box + Handle',
    featureIcon: Icons.redeem_rounded,
  ),
  Product(
    id: 'eid_p6',
    name: 'Eid Twin Gold Tin & Emerald Sleeve',
    desc:
        'Solusi efisien distribusi ribuan karyawan & mitra: duet kaleng emas Nastar Wisman & Putri Salju Mede dengan sleeve logo korporat.',
    price: 385000,
    category: 'smart',
    emoji: '🌟',
    image: 'assets/images/eid_hamper_smart2.jpg',
    badge: 'Smart Volume',
    rating: 4.94,
    reviews: 290,
    featureLabel: '26 x 18 x 9 cm • Gold Foil Emerald Sleeve',
    featureIcon: Icons.local_shipping_outlined,
  ),
];

Widget _buildOrnamentalGoldDivider({bool onDark = false}) {
  final lineColor = onDark
      ? _kGoldAccent.withValues(alpha: 0.35)
      : _kGoldAccent.withValues(alpha: 0.55);
  final starColor = onDark ? _kTertiaryFixed : _kGoldDark;
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(width: 48, height: 1, color: lineColor),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          '✦',
          style: _jakarta(11, weight: FontWeight.w700, color: starColor),
        ),
      ),
      Container(width: 48, height: 1, color: lineColor),
    ],
  );
}

// ---------------------------------------------------------------------------
// Main Hampers Store View
// ---------------------------------------------------------------------------
class HampersStoreView extends StatefulWidget {
  const HampersStoreView({super.key, required this.onOpenAdmin});

  final VoidCallback onOpenAdmin;

  @override
  State<HampersStoreView> createState() => _HampersStoreViewState();
}

class _HampersStoreViewState extends State<HampersStoreView> {
  final _scroll = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _katalogKey = GlobalKey();
  final _personalisasiKey = GlobalKey();
  final _legalitasKey = GlobalKey();
  final _proposalKey = GlobalKey();
  final _quoteFormKey = GlobalKey();

  // Active Season Edition ('Tahun Baru 2027' vs 'Idul Fitri 1448 H')
  HamperSeason _season = HamperSeason.newYear;

  Timer? _countdownTimer;
  late final ValueNotifier<DateTime> _currentTimeNotifier;

  DateTime _getTargetDeadline(bool isEid) {
    final now = DateTime.now();
    if (isEid) {
      // H-10 Lebaran 1448 H (~10 Maret 2027)
      var target = DateTime(2027, 3, 10, 23, 59, 59);
      if (target.isBefore(now)) {
        target = DateTime(now.year + 1, 3, 10, 23, 59, 59);
      }
      return target;
    } else {
      // Batas Akhir Pemesanan Tahun Baru: 20 Desember 2026
      var target = DateTime(2026, 12, 20, 23, 59, 59);
      if (target.isBefore(now)) {
        target = DateTime(now.year + 1, 12, 20, 23, 59, 59);
      }
      return target;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentTimeNotifier = ValueNotifier<DateTime>(DateTime.now());
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentTimeNotifier.value = DateTime.now();
    });
  }

  bool get _isEid => _season == HamperSeason.eid;
  Color get _activePrimary => _isEid ? _kEidPrimary : _kPrimary;
  Color get _activePrimaryDark => _isEid ? _kEidPrimaryDark : _kPrimaryDark;
  Color get _activePrimaryContainer =>
      _isEid ? _kEidPrimaryContainer : _kPrimaryContainer;

  void _setSeason(HamperSeason next) {
    if (_season == next) return;
    setState(() {
      _season = next;
    });
    showToast(
      context,
      next == HamperSeason.eid
          ? 'Beralih ke Koleksi Hampers Idul Fitri 1448 H / Lebaran'
          : 'Beralih ke Koleksi Hampers Tahun Baru 2027',
      icon: next == HamperSeason.eid
          ? Icons.nights_stay_rounded
          : Icons.auto_awesome_rounded,
    );
  }

  Widget _buildSeasonSwitcherPill({bool onDark = true, bool compact = false}) {
    final bg = onDark
        ? Colors.black.withValues(alpha: 0.35)
        : _kCardInner;
    final borderCol = onDark
        ? _kGoldAccent.withValues(alpha: 0.55)
        : _kCardBorder;

    Widget buildOption({
      required HamperSeason target,
      required IconData icon,
      required String label,
    }) {
      final active = _season == target;
      final fgColor = active
          ? _kPrimaryDark
          : (onDark
              ? Colors.white.withValues(alpha: 0.85)
              : _kCardTextMuted);
      return InkWell(
        onTap: () => _setSeason(target),
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 11 : 14,
            vertical: compact ? 5.5 : 7,
          ),
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(
                    colors: [_kGoldDark, _kTertiaryFixed],
                  )
                : null,
            color: active ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: _kGoldAccent.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: compact ? 13 : 14,
                color: active ? _kPrimaryDark : _kTertiaryFixed,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: _jakarta(
                  compact ? 11 : 11.5,
                  weight: active ? FontWeight.w700 : FontWeight.w600,
                  color: fgColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderCol, width: 1.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildOption(
            target: HamperSeason.newYear,
            icon: Icons.auto_awesome_rounded,
            label: compact ? 'Tahun Baru' : 'Edisi Tahun Baru',
          ),
          const SizedBox(width: 3),
          buildOption(
            target: HamperSeason.eid,
            icon: Icons.nights_stay_rounded,
            label: compact ? 'Idul Fitri' : 'Edisi Idul Fitri',
          ),
        ],
      ),
    );
  }

  // Budget Filter ('all', 'smart', 'standard', 'vip') — isolated ValueNotifier
  final _selectedTierNotifier = ValueNotifier<String>('all');

  // B2B Quick Quote Form Controllers
  final _companyCtrl = TextEditingController();
  final _picCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _selectedBoxQtyNotifier = ValueNotifier<String>(
    '25 - 50 Box (Diskon Kuantitas 8% + Free Kartu Foil)',
  );

  static const List<String> _kQuantityOptions = [
    '10 - 24 Box (Diskon Kuantitas 5%)',
    '25 - 50 Box (Diskon Kuantitas 8% + Free Kartu Foil)',
    '51 - 100 Box (Diskon Kuantitas 12% + Free Logo Emboss)',
    '101 - 250 Box (Harga Kontrak Khusus + Free Multi-Drop Jakarta)',
    '250 - 500+ Box (VIP Enterprise Tier & Dedikasi Armada Truk)',
  ];

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _currentTimeNotifier.dispose();
    _scroll.dispose();
    _selectedTierNotifier.dispose();
    _selectedBoxQtyNotifier.dispose();
    _companyCtrl.dispose();
    _picCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        alignment: 0.02,
      );
    }
  }

  void _scrollToTop() {
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void _triggerProposalDownload() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _kCardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _kCardBorder),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _kCardInner,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _kCardBorder),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded,
                  color: _kGoldDark, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Unduh E-Proposal Direksi',
                style: _cormorant(22,
                    weight: FontWeight.w700, color: _kCardTextPrimary),
              ),
            ),
          ],
        ),
        content: Text(
          _isEid
              ? 'Memulai unduhan \'E-Proposal-Direksi-Maison-Cadeaux-IdulFitri-1448H.pdf\' (4.4 MB) lengkap dengan katalog Paket Raya & VIP, legalitas PT, format e-Faktur, dan lembar persetujuan direksi.'
              : 'Memulai unduhan \'E-Proposal-Direksi-Maison-Cadeaux-TahunBaru-2027.pdf\' (4.2 MB) lengkap dengan legalitas PT, format e-Faktur, dan lembar persetujuan dewan direksi.',
          style: _jakarta(13, color: _kCardTextMuted, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Tutup',
                style: _jakarta(12.5,
                    weight: FontWeight.w600, color: _kCardTextPrimary)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _kPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _scrollToKey(_quoteFormKey);
            },
            icon: const Icon(Icons.support_agent_rounded,
                size: 16, color: _kTertiaryFixed),
            label: Text(
              'Konsultasi B2B via WA',
              style: _jakarta(12,
                  weight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _openSpecModal({
    required String title,
    required String price,
    required String dimensions,
    required String material,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (ctx) => Dialog(
        backgroundColor: _kCardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _kCardBorder),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SPESIFIKASI FISIK & MATERIAL BOX',
                            style: _jakarta(
                              10,
                              weight: FontWeight.w700,
                              color: _kGoldDark,
                              spacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            style: _cormorant(28,
                                weight: FontWeight.w600,
                                color: _kCardTextPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            price,
                            style: _cormorant(
                              20,
                              weight: FontWeight.w700,
                              color: _kGoldDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: _kCardInner,
                      ),
                      icon: const Icon(Icons.close_rounded,
                          size: 18, color: _kCardTextPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _kCardInner,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kCardBorder),
                  ),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final wide = c.maxWidth >= 420;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: wide ? (c.maxWidth - 16) / 2 : c.maxWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DIMENSI PRESISI (P X L X T):',
                                  style: _jakarta(10,
                                      weight: FontWeight.w700,
                                      color: _kGoldDark),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dimensions,
                                  style: _jakarta(13.5,
                                      weight: FontWeight.w700,
                                      color: _kCardTextPrimary),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: wide ? (c.maxWidth - 16) / 2 : c.maxWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BAHAN KONSTRUKSI KEMASAN:',
                                  style: _jakarta(10,
                                      weight: FontWeight.w700,
                                      color: _kGoldDark),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  material,
                                  style: _jakarta(13,
                                      weight: FontWeight.w600,
                                      color: _kCardTextPrimary,
                                      height: 1.35),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'KELENGKAPAN STANDAR PER BOX (ALL-INCLUSIVE):',
                  style: _jakarta(
                    11.5,
                    weight: FontWeight.w700,
                    color: _kCardTextPrimary,
                    spacing: 0.6,
                  ),
                ),
                const SizedBox(height: 10),
                for (final item in const [
                  (
                    'Kartu Ucapan Fancy Paper:',
                    'Gramasi 310gsm dengan foil emas & nama direksi'
                  ),
                  (
                    'Custom Hangtag Logo:',
                    'Dicetak bertekstur dengan logo identitas kantor'
                  ),
                  (
                    'Pita Satin Impor:',
                    'Lebar 4 cm berpola festive dengan simpul presisi'
                  ),
                  (
                    'Proteksi Distribusi:',
                    'Double bubble wrap tebal & outer corrugated master box'
                  ),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _kCardInner,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _kCardBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              size: 17, color: _kGoldDark),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: _jakarta(12,
                                    color: _kCardTextMuted, height: 1.4),
                                children: [
                                  TextSpan(
                                    text: '${item.$1} ',
                                    style: _jakarta(12,
                                        weight: FontWeight.w700,
                                        color: _kCardTextPrimary),
                                  ),
                                  TextSpan(text: item.$2),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _kCardInner,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kCardBorder),
                  ),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final isNarrow = c.maxWidth < 400;
                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.verified_rounded,
                                    color: _kGoldDark, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Sample mock-up fisik dapat dikirimkan ke kantor Anda (S&K Berlaku)',
                                    style: _jakarta(11.5,
                                        color: _kCardTextPrimary),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _kPrimary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                _scrollToKey(_quoteFormKey);
                              },
                              child: Text(
                                'Ajukan Sample',
                                style: _jakarta(11.5,
                                    weight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          const Icon(Icons.verified_rounded,
                              color: _kGoldDark, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Sample mock-up fisik dapat dikirimkan ke kantor Anda (S&K Berlaku)',
                              style: _jakarta(11.5, color: _kCardTextPrimary),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _kPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              _scrollToKey(_quoteFormKey);
                            },
                            child: Text(
                              'Ajukan Sample',
                              style: _jakarta(11.5,
                                  weight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitB2bQuote(StoreState state, StoreProfile store) {
    final company = _companyCtrl.text.trim();
    final pic = _picCtrl.text.trim();
    final date = _dateCtrl.text.trim();

    if (company.isEmpty || pic.isEmpty || date.isEmpty) {
      showToast(
        context,
        'Mohon lengkapi Nama Perusahaan, Nama PIC, dan Rencana Tanggal Pengiriman.',
        icon: Icons.info_outline_rounded,
      );
      return;
    }

    final branch = state.selectedBranch;
    final branchInfo = branch != null ? ' (Tujuan: ${branch.name})' : '';
    final targetWa = (branch != null && branch.whatsapp.trim().isNotEmpty)
        ? branch.whatsapp.trim()
        : (store.whatsapp.trim().isNotEmpty
            ? store.whatsapp.trim()
            : '6281198247700');

    final editionLabel = _isEid
        ? 'Hampers Idul Fitri 1448 H / Lebaran'
        : 'Hampers Tahun Baru 2027';
    final message =
        'Halo Tim B2B ${store.name}$branchInfo, saya $pic dari $company ingin mengajukan penawaran resmi untuk $editionLabel sebanyak ${_selectedBoxQtyNotifier.value} dengan rencana tanggal pengiriman $date. Mohon kirimkan draft penawaran resmi berfaktur pajak PPN 11%. Terima kasih.';

    openUrl(waLink(targetWa, message));
    showToast(
      context,
      'Membuka WhatsApp B2B Concierge ${store.name}...',
      icon: Icons.chat_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        final store = state.store;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: _kSurface,
          endDrawer: _buildMobileDrawer(store),
          body: Stack(
            children: [
              Column(
                children: [
                  RepaintBoundary(
                    child: StaggeredThemeBlock(
                      stage: 0,
                      child: _buildTopHeader(context, store),
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      controller: _scroll,
                      child: CustomScrollView(
                        controller: _scroll,
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: StaggeredThemeBlock(
                                stage: 1,
                                child: _buildHeroSection(context, store),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: StaggeredThemeBlock(
                                stage: 2,
                                child: _buildClientTrustSection(context),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: StaggeredThemeBlock(
                                stage: 2,
                                child: _buildTestimonialsSection(context),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: StaggeredThemeBlock(
                                stage: 3,
                                child:
                                    _buildKatalogSection(context, state, store),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: StaggeredThemeBlock(
                                stage: 3,
                                child: _buildPersonalisasiSection(context),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: StaggeredThemeBlock(
                                stage: 3,
                                child: _buildLegalitasSection(context),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: StaggeredThemeBlock(
                                stage: 3,
                                child: _buildQuickQuoteSection(
                                    context, state, store),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: RepaintBoundary(
                              child: StaggeredThemeBlock(
                                stage: 3,
                                child: _buildFooterSection(context, store),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: RepaintBoundary(child: FloatingCartBar()),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 0. Mobile Drawer
  // ---------------------------------------------------------------------------
  Widget _buildMobileDrawer(StoreProfile store) {
    return Drawer(
      backgroundColor: _kSurface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                store.name.toUpperCase(),
                style: _cormorant(
                  22,
                  weight: FontWeight.w700,
                  color: _kPrimary,
                  spacing: 3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'ATELIER DE CADEAUX D’ENTREPRISE',
                style: _jakarta(
                  9,
                  weight: FontWeight.w600,
                  color: _kGoldDark,
                  spacing: 2.2,
                ),
              ),
              const SizedBox(height: 16),
              _buildSeasonSwitcherPill(onDark: false, compact: true),
              const SizedBox(height: 18),
              for (final item in [
                ('Katalog Anggaran', Icons.card_giftcard_rounded, _katalogKey),
                (
                  'Rincian & Dimensi Box',
                  Icons.aspect_ratio_rounded,
                  _katalogKey
                ),
                (
                  'Personalisasi Logo',
                  Icons.workspace_premium_outlined,
                  _personalisasiKey
                ),
                (
                  'Legalitas & e-Faktur',
                  Icons.verified_user_outlined,
                  _legalitasKey
                ),
                (
                  'Fast-Track WhatsApp',
                  Icons.support_agent_rounded,
                  _quoteFormKey
                ),
              ])
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Future.delayed(
                      const Duration(milliseconds: 220),
                      () => _scrollToKey(item.$3),
                    );
                  },
                  leading: Icon(item.$2, color: _kGoldDark, size: 20),
                  title: Text(
                    item.$1,
                    style: _jakarta(13.5,
                        weight: FontWeight.w600, color: _kPrimary),
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _activePrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _triggerProposalDownload();
                  },
                  icon: const Icon(Icons.download_rounded,
                      size: 17, color: _kTertiaryFixed),
                  label: Text(
                    'Unduh E-Proposal Direksi',
                    style: _jakarta(12.5,
                        weight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Header & New Year 2025 Countdown Banner
  // ---------------------------------------------------------------------------
  Widget _buildTopHeader(BuildContext context, StoreProfile store) {
    final hotline = _formatHotline(store.whatsapp);

    return Container(
      decoration: BoxDecoration(
        color: _kNavSurface.withValues(alpha: 0.98),
        boxShadow: [
          BoxShadow(
            color: _kPrimary.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main Navigation Bar (Zero Overflow Responsive Layout)
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  final mobile = w < 640;
                  final showDesktopNav = w >= 980;
                  final showProposalBtn =
                      w >= 1120 || (w >= 680 && !showDesktopNav);

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: mobile ? 14 : 24,
                      vertical: mobile ? 10 : 14,
                    ),
                    child: Row(
                      children: [
                        // Luxury Brand Logo
                        if (!showDesktopNav)
                          Expanded(
                            child: Hover(
                              onTap: _scrollToTop,
                              builder: (context, hovered) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    store.name.toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: _cormorant(
                                      mobile ? 17.5 : 22,
                                      weight: FontWeight.w700,
                                      color: hovered ? _kGoldDark : _kPrimary,
                                      spacing: mobile ? 1.5 : 2.5,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'ATELIER DE CADEAUX D’ENTREPRISE',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: _jakarta(
                                      mobile ? 6.8 : 8.0,
                                      weight: FontWeight.w600,
                                      color: _kGoldDark,
                                      spacing: mobile ? 1.1 : 1.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Hover(
                            onTap: _scrollToTop,
                            builder: (context, hovered) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  store.name.toUpperCase(),
                                  style: _cormorant(
                                    24,
                                    weight: FontWeight.w700,
                                    color: hovered ? _kGoldDark : _kPrimary,
                                    spacing: 3.0,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ATELIER DE CADEAUX D’ENTREPRISE',
                                  style: _jakarta(
                                    8.5,
                                    weight: FontWeight.w600,
                                    color: _kGoldDark,
                                    spacing: 2.1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Center Desktop Navigation Items (Guaranteed Zero Overflow)
                        if (showDesktopNav)
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _NavLink(
                                        label: 'Katalog Anggaran',
                                        isActive: true,
                                        onTap: () => _scrollToKey(_katalogKey),
                                      ),
                                      const SizedBox(width: 18),
                                      _NavLink(
                                        label: 'Rincian & Dimensi Box',
                                        onTap: () => _scrollToKey(_katalogKey),
                                      ),
                                      const SizedBox(width: 18),
                                      _NavLink(
                                        label: 'Personalisasi Logo',
                                        onTap: () =>
                                            _scrollToKey(_personalisasiKey),
                                      ),
                                      const SizedBox(width: 18),
                                      _NavLink(
                                        label: 'Legalitas & e-Faktur',
                                        onTap: () =>
                                            _scrollToKey(_legalitasKey),
                                      ),
                                      const SizedBox(width: 18),
                                      _NavLink(
                                        label: 'Fast-Track WhatsApp',
                                        onTap: () =>
                                            _scrollToKey(_quoteFormKey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 8),

                        // Right Action Buttons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (showProposalBtn) ...[
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      _kGoldAccent.withValues(alpha: 0.32),
                                  foregroundColor: _kPrimary,
                                  side: BorderSide(
                                      color: _kGoldDark.withValues(alpha: 0.55)),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 11,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                                onPressed: () => _scrollToKey(_proposalKey),
                                icon: const Icon(Icons.download_rounded,
                                    size: 15, color: _kGoldDark),
                                label: Text(
                                  'Unduh E-Proposal Direksi',
                                  style: _jakarta(
                                    11.5,
                                    weight: FontWeight.w600,
                                    color: _kOnSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _activePrimary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: mobile ? 11 : 18,
                                  vertical: mobile ? 9 : 11,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                  side: BorderSide(
                                    color: _kGoldAccent.withValues(alpha: 0.45),
                                  ),
                                ),
                              ),
                              onPressed: () => _scrollToKey(_quoteFormKey),
                              icon: Icon(Icons.support_agent_rounded,
                                  size: mobile ? 14 : 15,
                                  color: _kTertiaryFixed),
                              label: Text(
                                mobile ? 'Konsultasi' : 'Konsultasi B2B',
                                style: _jakarta(
                                  mobile ? 11 : 11.5,
                                  weight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (!showDesktopNav) ...[
                              const SizedBox(width: 4),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(),
                                onPressed: () =>
                                    _scaffoldKey.currentState?.openEndDrawer(),
                                icon: const Icon(Icons.menu_rounded,
                                    color: _kPrimary),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Season Switcher & Countdown Bar (Midnight Navy for Tahun Baru / Royal Emerald for Idul Fitri)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _activePrimaryDark,
                  _activePrimary,
                  _activePrimaryDark,
                ],
              ),
              border: Border(
                top: BorderSide(color: _kGoldAccent.withValues(alpha: 0.35)),
                bottom: BorderSide(color: _kGoldAccent.withValues(alpha: 0.35)),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final showRightInfo = c.maxWidth >= 980;
                    final isMobileStack = c.maxWidth < 760;

                    return ValueListenableBuilder<DateTime>(
                      valueListenable: _currentTimeNotifier,
                      builder: (context, now, _) {
                        final target = _getTargetDeadline(_isEid);
                        final diff = target.isAfter(now)
                            ? target.difference(now)
                            : Duration.zero;
                        final days = diff.inDays.toString().padLeft(2, '0');
                        final hours =
                            (diff.inHours % 24).toString().padLeft(2, '0');
                        final minutes =
                            (diff.inMinutes % 60).toString().padLeft(2, '0');
                        final seconds =
                            (diff.inSeconds % 60).toString().padLeft(2, '0');

                        final timerWidgets = <Widget>[
                          Icon(
                            _isEid
                                ? Icons.nights_stay_rounded
                                : Icons.auto_awesome_rounded,
                            size: 14,
                            color: _kTertiaryFixed,
                          ),
                          const SizedBox(width: 6),
                          RichText(
                            text: TextSpan(
                              style: _jakarta(11.5, color: Colors.white),
                              children: [
                                TextSpan(
                                  text: isMobileStack
                                      ? (_isEid
                                          ? 'Pre-Order Raya: '
                                          : 'Batas Order: ')
                                      : (_isEid
                                          ? 'Batas Akhir Pre-Order Idul Fitri: '
                                          : 'Batas Akhir Pemesanan Tahun Baru: '),
                                  style: _jakarta(
                                    11.5,
                                    weight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                TextSpan(
                                  text: isMobileStack
                                      ? (_isEid ? 'H-10 Lebaran' : '20 Des 2026')
                                      : (_isEid
                                          ? 'H-10 Lebaran (Early Bird -12%)'
                                          : '20 Desember 2026'),
                                  style: _jakarta(
                                    11.5,
                                    weight: FontWeight.w700,
                                    color: _kTertiaryFixed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _CountdownPill(
                            value: days,
                            unit: 'Hari',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Text(
                              ':',
                              style: _jakarta(
                                11.5,
                                weight: FontWeight.w700,
                                color: _kGoldAccent,
                              ),
                            ),
                          ),
                          _CountdownPill(value: hours, unit: 'Jam'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Text(
                              ':',
                              style: _jakarta(
                                11.5,
                                weight: FontWeight.w700,
                                color: _kGoldAccent,
                              ),
                            ),
                          ),
                          _CountdownPill(value: minutes, unit: 'Mnt'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Text(
                              ':',
                              style: _jakarta(
                                11.5,
                                weight: FontWeight.w700,
                                color: _kGoldAccent,
                              ),
                            ),
                          ),
                          _CountdownPill(value: seconds, unit: 'Dtk'),
                        ];

                        if (isMobileStack) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildSeasonSwitcherPill(
                                onDark: true,
                                compact: false,
                              ),
                              const SizedBox(height: 7),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: timerWidgets,
                                ),
                              ),
                            ],
                          );
                        }

                        final countdownRow = FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildSeasonSwitcherPill(
                                onDark: true,
                                compact: false,
                              ),
                              const SizedBox(width: 14),
                              ...timerWidgets,
                            ],
                          ),
                        );

                        if (!showRightInfo) {
                          return Center(child: countdownRow);
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: countdownRow),
                            const SizedBox(width: 16),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 14,
                                  color: _kTertiaryFixed,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Resmi PKP: e-Faktur PPN 11%',
                                  style: _jakarta(
                                    11.5,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    '|',
                                    style: _jakarta(
                                      11.5,
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: _jakarta(
                                      11.5,
                                      color:
                                          Colors.white.withValues(alpha: 0.82),
                                    ),
                                    children: [
                                      const TextSpan(text: 'Hotline B2B: '),
                                      TextSpan(
                                        text: hotline,
                                        style: _jakarta(
                                          11.5,
                                          weight: FontWeight.w700,
                                          color: _kTertiaryFixed,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 1: HERO TAHUN BARU 2027 / IDUL FITRI 1448 H B2B
  // ---------------------------------------------------------------------------
  Widget _buildHeroSection(BuildContext context, StoreProfile store) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1024;
    final mobile = width < 640;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _isEid
              ? const [
                  Color(0xFF04140E),
                  _kEidPrimary,
                  Color(0xFF0D3325),
                  _kEidPrimaryDark,
                ]
              : const [
                  Color(0xFF070C16),
                  _kPrimary,
                  Color(0xFF0F192C),
                  _kPrimaryDark,
                ],
        ),
      ),
      child: Stack(
        children: [
          // Custom Painted Celebration Backdrop (New Year Fireworks vs Eid Crescent & Lanterns)
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _isEid
                      ? _EidHeroBackdropPainter(
                          cormorantFamily: _kCormorantFamily,
                        )
                      : _NewYearHeroBackdropPainter(
                          cormorantFamily: _kCormorantFamily,
                        ),
                ),
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mobile ? 14 : 28,
              vertical: mobile ? 26 : 60,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Verified Badges Row (Desktop Only to keep Mobile ultra-clean and uncluttered)
                    if (!mobile)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(bottom: 22),
                        margin: const EdgeInsets.only(bottom: 34),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _kGoldAccent.withValues(alpha: 0.18),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              spacing: 10,
                              children: [
                                const _HeroTopBadge(
                                  icon: Icons.verified_user_outlined,
                                  label: 'Terbit Faktur Pajak PPN 11%',
                                  fg: _kTertiaryFixed,
                                ),
                                _HeroTopBadge(
                                  icon: Icons.receipt_long_outlined,
                                  label: 'Kuitansi Bermeterai Resmi',
                                  fg: Colors.white.withValues(alpha: 0.9),
                                ),
                                _HeroTopBadge(
                                  icon: Icons.local_shipping_outlined,
                                  label: 'Minimum Grosir Mulai 10 Box',
                                  fg: Colors.white.withValues(alpha: 0.9),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: _kGoldDark.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: _kGoldAccent.withValues(alpha: 0.55),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isEid
                                        ? Icons.nights_stay_rounded
                                        : Icons.auto_awesome_rounded,
                                    size: 14,
                                    color: _kTertiaryFixed,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    _isEid
                                        ? 'Distribusi Lebaran: H-14 s/d H-5 Idul Fitri'
                                        : 'Distribusi Tahun Baru: 20–30 Desember 2026',
                                    style: _jakarta(
                                      11.5,
                                      weight: FontWeight.w600,
                                      color: _kTertiaryFixed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Hero Grid (7 cols text + 5 cols image)
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 7,
                            child: _buildHeroTextColumn(store, false),
                          ),
                          const SizedBox(width: 48),
                          Expanded(
                            flex: 5,
                            child: _buildHeroImageCard(store, false),
                          ),
                        ],
                      )
                    else if (mobile)
                      _buildHeroTextColumn(
                        store,
                        true,
                        embeddedImageCard: _buildHeroImageCard(store, true),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeroTextColumn(store, false),
                          const SizedBox(height: 36),
                          _buildHeroImageCard(store, false),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroPricePill(bool mobile) {
    final startingPrice = _isEid ? 'Rp 285.000' : 'Rp 385.000';
    return Container(
      margin: EdgeInsets.only(
        top: mobile ? 12 : 16,
        bottom: mobile ? 14 : 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 12 : 16,
        vertical: mobile ? 7 : 8.5,
      ),
      decoration: BoxDecoration(
        color: _activePrimaryDark.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _kTertiaryFixed.withValues(alpha: 0.55),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sell_outlined,
            size: mobile ? 13 : 15,
            color: _kTertiaryFixed,
          ),
          const SizedBox(width: 7),
          RichText(
            text: TextSpan(
              style: _jakarta(
                mobile ? 11 : 12.5,
                weight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              children: [
                const TextSpan(text: 'Mulai '),
                TextSpan(
                  text: '$startingPrice / box',
                  style: _jakarta(
                    mobile ? 11.5 : 13,
                    weight: FontWeight.w800,
                    color: _kTertiaryFixed,
                  ),
                ),
                TextSpan(
                  text: mobile
                      ? '  •  Min. 10 Box  •  Diskon s/d 18%'
                      : '  •  Min. Order 10 Box  •  Diskon Kuantitas s/d 18%',
                  style: _jakarta(
                    mobile ? 11 : 12.5,
                    weight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroTextColumn(
    StoreProfile store,
    bool mobile, {
    Widget? embeddedImageCard,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gold-bordered Pill Badge
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: mobile ? 12 : 16, vertical: mobile ? 6 : 7),
          decoration: BoxDecoration(
            color: _kGoldAccent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: _kGoldAccent.withValues(alpha: 0.65)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _isEid
                      ? '✦  KOLEKSI RAYA IDUL FITRI 1448 H / 2027  ✦'
                      : '✦  KOLEKSI TAHUN BARU 2027  ✦',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _jakarta(
                    mobile ? 10 : 11.5,
                    weight: FontWeight.w700,
                    color: _kTertiaryFixed,
                    spacing: mobile ? 0.9 : 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: mobile ? 14 : 18),
        RichText(
          text: TextSpan(
            style: _cormorant(
              mobile ? 32 : 58,
              weight: FontWeight.w600,
              color: Colors.white,
              height: 1.12,
            ),
            children: [
              const TextSpan(
                text: 'Hampers ',
              ),
              TextSpan(
                text: _isEid ? 'Idul Fitri' : 'Tahun Baru',
                style: _cormorant(
                  mobile ? 32 : 58,
                  weight: FontWeight.w600,
                  color: _kTertiaryFixed,
                  style: FontStyle.italic,
                  height: 1.12,
                ),
              ),
              TextSpan(
                text: _isEid
                    ? '\n& Paket Raya Korporat'
                    : '\nKorporat yang Berkesan',
              ),
            ],
          ),
        ),
        _buildHeroPricePill(mobile),
        if (embeddedImageCard != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: embeddedImageCard,
          ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: RichText(
            text: TextSpan(
              style: _jakarta(
                mobile ? 13 : 16,
                weight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.88),
                height: mobile ? 1.5 : 1.6,
              ),
              children: mobile
                  ? [
                      TextSpan(
                        text: _isEid
                            ? 'Bingkisan silaturahmi & paket Raya korporat kurasi '
                            : 'Bingkisan eksklusif akhir tahun kurasi ',
                      ),
                      TextSpan(
                        text: 'Halal & BPOM berfaktur pajak PPN 11%',
                        style: _jakarta(
                          13,
                          weight: FontWeight.w700,
                          color: _kTertiaryFixed,
                        ),
                      ),
                      TextSpan(
                        text: _isEid
                            ? ' untuk jajaran direksi, mitra, hingga ribuan staf perseroan.'
                            : ' untuk jajaran direksi, mitra bisnis, dan apresiasi perseroan Anda.',
                      ),
                    ]
                  : [
                      TextSpan(
                        text: _isEid
                            ? 'Sempurnakan silaturahmi Hari Raya Idul Fitri bersama klien VVIP, jajaran direksi, hingga pembagian THR ribuan karyawan dengan kurasi '
                            : 'Rayakan pencapaian tahun ini bersama klien, mitra, dan jajaran direksi dengan bingkisan eksklusif berfaktur pajak resmi. Dirancang khusus untuk tim ',
                      ),
                      TextSpan(
                        text: _isEid
                            ? 'Hardbox Eksekutif & Paket Lebaran Praktis (Biskuit Kaleng & Sirup)'
                            : 'Procurement, HRD, dan Sekretariat Direksi',
                        style: _jakarta(
                          16,
                          weight: FontWeight.w600,
                          color: _kTertiaryFixed,
                          height: 1.6,
                        ),
                      ),
                      TextSpan(
                        text: _isEid
                            ? ' berfaktur pajak PPN 11% serta 100% bersertifikat Halal MUI & BPOM.'
                            : ' dengan kurasi gourmet bersertifikat Halal & BPOM.',
                      ),
                    ],
            ),
          ),
        ),
        SizedBox(height: mobile ? 22 : 28),
        if (mobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kGoldAccent,
                  foregroundColor: _activePrimaryDark,
                  elevation: 4,
                  shadowColor: _kGoldAccent.withValues(alpha: 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999)),
                ),
                onPressed: () => _scrollToKey(_proposalKey),
                icon: Icon(Icons.picture_as_pdf_outlined,
                    size: 18, color: _activePrimaryDark),
                label: Text(
                  'Unduh Proposal PDF',
                  style: _jakarta(
                    13,
                    weight: FontWeight.w700,
                    color: _activePrimaryDark,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: _activePrimaryDark.withValues(alpha: 0.55),
                  foregroundColor: Colors.white,
                  side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.55), width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999)),
                ),
                onPressed: () => _scrollToKey(_quoteFormKey),
                icon: const Icon(Icons.chat_bubble_outline_rounded,
                    size: 17, color: _kTertiaryFixed),
                label: Text(
                  'Konsultasi B2B WhatsApp',
                  style: _jakarta(
                    13,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        else
          Wrap(
            spacing: 14,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kGoldAccent,
                  foregroundColor: _activePrimaryDark,
                  elevation: 4,
                  shadowColor: _kGoldAccent.withValues(alpha: 0.4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999)),
                ),
                onPressed: () => _scrollToKey(_proposalKey),
                icon: Icon(Icons.picture_as_pdf_outlined,
                    size: 18, color: _activePrimaryDark),
                label: Text(
                  'Unduh Proposal PDF',
                  style: _jakarta(
                    13,
                    weight: FontWeight.w700,
                    color: _activePrimaryDark,
                  ),
                ),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: _activePrimaryDark.withValues(alpha: 0.55),
                  foregroundColor: Colors.white,
                  side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.55), width: 1.2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999)),
                ),
                onPressed: () => _scrollToKey(_quoteFormKey),
                icon: const Icon(Icons.chat_bubble_outline_rounded,
                    size: 17, color: _kTertiaryFixed),
                label: Text(
                  'Konsultasi B2B WhatsApp',
                  style: _jakarta(
                    13,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: mobile ? 22 : 32),
        Container(
          padding: EdgeInsets.only(top: mobile ? 18 : 24),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: _kGoldAccent.withValues(alpha: 0.2)),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (idx, stat) in [
                (
                  '100%',
                  mobile ? 'Halal & BPOM' : 'Kurasi Halal & BPOM Resmi'
                ),
                (
                  '>120+',
                  mobile ? 'Korporasi & BUMN' : 'Korporasi & BUMN Terlayani'
                ),
                (
                  '0%',
                  mobile ? 'Telat Logistik VIP' : 'Keterlambatan Logistik VIP'
                ),
              ].indexed) ...[
                if (idx > 0) SizedBox(width: mobile ? 8 : 14),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(mobile ? 10 : 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: _kGoldAccent.withValues(alpha: 0.22)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stat.$1,
                          style: _jakarta(
                            mobile ? 20 : 26,
                            weight: FontWeight.w800,
                            color: _kTertiaryFixed,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stat.$2,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: _jakarta(
                            mobile ? 10.5 : 11.5,
                            color: Colors.white.withValues(alpha: 0.78),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (mobile)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user_outlined,
                    size: 13, color: _kTertiaryFixed),
                const SizedBox(width: 6),
                Text(
                  'Resmi PKP  •  Faktur Pajak PPN 11%  •  Kuitansi Bermeterai',
                  style: _jakarta(
                    10.5,
                    weight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildHeroImageCard(StoreProfile store, [bool mobile = false]) {
    final activeProducts = _isEid ? _kEidProducts : store.products;
    final firstVip = activeProducts.isNotEmpty ? activeProducts.first : null;
    final vipTitle = firstVip?.name ??
        (_isEid
            ? 'The Sultanate Royal Raya Reserve'
            : 'The Midnight Gala Reserve');
    final vipPrice = firstVip != null
        ? rupiah(firstVip.price)
        : (_isEid ? 'Rp 2.650.000' : 'Rp 2.450.000');
    final heroBanner = _isEid
        ? 'assets/images/eid_hamper_vip1.jpg'
        : store.banner;

    return Container(
      padding: EdgeInsets.all(mobile ? 5 : 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _kTertiaryFixed.withValues(alpha: 0.55),
            _kGoldDark.withValues(alpha: 0.25),
            _kTertiaryFixed.withValues(alpha: 0.45),
          ],
        ),
        borderRadius: BorderRadius.circular(mobile ? 15 : 18),
        border: Border.all(
          color: _kTertiaryFixed.withValues(alpha: 0.75),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: _kGoldAccent.withValues(alpha: 0.18),
            blurRadius: 28,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(mobile ? 11 : 13),
        child: AspectRatio(
          aspectRatio: mobile ? (16 / 10.5) : (4 / 3.5),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppImage(
                src: heroBanner,
                emoji: _isEid ? '🕌' : '☕',
                fit: BoxFit.cover,
                cacheWidth: 720,
              ),
              // Subtle dark vignette at bottom for crisp text legibility
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 130,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          _activePrimaryDark.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: mobile ? 10 : 14,
                right: mobile ? 10 : 14,
                bottom: mobile ? 10 : 14,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: mobile ? 12 : 16,
                      vertical: mobile ? 10 : 13),
                  decoration: BoxDecoration(
                    color: _activePrimaryDark.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _kGoldAccent.withValues(alpha: 0.55)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEid
                                  ? 'MASTERPIECE IDUL FITRI VIP'
                                  : 'MASTERPIECE TIER VIP',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _jakarta(
                                mobile ? 9 : 10,
                                weight: FontWeight.w700,
                                color: _kTertiaryFixed,
                                spacing: mobile ? 1.0 : 1.4,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              vipTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _cormorant(
                                mobile ? 16.5 : 20,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isEid
                                  ? 'Box Kayu Jati & Velvet Emerald • 42 x 32 x 18 cm'
                                  : 'Box Kayu Jati Solid • 42 x 32 x 18 cm',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _jakarta(
                                mobile ? 10 : 11,
                                color: Colors.white.withValues(alpha: 0.72),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'MULAI DARI',
                            style: _jakarta(
                              mobile ? 8.5 : 9.5,
                              weight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.65),
                              spacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            vipPrice,
                            style: _cormorant(
                              mobile ? 18 : 22,
                              weight: FontWeight.w700,
                              color: _kTertiaryFixed,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 2A: CLIENT TRUST LOGOS
  // ---------------------------------------------------------------------------
  Widget _buildClientTrustSection(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 640;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 14 : 24,
        vertical: mobile ? 30 : 44,
      ),
      decoration: const BoxDecoration(
        color: _kSurfaceLow,
        border: Border(bottom: BorderSide(color: _kSurfaceHigh)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!mobile) ...[
                    Container(width: 48, height: 1, color: _kOutlineVariant),
                    const SizedBox(width: 14),
                  ],
                  Flexible(
                    child: Text(
                      'DIPERCAYA OLEH LEBIH DARI 120+ PERUSAHAAN, BUMN & MULTINASIONAL UNTUK PENGADAAN AKHIR TAHUN',
                      textAlign: TextAlign.center,
                      style: _jakarta(
                        mobile ? 10 : 11,
                        weight: FontWeight.w700,
                        color: _kOnSurfaceVariant,
                        spacing: mobile ? 1.4 : 2.2,
                      ),
                    ),
                  ),
                  if (!mobile) ...[
                    const SizedBox(width: 14),
                    Container(width: 48, height: 1, color: _kOutlineVariant),
                  ],
                ],
              ),
              SizedBox(height: mobile ? 18 : 28),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: mobile ? 20 : 40,
                runSpacing: mobile ? 12 : 18,
                children: [
                  for (final corp in const [
                    (Icons.account_balance_rounded, 'MANDIRA CORP'),
                    (Icons.cell_tower_rounded, 'TELKOMIKA NUSANTARA'),
                    (Icons.diamond_outlined, 'BKA PRIORITAS'),
                    (Icons.local_fire_department_rounded, 'PERTANUSA ENERGI'),
                    (Icons.directions_car_filled_outlined, 'ASTRACO INTL'),
                    (Icons.storefront_rounded, 'GOTECH INDONESIA'),
                    (Icons.spa_outlined, 'UNILUX CONSUMER'),
                    (Icons.token_outlined, 'DNS PACIFIC BANK'),
                  ])
                    Hover(
                      builder: (context, hovered) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(corp.$1,
                              size: mobile ? 17 : 21, color: _kGoldDark),
                          const SizedBox(width: 6),
                          Text(
                            corp.$2,
                            style: _cormorant(
                              mobile ? 16 : 19,
                              weight: FontWeight.w700,
                              color: hovered ? _kGoldDark : _kPrimary,
                              spacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 2B: EXECUTIVE TESTIMONIALS (Equal-Height 3-Column Grid)
  // ---------------------------------------------------------------------------
  Widget _buildTestimonialsSection(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 640;
    const testimonials = [
      (
        quote:
            '"Presisi jadwal pengiriman dan standar kemewahan hardbox kustom berlogo emas yang sangat diapresiasi oleh jajaran dewan komisaris kami."',
        initials: 'BM',
        role: 'VP Corporate Communications',
        company: 'PT Bank Mandira (Persero) Tbk',
        icon: Icons.account_balance_rounded,
      ),
      (
        quote:
            '"Ketertiban administrasi faktur pajak PPN 11%, e-Meterai, dan BAST lengkap membuat proses audit pengadaan akhir tahun berjalan tanpa kendala."',
        initials: 'TN',
        role: 'Head of Procurement & Vendor Relations',
        company: 'PT Telkomika Nusantara (Persero) Tbk',
        icon: Icons.cell_tower_rounded,
      ),
      (
        quote:
            '"Kualitas artisan cake bersertifikat Halal & kurasi gourmet mewah yang selalu konsisten untuk 350+ mitra VVIP kami selama 3 tahun berturut-turut."',
        initials: 'PE',
        role: 'Senior VP Human Capital',
        company: 'PT Pertanusa Energi (Persero)',
        icon: Icons.local_fire_department_rounded,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 14 : 24,
        vertical: mobile ? 44 : 72,
      ),
      decoration: const BoxDecoration(
        color: _kSurface,
        border: Border(bottom: BorderSide(color: _kSurfaceHigh)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            children: [
              _buildOrnamentalGoldDivider(),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'REPUTASI & TESTIMONI EKSEKUTIF',
                      textAlign: TextAlign.center,
                      style: _jakarta(
                        mobile ? 10.5 : 11.5,
                        weight: FontWeight.w700,
                        color: _kGoldDark,
                        spacing: mobile ? 1.6 : 2.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Apresiasi dari Jajaran Pemimpin Korporat & BUMN',
                textAlign: TextAlign.center,
                style: _cormorant(
                  mobile ? 27 : 36,
                  weight: FontWeight.w500,
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Text(
                  'Kepercayaan berkelanjutan dari para pengambil keputusan strategis dalam pengadaan bingkisan Tahun Baru berskala nasional.',
                  textAlign: TextAlign.center,
                  style: _jakarta(
                    mobile ? 12.5 : 13.5,
                    weight: FontWeight.w300,
                    color: _kOnSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: mobile ? 28 : 44),
              LayoutBuilder(
                builder: (context, c) {
                  final cols =
                      c.maxWidth >= 960 ? 3 : (c.maxWidth >= 640 ? 2 : 1);
                  return _buildEqualHeightGrid(
                    columns: cols,
                    spacing: mobile ? 18 : 28,
                    runSpacing: mobile ? 18 : 28,
                    children: [
                      for (final t in testimonials)
                        Hover(
                          builder: (context, hovered) => Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: _kCardSurface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: hovered
                                    ? _kGoldAccent
                                    : _kGoldAccent.withValues(alpha: 0.42),
                                width: hovered ? 1.5 : 1.0,
                              ),
                              boxShadow: _kCardShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Metallic Champagne Gold Top Accent Bar
                                Container(
                                  height: 3.5,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        _kGoldDark,
                                        _kTertiaryFixed,
                                        _kGoldDark,
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    mobile ? 18 : 26,
                                    mobile ? 18 : 24,
                                    mobile ? 18 : 26,
                                    mobile ? 18 : 26,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '“',
                                                style: _cormorant(
                                                  mobile ? 38 : 46,
                                                  weight: FontWeight.w700,
                                                  color: _kGoldDark,
                                                  height: 0.9,
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: List.generate(
                                                  5,
                                                  (_) => const Icon(
                                                    Icons.star_rounded,
                                                    size: 16,
                                                    color: _kGoldDark,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            t.quote,
                                            style: _jakarta(
                                              mobile ? 12.5 : 13,
                                              color: _kCardTextPrimary,
                                              style: FontStyle.italic,
                                              height: 1.55,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: mobile ? 16 : 22),
                                      Container(
                                        padding: const EdgeInsets.only(top: 14),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: _kCardBorder,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: _kPrimary,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: _kGoldAccent
                                                      .withValues(alpha: 0.75),
                                                ),
                                              ),
                                              child: Text(
                                                t.initials,
                                                style: _cormorant(
                                                  15,
                                                  weight: FontWeight.w700,
                                                  color: _kTertiaryFixed,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    t.role,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: _jakarta(
                                                      12,
                                                      weight: FontWeight.w700,
                                                      color: _kCardTextPrimary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Icon(t.icon,
                                                          size: 13,
                                                          color: _kGoldDark),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          t.company,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: _jakarta(
                                                            11,
                                                            weight:
                                                                FontWeight.w500,
                                                            color:
                                                                _kCardTextMuted,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 2C: KATALOG ANGGARAN & RINCIAN KOTAK (Equal-Height 3-Column Grid)
  // ---------------------------------------------------------------------------
  Widget _buildKatalogSection(
    BuildContext context,
    StoreState state,
    StoreProfile store,
  ) {
    final mobile = MediaQuery.sizeOf(context).width < 640;

    return Container(
      key: _katalogKey,
      width: double.infinity,
      color: _kSurface,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 14 : 24,
        vertical: mobile ? 44 : 76,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: ValueListenableBuilder<String>(
            valueListenable: _selectedTierNotifier,
            builder: (context, selectedTier, _) {
              final sourceProducts = _isEid ? _kEidProducts : store.products;
              final filteredProducts = sourceProducts.where((p) {
                if (selectedTier == 'all') return true;
                return p.category == selectedTier;
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section Header & Filter Tabs (Full Width Space-Between)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: mobile ? 20 : 28),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: _kSurfaceHigh)),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 580),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      _isEid
                                          ? '✦  KOLEKSI HAMPERS & PAKET RAYA IDUL FITRI 1448 H  ✦'
                                          : '✦  KOLEKSI EKSKLUSIF TAHUN BARU 2027  ✦',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: _jakarta(
                                        mobile ? 10 : 11.5,
                                        weight: FontWeight.w700,
                                        color: _kSecondary,
                                        spacing: mobile ? 1.2 : 2.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isEid
                                    ? 'Katalog Hampers Idul Fitri & Paket Lebaran'
                                    : store.catalogTitle,
                                style: _cormorant(
                                  mobile ? 28 : 38,
                                  weight: FontWeight.w600,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isEid
                                    ? 'Tersedia lengkap mulai dari Paket Lebaran Praktis (Biskuit Kaleng & Sirup untuk THR Karyawan) hingga Hardbox Kayu Jati VVIP untuk Direksi & Mitra Utama.'
                                    : 'Pilih klasifikasi anggaran untuk memfilter koleksi bingkisan Tahun Baru 2027 yang sesuai dengan alokasi dana HRD, Procurement, dan Direksi perseroan Anda.',
                                style: _jakarta(
                                  mobile ? 12.5 : 13.5,
                                  color: _kOnSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Filter Tabs (2x2 Equal Grid on Mobile, Capsule Wrap on Desktop)
                        if (mobile)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _kCardSurface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: _kCardBorder),
                              boxShadow: _kCardShadow,
                            ),
                            child: LayoutBuilder(
                              builder: (context, filterConstraints) {
                                final tabWidth =
                                    (filterConstraints.maxWidth - 6) / 2;
                                const mobileTabs = [
                                  ('all', 'Semua Anggaran'),
                                  ('smart', 'Smart (< Rp 500rb)'),
                                  ('standard', 'Standard (500rb - 1 Jt)'),
                                  ('vip', 'VIP (> Rp 1,5 Jt)'),
                                ];
                                return Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    for (final tab in mobileTabs)
                                      SizedBox(
                                        width: tabWidth,
                                        child: InkWell(
                                          onTap: () => _selectedTierNotifier
                                              .value = tab.$1,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 10,
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: selectedTier == tab.$1
                                                  ? _kGoldAccent
                                                  : _kCardInner,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              border: Border.all(
                                                color: selectedTier == tab.$1
                                                    ? _kGoldDark.withValues(
                                                        alpha: 0.55)
                                                    : _kCardBorder,
                                              ),
                                            ),
                                            child: Text(
                                              tab.$2,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: _jakarta(
                                                11,
                                                weight: selectedTier == tab.$1
                                                    ? FontWeight.w700
                                                    : FontWeight.w600,
                                                color: selectedTier == tab.$1
                                                    ? _kCardTextPrimary
                                                    : _kCardTextMuted,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _kCardSurface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: _kCardBorder),
                              boxShadow: _kCardShadow,
                            ),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                for (final tab in const [
                                  ('all', 'Semua Anggaran'),
                                  ('smart', 'Smart Volume (< Rp 500rb)'),
                                  (
                                    'standard',
                                    'Corporate Standard (Rp 500rb - 1 Jt)'
                                  ),
                                  ('vip', 'Executive & VIP (> Rp 1,5 Jt)'),
                                ])
                                  InkWell(
                                    onTap: () =>
                                        _selectedTierNotifier.value = tab.$1,
                                    borderRadius: BorderRadius.circular(7),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: selectedTier == tab.$1
                                            ? _kGoldAccent
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                          color: selectedTier == tab.$1
                                              ? _kGoldDark.withValues(
                                                  alpha: 0.5)
                                              : Colors.transparent,
                                        ),
                                      ),
                                      child: Text(
                                        tab.$2,
                                        style: _jakarta(
                                          12,
                                          weight: selectedTier == tab.$1
                                              ? FontWeight.w700
                                              : FontWeight.w600,
                                          color: selectedTier == tab.$1
                                              ? _kCardTextPrimary
                                              : _kCardTextMuted,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: mobile ? 24 : 44),

                  // Product Grid: 3-Column Layout
                  LayoutBuilder(
                    builder: (context, c) {
                      final cols =
                          c.maxWidth >= 980 ? 3 : (c.maxWidth >= 640 ? 2 : 1);
                      return _buildEqualHeightGrid(
                        columns: cols,
                        spacing: mobile ? 20 : 28,
                        runSpacing: mobile ? 20 : 28,
                        children: [
                          for (final product in filteredProducts)
                            _buildHamperCard(product, mobile: mobile),
                          _buildCustomTailoredCard(mobile: mobile),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHamperCard(Product product, {bool mobile = false}) {
    final spec = _kHamperSpecs[product.id];
    final dimensions = spec?.dimensions ??
        (product.featureLabel.contains('•')
            ? product.featureLabel.split('•').first.trim()
            : product.featureLabel);
    final shortMaterial = spec?.shortMaterial ??
        (product.featureLabel.contains('•')
            ? product.featureLabel.split('•').last.trim()
            : 'Hardbox Eksklusif');
    final fullMaterial = spec?.fullMaterial ?? product.featureLabel;
    final subBadge = spec?.subBadge ?? 'Kemasan Eksklusif B2B';
    final sashLabel = spec?.sashLabel ??
        (product.category == 'vip'
            ? 'VIP'
            : (product.category == 'standard' ? 'Best Seller' : 'Populer'));
    final items = spec?.items ??
        const [
          '1x Artisan Gourmet Cake / Pastry Bersertifikat Halal',
          '1x Premium Loose-Leaf Tea / Forest Honey Jar',
          '1x Kartu Ucapan Foil Emas Custom Kop PT',
          '1x Custom Hangtag & Pita Satin Tahun Baru 2027',
        ];

    final isVip = product.category == 'vip';
    final isStandard = product.category == 'standard';
    final tierMicroLabel = _isEid
        ? (isVip
            ? 'IDUL FITRI 1448 H  •  TIER VIP'
            : (isStandard
                ? 'IDUL FITRI 1448 H  •  TIER STANDARD'
                : 'IDUL FITRI 1448 H  •  PAKET RAYA & THR'))
        : (isVip
            ? 'KOLEKSI 2027  •  TIER VIP'
            : (isStandard
                ? 'KOLEKSI 2027  •  TIER STANDARD'
                : 'KOLEKSI 2027  •  SMART VOLUME'));
    final badgeBg = isVip
        ? _activePrimary.withValues(alpha: 0.94)
        : (isStandard ? _kGoldDark : _activePrimaryContainer);
    final badgeFg = isVip ? _kTertiaryFixed : Colors.white;
    final soldOut = product.soldOut;

    return Hover(
      builder: (context, hovered) => Container(
        decoration: BoxDecoration(
          color: _kCardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hovered ? _kGoldDark : _kCardBorder,
            width: hovered ? 1.5 : 1.1,
          ),
          boxShadow: _kCardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image + Badges + Corner Ribbon Sash + Price
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(
                    src: product.image,
                    emoji: product.emoji,
                    fit: BoxFit.cover,
                    grayscale: soldOut,
                    cacheWidth: 520,
                  ),
                  // Top Left Tier & Material Badges (Soft Frosted Pearl Badges)
                  Positioned(
                    top: mobile ? 10 : 12,
                    left: mobile ? 10 : 12,
                    right: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (product.badge.isNotEmpty)
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color:
                                          _kGoldAccent.withValues(alpha: 0.65),
                                      width: 0.9,
                                    ),
                                  ),
                                  child: Text(
                                    product.badge,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: _jakarta(
                                      10.5,
                                      weight: FontWeight.w700,
                                      color: badgeFg,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: soldOut
                                    ? const Color(0xFFFEE2E2)
                                    : const Color(0xFFD6EEE1),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                soldOut ? 'Slot Penuh' : 'Tersedia',
                                style: _jakarta(
                                  10,
                                  weight: FontWeight.w700,
                                  color: soldOut
                                      ? const Color(0xFF991B1B)
                                      : const Color(0xFF145840),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: _kBadgeGlass,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: _kGoldAccent.withValues(alpha: 0.75),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            subBadge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _jakarta(
                              10,
                              weight: FontWeight.w600,
                              color: _kBadgeText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Diagonal Black & Gold Corner Ribbon Sash (Top Right)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: _CornerRibbonSash(
                        label: sashLabel,
                        isGold: !isVip,
                      ),
                    ),
                  ),

                  // Price Pill (Bottom Right — Soft Frosted Pearl + Gold Border)
                  Positioned(
                    bottom: mobile ? 10 : 12,
                    right: mobile ? 10 : 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: mobile ? 10 : 12,
                          vertical: mobile ? 5 : 6),
                      decoration: BoxDecoration(
                        color: _kBadgeGlass,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: _kGoldAccent.withValues(alpha: 0.85),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.14),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          if (product.hasDiscount) ...[
                            Text(
                              rupiah(product.originalPrice!),
                              style: _jakarta(
                                mobile ? 10 : 11,
                                color: _kCardTextMuted.withValues(alpha: 0.65),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                          Text(
                            rupiah(product.price),
                            style: _cormorant(
                              mobile ? 18 : 20,
                              weight: FontWeight.w700,
                              color: _kBadgeText,
                            ),
                          ),
                          Text(
                            ' / box',
                            style: _jakarta(
                              mobile ? 10 : 11,
                              color: _kCardTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Body (Soft Porcelain White & Warm Alabaster)
            Padding(
              padding: EdgeInsets.all(mobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        size: 12,
                        color: _kGoldDark,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          tierMicroLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _jakarta(
                            mobile ? 9.5 : 10,
                            weight: FontWeight.w700,
                            color: _kGoldDark,
                            spacing: mobile ? 1.1 : 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _cormorant(
                      mobile ? 21 : 24,
                      weight: FontWeight.w700,
                      color: hovered ? _kGoldDark : _kCardTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _jakarta(
                      12,
                      color: _kCardTextMuted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dimension Pill (Warm Alabaster Inner Box)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: mobile ? 10 : 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _kCardInner,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _kCardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.aspect_ratio_rounded,
                                  size: 15, color: _kGoldDark),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  dimensions,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: _jakarta(
                                    mobile ? 11 : 11.5,
                                    weight: FontWeight.w700,
                                    color: _kCardTextPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            shortMaterial,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: _jakarta(
                              mobile ? 10.5 : 11,
                              color: _kCardTextMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Curated Items
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: _kCardBorder),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ISI KURASI EKSKLUSIF:',
                          style: _jakarta(
                            10,
                            weight: FontWeight.w700,
                            color: _kGoldDark,
                            spacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final item in items)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    size: 14,
                                    color: _kGoldDark,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(
                                    item,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: _jakarta(
                                      11.5,
                                      color: _kCardTextMuted,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Bottom Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _kCardInner,
                            foregroundColor: _kCardTextPrimary,
                            side: const BorderSide(color: _kCardBorder),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 13),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          onPressed: () => _openSpecModal(
                            title: product.name,
                            price: '${rupiah(product.price)} / box',
                            dimensions: dimensions,
                            material: fullMaterial,
                          ),
                          icon: const Icon(Icons.info_outline_rounded,
                              size: 15, color: _kGoldDark),
                          label: Text(
                            'Rincian Dimensi',
                            style: _jakarta(11.5,
                                weight: FontWeight.w700,
                                color: _kCardTextPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              soldOut ? _kOutlineVariant : _activePrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: soldOut
                            ? null
                            : () {
                                context.read<StoreBloc>().add(
                                      StoreEvent.addToCart(product: product),
                                    );
                                showToast(
                                  context,
                                  '${product.name} ditambahkan ke keranjang',
                                  icon: Icons.check_circle_outline_rounded,
                                );
                              },
                        child: Text(
                          soldOut ? 'Habis' : 'Pesan',
                          style: _jakarta(11.5,
                              weight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTailoredCard({bool mobile = false}) {
    return Container(
      padding: EdgeInsets.all(mobile ? 20 : 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _activePrimary,
            _activePrimaryContainer,
            _activePrimaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _kGoldAccent.withValues(alpha: 0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: _activePrimary.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.tune_rounded,
                        size: 14, color: _kGoldAccent),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _isEid
                            ? 'CUSTOM PARCEL LEBARAN & THR'
                            : 'CUSTOM TAILORED HAMPERS',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _jakarta(
                          10.5,
                          weight: FontWeight.w700,
                          color: _kGoldAccent,
                          spacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isEid
                    ? 'Butuh Paket THR Karyawan atau Parcel Sembako Raya Kustom?'
                    : 'Punya Plafon Anggaran Khusus Per Box dari Manajemen?',
                style: _cormorant(
                  mobile ? 24 : 28,
                  weight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isEid
                    ? 'Kami melayani perakitan ribuan Paket Lebaran Praktis (Biskuit Kaleng, Sirup, Kurma, Sembako Premium) maupun Hardbox VVIP sesuai plafon RAB perusahaan Anda.'
                    : 'Tim spesialis kami siap meracik komposisi item hampers sesuai batasan Rencana Anggaran Biaya (RAB) perusahaan Anda dengan minimum kuantitas 30 box.',
                style: _jakarta(
                  12.5,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.55,
                ),
              ),
            ],
          ),
          SizedBox(height: mobile ? 18 : 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.all_inclusive_rounded,
                        size: 16, color: _kGoldAccent),
                    const SizedBox(width: 6),
                    Text(
                      'Opsi Kustomisasi Bebas:',
                      style: _jakarta(12,
                          weight: FontWeight.w700, color: _kGoldAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _isEid
                      ? 'Kombinasi Lapis Legit Wisman, Nastar Edam, Kurma Ajwa, Sirup & Biskuit Kaleng Lebaran, Sajadah Sutra, hingga Amplop THR berlogo PT.'
                      : 'Kombinasi cake gourmet, artisan coffee, tumbler termos grafir logo, scarf sutra, hingga mug keramik buatan pengrajin lokal.',
                  style: _jakarta(
                    11.5,
                    color: Colors.white.withValues(alpha: 0.78),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: mobile ? 18 : 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _kTertiaryFixed,
                foregroundColor: _activePrimaryDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: () => _scrollToKey(_quoteFormKey),
              child: Text(
                'KONSULTASIKAN ANGGARAN KHUSUS',
                style: _jakarta(
                  11.5,
                  weight: FontWeight.w700,
                  color: _activePrimaryDark,
                  spacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 3: PERSONALISASI LOGO & BRANDING PERUSAHAAN
  // (Midnight Navy & Dark Obsidian Glass Section with Gold Serif Numerals 01-04)
  // ---------------------------------------------------------------------------
  Widget _buildPersonalisasiSection(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 640;
    const techniques = [
      (
        numeral: '01',
        icon: Icons.stars_rounded,
        title: 'Hot Foil Stamping Emas & Perak',
        desc:
            'Lapisan foil logam premium (Gold, Silver, atau Rose Gold) yang dicetak timbul panas di atas tutup hardbox, menghasilkan kilau mewah Tahun Baru 2027.',
        rec: 'Rekomendasi: Hardbox Seri Countdown',
      ),
      (
        numeral: '02',
        icon: Icons.precision_manufacturing_outlined,
        title: 'Grafir Presisi Laser (Laser Engraved)',
        desc:
            'Ukiran laser mikron pada material kayu jati/pinus solid atau plat akrilik tebal. Tahan gores permanen, memberikan nuansa kontemporer yang otentik.',
        rec: 'Rekomendasi: Seri Kayu Jati & Pinus',
      ),
      (
        numeral: '03',
        icon: Icons.mark_email_read_outlined,
        title: 'Kaligrafi & Segel Lilin Emas (Gold Wax Seal)',
        desc:
            'Kartu ucapan Tahun Baru 2027 dengan kop resmi perusahaan, dipadukan stempel segel lilin emas tradisional yang memuat monogram logo perseroan.',
        rec: 'Rekomendasi: Surat Pesan Direksi VIP',
      ),
      (
        numeral: '04',
        icon: Icons.bookmarks_outlined,
        title: 'Custom Sleeve & Pita Emboss 2027',
        desc:
            'Sleeve jaket kemasan penuh warna korporat (Full Corporate Pantone Matching) dan pita satin anyaman jacquard bertekstur logo Anda.',
        rec: 'Rekomendasi: Smart Volume Series',
      ),
    ];

    return Container(
      key: _personalisasiKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 14 : 24,
        vertical: mobile ? 48 : 84,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _activePrimaryDark,
            _activePrimary,
            _activePrimaryContainer,
            _activePrimaryDark,
          ],
        ),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: _kGoldAccent.withValues(alpha: 0.45),
            width: 1.2,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            children: [
              _buildOrnamentalGoldDivider(onDark: true),
              const SizedBox(height: 14),
              Text(
                '✦  PILAR PERSONALISASI KORPORAT  ✦',
                textAlign: TextAlign.center,
                style: _jakarta(
                  mobile ? 10.5 : 11.5,
                  weight: FontWeight.w700,
                  color: _kTertiaryFixed,
                  spacing: mobile ? 1.5 : 2.2,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 740),
                child: Text(
                  'Jadikan Brand Perusahaan Anda Tampil Memikat di Meja Klien & Direksi',
                  textAlign: TextAlign.center,
                  style: _cormorant(
                    mobile ? 28 : 38,
                    weight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  'Sentuhan identitas korporat yang berkelas, harmonis, dan tidak berlebihan. Kami memastikan nama dan logo perusahaan Anda terpampang dengan estetika tinggi pada setiap bingkisan Tahun Baru 2027.',
                  textAlign: TextAlign.center,
                  style: _jakarta(
                    mobile ? 12.5 : 13.5,
                    color: Colors.white.withValues(alpha: 0.78),
                    height: 1.55,
                  ),
                ),
              ),
              SizedBox(height: mobile ? 28 : 48),
              LayoutBuilder(
                builder: (context, c) {
                  final cols =
                      c.maxWidth >= 980 ? 4 : (c.maxWidth >= 600 ? 2 : 1);
                  return _buildEqualHeightGrid(
                    columns: cols,
                    spacing: mobile ? 16 : 24,
                    runSpacing: mobile ? 16 : 24,
                    children: [
                      for (final t in techniques)
                        Hover(
                          builder: (context, hovered) => Container(
                            padding: EdgeInsets.all(mobile ? 18 : 24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: _isEid
                                    ? const [
                                        Color(0xFF0E382A),
                                        Color(0xFF072219),
                                      ]
                                    : const [
                                        Color(0xFF152036),
                                        Color(0xFF0E1627),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: hovered
                                    ? _kTertiaryFixed
                                    : _kGoldAccent.withValues(alpha: 0.38),
                                width: hovered ? 1.5 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: _kGoldAccent
                                                .withValues(alpha: 0.14),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: _kGoldAccent
                                                  .withValues(alpha: 0.55),
                                            ),
                                          ),
                                          child: Icon(
                                            t.icon,
                                            color: _kTertiaryFixed,
                                            size: 21,
                                          ),
                                        ),
                                        Text(
                                          t.numeral,
                                          style: _cormorant(
                                            mobile ? 34 : 38,
                                            weight: FontWeight.w700,
                                            style: FontStyle.italic,
                                            color: _kTertiaryFixed
                                                .withValues(alpha: 0.72),
                                            height: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      t.title,
                                      style: _cormorant(
                                        21,
                                        weight: FontWeight.w600,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      t.desc,
                                      style: _jakarta(
                                        12,
                                        color: Colors.white
                                            .withValues(alpha: 0.74),
                                        height: 1.55,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(top: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: _kGoldAccent
                                            .withValues(alpha: 0.22),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.auto_awesome_rounded,
                                        size: 12,
                                        color: _kTertiaryFixed,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          t.rec.toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: _jakarta(
                                            10,
                                            weight: FontWeight.w700,
                                            color: _kTertiaryFixed,
                                            spacing: 0.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              SizedBox(height: mobile ? 24 : 40),

              // 3D Digital Preview Banner (Obsidian/Emerald & Gold Luxury Banner)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(mobile ? 20 : 36),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      _activePrimaryContainer,
                      _activePrimary,
                      _activePrimaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _kTertiaryFixed.withValues(alpha: 0.6),
                    width: 1.3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final isWide = c.maxWidth >= 820;
                    final textColumn = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: mobile ? 10 : 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: _kGoldAccent.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: _kGoldAccent.withValues(alpha: 0.55),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.speed_rounded,
                                  size: 14, color: _kTertiaryFixed),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _isEid
                                      ? 'LAYANAN EKSKLUSIF IDUL FITRI 1448 H • SLA MOCKUP 2 JAM KERJA'
                                      : 'LAYANAN EKSKLUSIF TAHUN BARU 2027 • SLA MOCKUP 2 JAM KERJA',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: _jakarta(
                                    mobile ? 9.5 : 10.5,
                                    weight: FontWeight.w700,
                                    color: _kTertiaryFixed,
                                    spacing: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Preview 3D Digital Hamper dengan Logo Anda Gratis',
                          style: _cormorant(
                            mobile ? 23 : 30,
                            weight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Cukup kirimkan berkas logo perusahaan Anda dalam format vektor (.AI, .EPS, .PDF atau PNG High Resolution). Tim kreatif atelier kami akan membuatkan simulasi visual 3D lengkap untuk disertakan dalam dokumen presentasi pengadaan perusahaan Anda.',
                          style: _jakarta(
                            mobile ? 12 : 13,
                            color: Colors.white.withValues(alpha: 0.82),
                            height: 1.55,
                          ),
                        ),
                      ],
                    );

                    final actionBtn = ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kTertiaryFixed,
                        foregroundColor: _activePrimaryDark,
                        elevation: 4,
                        shadowColor: _kGoldAccent.withValues(alpha: 0.4),
                        padding: EdgeInsets.symmetric(
                            horizontal: mobile ? 18 : 26,
                            vertical: mobile ? 15 : 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _scrollToKey(_quoteFormKey),
                      icon: Icon(Icons.cloud_upload_outlined,
                          size: 18, color: _activePrimaryDark),
                      label: Text(
                        'Upload Logo & Minta Mockup 3D',
                        style: _jakarta(mobile ? 12 : 12.5,
                            weight: FontWeight.w700, color: _activePrimaryDark),
                      ),
                    );

                    if (isWide) {
                      return Row(
                        children: [
                          Expanded(child: textColumn),
                          const SizedBox(width: 32),
                          actionBtn,
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        textColumn,
                        const SizedBox(height: 18),
                        actionBtn,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 4: LEGALITAS, FAKTUR PAJAK RESMI & DOWNLOAD E-PROPOSAL
  // (Executive Certificate Cards with Gold Seal Badges & Numerals 01-03)
  // ---------------------------------------------------------------------------
  Widget _buildLegalitasSection(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 640;
    const complianceCards = [
      (
        numeral: '01',
        icon: Icons.description_outlined,
        title: 'Faktur Pajak PPN 11% (e-Faktur Resmi)',
        desc:
            'Diterbitkan oleh PT Maison Cadeaux Indonesia (PKP Terdaftar) langsung ke NPWP korporasi Anda segera setelah pelunasan, memudahkan pelaporan rekonsiliasi pajak akhir tahun 2026.',
        bullets: [
          'Terintegrasi Sistem DJP Online',
          'Bukti Potong PPh 23 Siap Diproses',
        ],
      ),
      (
        numeral: '02',
        icon: Icons.receipt_outlined,
        title: 'Kelengkapan Audit: BAST & Meterai Rp 10.000',
        desc:
            'Dilengkapi Surat Jalan resmi, Berita Acara Serah Terima (BAST) per titik pengiriman, dan kuitansi asli bermaterai Rp 10.000 fisik / e-Meterai Peruri untuk arsip keuangan internal.',
        bullets: [
          'Tanda Terima Tervalidasi Penerima',
          'Laporan Pengiriman Real-Time (Excel)',
        ],
      ),
      (
        numeral: '03',
        icon: Icons.account_balance_outlined,
        title: 'Term of Payment (TOP) Korporasi',
        desc:
            'Skema pembayaran fleksibel bagi entitas PT yang telah terverifikasi: Down Payment (DP) 50% untuk booking slot logistik & produksi, dan pelunasan H-3 sebelum jadwal distribusi pertama.',
        bullets: [
          'Rekening Giro Perusahaan Resmi (Bank BUMN & Swasta Terdaftar OJK)',
          'Penerbitan SPK & Kontrak Kerja Sama',
        ],
      ),
    ];

    return Container(
      key: _legalitasKey,
      width: double.infinity,
      color: _kSurface,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 14 : 24,
        vertical: mobile ? 48 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildOrnamentalGoldDivider(),
              const SizedBox(height: 14),
              Text(
                '✦  PROCUREMENT COMPLIANT  ✦',
                textAlign: TextAlign.center,
                style: _jakarta(
                  mobile ? 10.5 : 11.5,
                  weight: FontWeight.w700,
                  color: _kSecondary,
                  spacing: mobile ? 1.5 : 2.2,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 740),
                child: Text(
                  'Tata Kelola Pengadaan Profesional & Kepatuhan Legalitas Perusahaan',
                  textAlign: TextAlign.center,
                  style: _cormorant(
                    mobile ? 27 : 36,
                    weight: FontWeight.w600,
                    height: 1.18,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  'Kami memahami standar ketat audit vendor perusahaan publik, BUMN, dan multinasional. Seluruh alur transaksi pengadaan Tahun Baru 2027 dijamin sesuai dengan hukum perpajakan Indonesia.',
                  textAlign: TextAlign.center,
                  style: _jakarta(
                    mobile ? 12.5 : 13.5,
                    color: _kOnSurfaceVariant,
                    height: 1.55,
                  ),
                ),
              ),
              SizedBox(height: mobile ? 28 : 48),
              LayoutBuilder(
                builder: (context, c) {
                  final cols =
                      c.maxWidth >= 960 ? 3 : (c.maxWidth >= 620 ? 2 : 1);
                  return _buildEqualHeightGrid(
                    columns: cols,
                    spacing: mobile ? 18 : 28,
                    runSpacing: mobile ? 18 : 28,
                    children: [
                      for (final card in complianceCards)
                        Hover(
                          builder: (context, hovered) => Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: _kCardSurface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: hovered
                                    ? _kGoldDark
                                    : _kGoldAccent.withValues(alpha: 0.45),
                                width: hovered ? 1.5 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _kPrimary.withValues(alpha: 0.06),
                                  blurRadius: 22,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Executive Certificate Top Gold Metallic Bar
                                Container(
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        _kGoldDark,
                                        _kTertiaryFixed,
                                        _kGoldDark,
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(mobile ? 18 : 28),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 46,
                                                height: 46,
                                                decoration: BoxDecoration(
                                                  color: _kPrimary,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: _kTertiaryFixed,
                                                    width: 1.5,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: _kGoldAccent
                                                          .withValues(
                                                              alpha: 0.25),
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  card.icon,
                                                  color: _kTertiaryFixed,
                                                  size: 20,
                                                ),
                                              ),
                                              Text(
                                                card.numeral,
                                                style: _cormorant(
                                                  mobile ? 34 : 38,
                                                  weight: FontWeight.w700,
                                                  style: FontStyle.italic,
                                                  color: _kGoldDark
                                                      .withValues(alpha: 0.72),
                                                  height: 1.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            card.title,
                                            style: _cormorant(
                                              mobile ? 21 : 23,
                                              weight: FontWeight.w700,
                                              color: _kCardTextPrimary,
                                              height: 1.2,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            card.desc,
                                            style: _jakarta(
                                              12,
                                              color: _kCardTextMuted,
                                              height: 1.55,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(top: 12),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: _kCardBorder,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            for (final b in card.bullets)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.verified_rounded,
                                                      size: 16,
                                                      color: _kGoldDark,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        b,
                                                        style: _jakarta(
                                                          12,
                                                          weight:
                                                              FontWeight.w600,
                                                          color:
                                                              _kCardTextPrimary,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              SizedBox(height: mobile ? 28 : 48),

              // Banner Download Proposal Direksi (Full Width Responsive Row)
              Container(
                key: _proposalKey,
                width: double.infinity,
                padding: EdgeInsets.all(mobile ? 20 : 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _activePrimaryDark,
                      _activePrimary,
                      _activePrimaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _kTertiaryFixed.withValues(alpha: 0.6),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _activePrimary.withValues(alpha: 0.24),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final isWide = c.maxWidth >= 820;

                    final leftCol = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: mobile ? 10 : 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: _kGoldAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                                color: _kGoldAccent.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            '✦  FORMAT SIAP PRESENTASI RAPAT DIREKSI 2026 / 2027',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _jakarta(
                              mobile ? 9.5 : 10.5,
                              weight: FontWeight.w700,
                              color: _kTertiaryFixed,
                              spacing: mobile ? 0.6 : 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Perlu Bahan untuk Pengajuan Rapat Direksi Hari Ini?',
                          style: _cormorant(
                            mobile ? 23 : 30,
                            weight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isEid
                              ? 'Unduh Paket E-Proposal Idul Fitri 1448 H Lengkap yang memuat katalog Paket Lebaran & VIP, legalitas PT, sertifikasi Halal & BPOM seluruh item, serta tabel diskon kuantitas grosir.'
                              : 'Unduh Paket E-Proposal Tahun Baru 2027 Lengkap yang memuat spesifikasi produk, legalitas PT, sertifikasi Halal & BPOM seluruh item, serta tabel diskon kuantitas grosir dalam 1 berkas terstruktur.',
                          style: _jakarta(
                            mobile ? 12 : 13,
                            weight: FontWeight.w300,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 14,
                          runSpacing: 8,
                          children: [
                            for (final m in [
                              (
                                Icons.picture_as_pdf_outlined,
                                'File: PDF 4.2 MB'
                              ),
                              (
                                Icons.update_rounded,
                                _isEid
                                    ? 'Edisi: Raya Idul Fitri 1448 H'
                                    : 'Edisi: Akhir Tahun 2026 — 2027'
                              ),
                              (
                                Icons.lock_open_rounded,
                                'Akses Langsung Bebas Registrasi'
                              ),
                            ])
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(m.$1, size: 15, color: _kGoldAccent),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      m.$2,
                                      style: _jakarta(11.5, color: _kGoldAccent),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    );

                    final downloadBtn = ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kTertiaryFixed,
                        foregroundColor: _activePrimaryDark,
                        elevation: 4,
                        shadowColor: _kGoldAccent.withValues(alpha: 0.4),
                        padding: EdgeInsets.symmetric(
                            horizontal: mobile ? 16 : 28,
                            vertical: mobile ? 15 : 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _triggerProposalDownload,
                      icon: Icon(Icons.download_for_offline_outlined,
                          size: 19, color: _activePrimaryDark),
                      label: Text(
                        mobile
                            ? 'DOWNLOAD PROPOSAL (PDF)'
                            : 'DOWNLOAD PROPOSAL DIREKSI (PDF)',
                        style: _jakarta(
                          mobile ? 11.5 : 12.5,
                          weight: FontWeight.w700,
                          color: _activePrimaryDark,
                          spacing: 0.8,
                        ),
                      ),
                    );

                    if (isWide) {
                      return Row(
                        children: [
                          Expanded(child: leftCol),
                          const SizedBox(width: 32),
                          downloadBtn,
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        leftCol,
                        const SizedBox(height: 20),
                        downloadBtn,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 5: FORMULIR CEPAT PENAWARAN GROSIR & LIVE WA PREVIEW
  // (VIP Concierge Lounge Form + Dark Midnight Navy & Gold Live WA Preview Card)
  // ---------------------------------------------------------------------------
  Widget _buildQuickQuoteSection(
    BuildContext context,
    StoreState state,
    StoreProfile store,
  ) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 980;
    final mobile = width < 640;

    return Container(
      key: _quoteFormKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 14 : 24,
        vertical: mobile ? 48 : 80,
      ),
      decoration: const BoxDecoration(
        color: _kSurfaceLow,
        border: Border(top: BorderSide(color: _kSurfaceHigh)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Column(
            children: [
              _buildOrnamentalGoldDivider(),
              const SizedBox(height: 14),
              Text(
                '✦  FAST-TRACK VIP B2B CONCIERGE  ✦',
                textAlign: TextAlign.center,
                style: _jakarta(
                  mobile ? 10.5 : 11.5,
                  weight: FontWeight.w700,
                  color: _kSecondary,
                  spacing: mobile ? 1.5 : 2.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Formulir Cepat Penawaran Harga Grosir & Ketersediaan Slot',
                textAlign: TextAlign.center,
                style: _cormorant(
                  mobile ? 27 : 36,
                  weight: FontWeight.w600,
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 660),
                child: Text(
                  'Khusus pengadaan korporat Tahun Baru 2027 (Min. 10 Box). Data Anda otomatis diformat menjadi pesan terstruktur dan dialihkan langsung ke WhatsApp tim Senior B2B Concierge kami untuk respon kilat 15 menit.',
                  textAlign: TextAlign.center,
                  style: _jakarta(
                    mobile ? 12.5 : 13.5,
                    color: _kOnSurfaceVariant,
                    height: 1.55,
                  ),
                ),
              ),
              SizedBox(height: mobile ? 26 : 44),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: _buildB2bFormCard(state, store, mobile: mobile),
                    ),
                    const SizedBox(width: 28),
                    Expanded(
                      flex: 5,
                      child: _buildLiveWaPreviewColumn(state, store,
                          mobile: mobile),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildB2bFormCard(state, store, mobile: mobile),
                    const SizedBox(height: 20),
                    _buildLiveWaPreviewColumn(state, store, mobile: mobile),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildB2bFormCard(
    StoreState state,
    StoreProfile store, {
    bool mobile = false,
  }) {
    final branches = store.branches;
    final activeBranch = state.selectedBranch;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _kCardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _kGoldAccent.withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: _kPrimary.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Metallic Champagne Gold Bar
          Container(
            height: 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_kGoldDark, _kTertiaryFixed, _kGoldDark],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(mobile ? 18 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Multi-branch / Atelier selector
                if (branches.isNotEmpty) ...[
                  Text(
                    'Pilih Atelier / Hub Distribusi Tujuan',
                    style: _jakarta(12,
                        weight: FontWeight.w700, color: _kCardTextPrimary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final b in branches)
                        InkWell(
                          onTap: () => context
                              .read<StoreBloc>()
                              .add(StoreEvent.selectBranch(b.id)),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: activeBranch?.id == b.id
                                  ? _kPrimary
                                  : _kCardInner,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: activeBranch?.id == b.id
                                    ? _kGoldAccent
                                    : _kCardBorder,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.storefront_rounded,
                                  size: 14,
                                  color: activeBranch?.id == b.id
                                      ? _kTertiaryFixed
                                      : _kGoldDark,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  b.name,
                                  style: _jakarta(
                                    11.5,
                                    weight: FontWeight.w700,
                                    color: activeBranch?.id == b.id
                                        ? Colors.white
                                        : _kCardTextPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                ],

                // Field 1: Company Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '1. Nama Perusahaan / Instansi PT *',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _jakarta(12,
                            weight: FontWeight.w700, color: _kCardTextPrimary),
                      ),
                    ),
                    if (!mobile)
                      Text(
                        'Wajib NPWP / PT / CV',
                        style: _jakarta(10.5, color: _kCardTextMuted),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _companyCtrl,
                  style: _jakarta(12.5, color: _kCardTextPrimary),
                  decoration: InputDecoration(
                    hintText: 'misal: PT Mandira Nusantara (Persero) Tbk',
                    hintStyle: _jakarta(12,
                        color: _kCardTextMuted.withValues(alpha: 0.65)),
                    prefixIcon: const Icon(Icons.apartment_rounded,
                        size: 18, color: _kGoldDark),
                    filled: true,
                    fillColor: _kCardInner,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: _kCardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: _kCardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: _kGoldDark, width: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Field 2: PIC & Division
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '2. Nama Lengkap PIC & Divisi *',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _jakarta(12,
                            weight: FontWeight.w700, color: _kCardTextPrimary),
                      ),
                    ),
                    if (!mobile)
                      Text(
                        'HRD / Procurement / Sekretariat',
                        style: _jakarta(10.5, color: _kCardTextMuted),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _picCtrl,
                  style: _jakarta(12.5, color: _kCardTextPrimary),
                  decoration: InputDecoration(
                    hintText: 'misal: Anita Wardani - HR & GA Department',
                    hintStyle: _jakarta(12,
                        color: _kCardTextMuted.withValues(alpha: 0.65)),
                    prefixIcon: const Icon(Icons.badge_outlined,
                        size: 18, color: _kGoldDark),
                    filled: true,
                    fillColor: _kCardInner,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: _kCardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: _kCardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: _kGoldDark, width: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Field 3: Estimated Box Quantity
                Text(
                  '3. Estimasi Jumlah Box (Minimal 10 Box) *',
                  style: _jakarta(12,
                      weight: FontWeight.w700, color: _kCardTextPrimary),
                ),
                const SizedBox(height: 6),
                ValueListenableBuilder<String>(
                  valueListenable: _selectedBoxQtyNotifier,
                  builder: (context, selectedBoxQty, _) =>
                      DropdownButtonFormField<String>(
                    initialValue: selectedBoxQty,
                    dropdownColor: _kCardInner,
                    iconEnabledColor: _kGoldDark,
                    isExpanded: true,
                    style: _jakarta(12.5, color: _kCardTextPrimary),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.inventory_2_outlined,
                          size: 18, color: _kGoldDark),
                      filled: true,
                      fillColor: _kCardInner,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _kCardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _kCardBorder),
                      ),
                    ),
                    items: [
                      for (final opt in _kQuantityOptions)
                        DropdownMenuItem(
                          value: opt,
                          child: Text(opt,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  _jakarta(12.5, color: _kCardTextPrimary)),
                        ),
                    ],
                    onChanged: (val) {
                      if (val != null) _selectedBoxQtyNotifier.value = val;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Field 4: Delivery Target Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '4. Rencana Tanggal Pengiriman *',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _jakarta(12,
                            weight: FontWeight.w700, color: _kCardTextPrimary),
                      ),
                    ),
                    if (!mobile)
                      Text(
                        'Batas Aman: 20 Des 2026',
                        style: _jakarta(10.5,
                            weight: FontWeight.w700, color: _kGoldDark),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _dateCtrl,
                  style: _jakarta(12.5, color: _kCardTextPrimary),
                  decoration: InputDecoration(
                    hintText: 'misal: 20 - 30 Desember 2026',
                    hintStyle: _jakarta(12,
                        color: _kCardTextMuted.withValues(alpha: 0.65)),
                    prefixIcon: const Icon(Icons.calendar_month_outlined,
                        size: 18, color: _kGoldDark),
                    filled: true,
                    fillColor: _kCardInner,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: _kCardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: _kCardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: _kGoldDark, width: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _activePrimary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: mobile ? 12 : 18, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: _kGoldAccent.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    onPressed: () => _submitB2bQuote(state, store),
                    icon: Icon(Icons.chat_outlined,
                        size: mobile ? 18 : 20, color: _kTertiaryFixed),
                    label: Text(
                      mobile
                          ? 'Kirim Penawaran via WhatsApp'
                          : 'Kirim Penawaran via WhatsApp (Respon 15 Menit)',
                      style: _jakarta(mobile ? 12 : 13,
                          weight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 18,
                  runSpacing: 6,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline_rounded,
                            size: 14, color: _kGoldDark),
                        const SizedBox(width: 4),
                        Text('Kerahasiaan Data Terjamin',
                            style: _jakarta(11, color: _kCardTextMuted)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_outlined,
                            size: 14, color: _kGoldDark),
                        const SizedBox(width: 4),
                        Text('Langsung Terhubung Senior B2B',
                            style: _jakarta(11, color: _kCardTextMuted)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveWaPreviewColumn(
    StoreState state,
    StoreProfile store, {
    bool mobile = false,
  }) {
    final activeBranch = state.selectedBranch;
    final hotline = _formatHotline(store.whatsapp);

    return Column(
      children: [
        // Dark Midnight Navy / Royal Emerald & Champagne Gold Live WA Preview Card
        Container(
          padding: EdgeInsets.all(mobile ? 18 : 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _activePrimaryDark,
                _activePrimary,
                _activePrimaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _kTertiaryFixed.withValues(alpha: 0.65),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: _activePrimary.withValues(alpha: 0.22),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _kGoldAccent.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _kGoldAccent.withValues(alpha: 0.16),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _kTertiaryFixed.withValues(alpha: 0.65),
                              ),
                            ),
                            child: const Icon(Icons.support_agent_rounded,
                                size: 18, color: _kTertiaryFixed),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pratinjau Pesan Otomatis',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: _jakarta(12.5,
                                      weight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Text(
                                  'VIP Concierge • Siap Kirim',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: _jakarta(10.5,
                                      color: _kTertiaryFixed),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: _kGoldAccent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: _kGoldAccent.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        'Draft Auto-Sync',
                        style: _jakarta(10,
                            weight: FontWeight.w700, color: _kTertiaryFixed),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListenableBuilder(
                listenable: Listenable.merge([
                  _companyCtrl,
                  _picCtrl,
                  _dateCtrl,
                  _selectedBoxQtyNotifier,
                ]),
                builder: (context, _) {
                  final picText = _picCtrl.text.trim().isNotEmpty
                      ? _picCtrl.text.trim()
                      : '[Nama PIC]';
                  final companyText = _companyCtrl.text.trim().isNotEmpty
                      ? _companyCtrl.text.trim()
                      : '[Nama Perusahaan PT]';
                  final dateText = _dateCtrl.text.trim().isNotEmpty
                      ? _dateCtrl.text.trim()
                      : '20 - 30 Desember 2026';

                  return Container(
                    padding: EdgeInsets.all(mobile ? 14 : 16),
                    decoration: BoxDecoration(
                      color: _activePrimaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _kGoldAccent.withValues(alpha: 0.42),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"Halo Tim B2B ${store.name},',
                          style: _jakarta(12,
                              weight: FontWeight.w700, color: _kTertiaryFixed),
                        ),
                        const SizedBox(height: 6),
                        RichText(
                          text: TextSpan(
                            style: _jakarta(
                              12,
                              color: Colors.white.withValues(alpha: 0.88),
                              height: 1.48,
                            ),
                            children: [
                              const TextSpan(text: 'Saya '),
                              TextSpan(
                                text: picText,
                                style: _jakarta(12,
                                    weight: FontWeight.w700,
                                    color: _kTertiaryFixed),
                              ),
                              const TextSpan(text: ' dari '),
                              TextSpan(
                                text: companyText,
                                style: _jakarta(12,
                                    weight: FontWeight.w700,
                                    color: _kTertiaryFixed),
                              ),
                              const TextSpan(
                                  text:
                                      ' ingin mengajukan penawaran resmi untuk '),
                              TextSpan(
                                text: _isEid
                                    ? 'Hampers Idul Fitri 1448 H / Lebaran'
                                    : 'Hampers Tahun Baru 2027',
                                style: _jakarta(12,
                                    weight: FontWeight.w700,
                                    color: _kTertiaryFixed),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _activePrimaryDark.withValues(alpha: 0.72),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _kGoldAccent.withValues(alpha: 0.32),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (activeBranch != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    '📍 Atelier Tujuan: ${activeBranch.name}',
                                    style: _jakarta(
                                      11,
                                      weight: FontWeight.w600,
                                      color: _kTertiaryFixed,
                                    ),
                                  ),
                                ),
                              Text(
                                '📦 Estimasi Kuantitas: ${_selectedBoxQtyNotifier.value}',
                                style: _jakarta(
                                  11,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '📅 Jadwal Pengiriman: $dateText',
                                style: _jakarta(
                                  11,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Mohon kirimkan draft penawaran resmi (Quotation) lengkap dengan Faktur Pajak PPN 11% dan katalog spesifikasi produk 2027. Terima kasih."',
                          style: _jakarta(
                            12,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.verified_rounded,
                                size: 12,
                                color: _kTertiaryFixed,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Prioritas VIP • Resmi PKP Terverifikasi',
                                style: _jakarta(
                                  10,
                                  weight: FontWeight.w600,
                                  color: _kTertiaryFixed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _kGoldAccent.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 16, color: _kTertiaryFixed),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Setelah klik tombol kirim, jendela WhatsApp Anda akan terbuka otomatis dengan teks penawaran resmi yang telah terisi rapi.',
                        style: _jakarta(
                          11,
                          color: Colors.white.withValues(alpha: 0.75),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Hotline Direct Card
        Container(
          padding: EdgeInsets.all(mobile ? 16 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _activePrimaryDark,
                _activePrimary,
                _activePrimaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kGoldAccent.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BUTUH KOORDINASI DARURAT DIREKSI?',
                      style: _jakarta(
                        10,
                        weight: FontWeight.w700,
                        color: _kGoldAccent,
                        spacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hotline: $hotline',
                      style: _cormorant(
                        mobile ? 19 : 21,
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.phone_in_talk_rounded,
                  size: 28, color: _kTertiaryFixed),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // FOOTER: CORPORATE NEW YEAR 2027 / IDUL FITRI 1448 H TIER
  // ---------------------------------------------------------------------------
  Widget _buildFooterSection(BuildContext context, StoreProfile store) {
    final mobile = MediaQuery.sizeOf(context).width < 640;

    return Container(
      width: double.infinity,
      color: _activePrimaryDark,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 16 : 24,
        vertical: mobile ? 44 : 64,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, c) {
                  final cols =
                      c.maxWidth >= 960 ? 4 : (c.maxWidth >= 600 ? 2 : 1);
                  final gap = 36.0;
                  final colW = (c.maxWidth - gap * (cols - 1)) / cols;

                  return Wrap(
                    spacing: gap,
                    runSpacing: mobile ? 24 : 32,
                    children: [
                      // Col 1: Brand Info
                      SizedBox(
                        width: colW,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.name.toUpperCase(),
                              style: _cormorant(
                                24,
                                weight: FontWeight.w700,
                                color: Colors.white,
                                spacing: 2.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'CORPORATE NEW YEAR 2027 HAMPERS & GIFTING',
                              style: _jakarta(
                                9,
                                weight: FontWeight.w600,
                                color: _kGoldAccent,
                                spacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              store.footerDesc,
                              style: _jakarta(
                                12,
                                color: Colors.white.withValues(alpha: 0.7),
                                height: 1.55,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'PT Maison Cadeaux Indonesia',
                              style: _jakarta(
                                12,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'NPWP: 81.932.482.1-014.000 (PKP Terdaftar)',
                              style: _jakarta(
                                11.5,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Col 2: Navigation
                      SizedBox(
                        width: colW,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NAVIGASI PENGADAAN B2B',
                              style: _jakarta(
                                11.5,
                                weight: FontWeight.w700,
                                color: _kGoldAccent,
                                spacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            for (final nav in [
                              (
                                'Katalog Tingkatan Anggaran (Tiering)',
                                _katalogKey
                              ),
                              ('Spesifikasi Box Kayu & Hardbox', _katalogKey),
                              (
                                'Bespoke Hot-Stamping & Kartu Ucapan',
                                _personalisasiKey
                              ),
                              (
                                'Faktur Pajak Elektronik & SOP Pengadaan',
                                _legalitasKey
                              ),
                              (
                                'Alokasi Grosir & Bulk Dispatch Tracker',
                                _quoteFormKey
                              ),
                            ])
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: InkWell(
                                  onTap: () => _scrollToKey(nav.$2),
                                  child: Text(
                                    nav.$1,
                                    style: _jakarta(
                                      12,
                                      color:
                                          Colors.white.withValues(alpha: 0.72),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Col 3: Compliance & Legal
                      SizedBox(
                        width: colW,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KEPATUHAN & LEGALITAS',
                              style: _jakarta(
                                11.5,
                                weight: FontWeight.w700,
                                color: _kGoldAccent,
                                spacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            for (final item in const [
                              (
                                Icons.shield_outlined,
                                'Faktur Pajak Standar (e-Faktur)',
                                'Penerbitan faktur pajak resmi bersamaan invoice dan kuitansi bermeterai.'
                              ),
                              (
                                Icons.verified_outlined,
                                'Sertifikasi Halal & BPOM RI',
                                '100% item kuliner terkurasi memiliki izin edar resmi Republik Indonesia.'
                              ),
                              (
                                Icons.description_outlined,
                                'Dokumen Legalitas Lengkap',
                                'NIB, SPK, Pakta Integritas Vendor, & Rekening Giro Bank BUMN/Swasta.'
                              ),
                            ])
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(item.$1,
                                        size: 16, color: _kGoldAccent),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.$2,
                                            style: _jakarta(
                                              12,
                                              weight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.$3,
                                            style: _jakarta(
                                              11,
                                              color: Colors.white
                                                  .withValues(alpha: 0.6),
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Col 4: Atelier & Showroom
                      SizedBox(
                        width: colW,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PRIVATE ATELIER SHOWROOM',
                              style: _jakarta(
                                11.5,
                                weight: FontWeight.w700,
                                color: _kGoldAccent,
                                spacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Kunjungi ruang kurasi kami untuk inspeksi material box kayu, food tasting, dan konsultasi ribbon swatch langsung.',
                              style: _jakarta(
                                12,
                                color: Colors.white.withValues(alpha: 0.7),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Maison Cadeaux Private Atelier',
                              style: _jakarta(
                                12,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              store.address,
                              style: _jakarta(
                                11,
                                color: Colors.white.withValues(alpha: 0.62),
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Operasional: Senin - Jumat (09.00 - 18.00 WIB)',
                              style: _jakarta(11, color: _kGoldAccent),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: _triggerProposalDownload,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.file_present_outlined,
                                      size: 15, color: Colors.white),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'Unduh Company Profile & Legalitas (ZIP)',
                                      style: _jakarta(
                                        11.5,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 44),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  border: Border(
                    top:
                        BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 24,
                  runSpacing: 12,
                  children: [
                    Text(
                      '© 2026 PT Maison Cadeaux Indonesia. Seluruh hak cipta dilindungi undang-undang. Spesialis Kurasi Hamper Korporat Mewah Edisi Tahun Baru 2027.',
                      style: _jakarta(
                        11.5,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    Wrap(
                      spacing: 20,
                      runSpacing: 8,
                      children: [
                        for (final label in const [
                          'Syarat & Ketentuan Pengadaan',
                          'Kebijakan Privasi Klien',
                          'Dukungan Logistik Multi-Alamat',
                        ])
                          Text(
                            label,
                            style: _jakarta(
                              11.5,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Hover(
      onTap: onTap,
      builder: (context, hovered) => Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive
                  ? _kPrimary
                  : (hovered ? _kGoldDark : Colors.transparent),
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: _jakarta(
            12.5,
            weight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: hovered
                ? _kGoldDark
                : (isActive ? _kPrimary : _kOnSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

class _HeroTopBadge extends StatelessWidget {
  const _HeroTopBadge({
    required this.icon,
    required this.label,
    required this.fg,
  });

  final IconData icon;
  final String label;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: _kGoldAccent.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: _jakarta(11.5, weight: FontWeight.w500, color: fg),
          ),
        ],
      ),
    );
  }
}

/// Gold-bordered Countdown Box for New Year 2025 Header Banner
class _CountdownPill extends StatelessWidget {
  const _CountdownPill({required this.value, required this.unit});

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: _kPrimaryContainer,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: _kGoldAccent.withValues(alpha: 0.55)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: _jakarta(
                11.5,
                weight: FontWeight.w700,
                color: _kTertiaryFixed,
              ),
            ),
            TextSpan(
              text: unit,
              style: _jakarta(
                10.5,
                weight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Diagonal Black-and-Gold Corner Ribbon Sash on Catalog Product Cards
class _CornerRibbonSash extends StatelessWidget {
  const _CornerRibbonSash({
    required this.label,
    this.isGold = false,
  });

  final String label;
  final bool isGold;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      height: 108,
      child: CustomPaint(
        painter: _CornerRibbonPainter(
          label: label.toUpperCase(),
          isGold: isGold,
          fontFamily: _kJakartaFamily,
        ),
      ),
    );
  }
}

class _CornerRibbonPainter extends CustomPainter {
  const _CornerRibbonPainter({
    required this.label,
    required this.isGold,
    required this.fontFamily,
  });

  final String label;
  final bool isGold;
  final String? fontFamily;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Move to center of diagonal sash in top-right corner
    canvas.translate(size.width * 0.64, size.height * 0.36);
    canvas.rotate(math.pi / 4);

    const ribbonWidth = 148.0;
    const ribbonHeight = 25.0;
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: ribbonWidth,
      height: ribbonHeight,
    );

    // Subtle drop shadow
    canvas.drawRect(
      rect.shift(const Offset(0, 2)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.32)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Ribbon fill gradient (Obsidian Black & Gold or Champagne Gold)
    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: isGold
            ? const [Color(0xFFB69156), Color(0xFFE3BE80), Color(0xFFB69156)]
            : const [Color(0xFF060A12), Color(0xFF141E30), Color(0xFF060A12)],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // Gold trim lines along top and bottom of sash
    final borderPaint = Paint()
      ..color = isGold
          ? const Color(0xFF0B1220).withValues(alpha: 0.45)
          : const Color(0xFFE3BE80).withValues(alpha: 0.85)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(-ribbonWidth / 2, -ribbonHeight / 2 + 2),
      Offset(ribbonWidth / 2, -ribbonHeight / 2 + 2),
      borderPaint,
    );
    canvas.drawLine(
      Offset(-ribbonWidth / 2, ribbonHeight / 2 - 2),
      Offset(ribbonWidth / 2, ribbonHeight / 2 - 2),
      borderPaint,
    );

    // Ribbon label text
    final tp = TextPainter(
      text: TextSpan(
        text: '★ $label ★',
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: isGold ? const Color(0xFF060A12) : const Color(0xFFE3BE80),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CornerRibbonPainter oldDelegate) =>
      oldDelegate.label != label || oldDelegate.isGold != isGold;
}

/// Custom Painter for the New Year Hero Celebration Backdrop:
/// Draws subtle ambient gold radial lighting, clean city skyline silhouette,
/// and delicate corner sparkles. Zero overlapping watermark text for absolute clarity.
class _NewYearHeroBackdropPainter extends CustomPainter {
  const _NewYearHeroBackdropPainter({this.cormorantFamily});

  final String? cormorantFamily;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final mobile = w < 640;

    // 1. Ambient Champagne Gold Radial Glows (Soft luxury vignette)
    final leftGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFE3BE80).withValues(alpha: mobile ? 0.09 : 0.14),
          const Color(0xFFE3BE80).withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: Offset(w * 0.15, h * 0.18), radius: 340),
      );
    canvas.drawCircle(Offset(w * 0.15, h * 0.18), 340, leftGlow);

    final rightGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD4B37A).withValues(alpha: mobile ? 0.11 : 0.16),
          const Color(0xFFD4B37A).withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: Offset(w * 0.82, h * 0.28), radius: 380),
      );
    canvas.drawCircle(Offset(w * 0.82, h * 0.28), 380, rightGlow);

    // 2. Subtle City Skyline Silhouette at Bottom of Hero
    final skylinePaint = Paint()
      ..color = const Color(0xFF04070D).withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    final skylineStroke = Paint()
      ..color = const Color(0xFFD4B37A).withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final skylinePath = Path()..moveTo(0, h);
    const buildingHeights = <double>[
      38, 62, 48, 88, 54, 112, 74, 134, 65, 96, 58, 122, 82, 105, 64, 128, 72,
      92, 52, 76, 44
    ];
    final stepW = w / buildingHeights.length;
    for (int i = 0; i < buildingHeights.length; i++) {
      final bx = i * stepW;
      final bh = buildingHeights[i];
      skylinePath.lineTo(bx, h - bh);
      // Spire on tall towers
      if (bh > 110) {
        skylinePath.lineTo(bx + stepW * 0.45, h - bh);
        skylinePath.lineTo(bx + stepW * 0.5, h - bh - 24);
        skylinePath.lineTo(bx + stepW * 0.55, h - bh);
      }
      skylinePath.lineTo(bx + stepW * 0.92, h - bh);
      skylinePath.lineTo(bx + stepW * 0.92, h - (bh * 0.55));
      skylinePath.lineTo(bx + stepW, h - (bh * 0.55));
    }
    skylinePath.lineTo(w, h);
    skylinePath.close();
    canvas.drawPath(skylinePath, skylinePaint);
    canvas.drawPath(skylinePath, skylineStroke);

    // 3. Signature Hallmark "2027" Watermark (Positioned in open sky - never overlapping text)
    final tp2027 = TextPainter(
      text: TextSpan(
        text: '2027',
        style: TextStyle(
          fontFamily: cormorantFamily,
          fontSize: mobile ? 56 : (w >= 1024 ? 135 : 95),
          fontWeight: FontWeight.w700,
          letterSpacing: mobile ? 3 : 6,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = mobile ? 1.2 : 1.5
            ..color =
                const Color(0xFFE3BE80).withValues(alpha: mobile ? 0.22 : 0.16),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset2027 = mobile
        ? Offset(w - tp2027.width - 16, 20)
        : Offset(w * 0.65 - tp2027.width / 2, h * 0.08);

    tp2027.paint(canvas, offset2027);

    // 4. Desktop-only gentle corner fireworks (positioned far from text columns)
    if (!mobile) {
      _drawFireworkBurst(
        canvas,
        center: Offset(w * 0.08, h * 0.12),
        radius: 64,
        rays: 20,
        alpha: 0.20,
      );
      _drawFireworkBurst(
        canvas,
        center: Offset(w * 0.92, h * 0.14),
        radius: 72,
        rays: 24,
        alpha: 0.22,
      );
    }

    // 4. Fine Champagne Gold Sparkles along top / outer edges only
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final sparkles = mobile
        ? const <(double, double, double, double)>[
            (0.06, 0.08, 1.8, 0.45),
            (0.18, 0.04, 1.4, 0.35),
            (0.85, 0.06, 2.0, 0.45),
            (0.94, 0.12, 1.6, 0.40),
            (0.92, 0.22, 1.5, 0.30),
            (0.05, 0.25, 1.4, 0.28),
          ]
        : const <(double, double, double, double)>[
            (0.05, 0.10, 2.0, 0.45),
            (0.16, 0.06, 1.6, 0.35),
            (0.24, 0.18, 2.2, 0.38),
            (0.78, 0.24, 1.8, 0.32),
            (0.86, 0.08, 2.4, 0.45),
            (0.94, 0.18, 2.0, 0.40),
          ];

    for (final (px, py, r, a) in sparkles) {
      dotPaint.color = const Color(0xFFE3BE80).withValues(alpha: a);
      canvas.drawCircle(Offset(w * px, h * py), r, dotPaint);
    }
  }

  void _drawFireworkBurst(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required int rays,
    required double alpha,
  }) {
    final rayPaint = Paint()
      ..color = const Color(0xFFE3BE80).withValues(alpha: alpha)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final tipPaint = Paint()
      ..color = const Color(0xFFFFE5B4).withValues(alpha: alpha + 0.12)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < rays; i++) {
      final angle = (i * 2 * math.pi) / rays;
      final isLong = i.isEven;
      final rStart = radius * (isLong ? 0.22 : 0.32);
      final rEnd = radius * (isLong ? 1.0 : 0.68);

      final p1 = Offset(
        center.dx + math.cos(angle) * rStart,
        center.dy + math.sin(angle) * rStart,
      );
      final p2 = Offset(
        center.dx + math.cos(angle) * rEnd,
        center.dy + math.sin(angle) * rEnd,
      );
      canvas.drawLine(p1, p2, rayPaint);
      canvas.drawCircle(p2, isLong ? 1.5 : 1.0, tipPaint);
    }

    // Center core sparkle
    canvas.drawCircle(
      center,
      2.0,
      Paint()..color = const Color(0xFFFFE5B4).withValues(alpha: alpha + 0.18),
    );
  }

  @override
  bool shouldRepaint(covariant _NewYearHeroBackdropPainter oldDelegate) =>
      false;
}

/// Custom Painter for the Idul Fitri 1448 H / Lebaran Hero Celebration Backdrop:
/// Draws glowing Arabian gold crescent moon & stars, subtle mosque dome silhouette at the bottom.
/// Zero overlapping watermark text for absolute clarity and elegance.
class _EidHeroBackdropPainter extends CustomPainter {
  const _EidHeroBackdropPainter({this.cormorantFamily});

  final String? cormorantFamily;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final mobile = w < 640;

    // 1. Ambient Arabian Gold & Emerald Radial Glows
    final leftGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFE3BE80).withValues(alpha: mobile ? 0.10 : 0.15),
          const Color(0xFFE3BE80).withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: Offset(w * 0.18, h * 0.20), radius: 360),
      );
    canvas.drawCircle(Offset(w * 0.18, h * 0.20), 360, leftGlow);

    final rightGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD4B37A).withValues(alpha: mobile ? 0.12 : 0.18),
          const Color(0xFFD4B37A).withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: Offset(w * 0.82, h * 0.26), radius: 400),
      );
    canvas.drawCircle(Offset(w * 0.82, h * 0.26), 400, rightGlow);

    // 2. Subtle Mosque Domes & Minaret Silhouette at Bottom of Hero
    final domePaint = Paint()
      ..color = const Color(0xFF020C08).withValues(alpha: 0.48)
      ..style = PaintingStyle.fill;
    final domeStroke = Paint()
      ..color = const Color(0xFFE3BE80).withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final horizonPath = Path()..moveTo(0, h);
    horizonPath.lineTo(0, h - 42);
    horizonPath.quadraticBezierTo(w * 0.12, h - 108, w * 0.24, h - 42);
    horizonPath.lineTo(w * 0.36, h - 42);
    horizonPath.quadraticBezierTo(w * 0.48, h - 138, w * 0.60, h - 42);
    horizonPath.lineTo(w * 0.74, h - 42);
    horizonPath.quadraticBezierTo(w * 0.86, h - 98, w, h - 42);
    horizonPath.lineTo(w, h);
    horizonPath.close();
    canvas.drawPath(horizonPath, domePaint);
    canvas.drawPath(horizonPath, domeStroke);

    // 3. Signature Hallmark "1448 H" Watermark (Positioned in open sky - never overlapping text)
    final tp1448 = TextPainter(
      text: TextSpan(
        text: '1448 H',
        style: TextStyle(
          fontFamily: cormorantFamily,
          fontSize: mobile ? 48 : (w >= 1024 ? 115 : 80),
          fontWeight: FontWeight.w700,
          letterSpacing: mobile ? 2.5 : 5,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = mobile ? 1.1 : 1.4
            ..color = const Color(0xFFE3BE80)
                .withValues(alpha: mobile ? 0.22 : 0.15),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset1448 = mobile
        ? Offset(w - tp1448.width - 16, 20)
        : Offset(w * 0.65 - tp1448.width / 2, h * 0.08);

    tp1448.paint(canvas, offset1448);

    // 4. Glowing Golden Crescent Moon in Top Far-Right (clear of headline text)
    final moonCenter =
        Offset(w * (mobile ? 0.91 : 0.90), h * (mobile ? 0.06 : 0.11));
    const moonRadius = 26.0;
    final moonOuter = Path()
      ..addOval(Rect.fromCircle(center: moonCenter, radius: moonRadius));
    final moonInner = Path()
      ..addOval(
        Rect.fromCircle(
          center: moonCenter.translate(9, -5),
          radius: moonRadius * 0.86,
        ),
      );
    final crescentPath =
        Path.combine(PathOperation.difference, moonOuter, moonInner);
    canvas.drawPath(
      crescentPath,
      Paint()
        ..color = const Color(0xFFE3BE80).withValues(alpha: 0.26)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      crescentPath,
      Paint()
        ..color = const Color(0xFFFFE5B4).withValues(alpha: 0.42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // 4. Subtle Hanging Fanous Lanterns on Desktop Far Edges
    if (!mobile) {
      _drawHangingLantern(canvas, Offset(w * 0.05, h * 0.18));
      _drawHangingLantern(canvas, Offset(w * 0.95, h * 0.20));
    }

    // 5. Eight-Pointed Islamic Stars & Gold Sparkles along top perimeter
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final starPositions = mobile
        ? const <(double, double, double, double)>[
            (0.06, 0.08, 1.8, 0.45),
            (0.20, 0.04, 1.4, 0.35),
            (0.76, 0.05, 1.8, 0.42),
            (0.92, 0.14, 1.5, 0.38),
          ]
        : const <(double, double, double, double)>[
            (0.05, 0.10, 2.0, 0.45),
            (0.22, 0.07, 2.2, 0.40),
            (0.78, 0.18, 1.8, 0.35),
            (0.88, 0.08, 2.4, 0.45),
          ];
    for (final (px, py, r, a) in starPositions) {
      dotPaint.color = const Color(0xFFE3BE80).withValues(alpha: a);
      canvas.drawCircle(Offset(w * px, h * py), r, dotPaint);
    }
  }

  void _drawHangingLantern(Canvas canvas, Offset bottomCenter) {
    final chainPaint = Paint()
      ..color = const Color(0xFFE3BE80).withValues(alpha: 0.24)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(bottomCenter.dx, 0),
      Offset(bottomCenter.dx, bottomCenter.dy - 20),
      chainPaint,
    );

    final bodyPath = Path()
      ..moveTo(bottomCenter.dx, bottomCenter.dy - 22)
      ..lineTo(bottomCenter.dx + 10, bottomCenter.dy - 12)
      ..lineTo(bottomCenter.dx + 7, bottomCenter.dy + 6)
      ..lineTo(bottomCenter.dx, bottomCenter.dy + 13)
      ..lineTo(bottomCenter.dx - 7, bottomCenter.dy + 6)
      ..lineTo(bottomCenter.dx - 10, bottomCenter.dy - 12)
      ..close();

    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = const Color(0xFFE3BE80).withValues(alpha: 0.14)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = const Color(0xFFE3BE80).withValues(alpha: 0.36)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    canvas.drawCircle(
      Offset(bottomCenter.dx, bottomCenter.dy - 3),
      3.5,
      Paint()..color = const Color(0xFFFFE5B4).withValues(alpha: 0.45),
    );
  }

  @override
  bool shouldRepaint(covariant _EidHeroBackdropPainter oldDelegate) => false;
}
