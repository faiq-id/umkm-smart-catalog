import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_event.dart';
import '../bloc/store_state.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../ui/common.dart';
import '../utils/format.dart';
import 'admin_login_page.dart';

enum AdminSection {
  ringkasan,
  katalog,
  stok,
  pesanan,
  profil,
  laporan,
  pengaturan,
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key, this.authService});

  final AuthService? authService;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  AuthService? _resolvedAuthService;
  bool _guestPreview = false;
  String? _seededForStoreKey;

  AuthService _getAuthService(BuildContext context) {
    return _resolvedAuthService ??=
        widget.authService ?? context.read<StoreBloc>().authService;
  }

  @override
  Widget build(BuildContext context) {
    final authService = _getAuthService(context);
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      initialData: authService.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.hasError ? null : snapshot.data;
        if (user != null) {
          final currentStoreId = context.read<StoreBloc>().state.currentStoreId;
          final seedKey = '${user.uid}:$currentStoreId';
          if (_seededForStoreKey != seedKey) {
            _seededForStoreKey = seedKey;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context
                    .read<StoreBloc>()
                    .add(const StoreEvent.adminEnsureCloudSeeded());
              }
            });
          }
          return _AdminDashboardView(
            isGuestPreview: false,
            userEmail: user.email,
            onSignOut: () async {
              await authService.signOut();
              if (context.mounted) {
                showToast(context, 'Anda telah keluar dari Panel Admin',
                    icon: Icons.logout_rounded);
              }
            },
          );
        }

        if (_guestPreview && AppConfig.canUseGuestPreview) {
          return _AdminDashboardView(
            isGuestPreview: true,
            userEmail: null,
            onSignOut: () => setState(() => _guestPreview = false),
          );
        }

        return AdminLoginPage(
          authService: authService,
          onGuestPreview: AppConfig.canUseGuestPreview
              ? () => setState(() => _guestPreview = true)
              : null,
        );
      },
    );
  }
}

class _AdminDashboardView extends StatefulWidget {
  const _AdminDashboardView({
    required this.isGuestPreview,
    required this.userEmail,
    required this.onSignOut,
  });

  final bool isGuestPreview;
  final String? userEmail;
  final VoidCallback onSignOut;

  @override
  State<_AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<_AdminDashboardView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AdminSection _section = AdminSection.ringkasan;
  String _tableFilter = 'all'; // 'all' | 'available' | 'soldout'
  String _searchQuery = '';
  String? _loadedStoreId;

  late final TextEditingController _waCtrl;
  late final TextEditingController _announcementCtrl;
  late final TextEditingController _bannerImageCtrl;
  late final TextEditingController _searchCtrl;
  late final TextEditingController _storeNameCtrl;
  late final TextEditingController _storeTaglineCtrl;
  late final TextEditingController _storeAddressCtrl;
  late final TextEditingController _storeIgCtrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<StoreBloc>().state;
    final store = state.store;
    _loadedStoreId = state.currentStoreId;
    _waCtrl = TextEditingController(
      text: store.whatsapp.isNotEmpty ? store.whatsapp : '+62 812-3456-7890',
    );
    _announcementCtrl = TextEditingController(
      text: store.promo.title,
    );
    _bannerImageCtrl = TextEditingController(
      text: store.banner,
    );
    _searchCtrl = TextEditingController();
    _storeNameCtrl = TextEditingController(text: store.name);
    _storeTaglineCtrl = TextEditingController(text: store.tagline);
    _storeAddressCtrl = TextEditingController(text: store.address);
    _storeIgCtrl = TextEditingController(text: store.instagram);
  }

  void _syncControllersForStore(StoreState state) {
    if (_loadedStoreId == state.currentStoreId) return;
    _loadedStoreId = state.currentStoreId;
    final store = state.store;
    _waCtrl.text = store.whatsapp;
    _announcementCtrl.text = store.promo.title;
    _bannerImageCtrl.text = store.banner;
    _storeNameCtrl.text = store.name;
    _storeTaglineCtrl.text = store.tagline;
    _storeAddressCtrl.text = store.address;
    _storeIgCtrl.text = store.instagram;
  }

  @override
  void dispose() {
    _waCtrl.dispose();
    _announcementCtrl.dispose();
    _bannerImageCtrl.dispose();
    _searchCtrl.dispose();
    _storeNameCtrl.dispose();
    _storeTaglineCtrl.dispose();
    _storeAddressCtrl.dispose();
    _storeIgCtrl.dispose();
    super.dispose();
  }

  void _openProductModal({Product? product}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => _ProductFormModal(
        product: product,
        onSaved: (p, isNew) {
          context.read<StoreBloc>().add(StoreEvent.adminSaveProduct(product: p));
          showToast(
            context,
            isNew
                ? 'Menu baru "${p.name}" berhasil ditambahkan!'
                : 'Perubahan "${p.name}" berhasil disimpan live!',
            icon: Icons.check_circle_rounded,
          );
        },
      ),
    );
  }

  void _deleteProduct(Product p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Produk?', style: Txt.serif(20, weight: FontWeight.w600)),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${p.name}" dari katalog toko? Tindakan ini dapat diulang dengan reset demo.',
          style: Txt.sans(14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Batal', style: Txt.sans(13.5, color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<StoreBloc>().add(StoreEvent.adminDeleteProduct(productId: p.id));
              showToast(context, '"${p.name}" berhasil dihapus dari katalog',
                  icon: Icons.delete_outline_rounded);
            },
            child: const Text('Hapus Produk'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1024;

    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        _syncControllersForStore(state);
        final store = state.store;
        final pal = store.palette;

        final sidebar = _AdminSidebar(
          store: store,
          activeSection: _section,
          isGuestPreview: widget.isGuestPreview,
          userEmail: widget.userEmail,
          onSignOut: widget.onSignOut,
          onSelect: (sec) {
            setState(() => _section = sec);
            if (!wide && _scaffoldKey.currentState?.isDrawerOpen == true) {
              Navigator.of(context).pop();
            }
          },
        );

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: pal.surface,
          drawer: wide ? null : Drawer(width: 288, child: sidebar),
          body: Row(
            children: [
              if (wide) SizedBox(width: 288, child: sidebar),
              Expanded(
                child: Column(
                  children: [
                    _AdminHeader(
                      store: store,
                      isWide: wide,
                      onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                      onViewStore: () => Navigator.of(context).pop(),
                    ),
                    if (widget.isGuestPreview)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        color: pal.secondarySoft,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            Text(
                              'Mode Simulasi Tamu — Perubahan hanya berlaku di browser Anda. Masuk sebagai Admin untuk menyimpan ke server.',
                              style: Txt.sans(12,
                                  weight: FontWeight.w600, color: pal.primary),
                            ),
                            InkWell(
                              onTap: widget.onSignOut,
                              child: Text(
                                'Masuk Admin →',
                                style: Txt.sans(12,
                                    weight: FontWeight.w800,
                                    color: pal.secondary),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (state.cloudError != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        color: const Color(0xFFFFE4E6),
                        child: Text(
                          'Sinkronisasi server tertunda: pastikan aturan keamanan (firestore.rules) sudah dipublikasikan di Firebase Console. (${state.cloudError})',
                          style: Txt.sans(12,
                              weight: FontWeight.w600,
                              color: const Color(0xFF9F1239)),
                        ),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildBody(context, state, store, pal),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context, StoreState state, StoreProfile store, StorePalette pal) {
    if (_section == AdminSection.katalog) {
      return _buildCatalogView(context, state, store, pal);
    }
    if (_section == AdminSection.stok) {
      return _buildStockBatchView(context, state, store, pal);
    }
    if (AppConfig.enableOrdersAndReports && _section == AdminSection.pesanan) {
      return _buildOrdersView(context, state, pal);
    }
    if (_section == AdminSection.profil || _section == AdminSection.pengaturan) {
      return _buildStoreSettingsView(context, state, store, pal);
    }
    if (AppConfig.enableOrdersAndReports && _section == AdminSection.laporan) {
      return _buildReportsView(context, state, store, pal);
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1360),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header & Quick Action Bar
              _buildTopBar(state, store, pal),
              const SizedBox(height: 28),

              // 2. Ringkasan Statistik KPI
              _buildKpiGrid(state, store, pal),
              const SizedBox(height: 28),

              // 3. Pengaturan Cepat Toko (Quick Controls)
              _buildQuickControls(state, store, pal),
              const SizedBox(height: 36),

              // 4. Daftar Kelola Produk (Table View)
              _buildProductTableSection(state, store, pal),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Header & Quick Action Bar
  // ---------------------------------------------------------------------------
  Widget _buildTopBar(StoreState state, StoreProfile store, StorePalette pal) {
    final mobile = Bp.mobile(context);
    final statusLabel = widget.isGuestPreview
        ? 'Mode Simulasi Tamu (Lokal)'
        : (state.cloudSyncing
            ? 'Menyimpan ke Cloud...'
            : 'Cloud Live • Tersimpan Otomatis');
    final statusBg = widget.isGuestPreview
        ? pal.surfaceHigh
        : const Color(0xFFD1FAE5);
    final statusFg = widget.isGuestPreview
        ? pal.onSurfaceVariant
        : const Color(0xFF065F46);

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      runSpacing: 16,
      spacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 6,
              children: [
                Text(
                  'ATELIER COMMAND CENTER',
                  style: Txt.sans(11.5,
                      weight: FontWeight.w800, color: pal.secondary, spacing: 1.2),
                ),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                      color: pal.outlineVariant, shape: BoxShape.circle),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.isGuestPreview
                            ? Icons.visibility_outlined
                            : Icons.cloud_done_outlined,
                        size: 13,
                        color: statusFg,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        statusLabel,
                        style: Txt.sans(11.5,
                            weight: FontWeight.w700, color: statusFg),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Kelola Katalog & Status Toko',
              style: Txt.serif(mobile ? 28 : 34,
                  weight: FontWeight.w500, color: pal.primary, spacing: -0.4),
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Text(
                AppConfig.enableOrdersAndReports
                    ? 'Panel manajemen operasional cepat UMKM ${store.name}. Pantau stok produk live, pesanan WhatsApp pelanggan, dan etalase publik.'
                    : 'Panel manajemen operasional cepat UMKM ${store.name}. Kelola katalog menu, stok produk live, status gerai, dan promo etalase publik.',
                style: Txt.sans(14, color: pal.onSurfaceVariant, height: 1.5),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            PillButton(
              label: 'Pratinjau Toko Publik',
              trailingIcon: Icons.north_east_rounded,
              bg: pal.surfaceContainer,
              hoverBg: pal.surfaceHigh,
              fg: pal.primary,
              fontSize: 12.5,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              onTap: () => Navigator.of(context).pop(),
            ),
            PillButton(
              label: 'Tambah Produk Baru',
              icon: Icons.add_rounded,
              bg: pal.primary,
              hoverBg: pal.primaryContainer,
              fg: Colors.white,
              fontSize: 12.5,
              shadow: true,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              onTap: () => _openProductModal(),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Ringkasan Statistik KPI
  // ---------------------------------------------------------------------------
  Widget _buildKpiGrid(StoreState state, StoreProfile store, StorePalette pal) {
    final products = store.products;
    final total = products.length;
    final available = products.where((p) => !p.soldOut).length;
    final soldOut = products.where((p) => p.soldOut).length;
    final discounted = products
        .where((p) => p.originalPrice != null && p.originalPrice! > p.price)
        .length;
    final categoryCount =
        store.categories.where((cat) => cat.id != 'all').length;
    final orders = state.currentOrders;
    final totalRevenue = orders.fold<int>(0, (sum, o) => sum + o.total);

    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 1024 ? 4 : (c.maxWidth >= 600 ? 2 : 1);
      final gap = 16.0;
      final w = (c.maxWidth - (cols - 1) * gap) / cols;

      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          // Total Menu
          _KpiCard(
            width: w,
            title: 'TOTAL MENU',
            icon: Icons.menu_book_outlined,
            iconBg: pal.surfaceContainer,
            iconFg: pal.primary,
            value: '$total',
            unit: 'Menu',
            subtitle: '$categoryCount kategori katalog',
            subIcon: Icons.category_outlined,
            subColor: pal.secondary,
            pal: pal,
          ),
          // Stok Tersedia
          _KpiCard(
            width: w,
            title: 'STOK TERSEDIA',
            icon: Icons.check_circle_outlined,
            iconBg: const Color(0xFFECFDF5),
            iconFg: const Color(0xFF065F46),
            value: '$available',
            unit: 'Menu Aktif',
            badge: 'Siap Dipesan Pelanggan',
            badgeBg: const Color(0xFFD1FAE5),
            badgeFg: const Color(0xFF065F46),
            pal: pal,
          ),
          // Stok Habis
          _KpiCard(
            width: w,
            title: 'STOK HABIS',
            icon: Icons.inventory_2_outlined,
            iconBg: const Color(0xFFFEF3C7),
            iconFg: const Color(0xFF92400E),
            value: '$soldOut',
            unit: 'Sold Out',
            badge: soldOut > 0 ? '$soldOut Menu Perlu Restock' : 'Semua Menu Siap Jual',
            badgeBg: const Color(0xFFFDE68A),
            badgeFg: const Color(0xFF78350F),
            pal: pal,
          ),
          if (AppConfig.enableOrdersAndReports)
            // Pesanan WhatsApp (Add-on / Paket Lengkap)
            _KpiCard(
              width: w,
              title: 'PESANAN WHATSAPP',
              icon: Icons.chat_outlined,
              iconBg: pal.surfaceContainer,
              iconFg: pal.secondary,
              value: '${orders.isNotEmpty ? orders.length : 38}',
              unit: 'Transaksi',
              subtitle:
                  'Omzet: ${rupiah(totalRevenue > 0 ? totalRevenue : 2840000)}',
              subColor: pal.primary,
              pal: pal,
            )
          else
            // Promo & Diskon Aktif (Paket Standar — 100% Data Live)
            _KpiCard(
              width: w,
              title: 'PROMO & DISKON',
              icon: Icons.local_offer_outlined,
              iconBg: pal.surfaceContainer,
              iconFg: pal.secondary,
              value: '$discounted',
              unit: 'Menu Diskon',
              badge: state.promoActive
                  ? 'Banner Promo Aktif (${store.promo.percent}%)'
                  : 'Banner Promo Nonaktif',
              badgeBg: state.promoActive
                  ? const Color(0xFFD1FAE5)
                  : pal.surfaceContainer,
              badgeFg: state.promoActive
                  ? const Color(0xFF065F46)
                  : pal.onSurfaceVariant,
              pal: pal,
            ),
        ],
      );
    });
  }

  // ---------------------------------------------------------------------------
  // 3. Pengaturan Cepat Toko
  // ---------------------------------------------------------------------------
  Widget _buildQuickControls(
      StoreState state, StoreProfile store, StorePalette pal) {
    final isOpen = state.isOpenAt(DateTime.now());
    final promoActive = state.promoActive;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: pal.surfaceLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: LayoutBuilder(builder: (context, c) {
        final wide = c.maxWidth >= 900;
        final w = wide ? (c.maxWidth - 28) / 3 : c.maxWidth;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            // Card 1: Sakelar Buka / Tutup Toko
            Container(
              width: w,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: pal.surfaceLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: pal.primaryContainer.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STATUS OPERASIONAL GERAI',
                        style: Txt.sans(11,
                            weight: FontWeight.w700,
                            color: pal.outline,
                            spacing: 0.6),
                      ),
                      Switch(
                        value: isOpen,
                        activeThumbColor: Colors.white,
                        activeTrackColor: pal.primary,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: pal.outlineVariant,
                        onChanged: (val) {
                          context
                              .read<StoreBloc>()
                              .add(StoreEvent.adminToggleOpen(val));
                          showToast(
                            context,
                            val ? 'Status Toko: BUKA' : 'Status Toko: TUTUP SEMENTARA',
                            icon: Icons.store_rounded,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: isOpen
                              ? const Color(0xFF059669)
                              : const Color(0xFFDC2626),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isOpen ? 'BUKA (Menerima Pesanan)' : 'TUTUP SEMENTARA',
                          overflow: TextOverflow.ellipsis,
                          style: Txt.serif(16,
                              weight: FontWeight.w600, color: pal.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Jam Operasional: 07.00 - 21.30 WIB',
                      style: Txt.sans(12.5, color: pal.onSurfaceVariant)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          size: 14, color: pal.outline),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Jika ditutup, tombol checkout pada etalase menampilkan pesan libur.',
                          style: Txt.sans(11.5,
                              color: pal.onSurfaceVariant.withValues(alpha: 0.8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card 2: Edit Nomor WhatsApp Order
            Container(
              width: w,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: pal.surfaceLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: pal.primaryContainer.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'WHATSAPP ADMIN DELI',
                        style: Txt.sans(11,
                            weight: FontWeight.w700,
                            color: pal.outline,
                            spacing: 0.6),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Terkoneksi',
                          style: Txt.sans(11,
                              weight: FontWeight.w700,
                              color: const Color(0xFF065F46)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tujuan pesanan dari keranjang belanja pelanggan',
                    style: Txt.sans(12.5, color: pal.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: pal.surfaceLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _waCtrl,
                            style: Txt.sans(13,
                                weight: FontWeight.w600, color: pal.primary),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.phone_iphone_rounded,
                                  size: 18, color: pal.outline),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PillButton(
                        label: 'Simpan',
                        bg: pal.surfaceContainer,
                        hoverBg: pal.surfaceHigh,
                        fg: pal.primary,
                        fontSize: 12,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        onTap: () {
                          context.read<StoreBloc>().add(
                              StoreEvent.adminUpdateStoreInfo(whatsapp: _waCtrl.text));
                          showToast(context, 'Nomor WhatsApp berhasil disimpan: ${_waCtrl.text}',
                              icon: Icons.check_circle_rounded);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card 3: Banner Pengumuman Toko
            Container(
              width: w,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: pal.surfaceLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: pal.primaryContainer.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.campaign_outlined, size: 16, color: pal.secondary),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'BANNER PENGUMUMAN TOKO',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Txt.sans(11,
                                    weight: FontWeight.w700,
                                    color: pal.outline,
                                    spacing: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            promoActive ? 'Aktif' : 'Off',
                            style: Txt.sans(11,
                                weight: FontWeight.w700,
                                color: promoActive ? pal.secondary : pal.outline),
                          ),
                          const SizedBox(width: 4),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: promoActive,
                              activeThumbColor: Colors.white,
                              activeTrackColor: pal.secondary,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: pal.outlineVariant,
                              onChanged: (val) {
                                context
                                    .read<StoreBloc>()
                                    .add(StoreEvent.adminTogglePromo(val));
                                showToast(
                                  context,
                                  val
                                      ? 'Banner promosi diaktifkan di toko publik'
                                      : 'Banner promosi disembunyikan',
                                  icon: Icons.campaign_rounded,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Teks & foto banner utama pada etalase toko pelanggan',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Txt.sans(12.5, color: pal.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Tooltip(
                        message: 'Klik untuk ubah foto banner',
                        child: InkWell(
                          onTap: () => _openBannerPhotoDialog(store, pal),
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: ValueListenableBuilder<TextEditingValue>(
                                    valueListenable: _bannerImageCtrl,
                                    builder: (context, val, _) {
                                      return AppImage(
                                        src: val.text.isNotEmpty ? val.text : store.banner,
                                        emoji: store.emoji,
                                        fit: BoxFit.cover,
                                        cacheWidth: 100,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 1,
                                bottom: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.black87,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.photo_camera_rounded, size: 9, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: pal.surfaceLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _announcementCtrl,
                            style: Txt.sans(12.5, color: pal.primary),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: InputBorder.none,
                              hintText: 'Teks pengumuman toko...',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PillButton(
                        label: 'Simpan',
                        bg: pal.surfaceContainer,
                        hoverBg: pal.surfaceHigh,
                        fg: pal.primary,
                        fontSize: 12,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        onTap: () {
                          final title = _announcementCtrl.text.trim();
                          final img = _bannerImageCtrl.text.trim();
                          context.read<StoreBloc>().add(
                                StoreEvent.adminUpdatePromoBanner(
                                  title: title.isNotEmpty ? title : null,
                                  bannerImage: img.isNotEmpty ? img : null,
                                ),
                              );
                          showToast(context, 'Banner pengumuman berhasil disimpan!',
                              icon: Icons.check_circle_rounded);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _openBannerPhotoDialog(store, pal),
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.photo_library_outlined, size: 13, color: pal.secondary),
                            const SizedBox(width: 4),
                            Text('Ganti Foto Banner...',
                                style: Txt.sans(11.5, weight: FontWeight.w700, color: pal.secondary)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text('Live Update di Toko',
                          style: Txt.sans(11, color: pal.outline)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _presetChip({
    required String label,
    required StorePalette pal,
    bool selected = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? pal.secondarySoft
              : pal.surfaceLow,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? pal.secondary
                : pal.outlineVariant.withValues(alpha: 0.5),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(Icons.check_rounded, size: 13, color: pal.secondary),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: Txt.sans(11.5,
                  color: selected ? pal.secondary : pal.primary,
                  weight: selected ? FontWeight.w700 : FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _openBannerPhotoDialog(StoreProfile store, StorePalette pal) {
    final bannerCtrl = TextEditingController(
      text: _bannerImageCtrl.text.isNotEmpty
          ? _bannerImageCtrl.text
          : store.banner,
    );
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final currentUrl = bannerCtrl.text.trim();
            final bannerPresets = [
              (
                'Bakery Morning Counter',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDKj4Kmn5YO_jsQZmK4COfshtvr-Mhj3H5TNDoZFylOTrLxC2sRe0ah-vlTxD5GQmJ_jkuEhYpOXnomMxhtSdUKF3ttv8YRS1FYqew3lZG4EoldMSwUAmMHC2QvOwxBaK0d3_WveIKdnP0bjniWMS2AQcwhU03ra7C5sIJEAxT072R2IORcqOlASC-slNnMdaq35BdF4CSauaK_m0Tq1WagP1oBFpaSFb9_F77TD4E'
              ),
              (
                'Almond Croissants Showcase',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCr2wH9AHj-nElvPmbhPRG5hntXAlHEh50vp6huPhU9Dqrbagfrm4HjIG3P53UmztxkCtAE79-NhqAufUXZ5u4J9l7SOH3Vnxgl1FJGaN6YzSSmYXU0rbr8Lc8mhfHVJYsgbNts3HADtoIbIszEwKjoNYQ5-mK4jFKlKYqcAtptgVawEb9Xa1_rIvFFNFtZGt2YfAjIg3VOWNZbynl_Wa0TYXk10Jq_NtKhlOV8c4o'
              ),
              (
                'Bordeaux Canelé Oven',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDlxMPbo8sJNAlGu8SHqnOzie7Zavvo4CwnyHwxYVolDGrNf1YXkRolM7rShWCeCCM8em_cz3dvr-cpU5c0z4FZIkt8RddGrpjcVYwNEJ6Jjrk-cxqrQciLSs8U1Yk-Rnd8zGC1m4tTEY4-JN4TmqyDOAQzR0EC1bqSjQIMa87fRMxtxQc6cRONZwamOjjHjPI5BbLjO-fbStir8JWW3y3c-HxeQGKQmxUHetJbMA0'
              ),
              (
                'Specialty Coffee Roaster',
                'assets/images/coffee_banner.jpg'
              ),
              (
                'Happy Pet Lifestyle',
                'assets/images/pet_banner.jpg'
              ),
            ];

            return Dialog(
              backgroundColor: pal.surfaceLowest,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 18),
                      decoration: BoxDecoration(
                        color: pal.surfaceLow,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.photo_library_outlined,
                                  size: 20, color: pal.secondary),
                              const SizedBox(width: 10),
                              Text(
                                'Ganti Foto Banner Pengumuman',
                                style: Txt.serif(18,
                                    weight: FontWeight.w600,
                                    color: pal.primary),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () => Navigator.of(dialogCtx).pop(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pratinjau Foto Banner',
                              style: Txt.sans(12.5,
                                  weight: FontWeight.w700, color: pal.primary)),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: AspectRatio(
                              aspectRatio: 16 / 7,
                              child: AppImage(
                                src: currentUrl.isNotEmpty
                                    ? currentUrl
                                    : store.banner,
                                emoji: store.emoji,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Pilih Foto Rekomendasi (Preset)',
                              style: Txt.sans(12,
                                  weight: FontWeight.w700, color: pal.outline)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: bannerPresets.map((preset) {
                              final isSelected = currentUrl == preset.$2;
                              return _presetChip(
                                label: preset.$1,
                                pal: pal,
                                selected: isSelected,
                                onTap: () {
                                  bannerCtrl.text = preset.$2;
                                  setDialogState(() {});
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          Text('Atau Masukkan URL / Link Gambar Sendiri',
                              style: Txt.sans(12,
                                  weight: FontWeight.w700, color: pal.outline)),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: pal.surfaceLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: pal.outlineVariant
                                      .withValues(alpha: 0.4)),
                            ),
                            child: TextField(
                              controller: bannerCtrl,
                              onChanged: (_) => setDialogState(() {}),
                              style: Txt.sans(12, color: pal.primary),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                                hintText: 'https://...',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: pal.surfaceLow,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PillButton(
                            label: 'Batal',
                            bg: pal.surfaceContainer,
                            hoverBg: pal.surfaceHigh,
                            fg: pal.primary,
                            fontSize: 12,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 9),
                            onTap: () => Navigator.of(dialogCtx).pop(),
                          ),
                          const SizedBox(width: 10),
                          PillButton(
                            label: 'Terapkan Foto Banner',
                            bg: pal.primary,
                            hoverBg: pal.primaryContainer,
                            fg: Colors.white,
                            fontSize: 12,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 9),
                            onTap: () {
                              final newUrl = bannerCtrl.text.trim();
                              setState(() {
                                _bannerImageCtrl.text = newUrl;
                              });
                              context.read<StoreBloc>().add(
                                    StoreEvent.adminUpdatePromoBanner(
                                      bannerImage:
                                          newUrl.isNotEmpty ? newUrl : null,
                                    ),
                                  );
                              Navigator.of(dialogCtx).pop();
                              showToast(
                                  context, 'Foto banner berhasil diperbarui live!',
                                  icon: Icons.check_circle_rounded);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Daftar Kelola Produk (Table View Interaktif)
  // ---------------------------------------------------------------------------
  Widget _buildProductTableSection(
      StoreState state, StoreProfile store, StorePalette pal) {
    final allProducts = store.products;
    final availableCount = allProducts.where((p) => !p.soldOut).length;
    final soldOutCount = allProducts.where((p) => p.soldOut).length;

    var filtered = allProducts.where((p) {
      if (_tableFilter == 'available' && p.soldOut) return false;
      if (_tableFilter == 'soldout' && !p.soldOut) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = p.name.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.desc.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Bar
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 12,
          spacing: 12,
          children: [
            Wrap(
              spacing: 8,
              children: [
                _TableFilterButton(
                  label: 'Semua (${allProducts.length})',
                  active: _tableFilter == 'all',
                  onTap: () => setState(() => _tableFilter = 'all'),
                  pal: pal,
                ),
                _TableFilterButton(
                  label: 'Tersedia ($availableCount)',
                  active: _tableFilter == 'available',
                  onTap: () => setState(() => _tableFilter = 'available'),
                  pal: pal,
                ),
                _TableFilterButton(
                  label: 'Habis ($soldOutCount)',
                  active: _tableFilter == 'soldout',
                  onTap: () => setState(() => _tableFilter = 'soldout'),
                  pal: pal,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: pal.surfaceLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: pal.outlineVariant.withValues(alpha: 0.4)),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: Txt.sans(13, color: pal.primary),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Cari pastry, coffee, toast...',
                      hintStyle: Txt.sans(12.5, color: pal.outline),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search_rounded,
                          size: 18, color: pal.outline),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Filter Lanjutan',
                  icon: Icon(Icons.tune_rounded, color: pal.outline),
                  style: IconButton.styleFrom(
                    backgroundColor: pal.surfaceLowest,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Table Container
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: pal.surfaceLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: pal.primaryContainer.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 880),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(pal.surfaceLow),
                headingTextStyle: Txt.sans(11.5,
                    weight: FontWeight.w700,
                    color: pal.onSurfaceVariant,
                    spacing: 0.8),
                dataRowMinHeight: 68,
                dataRowMaxHeight: 76,
                columns: const [
                  DataColumn(label: Text('PRODUK')),
                  DataColumn(label: Text('KATEGORI')),
                  DataColumn(label: Text('HARGA ATELIER')),
                  DataColumn(label: Text('STATUS ETALASE')),
                  DataColumn(label: Text('SAKELAR CEPAT')),
                  DataColumn(label: Text('TINDAKAN')),
                ],
                rows: [
                  for (final p in filtered)
                    DataRow(
                      cells: [
                        // Produk (Gambar + Nama + Deskripsi)
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: AppImage(
                                    src: p.image,
                                    emoji: p.emoji,
                                    grayscale: p.soldOut,
                                    cacheWidth: 150,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    p.name,
                                    style: Txt.serif(15.5,
                                        weight: FontWeight.w600,
                                        color: pal.primary),
                                  ),
                                  const SizedBox(height: 2),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 240),
                                    child: Text(
                                      p.desc,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Txt.sans(12,
                                          color: pal.onSurfaceVariant),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Kategori
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: pal.surfaceContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              p.category.toUpperCase(),
                              style: Txt.sans(10.5,
                                  weight: FontWeight.w700,
                                  color: pal.onSurfaceVariant,
                                  spacing: 0.6),
                            ),
                          ),
                        ),
                        // Harga
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                rupiah(p.price),
                                style: Txt.sans(13.5,
                                    weight: FontWeight.w800, color: pal.primary),
                              ),
                              if (p.hasDiscount)
                                Text(
                                  rupiah(p.originalPrice!),
                                  style: Txt.sans(11,
                                      color: pal.outline,
                                      decoration: TextDecoration.lineThrough),
                                ),
                            ],
                          ),
                        ),
                        // Status Etalase
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: !p.soldOut
                                  ? const Color(0xFFD1FAE5)
                                  : const Color(0xFFFFE4E6),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: !p.soldOut
                                        ? const Color(0xFF059669)
                                        : const Color(0xFFE11D48),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  !p.soldOut ? 'Tersedia' : 'Habis Terjual',
                                  style: Txt.sans(11.5,
                                      weight: FontWeight.w700,
                                      color: !p.soldOut
                                          ? const Color(0xFF065F46)
                                          : const Color(0xFF9F1239)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Sakelar Cepat
                        DataCell(
                          Switch(
                            value: !p.soldOut,
                            activeThumbColor: Colors.white,
                            activeTrackColor: const Color(0xFF059669),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: pal.outlineVariant,
                            onChanged: (val) {
                              final newStock = val ? 15 : 0;
                              context.read<StoreBloc>().add(
                                  StoreEvent.adminUpdateStock(
                                      productId: p.id, stock: newStock));
                              showToast(
                                context,
                                val
                                    ? '${p.name} diubah menjadi Tersedia'
                                    : '${p.name} diubah menjadi Habis Terjual',
                                icon: val
                                    ? Icons.check_circle_rounded
                                    : Icons.inventory_2_rounded,
                              );
                            },
                          ),
                        ),
                        // Tindakan
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PillButton(
                                label: 'Edit Produk',
                                bg: pal.surfaceContainer,
                                hoverBg: pal.surfaceHigh,
                                fg: pal.primary,
                                fontSize: 12,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 7),
                                onTap: () => _openProductModal(product: p),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                tooltip: 'Hapus Produk',
                                icon: Icon(Icons.delete_outline_rounded,
                                    size: 18, color: pal.outline),
                                hoverColor: const Color(0xFFFFE4E6),
                                onPressed: () => _deleteProduct(p),
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
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // View Dedicated: Katalog Produk
  // ---------------------------------------------------------------------------
  Widget _buildCatalogView(
      BuildContext context, StoreState state, StoreProfile store, StorePalette pal) {
    final allProducts = store.products;
    final availableCount = allProducts.where((p) => !p.soldOut).length;
    final soldOutCount = allProducts.where((p) => p.soldOut).length;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1360),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.end,
                runSpacing: 16,
                spacing: 16,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: pal.secondary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'KATALOG STUDIO • ${store.shortName.toUpperCase()}',
                              style: Txt.sans(11,
                                  weight: FontWeight.w800,
                                  color: pal.secondary,
                                  spacing: 0.8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('• Mode Live Update',
                              style: Txt.sans(11.5, color: pal.outline)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Katalog & Menu Etalase Toko',
                          style: Txt.serif(28,
                              weight: FontWeight.w600, color: pal.primary)),
                      const SizedBox(height: 4),
                      Text(
                        'Kelola semua rincian menu, foto produk, kategori, harga normal, harga diskon, dan status tayang di web pelanggan.',
                        style: Txt.sans(13.5, color: pal.onSurfaceVariant),
                      ),
                    ],
                  ),
                  PillButton(
                    label: 'Tambah Menu Baru',
                    icon: Icons.add_circle_outline_rounded,
                    bg: pal.primary,
                    hoverBg: pal.primaryContainer,
                    fg: Colors.white,
                    shadow: true,
                    fontSize: 13,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    onTap: () => _openProductModal(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // KPI Stats Ringkas Katalog
              LayoutBuilder(builder: (context, constraints) {
                final w = (constraints.maxWidth - 48) / 4;
                final isNarrow = constraints.maxWidth < 900;
                final cardW = isNarrow ? (constraints.maxWidth - 16) / 2 : w;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _catalogStatCard(
                      label: 'TOTAL MENU',
                      value: '${allProducts.length}',
                      subtitle: 'Item terdaftar di katalog',
                      icon: Icons.restaurant_menu_rounded,
                      pal: pal,
                      width: cardW,
                    ),
                    _catalogStatCard(
                      label: 'MENU TAYANG',
                      value: '$availableCount',
                      subtitle: 'Siap dipesan pelanggan',
                      icon: Icons.check_circle_outline_rounded,
                      color: const Color(0xFF059669),
                      pal: pal,
                      width: cardW,
                    ),
                    _catalogStatCard(
                      label: 'MENU HABIS',
                      value: '$soldOutCount',
                      subtitle: 'Ditandai sold out di web',
                      icon: Icons.highlight_off_rounded,
                      color: soldOutCount > 0
                          ? const Color(0xFFE11D48)
                          : pal.outline,
                      pal: pal,
                      width: cardW,
                    ),
                    _catalogStatCard(
                      label: 'KATEGORI AKTIF',
                      value: '${store.categories.length - 1}',
                      subtitle: 'Grup menu etalase',
                      icon: Icons.category_outlined,
                      pal: pal,
                      width: cardW,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 28),

              // Tabel Produk Interaktif
              _buildProductTableSection(state, store, pal),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _catalogStatCard({
    required String label,
    required String value,
    required String subtitle,
    required IconData icon,
    required StorePalette pal,
    required double width,
    Color? color,
  }) {
    final c = color ?? pal.secondary;
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: pal.surfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: pal.primaryContainer.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: Txt.sans(10.5,
                      weight: FontWeight.w800,
                      color: pal.outline,
                      spacing: 0.8)),
              Icon(icon, size: 18, color: c),
            ],
          ),
          const SizedBox(height: 10),
          Text(value,
              style: Txt.serif(26, weight: FontWeight.w600, color: pal.primary)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: Txt.sans(11.5, color: pal.onSurfaceVariant)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // View Dedicated: Kontrol Stok Cepat (Ready / Habis)
  // ---------------------------------------------------------------------------
  Widget _buildStockBatchView(
      BuildContext context, StoreState state, StoreProfile store, StorePalette pal) {
    final allProducts = store.products;
    final outOfStockCount = allProducts.where((p) => p.soldOut).length;
    final readyCount = allProducts.length - outOfStockCount;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1360),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.end,
                runSpacing: 16,
                spacing: 16,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.toggle_on_rounded,
                                    size: 15, color: Color(0xFF065F46)),
                                const SizedBox(width: 5),
                                Text(
                                  'KONTROL STOK ETALASE • LIVE',
                                  style: Txt.sans(11,
                                      weight: FontWeight.w800,
                                      color: const Color(0xFF065F46),
                                      spacing: 0.8),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('• Sakelar 1-Klik Siap Jual',
                              style: Txt.sans(11.5, color: pal.outline)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Kontrol Stok (Ready / Habis)',
                          style: Txt.serif(28,
                              weight: FontWeight.w600, color: pal.primary)),
                      const SizedBox(height: 4),
                      Text(
                        'Sakelar cepat untuk mengatur ketersediaan menu secara live. Menu yang ditandai habis otomatis berlabel "Habis Terjual" pada katalog dan pemesanan WhatsApp pelanggan.',
                        style: Txt.sans(13.5, color: pal.onSurfaceVariant),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      PillButton(
                        label: 'Setel Semua Menu Ready',
                        icon: Icons.check_circle_outline_rounded,
                        bg: const Color(0xFF059669),
                        hoverBg: const Color(0xFF047857),
                        fg: Colors.white,
                        fontSize: 12.5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 11),
                        onTap: () {
                          for (final p in allProducts) {
                            if (p.soldOut || p.stock == 0) {
                              context.read<StoreBloc>().add(
                                    StoreEvent.adminUpdateStock(
                                      productId: p.id,
                                      stock: 15,
                                    ),
                                  );
                            }
                          }
                          showToast(
                            context,
                            'Semua menu kini berstatus "Siap Dipesan" di etalase!',
                            icon: Icons.check_circle_rounded,
                          );
                        },
                      ),
                      PillButton(
                        label: 'Restock Semua (+10)',
                        icon: Icons.add_box_outlined,
                        bg: pal.surfaceContainer,
                        hoverBg: pal.surfaceHigh,
                        fg: pal.primary,
                        fontSize: 12.5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 11),
                        onTap: () {
                          for (final p in allProducts) {
                            context.read<StoreBloc>().add(
                                  StoreEvent.adminUpdateStock(
                                    productId: p.id,
                                    stock: p.stock + 10,
                                  ),
                                );
                          }
                          showToast(
                            context,
                            'Semua menu berhasil ditambah +10 porsi!',
                            icon: Icons.check_circle_rounded,
                          );
                        },
                      ),
                      PillButton(
                        label: 'Simulasi Pesanan WhatsApp',
                        icon: Icons.chat_outlined,
                        bg: const Color(0xFF25D366).withValues(alpha: 0.15),
                        hoverBg: const Color(0xFF25D366).withValues(alpha: 0.25),
                        fg: const Color(0xFF075E54),
                        fontSize: 12.5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 11),
                        onTap: () => _openWhatsAppPreviewDialog(store, pal),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3 Status Cards Ringkas & Realistis
              LayoutBuilder(builder: (context, constraints) {
                final w = (constraints.maxWidth - 32) / 3;
                final isNarrow = constraints.maxWidth < 960;
                final cardW = isNarrow ? constraints.maxWidth : w;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    // Card 1: Menu Siap Dipesan
                    Container(
                      width: cardW,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: pal.surfaceLowest,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: pal.outlineVariant.withValues(alpha: 0.35)),
                        boxShadow: [
                          BoxShadow(
                            color: pal.primaryContainer.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded,
                                      size: 16, color: Color(0xFF059669)),
                                  const SizedBox(width: 6),
                                  Text(
                                    'STATUS ETALASE PUBLIK',
                                    style: Txt.sans(11,
                                        weight: FontWeight.w800,
                                        color: const Color(0xFF059669),
                                        spacing: 0.6),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text('Live di Web',
                                    style: Txt.sans(10.5,
                                        weight: FontWeight.w700,
                                        color: const Color(0xFF065F46))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$readyCount Menu Siap Dipesan',
                            style: Txt.serif(18,
                                weight: FontWeight.w600, color: pal.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pelanggan dapat langsung memasukkan menu ini ke keranjang belanja dan checkout ke WhatsApp.',
                            style: Txt.sans(12, color: pal.onSurfaceVariant),
                          ),
                          const SizedBox(height: 14),
                          InkWell(
                            onTap: () {
                              for (final p in allProducts) {
                                if (p.soldOut || p.stock == 0) {
                                  context.read<StoreBloc>().add(
                                        StoreEvent.adminUpdateStock(
                                          productId: p.id,
                                          stock: 15,
                                        ),
                                      );
                                }
                              }
                              showToast(context, 'Semua menu disetel siap jual!');
                            },
                            child: Row(
                              children: [
                                Text('Setel Semua Siap Jual',
                                    style: Txt.sans(12,
                                        weight: FontWeight.w700,
                                        color: const Color(0xFF059669))),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward_rounded,
                                    size: 14, color: Color(0xFF059669)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Card 2: Menu Habis Terjual
                    Container(
                      width: cardW,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: outOfStockCount > 0
                            ? const Color(0xFFFFF1F2)
                            : pal.surfaceLowest,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: outOfStockCount > 0
                                ? const Color(0xFFFECDD3)
                                : pal.outlineVariant.withValues(alpha: 0.35)),
                        boxShadow: [
                          BoxShadow(
                            color: pal.primaryContainer.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.inventory_2_outlined,
                                      size: 16,
                                      color: outOfStockCount > 0
                                          ? const Color(0xFFE11D48)
                                          : const Color(0xFF059669)),
                                  const SizedBox(width: 6),
                                  Text(
                                    'ALERT MENU HABIS',
                                    style: Txt.sans(11,
                                        weight: FontWeight.w800,
                                        color: outOfStockCount > 0
                                            ? const Color(0xFFE11D48)
                                            : const Color(0xFF059669),
                                        spacing: 0.6),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: outOfStockCount > 0
                                      ? const Color(0xFFFFE4E6)
                                      : const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  outOfStockCount > 0
                                      ? '$outOfStockCount Menu Habis'
                                      : 'Stok Terkendali',
                                  style: Txt.sans(10.5,
                                      weight: FontWeight.w700,
                                      color: outOfStockCount > 0
                                          ? const Color(0xFF9F1239)
                                          : const Color(0xFF065F46)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            outOfStockCount > 0
                                ? '$outOfStockCount menu berlabel "Habis Terjual"'
                                : 'Semua menu dalam kondisi siap dipesan',
                            style: Txt.serif(18,
                                weight: FontWeight.w600,
                                color: outOfStockCount > 0
                                    ? const Color(0xFF9F1239)
                                    : pal.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            outOfStockCount > 0
                                ? 'Menu yang habis otomatis tidak bisa di-checkout pelanggan, mencegah kasir menolak pesanan.'
                                : 'Tidak ada menu yang kehabisan stok saat ini.',
                            style: Txt.sans(12, color: pal.onSurfaceVariant),
                          ),
                          const SizedBox(height: 14),
                          InkWell(
                            onTap: () {
                              for (final p in allProducts) {
                                if (p.soldOut || p.stock <= 0) {
                                  context.read<StoreBloc>().add(
                                        StoreEvent.adminUpdateStock(
                                          productId: p.id,
                                          stock: 10,
                                        ),
                                      );
                                }
                              }
                              showToast(
                                context,
                                'Menu yang habis berhasil direstock +10!',
                                icon: Icons.check_circle_rounded,
                              );
                            },
                            child: Row(
                              children: [
                                Text('Restock Menu Habis (+10)',
                                    style: Txt.sans(12,
                                        weight: FontWeight.w700,
                                        color: pal.secondary)),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_forward_rounded,
                                    size: 14, color: pal.secondary),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Card 3: Integrasi Order WhatsApp (Rekomendasi #1)
                    Container(
                      width: cardW,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: pal.surfaceLowest,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: pal.outlineVariant.withValues(alpha: 0.35)),
                        boxShadow: [
                          BoxShadow(
                            color: pal.primaryContainer.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.chat_bubble_outline_rounded,
                                      size: 16, color: pal.secondary),
                                  const SizedBox(width: 6),
                                  Text(
                                    'PESANAN VIA WHATSAPP',
                                    style: Txt.sans(11,
                                        weight: FontWeight.w800,
                                        color: pal.secondary,
                                        spacing: 0.6),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: pal.surfaceLow,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text('Siap Kirim',
                                    style: Txt.sans(10.5,
                                        weight: FontWeight.w700,
                                        color: pal.primary)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Format Pesanan Rapi & Akurat',
                            style: Txt.serif(18,
                                weight: FontWeight.w600, color: pal.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pesan pelanggan tersusun rapi dengan nama menu, catatan porsi, dan total rupiah yang siap diproses kasir.',
                            style: Txt.sans(12, color: pal.onSurfaceVariant),
                          ),
                          const SizedBox(height: 14),
                          InkWell(
                            onTap: () => _openWhatsAppPreviewDialog(store, pal),
                            child: Row(
                              children: [
                                Text('Lihat Contoh Pesanan WA',
                                    style: Txt.sans(12,
                                        weight: FontWeight.w700,
                                        color: pal.secondary)),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_forward_rounded,
                                    size: 14, color: pal.secondary),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 32),

              // Tabel Kontrol Stok Khusus (Live Stock Controller!)
              _buildStockTable(state, store, pal),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockTable(
      StoreState state, StoreProfile store, StorePalette pal) {
    final allProducts = store.products;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: pal.surfaceLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: pal.primaryContainer.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              color: pal.surfaceLow,
              border: Border(
                  bottom: BorderSide(
                      color: pal.outlineVariant.withValues(alpha: 0.35))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('KONTROL KUOTA PORSI PER MENU',
                        style: Txt.sans(11,
                            weight: FontWeight.w800,
                            color: pal.secondary,
                            spacing: 0.8)),
                    const SizedBox(height: 2),
                    Text(
                      'Klik tombol [-] / [+] atau Sakelar Cepat untuk ubah stok live di toko',
                      style: Txt.sans(12.5, color: pal.onSurfaceVariant),
                    ),
                  ],
                ),
                Text('Total ${allProducts.length} Produk',
                    style: Txt.sans(12,
                        weight: FontWeight.w600, color: pal.outline)),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 920),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(pal.surfaceLow),
                headingTextStyle: Txt.sans(11.5,
                    weight: FontWeight.w700,
                    color: pal.onSurfaceVariant,
                    spacing: 0.8),
                dataRowMinHeight: 68,
                dataRowMaxHeight: 76,
                columns: const [
                  DataColumn(label: Text('PRODUK MENU')),
                  DataColumn(label: Text('KATEGORI')),
                  DataColumn(label: Text('SISA KUOTA PORSI')),
                  DataColumn(label: Text('STATUS STOK')),
                  DataColumn(label: Text('SAKELAR CEPAT')),
                  DataColumn(label: Text('TAMBAH CEPAT')),
                ],
                rows: [
                  for (final p in allProducts)
                    DataRow(
                      cells: [
                        // Produk
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: AppImage(
                                    src: p.image,
                                    emoji: p.emoji,
                                    grayscale: p.soldOut,
                                    cacheWidth: 120,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(p.name,
                                      style: Txt.serif(15,
                                          weight: FontWeight.w600,
                                          color: pal.primary)),
                                  const SizedBox(height: 2),
                                  Text(rupiah(p.price),
                                      style: Txt.sans(12,
                                          color: pal.secondary,
                                          weight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Kategori
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: pal.surfaceLow,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                  color: pal.outlineVariant
                                      .withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              p.badge.isNotEmpty
                                  ? p.badge.toUpperCase()
                                  : p.category.toUpperCase(),
                              style: Txt.sans(10.5,
                                  weight: FontWeight.w700,
                                  color: pal.onSurfaceVariant,
                                  spacing: 0.6),
                            ),
                          ),
                        ),

                        // Counter Porsi [-] [qty] [+]
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: p.stock > 0
                                    ? () {
                                        context.read<StoreBloc>().add(
                                              StoreEvent.adminUpdateStock(
                                                productId: p.id,
                                                stock: p.stock - 1,
                                              ),
                                            );
                                      }
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: p.stock > 0
                                        ? pal.surfaceContainer
                                        : pal.surfaceLow,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: pal.outlineVariant
                                            .withValues(alpha: 0.5)),
                                  ),
                                  child: Icon(Icons.remove_rounded,
                                      size: 16,
                                      color: p.stock > 0
                                          ? pal.primary
                                          : pal.outlineVariant),
                                ),
                              ),
                              Container(
                                width: 72,
                                alignment: Alignment.center,
                                child: Text(
                                  p.stock > 0 ? '${p.stock} Porsi' : '0 Porsi',
                                  style: Txt.sans(13,
                                      weight: FontWeight.w800,
                                      color: p.stock > 0
                                          ? pal.primary
                                          : const Color(0xFFE11D48)),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  context.read<StoreBloc>().add(
                                        StoreEvent.adminUpdateStock(
                                          productId: p.id,
                                          stock: p.stock + 1,
                                        ),
                                      );
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: pal.surfaceContainer,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: pal.outlineVariant
                                            .withValues(alpha: 0.5)),
                                  ),
                                  child: Icon(Icons.add_rounded,
                                      size: 16, color: pal.primary),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status Stok Badge
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: p.stock > 5
                                  ? const Color(0xFFD1FAE5)
                                  : (p.stock > 0
                                      ? const Color(0xFFFEF3C7)
                                      : const Color(0xFFFFE4E6)),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: p.stock > 5
                                        ? const Color(0xFF059669)
                                        : (p.stock > 0
                                            ? const Color(0xFFD97706)
                                            : const Color(0xFFE11D48)),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  p.stock > 5
                                      ? 'Stok Aman'
                                      : (p.stock > 0
                                          ? 'Sisa Sedikit'
                                          : 'Habis Terjual'),
                                  style: Txt.sans(11.5,
                                      weight: FontWeight.w700,
                                      color: p.stock > 5
                                          ? const Color(0xFF065F46)
                                          : (p.stock > 0
                                              ? const Color(0xFF92400E)
                                              : const Color(0xFF9F1239))),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Sakelar Cepat
                        DataCell(
                          Transform.scale(
                            scale: 0.85,
                            child: Switch(
                              value: !p.soldOut,
                              activeThumbColor: Colors.white,
                              activeTrackColor: const Color(0xFF059669),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: pal.outlineVariant,
                              onChanged: (val) {
                                final newStock = val ? 15 : 0;
                                context.read<StoreBloc>().add(
                                      StoreEvent.adminUpdateStock(
                                        productId: p.id,
                                        stock: newStock,
                                      ),
                                    );
                                showToast(
                                  context,
                                  val
                                      ? '"${p.name}" sekarang Tersedia di etalase'
                                      : '"${p.name}" ditandai Habis Terjual',
                                  icon: val
                                      ? Icons.check_circle_rounded
                                      : Icons.remove_circle_outline_rounded,
                                );
                              },
                            ),
                          ),
                        ),

                        // Tambah Cepat Buttons
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.read<StoreBloc>().add(
                                        StoreEvent.adminUpdateStock(
                                          productId: p.id,
                                          stock: p.stock + 5,
                                        ),
                                      );
                                  showToast(
                                      context, '+5 Porsi "${p.name}" ditambahkan!');
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: pal.surfaceLow,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: pal.outlineVariant
                                            .withValues(alpha: 0.5)),
                                  ),
                                  child: Text('+5',
                                      style: Txt.sans(11.5,
                                          weight: FontWeight.w700,
                                          color: pal.primary)),
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () {
                                  context.read<StoreBloc>().add(
                                        StoreEvent.adminUpdateStock(
                                          productId: p.id,
                                          stock: p.stock + 10,
                                        ),
                                      );
                                  showToast(
                                      context, '+10 Porsi "${p.name}" ditambahkan!');
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: pal.secondary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: pal.secondary
                                            .withValues(alpha: 0.4)),
                                  ),
                                  child: Text('+10',
                                      style: Txt.sans(11.5,
                                          weight: FontWeight.w700,
                                          color: pal.secondary)),
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
        ],
      ),
    );
  }

  void _openWhatsAppPreviewDialog(StoreProfile store, StorePalette pal) {
    final firstProd = store.products.isNotEmpty ? store.products[0] : null;
    final secondProd = store.products.length > 1 ? store.products[1] : firstProd;
    final p1Name = firstProd?.name ?? 'Menu Unggulan';
    final p1Price = firstProd?.price ?? 35000;
    final p2Name = secondProd?.name ?? 'Minuman Spesial';
    final p2Price = secondProd?.price ?? 28000;
    final totalOrder = (p1Price * 2) + p2Price + 2000;

    final sampleOrder = 'Halo ${store.name}, saya ingin memesan via etalase web:\n\n'
        '📋 Rincian Pesanan:\n'
        '• 2x $p1Name (${rupiah(p1Price * 2)})\n'
        '• 1x $p2Name (${rupiah(p2Price)})\n\n'
        'Subtotal Menu: ${rupiah((p1Price * 2) + p2Price)}\n'
        'Biaya Kemasan: Rp 2.000\n'
        'Total Pembayaran: ${rupiah(totalOrder)}\n\n'
        '📍 Data Pemesan:\n'
        '• Nama: Rian Pratama\n'
        '• WhatsApp: 0812-8899-7766\n'
        '• Alamat: Jl. Senopati Dalam No. 18, Jakarta Selatan\n'
        '• Catatan: Mohon dipacking rapi & aman ya kak.\n\n'
        'Terima kasih!';

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: pal.surfaceLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chat_outlined,
                  color: Color(0xFF059669), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Format Pesanan WhatsApp Masuk',
                      style: Txt.serif(18,
                          weight: FontWeight.w600, color: pal.primary)),
                  const SizedBox(height: 2),
                  Text(
                    'Contoh pesan yang dikirim pelanggan ke nomor WhatsApp: ${store.whatsapp}',
                    style: Txt.sans(12, color: pal.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            size: 15, color: Color(0xFF16A34A)),
                        const SizedBox(width: 6),
                        Text('Format Pesan Langsung Rapi & Terstruktur',
                            style: Txt.sans(11.5,
                                weight: FontWeight.w700,
                                color: const Color(0xFF15803D))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDCFCE7)),
                      ),
                      child: SelectableText(
                        sampleOrder,
                        style: Txt.sans(12,
                            color: const Color(0xFF166534), height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '💡 Tombol "Pesan via WhatsApp" membuka aplikasi WhatsApp dengan format pesanan di atas yang sudah terisi. Pelanggan tinggal menekan kirim, sehingga kasir tidak perlu mencatat ulang. Pesanan belum masuk ke sistem secara otomatis.',
                style: Txt.sans(12,
                    color: pal.onSurfaceVariant, height: 1.45),
              ),
            ],
          ),
        ),
        actions: [
          PillButton(
            label: 'Tutup',
            bg: pal.surfaceContainer,
            hoverBg: pal.surfaceHigh,
            fg: pal.primary,
            fontSize: 12.5,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            onTap: () => Navigator.of(dialogCtx).pop(),
          ),
          PillButton(
            label: 'Buka Chat WhatsApp (Test)',
            icon: Icons.open_in_new_rounded,
            bg: const Color(0xFF059669),
            hoverBg: const Color(0xFF047857),
            fg: Colors.white,
            fontSize: 12.5,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            onTap: () {
              Navigator.of(dialogCtx).pop();
              openUrl(waLink(store.whatsapp, sampleOrder));
              showToast(
                context,
                'Membuka WhatsApp ke nomor gerai ${store.whatsapp}...',
                icon: Icons.chat_outlined,
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // View Pesanan Deli (Live Orders)
  // ---------------------------------------------------------------------------
  Widget _buildOrdersView(
      BuildContext context, StoreState state, StorePalette pal) {
    final orders = state.currentOrders;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pesanan Masuk Gerai & Kafe',
                  style: Txt.serif(28, color: pal.primary)),
              const SizedBox(height: 6),
              Text('Pantau antrean pesanan masuk dari Pesan Antar (Delivery) dan Ambil di Gerai (Pickup).',
                  style: Txt.sans(14, color: pal.onSurfaceVariant)),
              const SizedBox(height: 24),
              for (final o in orders)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(18),
                  decoration: cardDecoration(pal, radius: 18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: pal.surfaceContainer, shape: BoxShape.circle),
                        child: Icon(Icons.receipt_long_rounded,
                            color: pal.secondary, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(o.id,
                                    style: Txt.sans(14,
                                        weight: FontWeight.w800,
                                        color: pal.primary)),
                                const SizedBox(width: 8),
                                Text('• ${o.customer}',
                                    style: Txt.sans(13.5,
                                        weight: FontWeight.w600,
                                        color: pal.primary)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: pal.surfaceContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(o.channel,
                                      style: Txt.sans(11,
                                          color: pal.onSurfaceVariant)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(o.items.join(', '),
                                style: Txt.sans(13, color: pal.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(rupiah(o.total),
                              style: Txt.sans(14,
                                  weight: FontWeight.w800, color: pal.primary)),
                          const SizedBox(height: 4),
                          DropdownButton<OrderStatus>(
                            value: o.status,
                            isDense: true,
                            underline: const SizedBox(),
                            items: OrderStatus.values.map((s) {
                              return DropdownMenuItem(
                                value: s,
                                child: Text(s.name.toUpperCase(),
                                    style: Txt.sans(11, weight: FontWeight.w700)),
                              );
                            }).toList(),
                            onChanged: (newStatus) {
                              if (newStatus != null) {
                                context.read<StoreBloc>().add(
                                    StoreEvent.adminUpdateOrderStatus(
                                        orderId: o.id, status: newStatus));
                              }
                            },
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

  // ---------------------------------------------------------------------------
  // View Profil & Pengaturan
  // ---------------------------------------------------------------------------
  Widget _buildStoreSettingsView(BuildContext context, StoreState state,
      StoreProfile store, StorePalette pal) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profil & Gerai UMKM',
                  style: Txt.serif(28, color: pal.primary)),
              const SizedBox(height: 6),
              Text('Informasi gerai yang tampil pada header dan footer etalase.',
                  style: Txt.sans(14, color: pal.onSurfaceVariant)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: cardDecoration(pal, radius: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama Gerai',
                        style: Txt.sans(13, weight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(controller: _storeNameCtrl),
                    const SizedBox(height: 18),
                    Text('Tagline / Slogan',
                        style: Txt.sans(13, weight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(controller: _storeTaglineCtrl),
                    const SizedBox(height: 18),
                    Text('Alamat Fisik',
                        style: Txt.sans(13, weight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(controller: _storeAddressCtrl),
                    const SizedBox(height: 18),
                    Text('Nomor WhatsApp Pesanan',
                        style: Txt.sans(13, weight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(controller: _waCtrl),
                    const SizedBox(height: 18),
                    Text('Instagram (@username)',
                        style: Txt.sans(13, weight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(controller: _storeIgCtrl),
                    const SizedBox(height: 22),
                    Align(
                      alignment: Alignment.centerRight,
                      child: PillButton(
                        label: 'Simpan Profil Gerai',
                        icon: Icons.check_circle_outline_rounded,
                        bg: pal.primary,
                        hoverBg: pal.primaryContainer,
                        fg: Colors.white,
                        fontSize: 13,
                        shadow: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 11),
                        onTap: () {
                          context.read<StoreBloc>().add(
                                StoreEvent.adminUpdateStoreInfo(
                                  name: _storeNameCtrl.text.trim(),
                                  tagline: _storeTaglineCtrl.text.trim(),
                                  address: _storeAddressCtrl.text.trim(),
                                  whatsapp: _waCtrl.text.trim(),
                                  instagram: _storeIgCtrl.text.trim(),
                                ),
                              );
                          showToast(
                            context,
                            widget.isGuestPreview
                                ? 'Profil gerai diperbarui (simulasi lokal)'
                                : 'Profil gerai berhasil disimpan ke Cloud!',
                            icon: Icons.cloud_done_outlined,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: cardDecoration(pal, radius: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Database & Reset Template',
                        style: Txt.serif(20,
                            weight: FontWeight.w600, color: pal.primary)),
                    const SizedBox(height: 6),
                    Text(
                      'Gunakan tombol ini setelah sesi demo ke klien untuk mengembalikan katalog, harga, dan stok ${store.shortName} ke data bawaan awal.',
                      style: Txt.sans(13,
                          color: pal.onSurfaceVariant, height: 1.45),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        PillButton(
                          label: 'Reset Katalog ke Data Awal',
                          icon: Icons.restart_alt_rounded,
                          bg: pal.surfaceContainer,
                          hoverBg: pal.surfaceHigh,
                          fg: pal.primary,
                          border: pal.outlineVariant,
                          fontSize: 12.5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 11),
                          onTap: () {
                            context
                                .read<StoreBloc>()
                                .add(const StoreEvent.adminResetToTemplate());
                            showToast(
                              context,
                              'Katalog ${store.shortName} dikembalikan ke data awal!',
                              icon: Icons.restart_alt_rounded,
                            );
                          },
                        ),
                        PillButton(
                          label: widget.isGuestPreview
                              ? 'Masuk Akun Admin'
                              : 'Keluar (Logout)',
                          icon: widget.isGuestPreview
                              ? Icons.login_rounded
                              : Icons.logout_rounded,
                          bg: const Color(0xFFFFE4E6),
                          hoverBg: const Color(0xFFFECDD3),
                          fg: const Color(0xFF9F1239),
                          fontSize: 12.5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 11),
                          onTap: widget.onSignOut,
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

  // ---------------------------------------------------------------------------
  // View Laporan Penjualan
  // ---------------------------------------------------------------------------
  Widget _buildReportsView(BuildContext context, StoreState state,
      StoreProfile store, StorePalette pal) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Laporan Penjualan & Performa Deli',
                  style: Txt.serif(28, color: pal.primary)),
              const SizedBox(height: 6),
              Text('Ringkasan transaksi dan produk terlaris minggu ini.',
                  style: Txt.sans(14, color: pal.onSurfaceVariant)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: cardDecoration(pal, radius: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Omzet Minggu Ini',
                            style: Txt.sans(14, color: pal.onSurfaceVariant)),
                        Text('Rp 18.450.000',
                            style: Txt.serif(22,
                                weight: FontWeight.w700, color: pal.primary)),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Varian Terlaris (Top Seller)',
                            style: Txt.sans(14, color: pal.onSurfaceVariant)),
                        Text('Almond Flaky Croissant (142 porsi)',
                            style: Txt.sans(14,
                                weight: FontWeight.w700, color: pal.secondary)),
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

// ---------------------------------------------------------------------------
// SIDEBAR ADMIN (Fixed Left Navigation)
// ---------------------------------------------------------------------------
class _AdminSidebar extends StatelessWidget {
  const _AdminSidebar({
    required this.store,
    required this.activeSection,
    required this.isGuestPreview,
    required this.userEmail,
    required this.onSignOut,
    required this.onSelect,
  });

  final StoreProfile store;
  final AdminSection activeSection;
  final bool isGuestPreview;
  final String? userEmail;
  final VoidCallback onSignOut;
  final ValueChanged<AdminSection> onSelect;

  @override
  Widget build(BuildContext context) {
    final pal = store.palette;

    return Container(
      color: pal.surfaceLow,
      child: Column(
        children: [
          // Brand Header
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        store.shortName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Txt.serif(20,
                            weight: FontWeight.w600, color: pal.primary),
                      ),
                      Text(
                        'ADMIN ${store.id == 'bakery' ? 'ATELIER' : (store.id == 'coffee' ? 'KEDAI' : 'GERAI')}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Txt.sans(10.5,
                            weight: FontWeight.w700,
                            color: pal.onSurfaceVariant,
                            spacing: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: pal.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'UMKM',
                    style: Txt.sans(10,
                        weight: FontWeight.w800, color: pal.secondary),
                  ),
                ),
              ],
            ),
          ),

          // Mode Admin Aktif Pill
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: pal.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  PulseDot(
                    color: isGuestPreview
                        ? pal.outline
                        : const Color(0xFF059669),
                    size: 8,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isGuestPreview
                          ? 'Simulasi Tamu'
                          : 'Admin Cloud Aktif',
                      overflow: TextOverflow.ellipsis,
                      style: Txt.sans(12,
                          weight: FontWeight.w700, color: pal.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8, bottom: 6),
                  child: Text(
                    'ATELIER OPERATIONS',
                    style: Txt.sans(10,
                        weight: FontWeight.w700,
                        color: pal.outline,
                        spacing: 1.2),
                  ),
                ),
                _SidebarItem(
                  icon: Icons.space_dashboard_outlined,
                  label: 'Ringkasan Atelier',
                  active: activeSection == AdminSection.ringkasan,
                  onTap: () => onSelect(AdminSection.ringkasan),
                  pal: pal,
                ),
                _SidebarItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Katalog Produk',
                  active: activeSection == AdminSection.katalog,
                  onTap: () => onSelect(AdminSection.katalog),
                  pal: pal,
                ),
                _SidebarItem(
                  icon: Icons.toggle_on_outlined,
                  label: 'Kontrol Stok (Ready/Habis)',
                  active: activeSection == AdminSection.stok,
                  onTap: () => onSelect(AdminSection.stok),
                  pal: pal,
                ),
                if (AppConfig.enableOrdersAndReports)
                  _SidebarItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'Pesanan Deli',
                    active: activeSection == AdminSection.pesanan,
                    onTap: () => onSelect(AdminSection.pesanan),
                    pal: pal,
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 20, bottom: 6),
                  child: Text(
                    'PENGATURAN BUTIK',
                    style: Txt.sans(10,
                        weight: FontWeight.w700,
                        color: pal.outline,
                        spacing: 1.2),
                  ),
                ),
                _SidebarItem(
                  icon: Icons.storefront_outlined,
                  label: 'Profil & Gerai UMKM',
                  active: activeSection == AdminSection.profil,
                  onTap: () => onSelect(AdminSection.profil),
                  pal: pal,
                ),
                if (AppConfig.enableOrdersAndReports)
                  _SidebarItem(
                    icon: Icons.query_stats_outlined,
                    label: 'Laporan Penjualan',
                    active: activeSection == AdminSection.laporan,
                    onTap: () => onSelect(AdminSection.laporan),
                    pal: pal,
                  ),
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Pengaturan Atelier',
                  active: activeSection == AdminSection.pengaturan,
                  onTap: () => onSelect(AdminSection.pengaturan),
                  pal: pal,
                ),
              ],
            ),
          ),

          // User Profile Card at Bottom
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: pal.surfaceHigh.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: pal.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isGuestPreview
                          ? Icons.visibility_outlined
                          : Icons.verified_user_rounded,
                      size: 17,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isGuestPreview ? 'Pratinjau Tamu' : 'Admin Resmi',
                          style: Txt.sans(12.5,
                              weight: FontWeight.w700, color: pal.primary),
                        ),
                        Text(
                          userEmail ?? 'Simulasi • ${store.shortName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Txt.sans(11, color: pal.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: isGuestPreview
                        ? 'Masuk Akun Admin'
                        : 'Keluar dari Admin',
                    onPressed: onSignOut,
                    icon: Icon(
                      isGuestPreview
                          ? Icons.login_rounded
                          : Icons.logout_rounded,
                      size: 18,
                      color: pal.primary,
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
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    required this.pal,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final StorePalette pal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Hover(
        onTap: onTap,
        builder: (context, h) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? pal.primaryContainer
                : (h ? pal.surfaceContainer : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: active
                    ? Colors.white
                    : (h ? pal.primary : pal.onSurfaceVariant),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Txt.sans(13.5,
                      weight: active ? FontWeight.w700 : FontWeight.w500,
                      color: active
                          ? Colors.white
                          : (h ? pal.primary : pal.onSurfaceVariant)),
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
// TOP HEADER ADMIN
// ---------------------------------------------------------------------------
class _AdminHeader extends StatelessWidget {
  const _AdminHeader({
    required this.store,
    required this.isWide,
    required this.onOpenDrawer,
    required this.onViewStore,
  });

  final StoreProfile store;
  final bool isWide;
  final VoidCallback onOpenDrawer;
  final VoidCallback onViewStore;

  @override
  Widget build(BuildContext context) {
    final pal = store.palette;
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: width < 600 ? 12 : 24),
      decoration: BoxDecoration(
        color: pal.surface.withValues(alpha: 0.9),
        border: Border(
            bottom: BorderSide(color: pal.outlineVariant.withValues(alpha: 0.3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!isWide)
                IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: onOpenDrawer,
                ),
              if (width >= 560)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: pal.surfaceLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings_outlined,
                          size: 18, color: pal.outline),
                      const SizedBox(width: 8),
                      Text(
                        'GERAI UTAMA JAKARTA',
                        style: Txt.sans(11.5,
                            weight: FontWeight.w700,
                            color: pal.onSurfaceVariant,
                            spacing: 0.8),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Row(
            children: [
              PillButton(
                label: width >= 720
                    ? 'Lihat Toko Publik (Katalog)'
                    : (width >= 480 ? 'Lihat Toko' : 'Toko'),
                icon: Icons.visibility_outlined,
                bg: pal.surfaceContainer,
                hoverBg: pal.surfaceHigh,
                fg: pal.primary,
                fontSize: 12.5,
                padding: EdgeInsets.symmetric(
                    horizontal: width < 480 ? 10 : 16, vertical: 9),
                onTap: onViewStore,
              ),
              const SizedBox(width: 10),
              IconButton(
                tooltip: 'Notifikasi',
                style: IconButton.styleFrom(
                  backgroundColor: pal.surfaceLow,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: Stack(
                  children: [
                    Icon(Icons.notifications_outlined,
                        size: 20, color: pal.onSurfaceVariant),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: pal.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  showToast(context, 'Tidak ada notifikasi baru saat ini.');
                },
              ),
              if (width >= 480) ...[
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 24,
                  color: pal.outlineVariant.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 12),
              ],
              Row(
                children: [
                  if (width >= 640)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Pengelola Gerai',
                            style: Txt.sans(12.5,
                                weight: FontWeight.w700, color: pal.primary)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('WhatsApp Aktif',
                                style: Txt.sans(11,
                                    weight: FontWeight.w600,
                                    color: const Color(0xFF047857))),
                          ],
                        ),
                      ],
                    ),
                  if (width >= 640) const SizedBox(width: 10),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: pal.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded,
                        size: 18, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// KPI CARD WIDGET
// ---------------------------------------------------------------------------
class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.width,
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.value,
    required this.unit,
    this.subtitle,
    this.subIcon,
    this.subColor,
    this.badge,
    this.badgeBg,
    this.badgeFg,
    required this.pal,
  });

  final double width;
  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String value;
  final String unit;
  final String? subtitle;
  final IconData? subIcon;
  final Color? subColor;
  final String? badge;
  final Color? badgeBg;
  final Color? badgeFg;
  final StorePalette pal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: pal.surfaceLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: pal.primaryContainer.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Txt.sans(11,
                      weight: FontWeight.w700,
                      color: pal.onSurfaceVariant,
                      spacing: 0.8),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: iconFg),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: Txt.serif(34, weight: FontWeight.w600, color: pal.primary),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  unit,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Txt.sans(13, color: pal.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                badge!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Txt.sans(11, weight: FontWeight.w700, color: badgeFg),
              ),
            )
          else if (subtitle != null)
            Row(
              children: [
                if (subIcon != null) ...[
                  Icon(subIcon, size: 14, color: subColor),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Txt.sans(11.5,
                        weight: FontWeight.w700, color: subColor ?? pal.primary),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TABLE FILTER BUTTON
// ---------------------------------------------------------------------------
class _TableFilterButton extends StatelessWidget {
  const _TableFilterButton({
    required this.label,
    required this.active,
    required this.onTap,
    required this.pal,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final StorePalette pal;

  @override
  Widget build(BuildContext context) {
    return Hover(
      onTap: onTap,
      builder: (context, h) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? pal.primary
              : (h ? pal.surfaceHigh : pal.surfaceContainer),
          borderRadius: BorderRadius.circular(12),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: pal.primary.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: Txt.sans(12.5,
              weight: FontWeight.w700,
              color: active ? Colors.white : pal.onSurfaceVariant),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. MODAL FORM: TAMBAH / EDIT PRODUK
// ---------------------------------------------------------------------------
class _ProductFormModal extends StatefulWidget {
  const _ProductFormModal({this.product, required this.onSaved});
  final Product? product;
  final void Function(Product p, bool isNew) onSaved;

  @override
  State<_ProductFormModal> createState() => _ProductFormModalState();
}

class _ProductFormModalState extends State<_ProductFormModal> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _discountCtrl;
  late final TextEditingController _descCtrl;
  late String _category;
  late bool _available;
  late String _imageUrl;

  static const _categories = [
    'Viennoiserie',
    'French Pastry',
    'Signature Pastry',
    'Artisan Coffee',
    'Savory Gourmet',
    'Artisanal Bread',
    'Hampers & Gift',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(
      text: p != null ? formatDots(p.price) : '',
    );
    _discountCtrl = TextEditingController(
      text: p?.originalPrice != null ? formatDots(p!.originalPrice!) : '',
    );
    _descCtrl = TextEditingController(text: p?.desc ?? '');
    _category = p?.category != null && _categories.contains(p!.category)
        ? p.category
        : 'Viennoiserie';
    _available = p != null ? !p.soldOut : true;
    _imageUrl = p?.image ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _discountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _openChangeProductPhotoDialog(StorePalette pal) {
    final photoUrlCtrl = TextEditingController(text: _imageUrl);
    final presets = [
      (
        'Almond Flaky Croissant',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCr2wH9AHj-nElvPmbhPRG5hntXAlHEh50vp6huPhU9Dqrbagfrm4HjIG3P53UmztxkCtAE79-NhqAufUXZ5u4J9l7SOH3Vnxgl1FJGaN6YzSSmYXU0rbr8Lc8mhfHVJYsgbNts3HADtoIbIszEwKjoNYQ5-mK4jFKlKYqcAtptgVawEb9Xa1_rIvFFNFtZGt2YfAjIg3VOWNZbynl_Wa0TYXk10Jq_NtKhlOV8c4o'
      ),
      (
        'Smoked Canelé',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDlxMPbo8sJNAlGu8SHqnOzie7Zavvo4CwnyHwxYVolDGrNf1YXkRolM7rShWCeCCM8em_cz3dvr-cpU5c0z4FZIkt8RddGrpjcVYwNEJ6Jjrk-cxqrQciLSs8U1Yk-Rnd8zGC1m4tTEY4-JN4TmqyDOAQzR0EC1bqSjQIMa87fRMxtxQc6cRONZwamOjjHjPI5BbLjO-fbStir8JWW3y3c-HxeQGKQmxUHetJbMA0'
      ),
      (
        'Valrhona Pain au Chocolat',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBc4womnYUZzlz5uR_tGFzvgF_WgwIQ2FKn4slW5iEBof1GQ_W8uK9XiUqch1bfLZC6CvbK0ahE8GyjPtHTkD0l17Wy7Knpe6qkT_hhhvIX9JR_yfBLEJWfIK2rgEkmc6qWk8LxKVIWirW4TBhBSW9ce6iY5cGXZIitXrQAFalF6Ys80EfylVtPlprdV1ExEWBa2wX8mRx3yl-LuR1F8lt8NYUT6JOe0bc9_WWXShw'
      ),
      (
        'Iced Spanish Latte',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD7y6TBrXfrJRbA0I9NrT4OWcAO8xQzkxwog846wLL_yxLXKyKbM0QJ6LUPIIlljbR0s9SckagYBalFKdaolY-B2rwQsBXRpDuV4hEnQPClqD-Ntx0GFOV1pT7G_7pyfF0uHid_KFMAmrnFTHxMtToLLaSsjz19MhAuttQEML4wmx_Tis_eNPQ5Q31gjbD3468Pt9cZdjrn4vGV_ae3sFsOcfYfnl4v9PCK2ZuO6Ak'
      ),
      (
        'Pistachio Escargot',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA_ED0CnOl-IV1Uj_Ee5xyV9ATfAe_Sx33992HdNhPCFm5gVzs2w6Zr6lDVbnJOsrYk21kL7LJ9-3iYqyZpVquruOQzUHgPbNl03yaw3jozDVClzAvw5xCzBrb5uCTppRbYA5MGjtuRQp4BKDKgc-w8NZ2N7vDOobKCOpqQwh1XbQnlUhk-wj-VITr8P9Kn3M5s-ulAEpysWzzmFm6PwS4tPT6bpOI-NXhaKFoyO6I'
      ),
      (
        'Truffle Mushroom Toast',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBWtOjMjmYyIyck3576BFSYHtQwpf5I5uTkVQ6RE5ZDQg49Ffrkm1UF5Il5yDkqllLD9020yH8JfvIGxaod4iJtVHkvEkZT_V_AShUQsv4S3eNr3kcH-kGdv9BA0fLYHL8GuvodAeXQckc-_NhLqURFubzL2dcpvTj4_AjzZexWiFjc-BlpVBcxanNI5Ts-xYUAb7V83NaeOiymYl_097oowfyUkdvLD31wKdlQVy0'
      ),
      (
        'Artisan Pour-Over Coffee',
        'assets/images/coffee_1.jpg'
      ),
      (
        'Specialty Flat White',
        'assets/images/coffee_2.jpg'
      ),
      (
        'Pet Gourmet Nutrition',
        'assets/images/pet_1.jpg'
      ),
      (
        'Artisan Bakery Hampers',
        'assets/images/bakery_hampers.jpg'
      ),
      (
        'House Blend Coffee Beans',
        'assets/images/coffee_beans.jpg'
      ),
      (
        'Organic Tofu Cat Litter',
        'assets/images/pet_tofu_litter.jpg'
      ),
      (
        'Donut Plush Pet Bed',
        'assets/images/pet_donut_bed.jpg'
      ),
      (
        'Boutique Pet Hotel Suite',
        'assets/images/pet_hotel.jpg'
      ),
    ];

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setPhotoState) {
            final activeUrl = photoUrlCtrl.text.trim();
            return Dialog(
              backgroundColor: pal.surfaceLowest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                      decoration: BoxDecoration(
                        color: pal.surfaceLow,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, size: 20, color: pal.secondary),
                              const SizedBox(width: 8),
                              Text('Pilih Foto Produk',
                                  style: Txt.serif(18, weight: FontWeight.w600, color: pal.primary)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pratinjau Foto Produk',
                              style: Txt.sans(12.5, weight: FontWeight.w700, color: pal.primary)),
                          const SizedBox(height: 8),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                width: 140,
                                height: 140,
                                child: AppImage(
                                  src: activeUrl,
                                  emoji: widget.product?.emoji ?? '🥐',
                                  fit: BoxFit.cover,
                                  cacheWidth: 300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Pilih Foto Katalog Siap Pakai (Preset)',
                              style: Txt.sans(12, weight: FontWeight.w700, color: pal.outline)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: presets.map((p) {
                              final isSelected = activeUrl == p.$2;
                              return InkWell(
                                onTap: () {
                                  photoUrlCtrl.text = p.$2;
                                  setPhotoState(() {});
                                },
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? pal.secondarySoft
                                        : pal.surfaceLow,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: isSelected
                                          ? pal.secondary
                                          : pal.outlineVariant.withValues(alpha: 0.5),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isSelected) ...[
                                        Icon(Icons.check_rounded, size: 13, color: pal.secondary),
                                        const SizedBox(width: 4),
                                      ],
                                      Text(
                                        p.$1,
                                        style: Txt.sans(11.5,
                                            weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                            color: isSelected ? pal.secondary : pal.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          Text('Atau Masukkan URL / Link Gambar Sendiri',
                              style: Txt.sans(12, weight: FontWeight.w700, color: pal.outline)),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: pal.surfaceLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.4)),
                            ),
                            child: TextField(
                              controller: photoUrlCtrl,
                              onChanged: (_) => setPhotoState(() {}),
                              style: Txt.sans(12, color: pal.primary),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                                hintText: 'https://...',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: pal.surfaceLow,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PillButton(
                            label: 'Batal',
                            bg: pal.surfaceContainer,
                            hoverBg: pal.surfaceHigh,
                            fg: pal.primary,
                            fontSize: 12,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            onTap: () => Navigator.of(ctx).pop(),
                          ),
                          const SizedBox(width: 10),
                          PillButton(
                            label: 'Gunakan Foto Ini',
                            bg: pal.primary,
                            hoverBg: pal.primaryContainer,
                            fg: Colors.white,
                            fontSize: 12,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            onTap: () {
                              setState(() {
                                _imageUrl = photoUrlCtrl.text.trim();
                              });
                              Navigator.of(ctx).pop();
                              showToast(context, 'Foto produk diperbarui!',
                                  icon: Icons.check_circle_rounded);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      showToast(context, 'Mohon isi nama produk!');
      return;
    }
    final price = int.tryParse(_priceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (price <= 0) {
      showToast(context, 'Mohon masukkan harga yang valid!');
      return;
    }
    final originalPrice =
        int.tryParse(_discountCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));

    final isNew = widget.product == null;
    final p = widget.product ??
        Product(
          id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          desc: _descCtrl.text.trim(),
          category: _category.toLowerCase(),
          badge: _category,
          price: price,
          originalPrice: originalPrice,
          image: _imageUrl,
          rating: 5.0,
          reviews: 1,
          featureLabel: 'Fresh Daily',
          featureIcon: Icons.star_rounded,
          emoji: '🥐',
          stock: _available ? 15 : 0,
        );

    final updated = p.copyWith(
      name: name,
      category: _category.toLowerCase(),
      badge: _category,
      price: price,
      originalPrice: originalPrice,
      desc: _descCtrl.text.trim(),
      image: _imageUrl,
      stock: _available ? (p.stock > 0 ? p.stock : 15) : 0,
    );

    Navigator.of(context).pop();
    widget.onSaved(updated, isNew);
  }

  @override
  Widget build(BuildContext context) {
    final pal = context.watch<StoreBloc>().state.store.palette;
    final isEdit = widget.product != null;

    return Dialog(
      backgroundColor: pal.surfaceLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 820),
        child: Column(
          children: [
            // Header Modal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              decoration: BoxDecoration(
                color: pal.surfaceLow,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('KATALOG STUDIO',
                          style: Txt.sans(11,
                              weight: FontWeight.w800,
                              color: pal.secondary,
                              spacing: 1)),
                      const SizedBox(height: 2),
                      Text(
                        isEdit ? 'Edit Rincian Produk' : 'Tambah Menu Baru ke Katalog',
                        style: Txt.serif(20,
                            weight: FontWeight.w600, color: pal.primary),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upload Foto
                    Text('Foto Produk Atelier',
                        style: Txt.sans(13, weight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: pal.surfaceLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => _openChangeProductPhotoDialog(pal),
                            borderRadius: BorderRadius.circular(14),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: SizedBox(
                                    width: 72,
                                    height: 72,
                                    child: AppImage(
                                      src: _imageUrl,
                                      emoji: widget.product?.emoji ?? '🥐',
                                      fit: BoxFit.cover,
                                      cacheWidth: 200,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  bottom: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black87,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.photo_camera_rounded,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PillButton(
                                  label: 'Unggah / Ganti Foto',
                                  icon: Icons.cloud_upload_outlined,
                                  bg: pal.surfaceHigh,
                                  hoverBg: pal.surfaceContainer,
                                  fg: pal.primary,
                                  fontSize: 12,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  onTap: () => _openChangeProductPhotoDialog(pal),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '*Pilih foto dari preset atelier atau masukkan URL foto baru.',
                                  style: Txt.sans(11.5,
                                      weight: FontWeight.w600,
                                      color: pal.secondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nama Produk
                    Text('Nama Produk Pastry / Deli',
                        style: Txt.sans(13, weight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: pal.surfaceLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Kategori
                    Text('Kategori Menu',
                        style: Txt.sans(13, weight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: pal.surfaceLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _category,
                          isExpanded: true,
                          items: _categories.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text(c, style: Txt.sans(13.5)),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _category = v);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Harga & Diskon
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Harga Normal (Rp)',
                                  style: Txt.sans(13, weight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _priceCtrl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  ThousandsSeparatorInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: pal.surfaceLow,
                                  prefixText: 'Rp ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Harga Coret (Rp)',
                                      style: Txt.sans(13, weight: FontWeight.w700)),
                                  Text('Opsional',
                                      style: Txt.sans(11, color: pal.outline)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _discountCtrl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  ThousandsSeparatorInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: pal.surfaceLow,
                                  prefixText: 'Rp ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Deskripsi
                    Text('Deskripsi Singkat & Tasting Notes',
                        style: Txt.sans(13, weight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _descCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: pal.surfaceLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Status Ketersediaan
                    Text('Status Ketersediaan Awal',
                        style: Txt.sans(13, weight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _available = true),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: _available
                                    ? const Color(0xFFD1FAE5)
                                    : pal.surfaceLow,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _available
                                      ? const Color(0xFF059669)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tersedia Segera',
                                      style: Txt.sans(13,
                                          weight: FontWeight.w700,
                                          color: _available
                                              ? const Color(0xFF065F46)
                                              : pal.primary)),
                                  const SizedBox(height: 2),
                                  Text('Langsung tayang di etalase',
                                      style: Txt.sans(11.5,
                                          color: pal.onSurfaceVariant)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _available = false),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: !_available
                                    ? const Color(0xFFFFE4E6)
                                    : pal.surfaceLow,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: !_available
                                      ? const Color(0xFFE11D48)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Habis / Sold Out',
                                      style: Txt.sans(13,
                                          weight: FontWeight.w700,
                                          color: !_available
                                              ? const Color(0xFF9F1239)
                                              : pal.primary)),
                                  const SizedBox(height: 2),
                                  Text('Pelanggan melihat tanda habis',
                                      style: Txt.sans(11.5,
                                          color: pal.onSurfaceVariant)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer Modal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              decoration: BoxDecoration(
                color: pal.surfaceLow,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PillButton(
                    label: 'Batal',
                    bg: pal.surfaceContainer,
                    hoverBg: pal.surfaceHigh,
                    fg: pal.primary,
                    fontSize: 13,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 10),
                  PillButton(
                    label: 'Simpan Perubahan',
                    bg: pal.primary,
                    hoverBg: pal.primaryContainer,
                    fg: Colors.white,
                    fontSize: 13,
                    shadow: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 10),
                    onTap: _submit,
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
