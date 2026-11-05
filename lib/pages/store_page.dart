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

enum NavSection { beranda, katalog, lokasi, qr }

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final _scroll = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _keys = {for (final s in NavSection.values) s: GlobalKey()};
  final _activeNotifier = ValueNotifier<NavSection>(NavSection.beranda);
  DateTime _lastScrollCheck = DateTime.now();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _activeNotifier.dispose();
    super.dispose();
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

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: pal.surface,
          endDrawer: ValueListenableBuilder<NavSection>(
            valueListenable: _activeNotifier,
            builder: (context, active, _) => _MobileDrawer(
              active: active,
              onNav: (s) {
                Navigator.of(context).pop();
                Future.delayed(const Duration(milliseconds: 250), () => scrollTo(s));
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
                  if (AppConfig.isDemoShowcase)
                    RepaintBoundary(
                      child: DemoBar(
                          onAdmin: _openAdmin,
                          onSwitched: () => scrollTo(NavSection.beranda)),
                    ),
                  RepaintBoundary(
                    child: ValueListenableBuilder<NavSection>(
                      valueListenable: _activeNotifier,
                      builder: (context, active, _) => _Header(
                        active: active,
                        onNav: scrollTo,
                        onAdmin: _openAdmin,
                        onMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      controller: _scroll,
                      child: SingleChildScrollView(
                        controller: _scroll,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          key: ValueKey(store.id),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RepaintBoundary(
                              child: HeroSection(
                                key: _keys[NavSection.beranda],
                                onDirections: () => scrollTo(NavSection.lokasi),
                              ),
                            ),
                            RepaintBoundary(
                              child: PromoBanner(
                                  onClaim: () => scrollTo(NavSection.katalog)),
                            ),
                            RepaintBoundary(
                              child: CatalogSection(key: _keys[NavSection.katalog]),
                            ),
                            RepaintBoundary(
                              child: LocationSection(
                                key: _keys[NavSection.lokasi],
                                qrKey: _keys[NavSection.qr]!,
                              ),
                            ),
                            RepaintBoundary(
                              child: StoreFooter(onNav: scrollTo),
                            ),
                          ],
                        ),
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
}

// ---------------------------------------------------------------------------
// 0. Demo bar (sticky paling atas)
// ---------------------------------------------------------------------------

class DemoBar extends StatelessWidget {
  const DemoBar({super.key, required this.onAdmin, required this.onSwitched});
  final VoidCallback onAdmin;
  final VoidCallback onSwitched;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoreBloc>().state;
    final pal = state.store.palette;
    final mobile = Bp.mobile(context);
    const bg = Color(0xFF1B120E);

    final switcher = Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF291B16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF4A342C)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final s in state.allStores)
            Hover(
              onTap: () {
                context.read<StoreBloc>().add(StoreEvent.switchTheme(s.id));
                onSwitched();
                showToast(context, 'Beralih ke ${s.themeLabel} ${s.emoji}',
                    icon: Icons.palette_outlined);
              },
              builder: (context, h) {
                final active = s.id == state.currentStoreId;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFF412B23)
                        : (h ? const Color(0xFF33231D) : Colors.transparent),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s.emoji, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 5),
                      Text(
                        mobile
                            ? s.shortThemeLabel
                            : '${s.themeLabel}${active ? ' (Aktif)' : ''}',
                        style: Txt.sans(11.5,
                            weight: active ? FontWeight.w700 : FontWeight.w500,
                            color: active || h ? Colors.white : const Color(0xFFC9B7B0)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );

    final profileBtn = Hover(
      onTap: () => Navigator.of(context).pushNamed('/profile'),
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: hovered ? pal.secondary : const Color(0xFF3B2720),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFF6B4232)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_stories_outlined, size: 13, color: Color(0xFFFFDDBA)),
            const SizedBox(width: 5),
            Text(
              mobile ? 'Company Profile' : '🏛️ Web Company Profile',
              style: Txt.sans(
                11,
                weight: FontWeight.w600,
                color: const Color(0xFFFFDDBA),
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      width: double.infinity,
      color: bg,
      padding: EdgeInsets.symmetric(horizontal: Bp.hPad(context), vertical: 7),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: mobile
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      switcher,
                      const SizedBox(width: 8),
                      profileBtn,
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: switcher,
                      ),
                    ),
                    const SizedBox(width: 14),
                    profileBtn,
                  ],
                ),
        ),
      ),
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
                const SizedBox(width: 10),
              ],

              // Admin Demo Button
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
              const SizedBox(height: 10),
              PillButton(
                label: 'Buka Dashboard Admin',
                icon: Icons.dashboard_customize_outlined,
                onTap: onAdmin,
                bg: pal.primary,
                fg: Colors.white,
                expand: true,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
