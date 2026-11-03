import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_state.dart';
import '../ui/common.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key, required this.onDirections});
  final VoidCallback onDirections;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        final store = state.store;
        final pal = store.palette;
        final mobile = Bp.mobile(context);
        final wide = MediaQuery.sizeOf(context).width >= 768;
        final open = state.isOpenAt(_now);

        final statusBadge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: pal.surfaceLowest,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(color: pal.primary.withValues(alpha: 0.04), blurRadius: 6)
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PulseDot(color: open ? const Color(0xFF059669) : const Color(0xFFDC2626)),
              const SizedBox(width: 9),
              Text(open ? 'Buka Sekarang' : 'Sedang Tutup',
                  style: Txt.sans(12, weight: FontWeight.w700, color: pal.primary)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 4,
                height: 4,
                decoration: BoxDecoration(color: pal.outlineVariant, shape: BoxShape.circle),
              ),
              Text(state.statusDetail(_now),
                  style: Txt.sans(12.5, color: pal.onSurfaceVariant)),
            ],
          ),
        );

        final emblem = Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: mobile ? 96 : 112,
              height: mobile ? 96 : 112,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: pal.surfaceLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.4)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [pal.primaryContainer, pal.primary],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(store.logoIcon, size: mobile ? 36 : 42, color: pal.secondarySoft),
                    const SizedBox(height: 2),
                    Text(store.shortName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Txt.sans(7.5,
                            weight: FontWeight.w800,
                            color: pal.onPrimaryMuted,
                            spacing: 1.2)),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -8,
              bottom: -8,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: pal.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: pal.surfaceLowest, width: 2),
                ),
                child: const Icon(Icons.verified_rounded, color: Colors.white, size: 15),
              ),
            ),
          ],
        );

        final info = Column(
          crossAxisAlignment: wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Wrap(
              alignment: wide ? WrapAlignment.start : WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 6,
              children: [
                Text(store.name,
                    textAlign: wide ? TextAlign.start : TextAlign.center,
                    style: Txt.serif(mobile ? 30 : 36,
                        color: pal.primary, height: 1.15, spacing: -0.4)),
                Tag(store.established, bg: pal.surfaceContainer, fg: pal.secondary),
              ],
            ),
            const SizedBox(height: 6),
            Text(store.tagline,
                textAlign: wide ? TextAlign.start : TextAlign.center,
                style: Txt.serif(mobile ? 18 : 20,
                    style: FontStyle.italic, color: pal.onSurfaceVariant, height: 1.35)),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(store.bio,
                  textAlign: wide ? TextAlign.start : TextAlign.center,
                  style: Txt.sans(15, color: pal.onSurfaceVariant, height: 1.6)),
            ),
            if (MediaQuery.sizeOf(context).width < 1200) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: wide ? WrapAlignment.start : WrapAlignment.center,
                children: [
                  Tag('★ ${store.rating.toStringAsFixed(2)} · ${store.reviewsLabel}',
                      bg: pal.secondarySoft.withValues(alpha: 0.6), fg: pal.secondaryDeep),
                  Tag(store.highlightBadge,
                      icon: store.highlightIcon,
                      bg: const Color(0xFFECFDF5),
                      fg: const Color(0xFF065F46)),
                ],
              ),
            ],
          ],
        );

        final score = Container(
          padding: const EdgeInsets.only(left: 28),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: pal.outlineVariant.withValues(alpha: 0.4))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.star_rounded, color: pal.secondary, size: 24),
                const SizedBox(width: 4),
                Text('${store.rating.toStringAsFixed(2)} / 5.0',
                    style: Txt.sans(15, weight: FontWeight.w800, color: pal.secondary)),
              ]),
              const SizedBox(height: 2),
              Text(store.reviewsLabel, style: Txt.sans(13, color: pal.onSurfaceVariant)),
              const SizedBox(height: 10),
              Tag(store.highlightBadge,
                  icon: store.highlightIcon,
                  bg: const Color(0xFFECFDF5),
                  fg: const Color(0xFF065F46)),
            ],
          ),
        );

        final waText =
            'Halo ${store.shortName}, saya ingin bertanya mengenai katalog dan pemesanan.';
        final actions = [
          _QuickAction(
            icon: Icons.map_outlined,
            title: 'Petunjuk Arah',
            subtitle: store.shortAddress,
            onTap: widget.onDirections,
          ),
          _QuickAction(
            icon: Icons.photo_camera_outlined,
            title: 'Instagram',
            subtitle: store.instagram,
            onTap: () => openUrl(
                'https://instagram.com/${store.instagram.replaceAll('@', '')}'),
          ),
          _QuickAction(
            icon: Icons.play_circle_outline_rounded,
            title: 'TikTok Feed',
            subtitle: store.tiktok,
            onTap: () => openUrl('https://tiktok.com/${store.tiktok}'),
          ),
          _QuickAction(
            icon: Icons.chat_outlined,
            title: 'Tanya Admin',
            subtitle: 'WhatsApp Chat',
            dark: true,
            onTap: () => openUrl(waLink(store.whatsapp, waText)),
          ),
        ];

        return Container(
          width: double.infinity,
          color: pal.surfaceLow,
          child: Stack(
            children: [
              Positioned(
                top: -120,
                left: -80,
                child: _Glow(color: pal.secondary.withValues(alpha: 0.10), size: 380),
              ),
              Positioned(
                top: 80,
                right: -60,
                child: _Glow(color: pal.glow.withValues(alpha: 0.55), size: 480),
              ),
              ContentWidth(
                child: Padding(
                  padding: EdgeInsets.only(top: 24, bottom: mobile ? 36 : 48),
                  child: Column(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          Text.rich(
                            TextSpan(children: [
                              TextSpan(text: '${store.area.toUpperCase()}  /  '),
                              TextSpan(
                                  text: store.type.toUpperCase(),
                                  style: TextStyle(
                                      color: pal.secondary, fontWeight: FontWeight.w700)),
                            ]),
                            style: Txt.sans(11.5,
                                weight: FontWeight.w600,
                                color: pal.onSurfaceVariant,
                                spacing: 1),
                          ),
                          statusBadge,
                        ],
                      ),
                      const SizedBox(height: 22),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(mobile ? 22 : 36),
                        decoration: cardDecoration(pal, radius: 22),
                        child: wide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  emblem,
                                  const SizedBox(width: 32),
                                  Expanded(child: info),
                                  if (MediaQuery.sizeOf(context).width >= 1200) ...[
                                    const SizedBox(width: 24),
                                    score,
                                  ],
                                ],
                              )
                            : Column(children: [emblem, const SizedBox(height: 22), info]),
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(builder: (context, c) {
                        final cols = c.maxWidth >= 640 ? 4 : 2;
                        const gap = 12.0;
                        final w = (c.maxWidth - gap * (cols - 1)) / cols;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [for (final a in actions) SizedBox(width: w, child: a)],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.dark = false,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final mobile = Bp.mobile(context);
    return Hover(
      onTap: onTap,
      builder: (context, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(mobile ? 10 : 16),
        decoration: BoxDecoration(
          color: dark
              ? (h ? pal.primaryContainer : pal.primary)
              : (h ? pal.surfaceContainer : pal.surfaceLowest),
          borderRadius: BorderRadius.circular(14),
          border: dark ? null : Border.all(color: pal.outlineVariant.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: pal.primary.withValues(alpha: h ? 0.08 : 0.03),
              blurRadius: h ? 16 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: dark
                    ? Colors.white.withValues(alpha: 0.1)
                    : (h ? pal.primary : pal.surfaceContainer),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  size: 21, color: dark || h ? Colors.white : pal.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Txt.sans(12.5,
                          weight: FontWeight.w700, color: dark ? Colors.white : pal.primary)),
                  Text(subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Txt.sans(12.5,
                          color: dark ? pal.onPrimaryMuted : pal.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
