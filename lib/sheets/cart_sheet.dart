import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_event.dart';
import '../bloc/store_state.dart';
import '../sheets/variant_sheet.dart';
import '../ui/common.dart';
import '../utils/format.dart';

Future<void> showCartSheet(BuildContext context) {
  final mobile = MediaQuery.sizeOf(context).width < 640;
  final pal = context.read<StoreBloc>().state.store.palette;

  if (mobile) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: pal.primary.withValues(alpha: 0.6),
      builder: (_) => const CartSheet(mobile: true),
    );
  }
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Tutup Keranjang',
    barrierColor: pal.primary.withValues(alpha: 0.6),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, _, _) => const Center(child: CartSheet(mobile: false)),
    transitionBuilder: (_, a, _, child) => FadeTransition(
      opacity: a,
      child: ScaleTransition(
        scale: Tween(begin: 0.95, end: 1.0)
            .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
        child: child,
      ),
    ),
  );
}

class CartSheet extends StatefulWidget {
  const CartSheet({super.key, required this.mobile});
  final bool mobile;

  @override
  State<CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends State<CartSheet> {
  final _nameCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        final store = state.store;
        final pal = store.palette;
        final cart = state.cart;

        final header = Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: pal.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pesanan Anda',
                        style: Txt.serif(21, weight: FontWeight.w600, color: pal.primary)),
                    Text('${state.cartCount} item dipilih',
                        style: Txt.sans(12.5, color: pal.onSurfaceVariant)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close_rounded, color: pal.onSurfaceVariant),
              ),
            ],
          ),
        );

        if (cart.isEmpty) {
          return Material(
            color: Colors.transparent,
            child: Container(
              width: widget.mobile ? double.infinity : 520,
              margin: widget.mobile ? EdgeInsets.zero : const EdgeInsets.all(16),
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: pal.surfaceLowest,
                borderRadius: widget.mobile
                    ? const BorderRadius.vertical(top: Radius.circular(28))
                    : BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  header,
                  const SizedBox(height: 24),
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: pal.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.remove_shopping_cart_outlined,
                        size: 36, color: pal.outline),
                  ),
                  const SizedBox(height: 18),
                  Text('Keranjang Masih Kosong',
                      style: Txt.serif(22, weight: FontWeight.w600, color: pal.primary)),
                  const SizedBox(height: 6),
                  Text('Silakan pilih produk favorit Anda dari katalog.',
                      textAlign: TextAlign.center,
                      style: Txt.sans(13.5, color: pal.onSurfaceVariant)),
                  const SizedBox(height: 24),
                  PillButton(
                    label: 'Lihat Menu',
                    icon: Icons.menu_book_rounded,
                    bg: pal.primary,
                    fg: Colors.white,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          );
        }

        final isDelivery = state.orderType == 'Delivery';

        final orderTypeSelector = Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: pal.surfaceLow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              {'type': 'Delivery', 'label': '🛵 Pesan Antar', 'desc': 'Delivery'},
              {'type': 'Take Away', 'label': '🛍️ Ambil di Gerai', 'desc': 'Pickup'},
            ].map((item) {
              final type = item['type']!;
              final label = item['label']!;
              final active = state.orderType == type;
              return Expanded(
                child: InkWell(
                  onTap: () => context
                      .read<StoreBloc>()
                      .add(StoreEvent.setOrderType(type)),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: active ? pal.surfaceLowest : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: pal.primary.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: Txt.sans(12.5,
                            weight: active ? FontWeight.w700 : FontWeight.w600,
                            color: active ? pal.primary : pal.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );

        final deliveryInfo = Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: isDelivery
                ? const Color(0xFFECFDF5)
                : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isDelivery
                    ? const Color(0xFFA7F3D0)
                    : const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: [
              Icon(
                isDelivery
                    ? Icons.local_shipping_outlined
                    : Icons.storefront_outlined,
                size: 17,
                color: isDelivery
                    ? const Color(0xFF065F46)
                    : const Color(0xFF1E40AF),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isDelivery
                      ? 'Pesan antar — ongkos kirim & jadwal dikonfirmasi via WhatsApp'
                      : 'Ambil di gerai: ${store.shortAddress}',
                  style: Txt.sans(12,
                      weight: FontWeight.w600,
                      color: isDelivery
                          ? const Color(0xFF065F46)
                          : const Color(0xFF1E40AF)),
                ),
              ),
            ],
          ),
        );

        final itemsList = Column(
          children: [
            for (final item in cart)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: pal.surfaceLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 58,
                        height: 58,
                        child: AppImage(
                          src: item.product.image,
                          emoji: item.product.emoji,
                          cacheWidth: 150,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.name,
                              style: Txt.sans(13.5,
                                  weight: FontWeight.w700, color: pal.primary)),
                          if (item.options.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                item.options.join(', '),
                                style: Txt.sans(11.5, color: pal.onSurfaceVariant),
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(rupiah(item.unitPrice),
                              style: Txt.sans(13,
                                  weight: FontWeight.w700, color: pal.secondary)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        QtyStepper(
                          qty: item.qty,
                          compact: true,
                          onMinus: () => context.read<StoreBloc>().add(
                              StoreEvent.updateCartQty(cartKey: item.key, delta: -1)),
                          onPlus: () => context.read<StoreBloc>().add(
                              StoreEvent.updateCartQty(cartKey: item.key, delta: 1)),
                        ),
                        const SizedBox(height: 6),
                        Text(rupiah(item.total),
                            style: Txt.sans(13.5,
                                weight: FontWeight.w800, color: pal.primary)),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );

        final promoSection = Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: state.promoClaimed
                ? const Color(0xFFECFDF5)
                : pal.secondarySoft.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: state.promoClaimed
                  ? const Color(0xFF059669)
                  : pal.secondary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.local_offer_rounded,
                  size: 20,
                  color: state.promoClaimed
                      ? const Color(0xFF059669)
                      : pal.secondary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.promoClaimed
                          ? 'Kupon ${store.promo.code} Aktif'
                          : 'Punya Kupon Promo?',
                      style: Txt.sans(13,
                          weight: FontWeight.w700,
                          color: state.promoClaimed
                              ? const Color(0xFF065F46)
                              : pal.primary),
                    ),
                    Text(
                      state.promoClaimed
                          ? 'Hemat ${store.promo.percent}% hingga ${rupiah(store.promo.maxDiscount)}'
                          : 'Gunakan kode ${store.promo.code} untuk diskon ${store.promo.percent}%',
                      style: Txt.sans(11.5,
                          color: state.promoClaimed
                              ? const Color(0xFF047857)
                              : pal.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (!state.promoClaimed)
                PillButton(
                  label: 'Klaim',
                  fontSize: 11.5,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  bg: pal.secondary,
                  fg: Colors.white,
                  onTap: () {
                    context.read<StoreBloc>().add(const StoreEvent.claimPromo());
                    showToast(context, 'Kupon promo berhasil diterapkan!',
                        icon: Icons.local_offer_rounded);
                  },
                ),
            ],
          ),
        );

        final customerInputs = Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: isDelivery
                    ? 'Nama Pemesan & No. WhatsApp'
                    : 'Nama Pemesan (Panggilan saat siap)',
                hintText: isDelivery
                    ? 'Contoh: Rian Pratama (0812-xxxx-xxxx)'
                    : 'Contoh: Rian',
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteCtrl,
              decoration: InputDecoration(
                labelText: isDelivery
                    ? 'Alamat Pengantaran & Catatan'
                    : 'Catatan Tambahan (Opsional)',
                hintText: isDelivery
                    ? 'Contoh: Jl. Senopati No. 12 (Pagar putih), sendok kayu 2'
                    : 'Contoh: Es dipisah, sendok kayu 2',
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        );

        final priceBreakdown = Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: Txt.sans(13, color: pal.onSurfaceVariant)),
                Text(rupiah(state.subtotal),
                    style: Txt.sans(13.5, weight: FontWeight.w600, color: pal.primary)),
              ],
            ),
            if (state.discount > 0) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Diskon Promo (${store.promo.code})',
                      style: Txt.sans(13,
                          weight: FontWeight.w600, color: const Color(0xFF059669))),
                  Text('-${rupiah(state.discount)}',
                      style: Txt.sans(13.5,
                          weight: FontWeight.w700, color: const Color(0xFF059669))),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Divider(color: pal.outlineVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Akhir',
                    style: Txt.sans(15, weight: FontWeight.w800, color: pal.primary)),
                Text(rupiah(state.total),
                    style: Txt.sans(18, weight: FontWeight.w800, color: pal.secondary)),
              ],
            ),
          ],
        );

        final footer = Container(
          padding: EdgeInsets.fromLTRB(22, 16, 22, widget.mobile ? 24 : 20),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: pal.surfaceContainer)),
          ),
          child: PillButton(
            label: 'Pesan Sekarang via WhatsApp — ${rupiah(state.total)}',
            icon: Icons.chat_rounded,
            bg: pal.secondary,
            hoverBg: pal.secondaryDeep,
            fg: Colors.white,
            fontSize: 14,
            radius: 18,
            expand: true,
            shadow: true,
            padding: const EdgeInsets.symmetric(vertical: 16),
            onTap: () {
              context.read<StoreBloc>().add(
                    StoreEvent.placeOrder(
                      customer: _nameCtrl.text,
                      note: _noteCtrl.text,
                      onSuccess: (waMsg) {
                        Navigator.of(context).pop();
                        showToast(context, 'Pesanan berhasil dibuat! Membuka WhatsApp...',
                            icon: Icons.check_circle_rounded);
                        openUrl(waLink(store.whatsapp, waMsg));
                      },
                    ),
                  );
            },
          ),
        );

        return Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: widget.mobile ? double.infinity : 540,
              maxHeight: MediaQuery.sizeOf(context).height * (widget.mobile ? 0.94 : 0.9),
            ),
            margin: widget.mobile ? EdgeInsets.zero : const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: pal.surfaceLowest,
              borderRadius: widget.mobile
                  ? const BorderRadius.vertical(top: Radius.circular(28))
                  : BorderRadius.circular(28),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 40)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.mobile)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: pal.outlineVariant, borderRadius: BorderRadius.circular(4)),
                  ),
                header,
                Divider(height: 1, color: pal.surfaceContainer),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderTypeSelector,
                        deliveryInfo,
                        const SizedBox(height: 18),
                        itemsList,
                        const SizedBox(height: 12),
                        promoSection,
                        const SizedBox(height: 18),
                        customerInputs,
                        const SizedBox(height: 20),
                        priceBreakdown,
                      ],
                    ),
                  ),
                ),
                footer,
              ],
            ),
          ),
        );
      },
    );
  }
}
