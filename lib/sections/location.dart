import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_event.dart';
import '../bloc/store_state.dart';
import '../models/models.dart';
import '../ui/common.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key, required this.qrKey});
  final GlobalKey qrKey;

  void _showBulkOrderDialog(BuildContext context, StoreProfile store) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: 'Besok (Siang)');
    final noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDState) {
          final pal = store.palette;
          return AlertDialog(
            backgroundColor: pal.surfaceLowest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              children: [
                Icon(Icons.card_giftcard_rounded, color: pal.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(store.reserveLabel,
                      style: Txt.serif(19, weight: FontWeight.w600, color: pal.primary)),
                ),
              ],
            ),
            content: SizedBox(
              width: 440,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Konsultasikan pesanan hampers, katering acara kantor, atau kebutuhan khusus gerai ${store.shortName}.',
                      style: Txt.sans(13, color: pal.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Nama Pemesan',
                        hintText: 'Contoh: Rian / PT Nusantara',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Nomor WhatsApp',
                        hintText: '0812-xxxx-xxxx',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: dateCtrl,
                      decoration: InputDecoration(
                        labelText: 'Tanggal & Waktu Pengambilan / Kirim',
                        hintText: 'Contoh: 15 November, pk 10:00 WIB',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Rincian Pesanan & Kebutuhan Acara',
                        hintText: 'Contoh: Paket 30 box snack meeting & 10 pouch beans',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Batal', style: TextStyle(color: pal.outline)),
              ),
              PillButton(
                label: 'Kirim Permintaan via WhatsApp',
                icon: Icons.send_rounded,
                bg: pal.primary,
                fg: Colors.white,
                onTap: () {
                  final text =
                      'Halo ${store.shortName}, saya ingin konsultasi pesanan khusus/hampers:\n'
                      '• Nama: ${nameCtrl.text.isEmpty ? 'Pelanggan Web' : nameCtrl.text}\n'
                      '• No. WA: ${phoneCtrl.text.isEmpty ? '-' : phoneCtrl.text}\n'
                      '• Tanggal Kebutuhan: ${dateCtrl.text}\n'
                      '• Rincian: ${noteCtrl.text.isEmpty ? 'Mohon info katalog paket hampers & harga' : noteCtrl.text}';
                  Navigator.of(ctx).pop();
                  openUrl(waLink(store.whatsapp, text));
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        final store = state.store;
        final pal = store.palette;
        final mobile = Bp.mobile(context);
        final wide = MediaQuery.sizeOf(context).width >= 992;

        return ContentWidth(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Tag('Atelier Experience', bg: pal.surfaceContainer, fg: pal.secondary),
                    const SizedBox(width: 8),
                    Text('|', style: TextStyle(color: pal.outlineVariant)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Kunjungan Dine-in & Sistem Meja Pintar',
                          overflow: TextOverflow.ellipsis,
                          style: Txt.sans(13, color: pal.onSurfaceVariant)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(store.locationTitle,
                    style: Txt.serif(mobile ? 28 : 34, color: pal.primary, spacing: -0.3)),
                const SizedBox(height: 24),
                wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 7, child: _MapCard(store: store)),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 5,
                            child: _DeliveryPickupCard(
                              key: qrKey,
                              store: store,
                              onBulkOrder: () => _showBulkOrderDialog(context, store),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _MapCard(store: store),
                          const SizedBox(height: 24),
                          _DeliveryPickupCard(
                            key: qrKey,
                            store: store,
                            onBulkOrder: () => _showBulkOrderDialog(context, store),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({required this.store});
  final StoreProfile store;

  @override
  Widget build(BuildContext context) {
    final pal = store.palette;
    final mobile = Bp.mobile(context);

    return Container(
      padding: EdgeInsets.all(mobile ? 18 : 24),
      decoration: cardDecoration(pal, radius: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: pal.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.storefront_rounded, color: pal.secondary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.name,
                        style: Txt.serif(20, weight: FontWeight.w600, color: pal.primary)),
                    const SizedBox(height: 3),
                    Text(store.address,
                        style: Txt.sans(13, color: pal.onSurfaceVariant, height: 1.4)),
                  ],
                ),
              ),
              if (!mobile)
                Tag(store.parkingLabel,
                    icon: Icons.local_parking_rounded,
                    bg: const Color(0xFFECFDF5),
                    fg: const Color(0xFF065F46)),
            ],
          ),
          const SizedBox(height: 18),
          // Stylized interactive map box
          Container(
            height: mobile ? 220 : 260,
            width: double.infinity,
            decoration: BoxDecoration(
              color: pal.mapBase,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Stylized road & block pattern
                  Positioned.fill(
                    child: CustomPaint(painter: _MapPainter(pal: pal)),
                  ),
                  // Floating Store Pin with pulse
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: pal.primary,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white38),
                          boxShadow: [
                            BoxShadow(
                                color: pal.primary.withValues(alpha: 0.3),
                                blurRadius: 14,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(store.logoIcon, size: 14, color: pal.secondarySoft),
                            const SizedBox(width: 6),
                            Text(store.shortName,
                                style: Txt.sans(11.5,
                                    weight: FontWeight.w700, color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: pal.secondary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: pal.secondary.withValues(alpha: 0.4),
                                blurRadius: 10,
                                spreadRadius: 2),
                          ],
                        ),
                        child: const Icon(Icons.location_on_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  // Open in Google Maps button
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: PillButton(
                      label: 'Buka Google Maps',
                      icon: Icons.near_me_rounded,
                      bg: pal.surfaceLowest.withValues(alpha: 0.95),
                      fg: pal.primary,
                      fontSize: 12,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shadow: true,
                      onTap: () => openUrl(
                          'https://maps.google.com/?q=${Uri.encodeComponent('${store.name} ${store.address}')}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Hours schedule grid
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth >= 540 ? 3 : 2;
            const gap = 10.0;
            final itemW = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final h in store.hours)
                  SizedBox(
                    width: itemW,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: pal.surfaceLow,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(h.days,
                              style: Txt.sans(11.5, color: pal.onSurfaceVariant)),
                          const SizedBox(height: 3),
                          Text(h.time,
                              style: Txt.sans(13,
                                  weight: FontWeight.w700,
                                  color: h.closed ? pal.outline : pal.primary)),
                          const SizedBox(height: 2),
                          Text(h.note,
                              style: Txt.sans(11,
                                  color: h.closed ? pal.outline : pal.secondary)),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _DeliveryPickupCard extends StatelessWidget {
  const _DeliveryPickupCard(
      {super.key, required this.store, required this.onBulkOrder});
  final StoreProfile store;
  final VoidCallback onBulkOrder;

  @override
  Widget build(BuildContext context) {
    final pal = store.palette;
    final mobile = Bp.mobile(context);

    return Container(
      padding: EdgeInsets.all(mobile ? 20 : 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [pal.darkCardTop, pal.darkCardBottom],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: pal.darkCardBorder),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 14, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text('LAYANAN PESAN ANTAR & PICKUP',
                        style: Txt.sans(10.5,
                            weight: FontWeight.w800,
                            color: pal.secondarySoft,
                            spacing: 0.8)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                            color: Color(0xFF34D399), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text('Tersedia Setiap Hari',
                          style: Txt.sans(11,
                              weight: FontWeight.w700,
                              color: const Color(0xFF34D399))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(store.qrTitle,
                  style: Txt.serif(mobile ? 22 : 25,
                      weight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.25)),
              const SizedBox(height: 10),
              Text(store.qrDesc,
                  style:
                      Txt.sans(13.5, color: pal.darkCardText, height: 1.55)),
              const SizedBox(height: 20),
              // Interactive Delivery & Pickup Box
              _DeliverySimulationBox(store: store),
            ],
          ),
          const SizedBox(height: 22),
          Divider(color: Colors.white.withValues(alpha: 0.12)),
          const SizedBox(height: 14),
          mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Butuh pesanan jumlah besar / acara?',
                        style: Txt.sans(12.5, color: pal.darkCardText)),
                    const SizedBox(height: 10),
                    PillButton(
                      label: store.reserveLabel,
                      icon: Icons.card_giftcard_rounded,
                      bg: Colors.white,
                      hoverBg: pal.surfaceContainer,
                      fg: pal.primary,
                      fontSize: 12.5,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shadow: true,
                      onTap: onBulkOrder,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text('Butuh pesanan jumlah besar / acara?',
                          style: Txt.sans(12, color: pal.darkCardText)),
                    ),
                    const SizedBox(width: 12),
                    PillButton(
                      label: store.reserveLabel,
                      icon: Icons.card_giftcard_rounded,
                      bg: Colors.white,
                      hoverBg: pal.surfaceContainer,
                      fg: pal.primary,
                      fontSize: 12.5,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shadow: true,
                      onTap: onBulkOrder,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _DeliverySimulationBox extends StatefulWidget {
  const _DeliverySimulationBox({required this.store});
  final StoreProfile store;

  @override
  State<_DeliverySimulationBox> createState() => _DeliverySimulationBoxState();
}

class _DeliverySimulationBoxState extends State<_DeliverySimulationBox> {
  int _selectedTab = 0; // 0: Delivery, 1: Pickup

  @override
  Widget build(BuildContext context) {
    final pal = widget.store.palette;
    final isDelivery = _selectedTab == 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector Tab Delivery vs Pickup
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedTab = 0);
                      context
                          .read<StoreBloc>()
                          .add(const StoreEvent.setOrderType('Delivery'));
                      showToast(context, 'Mode Pesan Antar (Delivery) aktif',
                          icon: Icons.delivery_dining_rounded);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isDelivery ? pal.secondary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delivery_dining_rounded,
                              size: 16,
                              color: isDelivery
                                  ? Colors.white
                                  : Colors.white70),
                          const SizedBox(width: 6),
                          Text(
                            'Pesan Antar',
                            style: Txt.sans(12,
                                weight: FontWeight.w700,
                                color: isDelivery
                                    ? Colors.white
                                    : Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedTab = 1);
                      context
                          .read<StoreBloc>()
                          .add(const StoreEvent.setOrderType('Take Away'));
                      showToast(
                          context, 'Mode Ambil di Gerai (Self-Pickup) aktif',
                          icon: Icons.shopping_bag_outlined);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !isDelivery ? pal.secondary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined,
                              size: 15,
                              color: !isDelivery
                                  ? Colors.white
                                  : Colors.white70),
                          const SizedBox(width: 6),
                          Text(
                            'Ambil di Gerai',
                            style: Txt.sans(12,
                                weight: FontWeight.w700,
                                color: !isDelivery
                                    ? Colors.white
                                    : Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Detail Card
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: isDelivery
                ? Column(
                    key: const ValueKey('delivery'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFF059669)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.local_shipping_outlined,
                                size: 16, color: Color(0xFF34D399)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tersedia pilihan pesan antar',
                                    style: Txt.sans(12.5,
                                        weight: FontWeight.w700,
                                        color: Colors.white)),
                                Text('Ongkos kirim & jadwal dikonfirmasi via WhatsApp',
                                    style: Txt.sans(11.5,
                                        color: pal.darkCardText)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '📍 Pesanan diantar sesuai jangkauan area gerai. Detail alamat, ongkos kirim, dan estimasi waktu akan dikonfirmasi oleh tim gerai setelah pesanan Anda masuk.',
                        style: Txt.sans(12,
                            color: Colors.white70, height: 1.45),
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey('pickup'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.storefront_outlined,
                                size: 16, color: Color(0xFF60A5FA)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tersedia pilihan ambil di gerai',
                                    style: Txt.sans(12.5,
                                        weight: FontWeight.w700,
                                        color: Colors.white)),
                                Text(
                                    'Tunjukkan pesanan Anda di kasir saat tiba',
                                    style: Txt.sans(11.5,
                                        color: pal.darkCardText)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '🛍️ Pesan dulu dari rumah atau kantor via WhatsApp, lalu ambil pesanan di gerai sesuai waktu yang dikonfirmasi oleh tim kami.',
                        style: Txt.sans(12,
                            color: Colors.white70, height: 1.45),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.pal});
  final StorePalette pal;

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final blockPaint = Paint()
      ..color = pal.surfaceContainer.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Blocks
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(20, 20, size.width * 0.4, 70), const Radius.circular(12)),
        blockPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.55, 30, size.width * 0.38, 80),
            const Radius.circular(12)),
        blockPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(30, size.height * 0.6, size.width * 0.35, 75),
            const Radius.circular(12)),
        blockPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                size.width * 0.5, size.height * 0.55, size.width * 0.42, 80),
            const Radius.circular(12)),
        blockPaint);

    // Roads
    final p1 = Path()
      ..moveTo(0, size.height * 0.45)
      ..lineTo(size.width, size.height * 0.45);
    canvas.drawPath(p1, roadPaint);

    final p2 = Path()
      ..moveTo(size.width * 0.48, 0)
      ..lineTo(size.width * 0.48, size.height);
    canvas.drawPath(p2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
