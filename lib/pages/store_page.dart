import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_event.dart';
import '../bloc/store_state.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../sections/catalog.dart';
import '../sections/footer.dart';
import '../sections/hero.dart';
import '../sections/location.dart';
import '../sections/promo.dart';
import '../ui/common.dart';
import '../widgets/cart_bar.dart';
import 'admin_page.dart';
import 'hampers_store_view.dart';

enum NavSection { beranda, katalog, lokasi, qr }

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _keys = {for (final s in NavSection.values) s: GlobalKey()};
  final _activeNotifier = ValueNotifier<NavSection>(NavSection.beranda);
  DateTime _lastScrollCheck = DateTime.now();

  late final AnimationController _themeCtrl;
  final _isExitingNotifier = ValueNotifier<bool>(false);
  bool _isSwitching = false;

  @override
  void initState() {
    super.initState();
    _themeCtrl = AnimationController(vsync: this, value: 1.0);
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _themeCtrl.dispose();
    _isExitingNotifier.dispose();
    _scroll.dispose();
    _activeNotifier.dispose();
    super.dispose();
  }

  Future<void> _onSelectTheme(
    String targetId,
    String title,
    String brand,
    IconData icon,
  ) async {
    final currentId = context.read<StoreBloc>().state.currentStoreId;
    if (targetId == currentId) {
      scrollTo(NavSection.beranda);
      return;
    }
    if (_isSwitching) return;
    _isSwitching = true;

    // Fase 1: Komponen halaman lama (Tombol Header -> Banner Hero -> Promo -> Katalog)
    // menghilang perlahan secara berurutan (staggered) tanpa layar hitam
    _isExitingNotifier.value = true;
    await _themeCtrl.animateBack(
      0.0,
      duration: const Duration(milliseconds: 340),
      curve: Curves.linear,
    );
    if (!mounted) {
      _isSwitching = false;
      return;
    }

    // Ganti tema ke desain baru
    context.read<StoreBloc>().add(StoreEvent.switchTheme(targetId));
    if (_scroll.hasClients) {
      _scroll.jumpTo(0);
    }
    _activeNotifier.value = NavSection.beranda;

    // Tunggu 1 frame agar komponen desain baru siap
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      _isSwitching = false;
      return;
    }

    // Fase 2: Komponen desain baru muncul bergantian (Header -> Banner Hero -> Promo -> Katalog)
    _isExitingNotifier.value = false;
    await _themeCtrl.animateTo(
      1.0,
      duration: const Duration(milliseconds: 460),
      curve: Curves.linear,
    );
    _isSwitching = false;
    if (!mounted) return;
    showToast(
      context,
      'Beralih ke $title ($brand)',
      icon: icon,
    );
  }

  void _onScroll() {
    final now = DateTime.now();
    if (now.difference(_lastScrollCheck).inMilliseconds < 120) return;
    _lastScrollCheck = now;

    var current = NavSection.beranda;
    for (final s in [NavSection.katalog, NavSection.lokasi, NavSection.qr]) {
      final ctx = _keys[s]!.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy < 260) current = s;
    }
    if (current != _activeNotifier.value) {
      _activeNotifier.value = current;
    }
  }

  void scrollTo(NavSection s) {
    if (s == NavSection.beranda) {
      _scroll.animateTo(0,
          duration: const Duration(milliseconds: 600), curve: Curves.easeOutCubic);
      return;
    }
    final ctx = _keys[s]!.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          alignment: 0.02);
    }
  }

  void _openAdmin() {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (_, _, _) => const AdminPage(),
      transitionsBuilder: (_, a, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.03), end: Offset.zero)
              .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        final store = state.store;
        final pal = store.palette;

        final Widget activeStoreView = store.id == 'pet'
            ? HampersStoreView(onOpenAdmin: _openAdmin)
            : Scaffold(
                key: _scaffoldKey,
                backgroundColor: pal.surface,
                endDrawer: ValueListenableBuilder<NavSection>(
                  valueListenable: _activeNotifier,
                  builder: (context, active, _) => _MobileDrawer(
                    active: active,
                    onNav: (s) {
                      Navigator.of(context).pop();
                      Future.delayed(
                          const Duration(milliseconds: 250), () => scrollTo(s));
                    },
                    onAdmin: () {
                      Navigator.of(context).pop();
                      _openAdmin();
                    },
                  ),
                ),
                body: Stack(
                  children: [
                    Column(
                      children: [
                        RepaintBoundary(
                          child: StaggeredThemeBlock(
                            stage: 0,
                            child: ValueListenableBuilder<NavSection>(
                              valueListenable: _activeNotifier,
                              builder: (context, active, _) => _Header(
                                active: active,
                                onNav: scrollTo,
                                onAdmin: _openAdmin,
                                onMenu: () =>
                                    _scaffoldKey.currentState?.openEndDrawer(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Scrollbar(
                            controller: _scroll,
                            child: CustomScrollView(
                              key: ValueKey(store.id),
                              controller: _scroll,
                              physics: const ClampingScrollPhysics(),
                              slivers: [
                                SliverToBoxAdapter(
                                  child: RepaintBoundary(
                                    child: HeroSection(
                                      key: _keys[NavSection.beranda],
                                      onDirections: () =>
                                          scrollTo(NavSection.lokasi),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: RepaintBoundary(
                                    child: StaggeredThemeBlock(
                                      stage: 2,
                                      child: PromoBanner(
                                        onClaim: () =>
                                            scrollTo(NavSection.katalog),
                                      ),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: RepaintBoundary(
                                    child: StaggeredThemeBlock(
                                      stage: 3,
                                      child: CatalogSection(
                                        key: _keys[NavSection.katalog],
                                      ),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: RepaintBoundary(
                                    child: StaggeredThemeBlock(
                                      stage: 3,
                                      child: LocationSection(
                                        key: _keys[NavSection.lokasi],
                                        qrKey: _keys[NavSection.qr]!,
                                      ),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: RepaintBoundary(
                                    child: StaggeredThemeBlock(
                                      stage: 3,
                                      child: StoreFooter(onNav: scrollTo),
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

        final bgSurface =
            store.id == 'pet' ? const Color(0xFFECE7DF) : pal.surface;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 380),
          color: bgSurface,
          child: Stack(
            children: [
              ThemeTransitionScope(
                animation: _themeCtrl,
                isExitingNotifier: _isExitingNotifier,
                child: activeStoreView,
              ),
              if (AppConfig.isDemoShowcase)
                DemoBar(
                  onAdmin: _openAdmin,
                  onSwitched: () => scrollTo(NavSection.beranda),
                  onSelectTheme: _onSelectTheme,
                ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 0. Smart Side-Tab + Portfolio Demo Switcher Sidebar
// ---------------------------------------------------------------------------

class DemoBar extends StatefulWidget {
  const DemoBar({
    super.key,
    required this.onAdmin,
    required this.onSwitched,
    this.onSelectTheme,
    this.isProfilePage = false,
  });

  final VoidCallback onAdmin;
  final VoidCallback onSwitched;
  final Future<void> Function(
    String storeId,
    String title,
    String brand,
    IconData icon,
  )? onSelectTheme;
  final bool isProfilePage;

  @override
  State<DemoBar> createState() => _DemoBarState();
}

class _DemoBarState extends State<DemoBar> {
  static bool _hasShownInitialHint = false;

  bool _isOpen = false;
  bool _showHint = false;
  Timer? _hintTimer;

  static const _kObsidian = Color(0xFF0B1220);
  static const _kObsidianLight = Color(0xFF141E30);
  static const _kCardSlate = Color(0xFF1E2636);
  static const _kGold = Color(0xFFE3BE80);
  static const _kGoldDark = Color(0xFF926E3E);

  @override
  void initState() {
    super.initState();
    if (!_hasShownInitialHint) {
      _hasShownInitialHint = true;
      _hintTimer = Timer(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() => _showHint = true);
        _hintTimer = Timer(const Duration(seconds: 7), () {
          if (!mounted) return;
          setState(() => _showHint = false);
        });
      });
    }
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    super.dispose();
  }

  void _openSidebar() {
    _hintTimer?.cancel();
    setState(() {
      _showHint = false;
      _isOpen = true;
    });
  }

  void _closeSidebar() {
    setState(() => _isOpen = false);
  }

  (IconData, String, String) _storeMeta(StoreProfile s) {
    switch (s.id) {
      case 'pet':
        return (
          Icons.card_giftcard_rounded,
          'Hampers Korporat B2B',
          'Maison Cadeaux',
        );
      case 'bakery':
        return (
          Icons.bakery_dining_rounded,
          'Artisan Bakery & Pastry',
          'Grain & Batter',
        );
      case 'coffee':
      default:
        return (
          Icons.coffee_rounded,
          'Specialty Coffee Shop',
          'Kopi Senja',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoreBloc>().state;
    final screenW = MediaQuery.sizeOf(context).width;
    final mobile = screenW < 640;
    final drawerWidth = mobile ? math.min(320.0, screenW * 0.86) : 365.0;

    return Stack(
      children: [
        // 1. Right-Edge Smart Side-Tab + Floating Callout Tooltip
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Auto-Hint Callout Bubble
                IgnorePointer(
                  ignoring: !_showHint || _isOpen,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 280),
                    opacity: (_showHint && !_isOpen) ? 1.0 : 0.0,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      offset: (_showHint && !_isOpen)
                          ? Offset.zero
                          : const Offset(0.08, 0),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: _openSidebar,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: mobile ? 205 : 245,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: mobile ? 12 : 16,
                                  vertical: mobile ? 10 : 13,
                                ),
                                decoration: BoxDecoration(
                                  color: _kObsidian.withValues(alpha: 0.96),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _kGold.withValues(alpha: 0.8),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.48),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                    BoxShadow(
                                      color: _kGold.withValues(alpha: 0.16),
                                      blurRadius: 16,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.auto_awesome_rounded,
                                        size: 15,
                                        color: _kGold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Coba ganti Tema Toko,\nCompany Profile & Panel Admin di sini',
                                        style: Txt.sans(
                                          mobile ? 11 : 12,
                                          weight: FontWeight.w600,
                                          color: Colors.white,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    InkWell(
                                      onTap: () {
                                        _hintTimer?.cancel();
                                        setState(() => _showHint = false);
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: 14,
                                        color: Colors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Right-pointing arrow pointer
                              Positioned(
                                right: -5,
                                child: Transform.rotate(
                                  angle: math.pi / 4,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: _kObsidian,
                                      border: Border(
                                        top: BorderSide(
                                          color: _kGold.withValues(alpha: 0.8),
                                          width: 1.2,
                                        ),
                                        right: BorderSide(
                                          color: _kGold.withValues(alpha: 0.8),
                                          width: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Docked Vertical Capsule Tab Trigger
                Hover(
                  onTap: _openSidebar,
                  builder: (context, hovered) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: EdgeInsets.symmetric(
                      horizontal: mobile ? 8 : 10,
                      vertical: mobile ? 14 : 18,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: hovered
                            ? [const Color(0xFF1A263D), _kObsidian]
                            : [_kObsidianLight, _kObsidian],
                      ),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(18),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: _kGold.withValues(alpha: hovered ? 0.95 : 0.72),
                          width: 1.3,
                        ),
                        left: BorderSide(
                          color: _kGold.withValues(alpha: hovered ? 0.95 : 0.72),
                          width: 1.3,
                        ),
                        bottom: BorderSide(
                          color: _kGold.withValues(alpha: hovered ? 0.95 : 0.72),
                          width: 1.3,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.45),
                          blurRadius: 18,
                          offset: const Offset(-4, 4),
                        ),
                        if (hovered)
                          BoxShadow(
                            color: _kGold.withValues(alpha: 0.25),
                            blurRadius: 14,
                          ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_left_rounded,
                          size: 18,
                          color: _kGold,
                        ),
                        const SizedBox(height: 4),
                        RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            mobile ? 'Pilih Demo & Admin' : 'Pilih Demo & Admin',
                            style: Txt.sans(
                              mobile ? 11 : 12,
                              weight: FontWeight.w700,
                              color: Colors.white,
                              spacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.palette_outlined,
                          size: 16,
                          color: _kGold,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Backdrop Scrim when Sidebar is Open
        IgnorePointer(
          ignoring: !_isOpen,
          child: GestureDetector(
            onTap: _closeSidebar,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 260),
              opacity: _isOpen ? 1.0 : 0.0,
              child: Container(
                color: Colors.black.withValues(alpha: 0.55),
              ),
            ),
          ),
        ),

        // 3. Slide-Over Luxury Sidebar ("PORTFOLIO DEMO SWITCHER")
        Align(
          alignment: Alignment.centerRight,
          child: IgnorePointer(
            ignoring: !_isOpen,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              offset: _isOpen ? Offset.zero : const Offset(1.05, 0),
              child: Container(
                width: drawerWidth,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: _kObsidian,
                  border: Border(
                    left: BorderSide(
                      color: _kGold.withValues(alpha: 0.55),
                      width: 1.2,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.65),
                      blurRadius: 32,
                      offset: const Offset(-10, 0),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Sidebar Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 18, 12, 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'PORTFOLIO DEMO SWITCHER',
                                style: Txt.sans(
                                  12,
                                  weight: FontWeight.w700,
                                  color: _kGold,
                                  spacing: 1.4,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _closeSidebar,
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white70,
                                size: 22,
                              ),
                              tooltip: 'Tutup',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: _kGold.withValues(alpha: 0.25),
                      ),

                      // Sidebar Content
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
                          children: [
                            Text(
                              'PILIH TEMA KATALOG (3 INDUSTRI)',
                              style: Txt.sans(
                                11,
                                weight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.68),
                                spacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 14),

                            for (final s in state.allStores) ...[
                              Builder(
                                builder: (context) {
                                  final active = !widget.isProfilePage &&
                                      s.id == state.currentStoreId;
                                  final (icon, title, brand) = _storeMeta(s);

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Hover(
                                      onTap: () {
                                        _closeSidebar();
                                        if (widget.onSelectTheme != null) {
                                          widget.onSelectTheme!(
                                            s.id,
                                            title,
                                            brand,
                                            icon,
                                          );
                                          return;
                                        }
                                        context
                                            .read<StoreBloc>()
                                            .add(StoreEvent.switchTheme(s.id));
                                        if (widget.isProfilePage) {
                                          Navigator.of(context)
                                              .pushReplacementNamed('/');
                                        } else {
                                          widget.onSwitched();
                                        }
                                        showToast(
                                          context,
                                          'Beralih ke $title ($brand)',
                                          icon: icon,
                                        );
                                      },
                                      builder: (context, hovered) =>
                                          AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: active
                                              ? const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(0xFF3E3122),
                                                    Color(0xFF282018),
                                                  ],
                                                )
                                              : null,
                                          color: active
                                              ? null
                                              : (hovered
                                                  ? const Color(0xFF263044)
                                                  : _kCardSlate),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: active
                                                ? _kGold
                                                : (hovered
                                                    ? _kGold
                                                        .withValues(alpha: 0.5)
                                                    : Colors.white.withValues(
                                                        alpha: 0.12)),
                                            width: active ? 1.4 : 1.0,
                                          ),
                                          boxShadow: active
                                              ? [
                                                  BoxShadow(
                                                    color: _kGoldDark
                                                        .withValues(alpha: 0.25),
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              icon,
                                              size: 24,
                                              color: _kGold,
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    title,
                                                    style: Txt.sans(
                                                      13.5,
                                                      weight: FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  RichText(
                                                    text: TextSpan(
                                                      style: Txt.sans(
                                                        12,
                                                        color: Colors.white
                                                            .withValues(
                                                                alpha: 0.72),
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                            text: '— $brand'),
                                                        if (active)
                                                          TextSpan(
                                                            text: ' (Aktif)',
                                                            style: Txt.sans(
                                                              12,
                                                              weight:
                                                                  FontWeight.w700,
                                                              color: _kGold,
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
                                  );
                                },
                              ),
                            ],

                            const SizedBox(height: 18),
                            Text(
                              'FITUR & HALAMAN SISTEM',
                              style: Txt.sans(
                                11,
                                weight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.68),
                                spacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Button 1: Lihat Web Company Profile
                            Hover(
                              onTap: () {
                                _closeSidebar();
                                if (!widget.isProfilePage) {
                                  Navigator.of(context).pushNamed('/profile');
                                }
                              },
                              builder: (context, hovered) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.isProfilePage
                                      ? const Color(0xFF33281C)
                                      : (hovered
                                          ? _kGold.withValues(alpha: 0.14)
                                          : Colors.white
                                              .withValues(alpha: 0.04)),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _kGold.withValues(
                                      alpha: widget.isProfilePage || hovered
                                          ? 0.9
                                          : 0.5,
                                    ),
                                    width: 1.1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.domain_rounded,
                                      size: 20,
                                      color: _kGold,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        widget.isProfilePage
                                            ? 'Web Company Profile (Aktif)'
                                            : 'Lihat Web Company Profile',
                                        style: Txt.sans(
                                          13,
                                          weight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 18,
                                      color: _kGold.withValues(alpha: 0.8),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Button 2: Buka Panel Admin (CMS)
                            Hover(
                              onTap: () {
                                _closeSidebar();
                                widget.onAdmin();
                              },
                              builder: (context, hovered) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: hovered
                                      ? _kGold.withValues(alpha: 0.16)
                                      : Colors.white.withValues(alpha: 0.04),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _kGold.withValues(
                                      alpha: hovered ? 0.95 : 0.55,
                                    ),
                                    width: 1.1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.settings_suggest_rounded,
                                      size: 20,
                                      color: _kGold,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Buka Panel Admin (CMS)',
                                        style: Txt.sans(
                                          13,
                                          weight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 18,
                                      color: _kGold.withValues(alpha: 0.8),
                                    ),
                                  ],
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
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Header / navigasi
// ---------------------------------------------------------------------------

class StoreLogo extends StatelessWidget {
  const StoreLogo({super.key, this.size = 36, this.radius = 10});
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final store = context.select<StoreBloc, StoreProfile>((b) => b.state.store);
    final pal = store.palette;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [pal.primaryContainer, pal.primary],
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
              color: pal.primary.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Icon(store.logoIcon, color: pal.secondarySoft, size: size * 0.55),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.active,
    required this.onNav,
    required this.onAdmin,
    required this.onMenu,
  });
  final NavSection active;
  final ValueChanged<NavSection> onNav;
  final VoidCallback onAdmin;
  final VoidCallback onMenu;

  static const labels = {
    NavSection.beranda: 'Beranda',
    NavSection.katalog: 'Menu & Katalog',
    NavSection.lokasi: 'Lokasi & Kontak',
    NavSection.qr: 'Delivery & Pickup',
  };

  @override
  Widget build(BuildContext context) {
    final store = context.select<StoreBloc, StoreProfile>((b) => b.state.store);
    final pal = store.palette;
    final width = MediaQuery.sizeOf(context).width;
    final showNav = width >= 1220;
    final showContact = width >= 1340;
    final isCompactAdmin = width < 720;
    final isUltraCompactAdmin = width < 460;

    return Container(
      decoration: BoxDecoration(
        color: pal.surface.withValues(alpha: 0.96),
        border: Border(bottom: BorderSide(color: pal.outlineVariant.withValues(alpha: 0.3))),
        boxShadow: [
          BoxShadow(
              color: pal.primaryContainer.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 1)),
        ],
      ),
      child: ContentWidth(
        child: SizedBox(
          height: Bp.mobile(context) ? 64 : 76,
          child: Row(
            children: [
              // 1. Logo & Brand Name (Tidak dipotong kaku agar 'Kopi Senja' tampil utuh)
              Hover(
                onTap: () => onNav(NavSection.beranda),
                builder: (context, _) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StoreLogo(size: width < 480 ? 32 : 36),
                    SizedBox(width: width < 480 ? 8 : 12),
                    Text(
                      width < 600 ? store.shortName : store.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Txt.serif(
                        width < 420 ? 16 : (width < 640 ? 18 : 21),
                        weight: FontWeight.w600,
                        color: pal.primary,
                        spacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Middle Nav (Muncul hanya jika lebar layar >= 1220px agar bebas overflow)
              if (showNav) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: pal.surfaceLow.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final e in labels.entries)
                        Hover(
                          onTap: () => onNav(e.key),
                          builder: (context, h) {
                            final a = e.key == active;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: a || h ? pal.surfaceContainer : Colors.transparent,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                e.value,
                                style: Txt.sans(13,
                                    weight: a ? FontWeight.w700 : FontWeight.w600,
                                    color: a || h ? pal.primary : pal.onSurfaceVariant),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const Spacer(),
              ] else ...[
                const Spacer(),
              ],

              // 3. Right Action Buttons
              if (showContact) ...[
                PillButton(
                  label: 'Hubungi Kami',
                  onTap: () => onNav(NavSection.lokasi),
                  bg: pal.primary,
                  hoverBg: pal.primaryContainer,
                  fg: Colors.white,
                  shadow: true,
                ),
                if (!AppConfig.isDemoShowcase) const SizedBox(width: 10),
              ],

              // Admin Demo Button (Hanya tampil jika DemoBar di atas tidak aktif agar tidak ganda)
              if (!AppConfig.isDemoShowcase)
                Hover(
                  onTap: onAdmin,
                  builder: (context, h) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: EdgeInsets.symmetric(
                      horizontal: isUltraCompactAdmin
                          ? 8
                          : (isCompactAdmin ? 10 : 14),
                      vertical: isUltraCompactAdmin ? 6 : 7,
                    ),
                    decoration: BoxDecoration(
                      color: h
                          ? pal.secondary.withValues(alpha: 0.16)
                          : pal.secondary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: pal.secondary.withValues(alpha: h ? 0.8 : 0.45),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.admin_panel_settings_rounded,
                          size: isUltraCompactAdmin ? 14 : 16,
                          color: pal.secondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isUltraCompactAdmin
                              ? 'Admin'
                              : (isCompactAdmin ? 'Admin' : 'Panel Admin'),
                          style: Txt.sans(
                            isUltraCompactAdmin ? 11 : 12,
                            weight: FontWeight.w700,
                            color: pal.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Mobile / Tablet Drawer Menu Hamburger Button
              if (!showNav) ...[
                SizedBox(width: width < 480 ? 4 : 8),
                IconButton(
                  onPressed: onMenu,
                  padding: EdgeInsets.all(width < 480 ? 6 : 8),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.menu_rounded,
                    color: pal.primary,
                    size: width < 480 ? 22 : 24,
                  ),
                  tooltip: 'Menu',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer({required this.active, required this.onNav, required this.onAdmin});
  final NavSection active;
  final ValueChanged<NavSection> onNav;
  final VoidCallback onAdmin;

  @override
  Widget build(BuildContext context) {
    final store = context.select<StoreBloc, StoreProfile>((b) => b.state.store);
    final pal = store.palette;
    const icons = {
      NavSection.beranda: Icons.home_outlined,
      NavSection.katalog: Icons.menu_book_outlined,
      NavSection.lokasi: Icons.place_outlined,
      NavSection.qr: Icons.delivery_dining_rounded,
    };
    return Drawer(
      backgroundColor: pal.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const StoreLogo(size: 44, radius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(store.name,
                      style: Txt.serif(20, weight: FontWeight.w500, color: pal.primary)),
                ),
              ]),
              const SizedBox(height: 24),
              for (final e in _Header.labels.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    onTap: () => onNav(e.key),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    tileColor: e.key == active ? pal.surfaceContainer : null,
                    leading: Icon(icons[e.key], color: pal.secondary),
                    title: Text(e.value,
                        style: Txt.sans(14, weight: FontWeight.w600, color: pal.primary)),
                  ),
                ),
              const Spacer(),
              PillButton(
                label: 'Lihat Web Company Profile',
                icon: Icons.auto_stories_outlined,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/profile');
                },
                bg: pal.surfaceHigh,
                fg: pal.primary,
                expand: true,
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
