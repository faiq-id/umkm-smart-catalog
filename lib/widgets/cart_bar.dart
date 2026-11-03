import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_state.dart';
import '../sheets/cart_sheet.dart';
import '../ui/common.dart';
import '../utils/format.dart';

class FloatingCartBar extends StatefulWidget {
  const FloatingCartBar({super.key});

  @override
  State<FloatingCartBar> createState() => _FloatingCartBarState();
}

class _FloatingCartBarState extends State<FloatingCartBar> {
  bool _minimized = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        if (state.cart.isEmpty) return const SizedBox.shrink();

        final store = state.store;
        final pal = store.palette;
        final mobile = Bp.mobile(context);

        return AnimatedSlide(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          offset: _minimized ? const Offset(0, 0.72) : Offset.zero,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, mobile ? 14 : 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: pal.surface.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                    boxShadow: [
                      BoxShadow(
                        color: pal.primary.withValues(alpha: 0.16),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Cart icon & badge
                      InkWell(
                        onTap: () => showCartSheet(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: pal.primary,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: pal.primary.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.shopping_cart_rounded,
                                  color: Colors.white, size: 22),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: pal.secondary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Text(
                                  '${state.cartCount}',
                                  style: Txt.sans(10,
                                      weight: FontWeight.w800, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Summary info
                      Expanded(
                        child: InkWell(
                          onTap: () => showCartSheet(context),
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.lastItemName.isEmpty
                                    ? 'Keranjang Pesanan'
                                    : state.lastItemName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Txt.sans(13,
                                    weight: FontWeight.w700, color: pal.primary),
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '${state.cartCount} item · ',
                                    style: Txt.sans(11.5, color: pal.onSurfaceVariant),
                                  ),
                                  Text(
                                    rupiah(state.total),
                                    style: Txt.sans(14,
                                        weight: FontWeight.w800, color: pal.secondary),
                                  ),
                                  if (state.discount > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Tag('Hemat ${rupiah(state.discount)}',
                                          bg: const Color(0xFFECFDF5),
                                          fg: const Color(0xFF065F46)),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Action buttons
                      PillButton(
                        label: mobile ? 'Pesan' : 'Pesan via WhatsApp',
                        icon: Icons.chat_rounded,
                        trailingIcon: Icons.arrow_forward_rounded,
                        bg: pal.secondary,
                        hoverBg: pal.secondaryDeep,
                        fg: Colors.white,
                        fontSize: 12.5,
                        shadow: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: mobile ? 12 : 16, vertical: 10),
                        gradient: LinearGradient(
                            colors: [pal.secondary, pal.secondaryDeep]),
                        onTap: () => showCartSheet(context),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () => setState(() => _minimized = !_minimized),
                        icon: Icon(
                          _minimized
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: pal.onSurfaceVariant,
                        ),
                        tooltip: _minimized ? 'Perluas' : 'Kecilkan',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

