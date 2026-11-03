import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_event.dart';
import '../bloc/store_state.dart';
import '../ui/common.dart';
import '../utils/format.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key, required this.onClaim});
  final VoidCallback onClaim;

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late Timer _timer;
  DateTime _now = DateTime.now();
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
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
        final promo = store.promo;
        final mobile = Bp.mobile(context);

        if (!state.promoActive) return const SizedBox(height: 32);

        var end = DateTime(_now.year, _now.month, _now.day, promo.endHour);
        final running = _now.isBefore(end);
        if (!running) end = end.add(const Duration(days: 1));
        final left = end.difference(_now);

        final claimed = state.promoClaimed;

        return Transform.translate(
          offset: const Offset(0, -16),
          child: ContentWidth(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: LayoutBuilder(builder: (context, c) {
                final minH = mobile
                    ? 380.0
                    : (c.maxWidth * 9 / 21).clamp(440.0, 540.0);
                return MouseRegion(
                  onEnter: (_) => setState(() => _hover = true),
                  onExit: (_) => setState(() => _hover = false),
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: minH),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: pal.primary.withValues(alpha: 0.14),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: AnimatedScale(
                            scale: _hover ? 1.05 : 1,
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeOut,
                            child: AppImage(
                              src: store.banner,
                              emoji: store.emoji,
                              cacheWidth: 1400,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: mobile
                                    ? Alignment.bottomCenter
                                    : Alignment.centerLeft,
                                end: mobile
                                    ? Alignment.topCenter
                                    : Alignment.centerRight,
                                stops: mobile
                                    ? const [0, 0.7, 1]
                                    : const [0, 0.45, 0.85],
                                colors: [
                                  pal.primary.withValues(alpha: 0.96),
                                  pal.primary.withValues(alpha: 0.78),
                                  pal.primary.withValues(alpha: mobile ? 0.25 : 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(mobile ? 20 : 40),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: mobile ? double.infinity : 620,
                                minHeight: minH - (mobile ? 40 : 80)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      Tag(promo.badge,
                                          bg: pal.secondary, fg: Colors.white),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.18),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.schedule_rounded,
                                                  size: 14, color: Colors.white),
                                              const SizedBox(width: 5),
                                              Text(
                                                '${running ? 'Berakhir dlm' : 'Mulai lagi dlm'} ${formatCountdown(left)}',
                                                style: Txt.sans(11.5,
                                                    weight: FontWeight.w700,
                                                    color: Colors.white,
                                                    spacing: 0.4),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(promo.eyebrow.toUpperCase(),
                                          style: Txt.eyebrow(pal.onPrimaryMuted,
                                              size: 12)),
                                      const SizedBox(height: 8),
                                      Text(promo.title,
                                          style: Txt.serif(mobile ? 28 : 38,
                                              color: Colors.white,
                                              height: 1.15,
                                              spacing: -0.4)),
                                      const SizedBox(height: 10),
                                      Text(promo.desc,
                                          maxLines: mobile ? 3 : null,
                                          overflow:
                                              mobile ? TextOverflow.ellipsis : null,
                                          style: Txt.sans(15,
                                              color: pal.onPrimaryMuted, height: 1.55)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  PillButton(
                                    label: claimed
                                        ? 'Promo Aktif ✓'
                                        : promo.cta,
                                    trailingIcon: claimed
                                        ? Icons.local_offer_rounded
                                        : Icons.arrow_forward_rounded,
                                    bg: Colors.white,
                                    hoverBg: pal.surfaceContainer,
                                    fg: pal.primary,
                                    shadow: true,
                                    fontSize: 14,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 13),
                                    onTap: () {
                                      if (!claimed) {
                                        context
                                            .read<StoreBloc>()
                                            .add(const StoreEvent.claimPromo());
                                        showToast(context,
                                            'Promo ${promo.code} diklaim! Diskon ${promo.percent}% otomatis di keranjang.',
                                            icon: Icons.local_offer_rounded);
                                      }
                                      widget.onClaim();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
