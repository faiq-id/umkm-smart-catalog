import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/common.dart';

// ===========================================================================
// GRAIN & BUTTER ARTISAN DELI — COMPANY PROFILE (PURE PROFILE, NO ADMIN/CART)
// ===========================================================================

/// Warna kurasi editorial haute-boulangerie Prancis.
class _ProfileColors {
  static const primary = Color(0xFF120805);
  static const primaryContainer = Color(0xFF2B1E1A);
  static const secondary = Color(0xFF9B4500);
  static const secondaryContainer = Color(0xFFFD8A42);
  static const surface = Color(0xFFFCF9F3);
  static const surfaceContainer = Color(0xFFF0EEE8);
  static const surfaceContainerLow = Color(0xFFF6F3ED);
  static const surfaceContainerHigh = Color(0xFFEBE8E2);
  static const surfaceContainerHighest = Color(0xFFE5E2DC);
  static const onSurface = Color(0xFF1C1C18);
  static const onSurfaceVariant = Color(0xFF4F4542);
  static const outline = Color(0xFF807471);
  static const outlineVariant = Color(0xFFD2C3BF);
  static const tertiaryFixed = Color(0xFFFFDDBA);
}

/// Model catatan terroir & rasa baker.
class _MenuItemData {
  const _MenuItemData({
    required this.id,
    required this.name,
    required this.category,
    required this.badge,
    required this.price,
    required this.image,
    required this.tastingNote,
    required this.modalEyebrow,
    required this.modalDescription,
    this.idealTime,
    this.coffeePairing,
    this.chefNoteType = 'Catatan Baker',
    this.icon = Icons.info_outline_rounded,
  });

  final String id;
  final String name;
  final String category; // 'Viennoiserie', 'Specialty Coffee', 'Savory Deli'
  final String badge;
  final String price;
  final String image;
  final String tastingNote;
  final String modalEyebrow;
  final String modalDescription;
  final String? idealTime;
  final String? coffeePairing;
  final String chefNoteType;
  final IconData icon;
}

const _kShowcaseItems = [
  _MenuItemData(
    id: 'croissant',
    name: 'Almond Flaky Croissant',
    category: 'Viennoiserie',
    badge: 'Artisan Viennoiserie',
    price: 'Rp 48.000',
    image:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAWlGFIlfL6bAKtmvOQnemZyvBCvAACIeBfmXbAvJQf06M5JWMSIGwWoScVvGbG6WcYGyS4r6wqjk-Yz_2XgGf8wes6K712yCeqQeZI9kn1ZwvYjhcqTFzLGLj89wHols5FBwpf7cDfSO-1RCoKy8_LQn3j87tFamn1RBM_mSuUtzhG6Q5FKwcDk7TuXz2NLSUowsvK1oYJoQlgrAnioTBZkC7B-DiHnLBQ3zrUQpw',
    tastingNote:
        'Marzipan almond panggang lembut, aroma mentega mentah, taburan sea salt karamel halus.',
    modalEyebrow: 'Catatan Baker & Terroir',
    modalDescription:
        'Adonan dasar croissant diistirahatkan selama 36 jam dalam suhu terkontrol 4°C untuk membentuk sarang laktosa alami. Setelah dipanggang pertama, croissant dibelah dan diisi frangipane murni kacang almond California, disiram sirup gula tebu aroma vanili Bourbon, kemudian dipanggang ulang hingga caramelised nutty.',
    idealTime: '08.00 – 11.30 WIB',
    coffeePairing: 'Double Flat White',
    chefNoteType: 'Catatan Baker',
  ),
  _MenuItemData(
    id: 'canele',
    name: 'Smoked Sea Salt Canelé',
    category: 'Viennoiserie',
    badge: 'Bordeaux Heritage',
    price: 'Rp 38.000',
    image:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBRboReSbpxYiED22bqsiW-ZGZYNXFRDrJXZKaZWLnRq0aKsUDLGGo9nQs2PeHDcr54VoVbMqwd8KwUPSaljuUiXXjENp98KBSle7Yne20jXRKk03tIEV0FZzTTaau7Mz-tJ91wlAxPWLRrz5W1gHntHviti3ZmN10wAgxXXH7mfkzo92GwpXKiLYm1LKK0-d36N4LPh6syGBvfdAR0WPRgqOum2SRDakV7cd-akQ4',
    tastingNote:
        'Karamel gosong manis legit di luar, custardy lembut wangi rum negrita & vanilla pods asli di dalam.',
    modalEyebrow: 'Tradisi Bordeaux 1700-an',
    modalDescription:
        'Dibuat menggunakan cetakan tembaga murni tradisional Prancis yang dipoles dengan lilin lebah murni (cire d\'abeille) untuk memastikan kulit karamel yang mengilap dan renyah tajam. Kami menambahkan garam laut asap Maldon di atasnya untuk menyeimbangkan manisnya custard telur organik.',
    idealTime: '14.00 – 18.00 WIB',
    coffeePairing: 'Filter Gayo Pantan Musara',
    chefNoteType: 'Catatan Baker',
  ),
  _MenuItemData(
    id: 'chocolat',
    name: 'Valrhona Pain au Chocolat',
    category: 'Viennoiserie',
    badge: 'Artisan Viennoiserie',
    price: 'Rp 45.000',
    image:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAqGFenzFb9uvFnZrHBRtkhORK2GdusfEmdxNRhwnvOAHIdhTi2Hu0W8n-A1BN7JS24ZNQ8ilEUbhX9zg5OJ6AItqLGwL8bJPKlHdUu4dOFdWNNH2UJDkkcUVjvGtSfInm92v1I1vSAsKM9Ya9UkdBYbeB8BccTRwx7rolo_EEahUNJWuR-DW4ESYzcmi47YAVs-eAxkljGKBr0QdSYM1_BKqyxvJI0ebv2PSPkm-o',
    tastingNote:
        'Cokelat hitam Guanaja 70% pahit seimbang, mentega murni meleleh hangat, kerenyahan 27 lapisan.',
    modalEyebrow: 'Grand Cru Chocolate',
    modalDescription:
        'Dua batang cokelat Prancis Valrhona Guanaja 70% kakao diselipkan di antara lembaran adonan yang bermentasi lambat. Rasa pahit buah kering dari kakao melengkapi kekayaan mentega Normandy dengan harmonis.',
    idealTime: '07.30 – 12.00 WIB',
    coffeePairing: 'Americano On The Rocks',
    chefNoteType: 'Catatan Baker',
  ),
  _MenuItemData(
    id: 'latte',
    name: 'Iced Spanish Latte',
    category: 'Specialty Coffee',
    badge: 'Signature Brew',
    price: 'Rp 46.000',
    image:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC2LeO-Z59kFxz-wzkFsdpMbGDfjJHjUlSXIUPmliioZCKC4kEji_S6SzERl8mQZw8Ww8ej3n3cg0sdh7ihRjxpPNxv9BBXeRz5toFi_b1vzVjJNC3H1H3mi-quhCcf08tkoWiUmq_pAM0uR8757SEzHQjTw0Rkw1_-Czgy_S4_bbKeXSC4JmFMzxaaypEs-F3CTPumFGqqUitnmKE-AfmaKmNxxv4tG2vTZCmpQ3o',
    tastingNote:
        'Susu kental manis buatan rumah, espresso sangrai medium cokelat rempah, dan akhir cecap creamy beludru.',
    modalEyebrow: 'Catatan Barista',
    modalDescription:
        'Espresso ganda diekstraksi dari biji Aceh Gayo proses anaerobic natural dengan mesin Slayer komersial bersuhu 93.2°C. Dicampur lembut dengan condensed milk karamel racikan barista dan susu pasteurisasi dingin berserat halus.',
    idealTime: '11.00 – 16.30 WIB',
    coffeePairing: 'Pain au Chocolat atau Canelé',
    chefNoteType: 'Catatan Barista',
    icon: Icons.local_cafe_outlined,
  ),
  _MenuItemData(
    id: 'pistachio',
    name: 'Pistachio Escargot',
    category: 'Viennoiserie',
    badge: 'Specialty Pastry',
    price: 'Rp 52.000',
    image:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDXa_okiHpg5iyM-5sNeKsunx-3ob6EB3BLLfOiB1Y8-2rTiAJSulvwyhmC8ie1BvrCKjEruWNQpRQjtrs0e2GGDHAhZoYTD92I7KZ_MvJdan8ruDOGfL3jneVtRQomPWLmZU93m_y3w93k3_ZvhLzM18QZj5kkZlWkXwVa80wHZCeySURufJNMVie-mqIi22TFyo8xVKadz7Dqph4VSTtMvobQb8JeFfnQauc5MF0',
    tastingNote:
        'Pasta kacang pistachio murni Sisilia, wangi kapulaga samar, sentuhan cranberry kering manis asam.',
    modalEyebrow: 'Pastry Spiral',
    modalDescription:
        'Bentuk gulungan spiral khas viennoiserie Prancis dengan isian pasta pistachio panggang murni asal Sisilia, Italia. Diimbangi dengan asam manis buah kranberi kering untuk sensasi berlapis yang tidak membuat eneg.',
    idealTime: '10.00 – 15.00 WIB',
    coffeePairing: 'Cold Brew Black Tea / Espresso Tonic',
    chefNoteType: 'Catatan Baker',
  ),
  _MenuItemData(
    id: 'truffle',
    name: 'Truffle Mushroom Toast',
    category: 'Savory Deli',
    badge: 'Warm Savory Deli',
    price: 'Rp 68.000',
    image:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDGqIFq35rroIddIR5JGwiUCQxn31iT5MPopQfirvxU7crN-InWIm85eh7xYMOIPN_N4Rvw-NshujPEFOoPPyfDpnF8fNppQ9YMu_7twiWwBZckiGb22ZG0x8q5lrXcQfjRSSxGOTHoAaWFo-IGK2cYJtpwRZ84ChpAkeuE9skB-H4368QdZp_9hLACYy6JMev2MiTSGlpPwMwQ3xiMecPhAbO3xUrLPXRKou5wo5A',
    tastingNote:
        'Roti country sourdough berpori kokoh, jamur tumis mentega thyme, pasta truffle hitam umami intens.',
    modalEyebrow: 'Sourdough Brunch',
    modalDescription:
        'Roti sourdough dipanggang di atas wajan besi dengan minyak zaitun extra virgin, disajikan dengan kombinasi jamur shimeji, portobello, dan kancing yang dimasak dengan thyme segar serta minyak truffle hitam berkualitas tinggi dari Umbria.',
    idealTime: '08.00 – 14.30 WIB',
    coffeePairing: 'Hot Piccolo Latte / V60 Toraja',
    chefNoteType: 'Catatan Chef',
    icon: Icons.restaurant_outlined,
  ),
];

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // GlobalKeys untuk smooth scroll ke bagian tertentu
  final _keyHero = GlobalKey();
  final _keyFilosofi = GlobalKey();
  final _keyMenu = GlobalKey();
  final _keySuasana = GlobalKey();
  final _keyTestimoni = GlobalKey();
  final _keyLokasiReservasi = GlobalKey();

  // State menu filter
  String _activeCategory = 'Semua Sajian';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        alignment: 0.05,
      );
    }
  }

  void _openDetailModal(_MenuItemData item) {
    showDialog(
      context: context,
      barrierColor: _ProfileColors.primary.withValues(alpha: 0.65),
      builder: (ctx) => _BakerNoteDialog(item: item),
    );
  }

  void _openWhatsAppConcierge() async {
    const text =
        'Halo Tim Concierge Grain & Butter Artisan Deli, saya ingin bertanya seputar sajian harian & informasi kunjungan ke atelier.';
    final url = Uri.parse('https://wa.me/6281299988776?text=${Uri.encodeComponent(text)}');

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tidak dapat membuka WhatsApp. Silakan hubungi langsung ke +62 812-9998-8776',
            style: Txt.sans(13, color: Colors.white),
          ),
          backgroundColor: _ProfileColors.secondary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Bp.mobile(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _ProfileColors.surface,
      endDrawer: mobile
          ? _ProfileMobileDrawer(
              onNav: (key) {
                Navigator.of(context).pop();
                Future.delayed(const Duration(milliseconds: 250), () => _scrollTo(key));
              },
              keyHero: _keyHero,
              keyFilosofi: _keyFilosofi,
              keyMenu: _keyMenu,
              keySuasana: _keySuasana,
              keyTestimoni: _keyTestimoni,
              keyLokasiReservasi: _keyLokasiReservasi,
              onOpenStore: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              },
            )
          : null,
      body: Column(
        children: [
          // Banner Switcher: Kembali ke Mode Toko / Katalog Demo
          _DemoProfileSwitchBar(
            onOpenStore: () => Navigator.of(context).pushReplacementNamed('/'),
          ),

          // Header sticky
          _ProfileHeader(
            onNav: _scrollTo,
            onOpenMenuDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
            keyHero: _keyHero,
            keyFilosofi: _keyFilosofi,
            keyMenu: _keyMenu,
            keySuasana: _keySuasana,
            keyTestimoni: _keyTestimoni,
            keyLokasiReservasi: _keyLokasiReservasi,
          ),

          // Body scrollable
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SECTION 1: HERO
                    _HeroSection(
                      key: _keyHero,
                      onExploreMenu: () => _scrollTo(_keyMenu),
                      onReserveTable: () => _scrollTo(_keyLokasiReservasi),
                    ),

                    const SizedBox(height: 56),

                    // SECTION 2: FILOSOFI & 4 PILAR
                    _FilosofiSection(key: _keyFilosofi),

                    const SizedBox(height: 72),

                    // SECTION 3: MENU UNGGULAN & PROFIL CITA RASA (NON-CART)
                    _MenuShowcaseSection(
                      key: _keyMenu,
                      activeCategory: _activeCategory,
                      onCategoryChanged: (cat) => setState(() => _activeCategory = cat),
                      onOpenDetail: _openDetailModal,
                    ),

                    const SizedBox(height: 72),

                    // SECTION 4: SUASANA & ESTETIKA ATELIER (PHOTO MOSAIC)
                    _SuasanaSection(key: _keySuasana),

                    const SizedBox(height: 72),

                    // SECTION 5: ULASAN PENGUNJUNG / TESTIMONI
                    _TestimoniSection(key: _keyTestimoni),

                    const SizedBox(height: 72),

                    // SECTION 6: LOKASI & PANDUAN KUNJUNGAN ATELIER
                    _LokasiReservasiSection(
                      key: _keyLokasiReservasi,
                      onOpenWhatsApp: _openWhatsAppConcierge,
                    ),

                    const SizedBox(height: 80),

                    // FOOTER
                    _ProfileFooter(
                      onNav: _scrollTo,
                      keyHero: _keyHero,
                      keyFilosofi: _keyFilosofi,
                      keyMenu: _keyMenu,
                      keySuasana: _keySuasana,
                      keyTestimoni: _keyTestimoni,
                      keyLokasiReservasi: _keyLokasiReservasi,
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
}

// ---------------------------------------------------------------------------
// 0. Top Bar Switcher (Mode Company Profile vs Toko Online)
// ---------------------------------------------------------------------------

class _DemoProfileSwitchBar extends StatelessWidget {
  const _DemoProfileSwitchBar({required this.onOpenStore});
  final VoidCallback onOpenStore;

  @override
  Widget build(BuildContext context) {
    final mobile = Bp.mobile(context);
    return Container(
      width: double.infinity,
      color: const Color(0xFF1B120E),
      padding: EdgeInsets.symmetric(horizontal: Bp.hPad(context), vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF291B16),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFF4A342C)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🏛️', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 6),
                        Text(
                          mobile ? 'Company Profile' : 'Atelier Company Profile',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFFDDBA),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Hover(
                onTap: onOpenStore,
                builder: (context, hovered) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: hovered ? _ProfileColors.secondary : const Color(0xFF412B23),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFF6B4232)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.storefront_rounded, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        mobile ? 'Mode Toko & Katalog' : 'Lihat Mode Toko Online & Pemesanan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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
}

// ---------------------------------------------------------------------------
// Header / Navigasi Company Profile
// ---------------------------------------------------------------------------

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.onNav,
    required this.onOpenMenuDrawer,
    required this.keyHero,
    required this.keyFilosofi,
    required this.keyMenu,
    required this.keySuasana,
    required this.keyTestimoni,
    required this.keyLokasiReservasi,
  });

  final void Function(GlobalKey) onNav;
  final VoidCallback onOpenMenuDrawer;
  final GlobalKey keyHero;
  final GlobalKey keyFilosofi;
  final GlobalKey keyMenu;
  final GlobalKey keySuasana;
  final GlobalKey keyTestimoni;
  final GlobalKey keyLokasiReservasi;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1100;

    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: _ProfileColors.surface.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: _ProfileColors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: _ProfileColors.primaryContainer.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Bp.hPad(context)),
            child: Row(
              children: [
                // Brand Logo & Title
                InkWell(
                  onTap: () => onNav(keyHero),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grain & Butter',
                          style: GoogleFonts.newsreader(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: _ProfileColors.primary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'ARTISAN DELI',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                            color: _ProfileColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Desktop Navigation Links
                if (isDesktop) ...[
                  _NavJumpLink(title: 'Beranda', onTap: () => onNav(keyHero), isActive: true),
                  _NavJumpLink(title: 'Cerita Kami', onTap: () => onNav(keyFilosofi)),
                  _NavJumpLink(title: 'Menu Unggulan', onTap: () => onNav(keyMenu)),
                  _NavJumpLink(title: 'Suasana', onTap: () => onNav(keySuasana)),
                  _NavJumpLink(title: 'Testimoni', onTap: () => onNav(keyTestimoni)),
                  _NavJumpLink(title: 'Lokasi & Kontak', onTap: () => onNav(keyLokasiReservasi)),
                  const SizedBox(width: 16),
                ],

                // Action: Reservasi Meja Button
                Hover(
                  onTap: () => onNav(keyLokasiReservasi),
                  builder: (context, hovered) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: hovered ? _ProfileColors.secondary : _ProfileColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _ProfileColors.primary.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.near_me_outlined, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Kunjungi Gerai',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Person / Atelier Host Icon
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: _ProfileColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded, size: 18, color: Colors.white),
                ),

                // Mobile drawer trigger
                if (!isDesktop) ...[
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: onOpenMenuDrawer,
                    icon: const Icon(Icons.menu_rounded, color: _ProfileColors.primary),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavJumpLink extends StatelessWidget {
  const _NavJumpLink({
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Hover(
      onTap: onTap,
      builder: (context, hovered) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            fontWeight: isActive || hovered ? FontWeight.w600 : FontWeight.w500,
            color: isActive
                ? _ProfileColors.secondary
                : (hovered ? _ProfileColors.primary : _ProfileColors.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

class _ProfileMobileDrawer extends StatelessWidget {
  const _ProfileMobileDrawer({
    required this.onNav,
    required this.keyHero,
    required this.keyFilosofi,
    required this.keyMenu,
    required this.keySuasana,
    required this.keyTestimoni,
    required this.keyLokasiReservasi,
    required this.onOpenStore,
  });

  final void Function(GlobalKey) onNav;
  final GlobalKey keyHero;
  final GlobalKey keyFilosofi;
  final GlobalKey keyMenu;
  final GlobalKey keySuasana;
  final GlobalKey keyTestimoni;
  final GlobalKey keyLokasiReservasi;
  final VoidCallback onOpenStore;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: _ProfileColors.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          children: [
            Text(
              'Grain & Butter',
              style: GoogleFonts.newsreader(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: _ProfileColors.primary,
              ),
            ),
            Text(
              'ARTISAN DELI & ROASTERY',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: _ProfileColors.secondary,
              ),
            ),
            const SizedBox(height: 28),
            _drawerTile('Beranda', () => onNav(keyHero)),
            _drawerTile('Cerita Kami (Filosofi)', () => onNav(keyFilosofi)),
            _drawerTile('Menu Unggulan', () => onNav(keyMenu)),
            _drawerTile('Suasana Atelier', () => onNav(keySuasana)),
            _drawerTile('Ulasan Pengunjung', () => onNav(keyTestimoni)),
            _drawerTile('Lokasi & Kunjungan', () => onNav(keyLokasiReservasi)),
            const Divider(height: 36),
            ElevatedButton.icon(
              onPressed: () => onNav(keyLokasiReservasi),
              style: ElevatedButton.styleFrom(
                backgroundColor: _ProfileColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.near_me_outlined, size: 18),
              label: Text(
                'Kunjungi Gerai Kami',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onOpenStore,
              style: OutlinedButton.styleFrom(
                foregroundColor: _ProfileColors.secondary,
                side: const BorderSide(color: _ProfileColors.secondary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.storefront_rounded, size: 18),
              label: Text(
                'Buka Mode Toko & Katalog',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(String label, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: _ProfileColors.primary,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: _ProfileColors.outline),
      onTap: onTap,
    );
  }
}

// ---------------------------------------------------------------------------
// SECTION 1: HERO
// ---------------------------------------------------------------------------

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    super.key,
    required this.onExploreMenu,
    required this.onReserveTable,
  });

  final VoidCallback onExploreMenu;
  final VoidCallback onReserveTable;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 992;

    return ContentWidth(
      child: Padding(
        padding: const EdgeInsets.only(top: 36, bottom: 20),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7,
                    child: _buildNarrative(context),
                  ),
                  const SizedBox(width: 48),
                  Expanded(
                    flex: 5,
                    child: _buildVisual(context),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNarrative(context),
                  const SizedBox(height: 36),
                  _buildVisual(context),
                ],
              ),
      ),
    );
  }

  Widget _buildNarrative(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Operational Status Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _ProfileColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _ProfileColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'BUKA SETIAP SELASA – MINGGU • 07.00 – 21.30 WIB',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: _ProfileColors.onSurface,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Poetic Headline
        Text(
          'Seni Memanggang Roti Tradisional Prancis & Kurasi Kopi Nusantara',
          style: GoogleFonts.newsreader(
            fontSize: Bp.mobile(context) ? 32 : 48,
            height: 1.12,
            fontWeight: FontWeight.w400,
            color: _ProfileColors.primary,
            letterSpacing: -0.6,
          ),
        ),

        const SizedBox(height: 12),

        // Subheading
        Text(
          'Di Jantung Kebayoran Baru, Jakarta Selatan',
          style: GoogleFonts.newsreader(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            color: _ProfileColors.secondary,
          ),
        ),

        const SizedBox(height: 16),

        // Body Paragraph
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Text(
            'Tempat bertemunya dedikasi artisan oven perancis dan aroma sangrai mikro kopi dataran tinggi. Tiap gigitan renyah dan sesapan hangat dirancang khusus untuk memuliakan waktu luang Anda.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 1.65,
              color: _ProfileColors.onSurfaceVariant,
            ),
          ),
        ),

        const SizedBox(height: 28),

        // CTA Buttons
        Wrap(
          spacing: 14,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: onExploreMenu,
              style: ElevatedButton.styleFrom(
                backgroundColor: _ProfileColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.restaurant_menu_rounded, size: 18),
              label: Text(
                'Jelajahi Menu Unggulan',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onReserveTable,
              style: OutlinedButton.styleFrom(
                backgroundColor: _ProfileColors.surfaceContainerHigh,
                foregroundColor: _ProfileColors.primary,
                side: BorderSide(color: _ProfileColors.outlineVariant.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.near_me_outlined, size: 18),
              label: Text(
                'Kunjungi Gerai Kami',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),

        const SizedBox(height: 36),

        // Micro Terroir Metas (3 Stats)
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('36 Jam', 'Fermentasi Dingin'),
              Container(width: 1, height: 32, color: _ProfileColors.outlineVariant.withValues(alpha: 0.5)),
              _buildStat('100%', 'Mentega AOP Charentes'),
              Container(width: 1, height: 32, color: _ProfileColors.outlineVariant.withValues(alpha: 0.5)),
              _buildStat('88+', 'SCA Specialty Score'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.newsreader(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: _ProfileColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: _ProfileColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildVisual(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Photo Card (Aspect 4/5)
        AspectRatio(
          aspectRatio: 4 / 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const AppImage(
                  src:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBRVMJ8Uja9UkayV7yNuOiYPwwMTvedRb88-QDZkpn3ES9G_Ej7mfoj30XWY4S8_ApuJybGH_oz2OORQPQtbgC5hKwX7yr_xYESN2iy5auiZeoi9QhVWu6Jkjsk4BNewgU-Ixa7YOYxqQ83Pt1kVzaySpVzcZWXwQkj6Dg9T0lRYs8Ne17eyKmaDmYa0NB6M_uNc7wC2P_DmVkNG2RCc4YGNocUoiEadcuTMKkRKC4',
                  emoji: '🥐',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        _ProfileColors.primary.withValues(alpha: 0.75),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Floating Editorial Pill
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: _ProfileColors.surface.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _ProfileColors.tertiaryFixed,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.bakery_dining_rounded,
                            color: _ProfileColors.secondary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'OVEN SUBUH HARI INI',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: _ProfileColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Laminasi Sempurna 108 Lipatan',
                                style: GoogleFonts.newsreader(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w500,
                                  color: _ProfileColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Decorative Accent Circular Tag
        Positioned(
          top: -16,
          right: -16,
          child: Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: _ProfileColors.secondaryContainer,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'FRESH\nBAKED\nDAILY',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// SECTION 2: FILOSOFI & 4 PILAR
// ---------------------------------------------------------------------------

class _FilosofiSection extends StatelessWidget {
  const _FilosofiSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentWidth(
      child: Column(
        children: [
          // Narrative Header
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              children: [
                Text(
                  'FILOSOFI & KEJUJURAN RASA',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                    color: _ProfileColors.secondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Filosofi Dedikasi Kami: Fermentasi Lambat 36 Jam, Mentega Murni AOP Prancis, dan Sangrai Mikro Beretika',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.newsreader(
                    fontSize: Bp.mobile(context) ? 26 : 34,
                    height: 1.22,
                    fontWeight: FontWeight.w500,
                    color: _ProfileColors.primary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Kami memandang adonan pastry dan biji kopi bukan sekadar sajian konsumsi harian, melainkan manifestasi kesabaran. Di tengah laju kota yang bergegas, kami memilih proses lambat yang menghargai ragi alami dan petani lokal.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    height: 1.6,
                    color: _ProfileColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 42),

          // 4 Pillars Mosaic Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final crossAxisCount = w >= 992 ? 4 : (w >= 600 ? 2 : 1);

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _pillarCard(
                    width: (w - (crossAxisCount - 1) * 20) / crossAxisCount,
                    icon: Icons.hourglass_bottom_rounded,
                    title: '36-Jam Slow Sourdough Fermentation',
                    desc:
                        'Memecah gluten alami secara optimal untuk hasilkan cangkang luar renyah keemasan, sarang pori lentur lembut, dan sangat ramah pencernaan.',
                    badge: 'RAGI ALAMI LIAR',
                  ),
                  _pillarCard(
                    width: (w - (crossAxisCount - 1) * 20) / crossAxisCount,
                    icon: Icons.verified_rounded,
                    title: '100% French AOP Charentes Butter',
                    desc:
                        'Menggunakan mentega murni sertifikasi asal Poitou-Charentes. Menghasilkan aroma hazelnut harum autentik Paris tanpa aroma sintetis tambahan.',
                    badge: 'STANDAR HAUTE-PÂTISSERIE',
                  ),
                  _pillarCard(
                    width: (w - (crossAxisCount - 1) * 20) / crossAxisCount,
                    icon: Icons.coffee_rounded,
                    title: 'Specialty Ethically Sourced Coffee',
                    desc:
                        'Koleksi mikro-lot dari Gayo Pantan Musara, Toraja Sapan, hingga Sidama Ethiopia. Kami bermitra langsung dengan penanam dengan harga perdagangan adil.',
                    badge: 'DIRECT TRADE TRACEABILITY',
                  ),
                  _pillarCard(
                    width: (w - (crossAxisCount - 1) * 20) / crossAxisCount,
                    icon: Icons.wb_twilight_rounded,
                    title: 'Fresh Daily Batch Roasting & Baking',
                    desc:
                        'Baking dimulai pukul 03.30 subuh setiap hari. Tiap rak dipastikan hangat segar, menolak sistem pembekuan adonan instan atau sisa jualan kemarin.',
                    badge: 'NIR-BAHAN PENGAWET',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _pillarCard({
    required double width,
    required IconData icon,
    required String title,
    required String desc,
    required String badge,
  }) {
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 250),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _ProfileColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _ProfileColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _ProfileColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _ProfileColors.secondary, size: 22),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: GoogleFonts.newsreader(
              fontSize: 18.5,
              fontWeight: FontWeight.w500,
              color: _ProfileColors.primary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.6,
              color: _ProfileColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            badge,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: _ProfileColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SECTION 3: MENU UNGGULAN & PROFIL CITA RASA
// ---------------------------------------------------------------------------

class _MenuShowcaseSection extends StatelessWidget {
  const _MenuShowcaseSection({
    super.key,
    required this.activeCategory,
    required this.onCategoryChanged,
    required this.onOpenDetail,
  });

  final String activeCategory;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<_MenuItemData> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final filtered = activeCategory == 'Semua Sajian'
        ? _kShowcaseItems
        : _kShowcaseItems.where((i) => i.category == activeCategory).toList();

    return ContentWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & Filters Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 768;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader(),
                        _buildFilterPills(),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: _buildFilterPills(),
                        ),
                      ],
                    );
            },
          ),

          const SizedBox(height: 36),

          // 6 Curated Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final crossAxisCount = w >= 992 ? 3 : (w >= 600 ? 2 : 1);
              final cardWidth = (w - (crossAxisCount - 1) * 24) / crossAxisCount;

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  for (final item in filtered)
                    _buildShowcaseCard(context, item, cardWidth),
                ],
              );
            },
          ),

          const SizedBox(height: 56),

          // Bespoke Atelier Services (Collaboration, Cupping, Hampers)
          _buildBespokeServices(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ETALASE KEAHLIAN TANGAN',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: _ProfileColors.secondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Koleksi Menu & Profil Cita Rasa',
          style: GoogleFonts.newsreader(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: _ProfileColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            'Sajian kurasi harian untuk dinikmati langsung di tempat. Tanpa perasa buatan, disiapkan dengan kecermatan temperatur tinggi.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.5,
              color: _ProfileColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPills() {
    const categories = ['Semua Sajian', 'Viennoiserie', 'Specialty Coffee', 'Savory Deli'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _ProfileColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final cat in categories)
            Hover(
              onTap: () => onCategoryChanged(cat),
              builder: (context, hovered) {
                final isSelected = activeCategory == cat;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? _ProfileColors.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    cat,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? _ProfileColors.primary
                          : (hovered ? _ProfileColors.primary : _ProfileColors.onSurfaceVariant),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildShowcaseCard(BuildContext context, _MenuItemData item, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _ProfileColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _ProfileColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Square Photo with Price Badge
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(
                    src: item.image,
                    emoji: item.category.contains('Coffee') ? '☕' : '🥐',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _ProfileColors.surface.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Text(
                        item.price,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: _ProfileColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Category Badge
          Text(
            item.badge.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: _ProfileColors.secondary,
            ),
          ),

          const SizedBox(height: 4),

          // Name
          Text(
            item.name,
            style: GoogleFonts.newsreader(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: _ProfileColors.primary,
            ),
          ),

          const SizedBox(height: 8),

          // Tasting Note Summary
          Text(
            'Catatan Rasa: ${item.tastingNote}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontStyle: FontStyle.italic,
              height: 1.5,
              color: _ProfileColors.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 16),

          // Action: Lihat Detail Rasa / Catatan Baker (PURE INFO, NO CART)
          Hover(
            onTap: () => onOpenDetail(item),
            builder: (context, hovered) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: hovered
                    ? _ProfileColors.surfaceContainerHighest
                    : _ProfileColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 16, color: _ProfileColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Lihat Detail Rasa / ${item.chefNoteType}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: _ProfileColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBespokeServices(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _ProfileColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _ProfileColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LAYANAN & KOLABORASI',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
              color: _ProfileColors.secondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pengalaman Khusus & Kemitraan Restoran',
            style: GoogleFonts.newsreader(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: _ProfileColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Selain bersantap di tempat, kami mempersembahkan format layanan terkurasi untuk kebutuhan personal dan korporat.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: _ProfileColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final crossAxisCount = w >= 860 ? 3 : 1;
              final serviceWidth = (w - (crossAxisCount - 1) * 20) / crossAxisCount;

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _serviceTile(
                    width: serviceWidth,
                    icon: Icons.local_cafe_outlined,
                    title: 'Private Coffee Tasting & Cupping',
                    desc:
                        'Sesi intim 90 menit mengeksplorasi 5 varietas single origin dunia dipandu oleh Head Q-Grader kami.',
                    badge: 'SESI JADWAL KHUSUS',
                  ),
                  _serviceTile(
                    width: serviceWidth,
                    icon: Icons.card_giftcard_outlined,
                    title: 'Hampers & Souvenir Acara Korporat',
                    desc:
                        'Kemasan bespoke linen ramah lingkungan berisi sourdough, cookies Valrhona, dan wangi drip bag kopi artisanal.',
                    badge: 'KATALOG MUSIMAN',
                  ),
                  _serviceTile(
                    width: serviceWidth,
                    icon: Icons.storefront_outlined,
                    title: 'Penyediaan Roti Mitra (Wholesale B2B)',
                    desc:
                        'Pasokan rutin viennoiserie dan artisan sourdough segar tiap fajar untuk boutique hotel & specialty café rekanan.',
                    badge: 'KEMITRAAN EKSKLUSIF',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _serviceTile({
    required double width,
    required IconData icon,
    required String title,
    required String desc,
    required String badge,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _ProfileColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _ProfileColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _ProfileColors.secondary, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.newsreader(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: _ProfileColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.55,
              color: _ProfileColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            badge,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: _ProfileColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SECTION 4: SUASANA & ESTETIKA ATELIER
// ---------------------------------------------------------------------------

class _SuasanaSection extends StatelessWidget {
  const _SuasanaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 768;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildHeader(),
                        _buildWifiBadge(),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 12),
                        _buildWifiBadge(),
                      ],
                    );
            },
          ),

          const SizedBox(height: 36),

          // Asymmetrical Gallery Mosaic
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final isDesktop = w >= 860;

              if (!isDesktop) {
                // Mobile stacked layout
                return Column(
                  children: [
                    _photoCard(
                      height: 280,
                      image:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuARWR-nedXaAxoVATjKisMruUz_7XRB-UfBik3hbc_Pv272CxxVsZk93EDEozfAekXqT39YfaBjSl1Do5SL3SvofgK1J2CzEVUHAmIXJg3Z9SIdNX3HV2GTZF4_PpX97mNsDg_g-9jJAsfxAc9hUV9ppoMRK7A2x1c4ubhB_EDTtUJHRKGtiX2swrhNQ7c7StdUKgmz2exca9tvA5f0EoGy55VVThxgcB-b8H66Fn0',
                      tag: 'DAPUR TERBUKA',
                      title: 'Aroma Oven Kayu & Kerapihan Artisan Pâtissier',
                    ),
                    const SizedBox(height: 16),
                    _photoCard(
                      height: 280,
                      image:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAfapbaeMigymPeb8xJ7XwxQuLzC_gAtvqs2nLqlRC5dbEbDoWd4ML9AXBsadfWvI-8j8PHQ1UWOXX4uDVz65SnnaAsjUgfP4Yl59CdhEolH0voHGobgjcQnxemgzKoC7r_pqSy4s6g0BpQr71qJX5Pju-smDQuLmmXxSziDk9-A_b5vsB7gOtG_JsX2QkzaiaAszskOIIEg7ur6tJggXu7dxVQfPsIeGLV4-SmofM',
                      tag: 'BAR SLOW BAR',
                      title: 'Koleksi Cangkir Keramik Buatan Tangan Pengrajin Lokal',
                    ),
                    const SizedBox(height: 16),
                    _photoCard(
                      height: 240,
                      image:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBz-mjQioMtwUfdZeKvCWtghFnW5tILVsghVWyx4YN0LEUfLXDWp_51I0ImK_G-1Yji3_5TN_unUYALV2Vms9uLmZNsdxvtttAiWimixqQnjmdSzsEu2g_0c_fuvptWcc51K6jeSB-WLQMA50ZQiUxQYDvMFpw0AWvvuhPj7UdXTRYRT0paALMrKU1KIrJie_OFc47sE2vHv0hG_e1MfKGz84cGb3Umcyyk3f_Qq_w',
                      tag: 'SUDUT HENING',
                      title: 'Pojok Baca & Ketenangan Pribadi',
                    ),
                    const SizedBox(height: 16),
                    _photoCard(
                      height: 240,
                      image:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCB98_Tnrx2fj7bt4fmbrBk-EHB-07zQ6FJPbJQO5-owwbXZ4_6fA7iTN9Jd97OFcuEAlPUDElSUfz2BvPUFR98XHn9wlFJtMAG1nr6sBT5fLSVLAY3Y3dNiYF5fnSqQLVxAWGV-F8kwD9iyf-cPDGc5EIbG4-rlmGyHjuZRWi-3syTqsMpm_xFJmib6_Xb4TLwouR4x2IHEa2AlMLiBKDAPQethS7P-BBSACdcURE',
                      tag: 'MEJA KOMUNAL',
                      title: 'Kayu Jati Solid untuk Pertemuan Hangat & Bekerja Tenang',
                    ),
                  ],
                );
              }

              // Desktop 7:5 top row and 4:8 bottom row
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: _photoCard(
                          height: 420,
                          image:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuARWR-nedXaAxoVATjKisMruUz_7XRB-UfBik3hbc_Pv272CxxVsZk93EDEozfAekXqT39YfaBjSl1Do5SL3SvofgK1J2CzEVUHAmIXJg3Z9SIdNX3HV2GTZF4_PpX97mNsDg_g-9jJAsfxAc9hUV9ppoMRK7A2x1c4ubhB_EDTtUJHRKGtiX2swrhNQ7c7StdUKgmz2exca9tvA5f0EoGy55VVThxgcB-b8H66Fn0',
                          tag: 'DAPUR TERBUKA',
                          title: 'Aroma Oven Kayu & Kerapihan Artisan Pâtissier',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 5,
                        child: _photoCard(
                          height: 420,
                          image:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuAfapbaeMigymPeb8xJ7XwxQuLzC_gAtvqs2nLqlRC5dbEbDoWd4ML9AXBsadfWvI-8j8PHQ1UWOXX4uDVz65SnnaAsjUgfP4Yl59CdhEolH0voHGobgjcQnxemgzKoC7r_pqSy4s6g0BpQr71qJX5Pju-smDQuLmmXxSziDk9-A_b5vsB7gOtG_JsX2QkzaiaAszskOIIEg7ur6tJggXu7dxVQfPsIeGLV4-SmofM',
                          tag: 'BAR SLOW BAR',
                          title: 'Koleksi Cangkir Keramik Buatan Tangan Pengrajin Lokal',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: _photoCard(
                          height: 290,
                          image:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBz-mjQioMtwUfdZeKvCWtghFnW5tILVsghVWyx4YN0LEUfLXDWp_51I0ImK_G-1Yji3_5TN_unUYALV2Vms9uLmZNsdxvtttAiWimixqQnjmdSzsEu2g_0c_fuvptWcc51K6jeSB-WLQMA50ZQiUxQYDvMFpw0AWvvuhPj7UdXTRYRT0paALMrKU1KIrJie_OFc47sE2vHv0hG_e1MfKGz84cGb3Umcyyk3f_Qq_w',
                          tag: 'SUDUT HENING',
                          title: 'Pojok Baca & Ketenangan Pribadi',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 8,
                        child: _photoCard(
                          height: 290,
                          image:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCB98_Tnrx2fj7bt4fmbrBk-EHB-07zQ6FJPbJQO5-owwbXZ4_6fA7iTN9Jd97OFcuEAlPUDElSUfz2BvPUFR98XHn9wlFJtMAG1nr6sBT5fLSVLAY3Y3dNiYF5fnSqQLVxAWGV-F8kwD9iyf-cPDGc5EIbG4-rlmGyHjuZRWi-3syTqsMpm_xFJmib6_Xb4TLwouR4x2IHEa2AlMLiBKDAPQethS7P-BBSACdcURE',
                          tag: 'MEJA KOMUNAL',
                          title: 'Kayu Jati Solid untuk Pertemuan Hangat & Bekerja Tenang',
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KEHANGATAN RUANG',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: _ProfileColors.secondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Suasana & Estetika Atelier',
          style: GoogleFonts.newsreader(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: _ProfileColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Text(
            'Suasana yang dirancang dengan kayu jati solid, pencahayaan senja yang tenang, serta deru lembut mesin espresso yang ramah untuk obrolan hangat maupun fokus bekerja.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.5,
              color: _ProfileColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWifiBadge() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.wifi_rounded, size: 18, color: _ProfileColors.secondary),
        const SizedBox(width: 8),
        Text(
          'Wi-Fi Berkecepatan Tinggi & Sudut Baca Hening',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: _ProfileColors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _photoCard({
    required double height,
    required String image,
    required String tag,
    required String title,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(src: image, emoji: '🏛️', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    _ProfileColors.primary.withValues(alpha: 0.82),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tag,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: _ProfileColors.secondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.newsreader(
                      fontSize: 18.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SECTION 5: ULASAN PENGUNJUNG / TESTIMONI
// ---------------------------------------------------------------------------

class _TestimoniSection extends StatelessWidget {
  const _TestimoniSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentWidth(
      child: Column(
        children: [
          // Header Center
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              children: [
                Text(
                  'ULASAN NYATA PENGUNJUNG',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                    color: _ProfileColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Apa Kata Penikmat Roti & Kopi Kami',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.newsreader(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: _ProfileColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kisah dari mereka yang meluangkan pagi dan sore hari di bilik kami di Kebayoran Baru.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    color: _ProfileColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 42),

          // 3 Testimonial Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final crossAxisCount = w >= 992 ? 3 : (w >= 600 ? 2 : 1);
              final cardWidth = (w - (crossAxisCount - 1) * 24) / crossAxisCount;

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _reviewCard(
                    width: cardWidth,
                    quote:
                        '"Laminasi almond croissant di Grain & Butter adalah yang paling mendekati standar boulangerie di arondisemen ke-6 Paris. Renyahnya luar biasa tanpa meninggalkan rasa minyak berlebih di langit-langit lidah."',
                    initials: 'AK',
                    name: 'Aline Kartasasmita',
                    role: 'Kurator Gastronomi & Penulis Majalah Rasa',
                  ),
                  _reviewCard(
                    width: cardWidth,
                    quote:
                        '"Tempat perlindungan terbaik saya untuk WFA di kawasan Jakarta Selatan. Meja kayu solidnya sangat nyaman, aromanya selalu menenangkan, dan Spanish Latte dinginnya sungguh tiada duanya."',
                    initials: 'DH',
                    name: 'Dimas Haryo',
                    role: 'Arsitek Lansekap Kebayoran Baru',
                  ),
                  _reviewCard(
                    width: cardWidth,
                    quote:
                        '"Canelé-nya memiliki caramelised crust dengan aroma lebah madu yang autentik. Menghargai sekali komitmen mereka yang tetap mempertahankan fermentasi lambat tanpa ragi instan."',
                    initials: 'SW',
                    name: 'Stella Wibowo',
                    role: 'Pencinta Kopi & Patisserie Klasik',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _reviewCard({
    required double width,
    required String quote,
    required String initials,
    required String name,
    required String role,
  }) {
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 260),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: _ProfileColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _ProfileColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
              // 5 Stars
              Row(
                children: [
                  for (int i = 0; i < 5; i++)
                    const Padding(
                      padding: EdgeInsets.only(right: 3),
                      child: Icon(Icons.star_rounded, size: 20, color: _ProfileColors.secondaryContainer),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                quote,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  height: 1.65,
                  fontStyle: FontStyle.italic,
                  color: _ProfileColors.primary,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: _ProfileColors.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: GoogleFonts.newsreader(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _ProfileColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: _ProfileColors.primary,
                        ),
                      ),
                      Text(
                        role,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: _ProfileColors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SECTION 6: LOKASI & PANDUAN KUNJUNGAN ATELIER (WALK-IN WELCOME)
// ---------------------------------------------------------------------------

class _LokasiReservasiSection extends StatelessWidget {
  const _LokasiReservasiSection({
    super.key,
    required this.onOpenWhatsApp,
  });

  final VoidCallback onOpenWhatsApp;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 992;

    return ContentWidth(
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: _buildLocationDetails(context)),
                const SizedBox(width: 48),
                Expanded(flex: 7, child: _buildVisitorGuide(context)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLocationDetails(context),
                const SizedBox(height: 36),
                _buildVisitorGuide(context),
              ],
            ),
    );
  }

  Widget _buildLocationDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TEMUKAN KETENANGAN KAMI',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: _ProfileColors.secondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Kunjungi Atelier Kami',
          style: GoogleFonts.newsreader(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: _ProfileColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Terletak di koridor teduh Kebayoran Baru, dikelilingi pepohonan rimbun yang asri.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.5,
            color: _ProfileColors.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 24),

        // Address Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _ProfileColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _ProfileColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.location_on_rounded, color: _ProfileColors.secondary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alamat Gerai',
                      style: GoogleFonts.newsreader(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: _ProfileColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jl. Wijaya Timur No. 42, RT 04 / RW 02, Kebayoran Baru, Jakarta Selatan, 12170',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        height: 1.5,
                        color: _ProfileColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => launchUrl(
                        Uri.parse('https://maps.google.com/?q=Kebayoran+Baru+Jakarta+Selatan'),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Buka Petunjuk Arah Google Maps',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: _ProfileColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.open_in_new_rounded, size: 14, color: _ProfileColors.secondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Timetable Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _ProfileColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 18, color: _ProfileColors.secondary),
                  const SizedBox(width: 8),
                  Text(
                    'Jadwal Operasional Oven & Kafe',
                    style: GoogleFonts.newsreader(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: _ProfileColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _scheduleRow('Selasa – Jumat', '07.30 – 21.00 WIB'),
              const Divider(height: 18),
              _scheduleRow('Sabtu – Minggu', '07.00 – 21.30 WIB'),
              const Divider(height: 18),
              _scheduleRow(
                'Senin',
                'Tutup (Waktu Istirahat & Kurasi Ragi)',
                isClosed: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Map Image Container
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const AppImage(
                  src:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCgdF8_JRirTLk_Nl5fpGXqPCtDYSYJqwr7jYP9oUK3pcFWDUSsSneSGHFeG8CqCUZA6lnaKGcCmk7bX3kcBvHl6RKYIp7bXqbBbFyAPGn8iSnvg-nGO-0A5SrGzvl5tEVZJt5BZ0U6yB3K3and7LJDNXNo1kTo-G79l-KEXYvwoweCksKqgfgn2jNA2LDKyoAVYhinNW3W3aRY5uesU_aGm2ellXPVRMku8wDe7AE',
                  emoji: '📍',
                  fit: BoxFit.cover,
                ),
                Container(color: _ProfileColors.primary.withValues(alpha: 0.2)),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _ProfileColors.surface.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.pin_drop_rounded, size: 18, color: _ProfileColors.secondary),
                        const SizedBox(width: 8),
                        Text(
                          'Grain & Butter Kebayoran Baru',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: _ProfileColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _scheduleRow(String days, String hours, {bool isClosed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          days,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: _ProfileColors.onSurfaceVariant,
          ),
        ),
        Text(
          hours,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: isClosed ? FontWeight.w500 : FontWeight.w700,
            fontStyle: isClosed ? FontStyle.italic : FontStyle.normal,
            color: isClosed ? _ProfileColors.secondary : _ProfileColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildVisitorGuide(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _ProfileColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _ProfileColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PENGALAMAN BERSANTAP SANTAI',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
              color: _ProfileColors.secondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Walk-In Welcome',
            style: GoogleFonts.newsreader(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: _ProfileColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kunjungan Kapan Saja Tanpa Perlu Reservasi Meja',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: _ProfileColors.secondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Kami percaya aroma butter dan viennoiserie hangat paling nikmat dinikmati secara spontan. Di Grain & Butter, Anda tidak perlu repot memesan meja di awal — silakan langsung datang kapan saja dan pilih sudut favorit Anda untuk sarapan, rehat kopi sore, atau bekerja santai.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              height: 1.6,
              color: _ProfileColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // 4 Fasilitas Unggulan
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 520;
              final itemWidth = isWide ? (constraints.maxWidth - 14) / 2 : constraints.maxWidth;
              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  _facilityCard(
                    width: itemWidth,
                    icon: Icons.power_rounded,
                    title: 'Work-Friendly & Stopkontak',
                    desc: 'Stopkontak di hampir tiap meja dengan Wi-Fi serat optik kencang.',
                  ),
                  _facilityCard(
                    width: itemWidth,
                    icon: Icons.yard_outlined,
                    title: 'Indoor AC & Teras Asri',
                    desc: 'Ruang dalam sejuk ber-AC dan area teras luar teduh ramah santai.',
                  ),
                  _facilityCard(
                    width: itemWidth,
                    icon: Icons.local_parking_rounded,
                    title: 'Parkir Nyaman & Aman',
                    desc: 'Tersedia slot parkir mobil & motor langsung di area depan gerai.',
                  ),
                  _facilityCard(
                    width: itemWidth,
                    icon: Icons.bakery_dining_outlined,
                    title: 'Fresh Daily Oven Batch',
                    desc: 'Batch viennoiserie hangat keluar oven pukul 07.30 & 14.00 WIB.',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Concierge Callout Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _ProfileColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _ProfileColors.outlineVariant.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _ProfileColors.secondary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: _ProfileColors.secondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rombongan Khusus atau Pesanan Hampers?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _ProfileColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Bila Anda ingin pesan whole cake, hampers, atau berencana datang dengan rombongan besar (>8 orang), concierge kami siap membantu.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          height: 1.4,
                          color: _ProfileColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Two Action Buttons: WhatsApp Concierge + Google Maps
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 480;
              return isWide
                  ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onOpenWhatsApp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _ProfileColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                            label: Text(
                              'Chat Concierge via WhatsApp',
                              style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () => launchUrl(
                            Uri.parse('https://maps.google.com/?q=Kebayoran+Baru+Jakarta+Selatan'),
                            mode: LaunchMode.externalApplication,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _ProfileColors.primary,
                            side: BorderSide(color: _ProfileColors.outlineVariant.withValues(alpha: 0.6)),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.near_me_outlined, size: 18, color: _ProfileColors.secondary),
                          label: Text(
                            'Petunjuk Arah',
                            style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: onOpenWhatsApp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _ProfileColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                            label: Text(
                              'Chat Concierge via WhatsApp',
                              style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => launchUrl(
                              Uri.parse('https://maps.google.com/?q=Kebayoran+Baru+Jakarta+Selatan'),
                              mode: LaunchMode.externalApplication,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _ProfileColors.primary,
                              side: BorderSide(color: _ProfileColors.outlineVariant.withValues(alpha: 0.6)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.near_me_outlined, size: 18, color: _ProfileColors.secondary),
                            label: Text(
                              'Buka Petunjuk Arah di Maps',
                              style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _facilityCard({
    required double width,
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _ProfileColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _ProfileColors.outlineVariant.withValues(alpha: 0.25)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _ProfileColors.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: _ProfileColors.secondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: _ProfileColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      height: 1.35,
                      color: _ProfileColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DETAIL / BAKER'S NOTE MODAL DIALOG
// ---------------------------------------------------------------------------

class _BakerNoteDialog extends StatelessWidget {
  const _BakerNoteDialog({required this.item});
  final _MenuItemData item;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: _ProfileColors.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.modalEyebrow.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: _ProfileColors.secondary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: _ProfileColors.surfaceContainer,
                      padding: const EdgeInsets.all(6),
                      minimumSize: const Size(32, 32),
                    ),
                    icon: const Icon(Icons.close_rounded, size: 18, color: _ProfileColors.primary),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                item.name,
                style: GoogleFonts.newsreader(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: _ProfileColors.primary,
                ),
              ),

              const SizedBox(height: 16),

              // Baker's narrative
              Text(
                item.modalDescription,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 1.65,
                  color: _ProfileColors.onSurfaceVariant,
                ),
              ),

              if (item.idealTime != null || item.coffeePairing != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _ProfileColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      if (item.idealTime != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WAKTU IDEAL NIKMAT',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: _ProfileColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.idealTime!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: _ProfileColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (item.coffeePairing != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PASANGAN MINUMAN',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: _ProfileColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.coffeePairing!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: _ProfileColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ProfileColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Tutup Jendela Catatan',
                    style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FOOTER
// ---------------------------------------------------------------------------

class _ProfileFooter extends StatelessWidget {
  const _ProfileFooter({
    required this.onNav,
    required this.keyHero,
    required this.keyFilosofi,
    required this.keyMenu,
    required this.keySuasana,
    required this.keyTestimoni,
    required this.keyLokasiReservasi,
  });

  final void Function(GlobalKey) onNav;
  final GlobalKey keyHero;
  final GlobalKey keyFilosofi;
  final GlobalKey keyMenu;
  final GlobalKey keySuasana;
  final GlobalKey keyTestimoni;
  final GlobalKey keyLokasiReservasi;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _ProfileColors.surfaceContainerLow,
        border: Border(
          top: BorderSide(
            color: _ProfileColors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: ContentWidth(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 56),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final isDesktop = w >= 992;

                  if (!isDesktop) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrandBio(),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildNavigationLinks()),
                            const SizedBox(width: 24),
                            Expanded(child: _buildVisitLinks()),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildHours(),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: _buildBrandBio()),
                      const SizedBox(width: 36),
                      Expanded(flex: 2, child: _buildNavigationLinks()),
                      const SizedBox(width: 36),
                      Expanded(flex: 3, child: _buildVisitLinks()),
                      const SizedBox(width: 36),
                      Expanded(flex: 3, child: _buildHours()),
                    ],
                  );
                },
              ),

              const SizedBox(height: 48),

              // Bottom Copyright Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: _ProfileColors.surfaceContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '© 2024 Grain & Butter Artisan Deli. Seluruh Hak Cipta Dilindungi.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: _ProfileColors.onSurfaceVariant,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Kebijakan Privasi',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: _ProfileColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Text(
                          'Syarat & Ketentuan',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: _ProfileColors.onSurfaceVariant,
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

  Widget _buildBrandBio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grain & Butter',
          style: GoogleFonts.newsreader(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: _ProfileColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'ARTISAN DELI & CAFÉ',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: _ProfileColors.secondary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Harmoni dedikasi artisan, bahan kurasi terroir istimewa, dan keramahan hangat dalam setiap hidangan deli serta kopi panggangan mikro.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.6,
            color: _ProfileColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Navigasi',
          style: GoogleFonts.newsreader(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _ProfileColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        _linkItem('Beranda', () => onNav(keyHero)),
        _linkItem('Cerita Kami', () => onNav(keyFilosofi)),
        _linkItem('Menu Unggulan', () => onNav(keyMenu)),
        _linkItem('Suasana Gerai', () => onNav(keySuasana)),
      ],
    );
  }

  Widget _buildVisitLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Kunjungan',
          style: GoogleFonts.newsreader(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _ProfileColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        _linkItem('Lokasi & Petunjuk Arah', () => onNav(keyLokasiReservasi)),
        _linkItem('Suasana & Fasilitas', () => onNav(keySuasana)),
        _linkItem('Ulasan Pengunjung', () => onNav(keyTestimoni)),
      ],
    );
  }

  Widget _buildHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Waktu Operasional',
          style: GoogleFonts.newsreader(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _ProfileColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: _ProfileColors.onSurfaceVariant),
            children: const [
              TextSpan(text: 'Selasa – Jumat: ', style: TextStyle(fontWeight: FontWeight.bold, color: _ProfileColors.primary)),
              TextSpan(text: '07.30 – 21.00 WIB\n'),
              TextSpan(text: 'Sabtu – Minggu: ', style: TextStyle(fontWeight: FontWeight.bold, color: _ProfileColors.primary)),
              TextSpan(text: '07.00 – 21.30 WIB\n'),
              TextSpan(text: 'Senin: ', style: TextStyle(fontWeight: FontWeight.bold, color: _ProfileColors.secondary)),
              TextSpan(text: 'Tutup (Kurasi Ragi)'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Jl. Wijaya Timur No. 42, Kebayoran Baru, Jakarta Selatan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: _ProfileColors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _linkItem(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: _ProfileColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
