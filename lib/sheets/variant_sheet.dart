import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_event.dart';
import '../models/models.dart';
import '../ui/common.dart';
import '../utils/format.dart';

Future<void> showVariantSheet(BuildContext context, Product p) {
  final mobile = MediaQuery.sizeOf(context).width < 640;
  final pal = context.read<StoreBloc>().state.store.palette;

  if (mobile) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: pal.primary.withValues(alpha: 0.55),
      builder: (_) => VariantSheet(product: p, mobile: true),
    );
  }
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Tutup',
    barrierColor: pal.primary.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, _, _) => Center(child: VariantSheet(product: p, mobile: false)),
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

class VariantSheet extends StatefulWidget {
  const VariantSheet({super.key, required this.product, required this.mobile});
  final Product product;
  final bool mobile;

  @override
  State<VariantSheet> createState() => _VariantSheetState();
}

class _VariantSheetState extends State<VariantSheet> {
  late final Map<int, Set<int>> _selected = {
    for (final (i, g) in widget.product.variants.indexed)
      i: g.required && !g.multi ? {0} : <int>{},
  };
  int _qty = 1;

  Product get p => widget.product;

  int get unitPrice {
    var t = p.price;
    for (final (i, g) in p.variants.indexed) {
      for (final o in _selected[i]!) {
        t += g.options[o].price;
      }
    }
    return t;
  }

  List<String> get optionLabels => [
        for (final (i, g) in p.variants.indexed)
          for (final o in _selected[i]!.toList()..sort()) g.options[o].label,
      ];

  void _toggle(int gi, int oi) {
    final g = p.variants[gi];
    setState(() {
      final s = _selected[gi]!;
      if (g.multi) {
        s.contains(oi) ? s.remove(oi) : s.add(oi);
      } else {
        s
          ..clear()
          ..add(oi);
      }
    });
  }

  void _commit() {
    final bloc = context.read<StoreBloc>();
    final currentQty = bloc.state.qtyInCart(p);

    if (currentQty + _qty > p.stock) {
      showToast(context, 'Stok ${p.name} tersisa ${p.stock}', error: true);
      return;
    }

    bloc.add(StoreEvent.addToCart(
      product: p,
      options: optionLabels,
      unitPrice: unitPrice,
      qty: _qty,
    ));

    Navigator.of(context).pop();
    showToast(context, '$_qty× ${p.name} ditambahkan ke pesanan',
        icon: Icons.shopping_bag_outlined);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoreBloc>().state;
    final pal = state.store.palette;
    final maxStockLeft = p.stock - state.qtyInCart(p);

    final header = Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
                width: 84,
                height: 84,
                child: AppImage(src: p.image, emoji: p.emoji, cacheWidth: 200)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: Text(p.name,
                      style: Txt.serif(22, weight: FontWeight.w500, color: pal.primary)),
                ),
                const SizedBox(height: 4),
                Text(p.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Txt.sans(13, color: pal.onSurfaceVariant, height: 1.45)),
                const SizedBox(height: 6),
                Row(children: [
                  Text(rupiah(p.price),
                      style: Txt.sans(15, weight: FontWeight.w800, color: pal.secondary)),
                  if (p.hasDiscount) ...[
                    const SizedBox(width: 8),
                    Text(rupiah(p.originalPrice!),
                        style: Txt.sans(12,
                            color: pal.outline, decoration: TextDecoration.lineThrough)),
                  ],
                  const Spacer(),
                  Text('Stok: ${p.stock}',
                      style: Txt.sans(11.5, weight: FontWeight.w600, color: pal.outline)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );

    final body = Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (gi, g) in p.variants.indexed) ...[
            Row(
              children: [
                Expanded(
                  child: Text('${gi + 1}. ${g.title}'.toUpperCase(),
                      style: Txt.eyebrow(pal.primary, size: 12)),
                ),
                Tag(g.required ? 'Wajib' : 'Opsional',
                    bg: pal.surfaceContainer,
                    fg: g.required ? pal.secondary : pal.onSurfaceVariant),
              ],
            ),
            const SizedBox(height: 10),
            for (final (oi, o) in g.options.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _OptionTile(
                  option: o,
                  multi: g.multi,
                  selected: _selected[gi]!.contains(oi),
                  onTap: () => _toggle(gi, oi),
                ),
              ),
            const SizedBox(height: 14),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: pal.surfaceLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Jumlah Pesanan',
                      style: Txt.sans(13, weight: FontWeight.w700, color: pal.primary)),
                ),
                QtyStepper(
                  qty: _qty,
                  onMinus: _qty > 1 ? () => setState(() => _qty--) : null,
                  onPlus: _qty < maxStockLeft ? () => setState(() => _qty++) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final footer = Container(
      padding: EdgeInsets.fromLTRB(22, 16, 22, widget.mobile ? 22 : 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: pal.surfaceContainer)),
      ),
      child: PillButton(
        label: maxStockLeft <= 0
            ? 'Stok di keranjang sudah maksimal'
            : 'Tambah ke Pesanan — ${rupiah(unitPrice * _qty)}',
        icon: Icons.shopping_bag_outlined,
        onTap: maxStockLeft <= 0 ? null : _commit,
        bg: pal.primary,
        hoverBg: pal.primaryContainer,
        fg: Colors.white,
        fontSize: 14,
        radius: 18,
        expand: true,
        shadow: true,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: widget.mobile ? double.infinity : 520,
          maxHeight: MediaQuery.sizeOf(context).height * (widget.mobile ? 0.92 : 0.88),
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
            Stack(
              children: [
                header,
                Positioned(
                  top: 14,
                  right: 14,
                  child: Hover(
                    onTap: () => Navigator.of(context).pop(),
                    builder: (context, h) => Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: h ? pal.surfaceHigh : pal.surfaceContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close_rounded, size: 18, color: pal.onSurfaceVariant),
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 1, color: pal.surfaceContainer),
            Flexible(child: SingleChildScrollView(child: body)),
            footer,
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile(
      {required this.option, required this.multi, required this.selected, required this.onTap});
  final VariantOption option;
  final bool multi;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Hover(
      onTap: onTap,
      builder: (context, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: selected
              ? pal.secondarySoft.withValues(alpha: 0.35)
              : (h ? pal.surfaceLow : Colors.transparent),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? pal.secondary : pal.outlineVariant.withValues(alpha: 0.5),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: multi ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: multi ? BorderRadius.circular(6) : null,
                color: selected && multi ? pal.primary : Colors.transparent,
                border: Border.all(
                    color: selected ? pal.primary : pal.outline, width: selected ? 2 : 1.5),
              ),
              child: selected
                  ? (multi
                      ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                      : Center(
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration:
                                BoxDecoration(color: pal.primary, shape: BoxShape.circle),
                          ),
                        ))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.label,
                      style: Txt.sans(13.5,
                          weight: selected ? FontWeight.w700 : FontWeight.w600,
                          color: pal.primary)),
                  if (option.desc != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(option.desc!,
                          style: Txt.sans(12.5, color: pal.onSurfaceVariant, height: 1.4)),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              option.price == 0 ? 'Gratis' : '+${rupiah(option.price)}',
              style: Txt.sans(12.5,
                  weight: FontWeight.w700,
                  color: option.price == 0 ? pal.outline : pal.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

class QtyStepper extends StatelessWidget {
  const QtyStepper(
      {super.key, required this.qty, this.onMinus, this.onPlus, this.compact = false});
  final int qty;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    Widget btn(IconData icon, VoidCallback? onTap) => Hover(
          onTap: onTap,
          cursor: onTap == null ? SystemMouseCursors.forbidden : null,
          builder: (context, h) => Container(
            width: compact ? 26 : 30,
            height: compact ? 26 : 30,
            decoration: BoxDecoration(
              color: h && onTap != null ? pal.surfaceContainer : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                size: compact ? 15 : 18,
                color: onTap == null ? pal.outlineVariant : pal.primary),
          ),
        );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      decoration: BoxDecoration(
        color: pal.surfaceLowest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          btn(Icons.remove_rounded, onMinus),
          SizedBox(
            width: compact ? 24 : 30,
            child: Text('$qty',
                textAlign: TextAlign.center,
                style: Txt.sans(compact ? 13 : 14.5,
                    weight: FontWeight.w800, color: pal.primary)),
          ),
          btn(Icons.add_rounded, onPlus),
        ],
      ),
    );
  }
}
