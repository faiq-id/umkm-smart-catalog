import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_event.dart';
import '../bloc/store_state.dart';
import '../models/models.dart';
import '../sheets/variant_sheet.dart';
import '../ui/common.dart';
import '../utils/format.dart';

class CatalogSection extends StatefulWidget {
  const CatalogSection({super.key});

  @override
  State<CatalogSection> createState() => _CatalogSectionState();
}

class _CatalogSectionState extends State<CatalogSection> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        final store = state.store;
        final pal = store.palette;
        final mobile = Bp.mobile(context);
        final products = state.filteredProducts;

        final searchField = TextField(
          controller: _search,
          onChanged: (v) => context.read<StoreBloc>().add(StoreEvent.searchChanged(v)),
          style: Txt.sans(13.5, color: pal.onSurface),
          cursorColor: pal.secondary,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: pal.surfaceLowest,
            hintText: store.searchHint,
            hintStyle: Txt.sans(13, color: pal.onSurfaceVariant.withValues(alpha: 0.6)),
            prefixIcon: Icon(Icons.search_rounded, color: pal.outline),
            suffixIcon: state.searchQuery.isEmpty
                ? null
                : IconButton(
                    icon: Icon(Icons.close_rounded, size: 18, color: pal.outline),
                    onPressed: () {
                      _search.clear();
                      context.read<StoreBloc>().add(const StoreEvent.searchChanged(''));
                    },
                  ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: pal.outlineVariant.withValues(alpha: 0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: pal.secondary, width: 1.6),
            ),
          ),
        );

        return ContentWidth(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(
                  direction: MediaQuery.sizeOf(context).width >= 768
                      ? Axis.horizontal
                      : Axis.vertical,
                  crossAxisAlignment: MediaQuery.sizeOf(context).width >= 768
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(store.catalogEyebrow.toUpperCase(),
                            style: Txt.eyebrow(pal.secondary, size: 12)),
                        const SizedBox(height: 4),
                        Text(store.catalogTitle,
                            style: Txt.serif(mobile ? 30 : 36,
                                color: pal.primary, spacing: -0.4)),
                      ],
                    ),
                    if (MediaQuery.sizeOf(context).width >= 768)
                      const Spacer()
                    else
                      const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width >= 768 ? 380 : double.infinity,
                      child: searchField,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      for (final c in store.categories)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _CategoryChip(
                            category: c,
                            active: c.id == state.selectedCategory,
                            count: c.id == 'all'
                                ? store.products.length
                                : store.products.where((p) => p.category == c.id).length,
                            onTap: () => context
                                .read<StoreBloc>()
                                .add(StoreEvent.categoryChanged(c.id)),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text('${products.length} item ditampilkan',
                        style: Txt.sans(12.5, color: pal.onSurfaceVariant)),
                    const Spacer(),
                    Hover(
                      onTap: () => context
                          .read<StoreBloc>()
                          .add(const StoreEvent.filterAvailableOnlyToggled()),
                      builder: (context, h) => Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: state.availableOnly ? pal.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: state.availableOnly ? pal.primary : pal.outline,
                                  width: 1.5),
                            ),
                            child: state.availableOnly
                                ? const Icon(Icons.check_rounded,
                                    size: 13, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text('Tampilkan yang tersedia saja',
                              style: Txt.sans(12.5,
                                  weight: FontWeight.w600,
                                  color: h ? pal.primary : pal.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: products.isEmpty
                      ? _EmptyState(
                          key: const ValueKey('empty'),
                          onReset: () {
                            _search.clear();
                            context.read<StoreBloc>().add(const StoreEvent.searchChanged(''));
                            context.read<StoreBloc>().add(const StoreEvent.categoryChanged('all'));
                            if (state.availableOnly) {
                              context
                                  .read<StoreBloc>()
                                  .add(const StoreEvent.filterAvailableOnlyToggled());
                            }
                          },
                        )
                      : _ProductGrid(
                          key: ValueKey(
                              '${state.selectedCategory}|${state.searchQuery}|${state.availableOnly}'),
                          products: products,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip(
      {required this.category, required this.active, required this.count, required this.onTap});
  final Category category;
  final bool active;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Hover(
      onTap: onTap,
      builder: (context, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: active ? pal.primary : (h ? pal.surfaceContainer : pal.surfaceLowest),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
              color: active ? pal.primary : pal.outlineVariant.withValues(alpha: 0.4)),
          boxShadow: active
              ? [
                  BoxShadow(
                      color: pal.primary.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(category.icon,
                size: 16, color: active ? pal.secondarySoft : pal.onSurfaceVariant),
            const SizedBox(width: 7),
            Text(category.label,
                style: Txt.sans(12.5,
                    weight: FontWeight.w600,
                    color: active ? Colors.white : (h ? pal.primary : pal.onSurfaceVariant))),
            const SizedBox(width: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: active ? Colors.white.withValues(alpha: 0.15) : pal.surfaceContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('$count',
                  style: Txt.sans(10.5,
                      weight: FontWeight.w700,
                      color: active ? Colors.white : pal.onSurfaceVariant)),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key, required this.onReset});
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      decoration: cardDecoration(pal),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: pal.surfaceContainer, shape: BoxShape.circle),
            child: Icon(Icons.search_off_rounded, size: 34, color: pal.outline),
          ),
          const SizedBox(height: 16),
          Text('Menu tidak ditemukan', style: Txt.serif(24, color: pal.primary)),
          const SizedBox(height: 6),
          Text('Coba kata kunci lain atau lihat semua kategori.',
              textAlign: TextAlign.center,
              style: Txt.sans(14, color: pal.onSurfaceVariant)),
          const SizedBox(height: 18),
          PillButton(
            label: 'Reset Pencarian',
            icon: Icons.refresh_rounded,
            onTap: onReset,
            bg: pal.primary,
            fg: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({super.key, required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 960 ? 3 : (c.maxWidth >= 560 ? 2 : 1);
      final gap = c.maxWidth >= 640 ? 24.0 : 18.0;
      final rows = <List<Product>>[];
      for (var i = 0; i < products.length; i += cols) {
        rows.add(products.sublist(i, (i + cols).clamp(0, products.length)));
      }
      return Column(
        children: [
          for (final (ri, row) in rows.indexed)
            Padding(
              padding: EdgeInsets.only(bottom: ri == rows.length - 1 ? 0 : gap),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < cols; i++) ...[
                    if (i > 0) SizedBox(width: gap),
                    Expanded(
                      child: i < row.length
                          ? _FadeIn(
                              delay: Duration(milliseconds: 60 * (ri * cols + i)),
                              child: ProductCard(product: row[i]),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ],
              ),
            ),
        ],
      );
    });
  }
}

class _FadeIn extends StatelessWidget {
  const _FadeIn({required this.child, required this.delay});
  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

List<String> defaultOptions(Product p) => [
      for (final g in p.variants)
        if (g.required && !g.multi && g.options.isNotEmpty) g.options.first.label,
    ];

void quickAdd(BuildContext context, Product p) {
  final bloc = context.read<StoreBloc>();
  final inCart = bloc.state.qtyInCart(p);

  if (p.soldOut) {
    showToast(context, '${p.name} sedang habis', error: true);
    return;
  }
  if (inCart + 1 > p.stock) {
    showToast(context, 'Stok ${p.name} tersisa ${p.stock}', error: true);
    return;
  }

  final opts = defaultOptions(p);
  final extra = [
    for (final g in p.variants)
      if (g.required && !g.multi && g.options.isNotEmpty) g.options.first.price,
  ].fold(0, (a, b) => a + b);

  bloc.add(StoreEvent.addToCart(
    product: p,
    options: opts,
    unitPrice: p.price + extra,
    qty: 1,
  ));

  showToast(context, '${p.name} ditambahkan ke pesanan',
      icon: Icons.shopping_bag_outlined);
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoreBloc>().state;
    final pal = state.store.palette;
    final p = product;
    final soldOut = p.soldOut;
    final inCart = state.qtyInCart(p);
    final lowStock = !soldOut && p.stock <= 5;

    return RepaintBoundary(
      child: Hover(
        onTap: soldOut
            ? null
            : () => p.variants.isNotEmpty
                ? showVariantSheet(context, p)
                : quickAdd(context, p),
        cursor: soldOut ? SystemMouseCursors.basic : SystemMouseCursors.click,
        builder: (context, h) {
          final hovered = h && !soldOut;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(0, hovered ? -4 : 0, 0),
            padding: const EdgeInsets.all(16),
            decoration: cardDecoration(pal, hovered: hovered),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedScale(
                          scale: hovered ? 1.06 : 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          child: AppImage(
                            src: p.image,
                            emoji: p.emoji,
                            grayscale: soldOut,
                            cacheWidth: 600,
                          ),
                        ),
                        if (soldOut)
                          Container(
                            color: Colors.black.withValues(alpha: 0.25),
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFF82181A),
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, blurRadius: 8)
                                ],
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                const Icon(Icons.block_rounded, size: 15, color: Colors.white),
                                const SizedBox(width: 6),
                                Text('HABIS TERJUAL / SOLD OUT',
                                    style: Txt.sans(11.5,
                                        weight: FontWeight.w800,
                                        color: Colors.white,
                                        spacing: 0.8)),
                              ]),
                            ),
                          ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Tag(p.badge,
                                bg: pal.surfaceLowest.withValues(alpha: 0.92),
                                fg: soldOut ? pal.onSurfaceVariant : pal.secondary),
                            if (p.hasDiscount && !soldOut) ...[
                              const SizedBox(height: 5),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: pal.secondary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text('-${p.discountPercent}% Hemat',
                                    style: Txt.sans(11,
                                        weight: FontWeight.w700, color: Colors.white)),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: pal.surfaceLowest.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.star_rounded, size: 15, color: pal.secondary),
                            const SizedBox(width: 3),
                            Text(p.rating.toStringAsFixed(1),
                                style: Txt.sans(11.5,
                                    weight: FontWeight.w800, color: pal.primary)),
                            const SizedBox(width: 3),
                            Text('(${p.reviews}+)',
                                style: Txt.sans(10, color: pal.outline)),
                          ]),
                        ),
                      ),
                      if (inCart > 0)
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: pal.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              const Icon(Icons.shopping_bag_rounded,
                                  size: 13, color: Colors.white),
                              const SizedBox(width: 4),
                              Text('$inCart di keranjang',
                                  style: Txt.sans(11,
                                      weight: FontWeight.w700, color: Colors.white)),
                            ]),
                          ),
                        ),
                      if (lowStock)
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Tag('Sisa ${p.stock} lagi!',
                              icon: Icons.bolt_rounded,
                              bg: const Color(0xFFFEF3C7),
                              fg: const Color(0xFF92400E)),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: Txt.serif(20,
                          weight: FontWeight.w500,
                          height: 1.3,
                          color: soldOut
                              ? pal.onSurfaceVariant.withValues(alpha: 0.8)
                              : (hovered ? pal.secondary : pal.primary)),
                      child: Text(p.name),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (p.hasDiscount)
                        Text(rupiah(p.originalPrice!),
                            style: Txt.sans(12,
                                color: pal.outline, decoration: TextDecoration.lineThrough)),
                      Text(rupiah(p.price),
                          style: Txt.sans(14.5,
                              weight: FontWeight.w800,
                              color: soldOut
                                  ? pal.onSurfaceVariant
                                  : (p.hasDiscount ? pal.secondary : pal.primary))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(p.desc,
                  style: Txt.sans(13,
                      height: 1.5,
                      color: soldOut
                          ? pal.onSurfaceVariant.withValues(alpha: 0.7)
                          : pal.onSurfaceVariant)),
              const SizedBox(height: 12),
              Divider(height: 1, color: pal.surfaceContainer),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(soldOut ? Icons.alarm_off_rounded : p.featureIcon,
                      size: 17, color: soldOut ? const Color(0xFFBA1A1A) : pal.secondary),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(soldOut ? 'Batch Habis Hari Ini' : p.featureLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Txt.sans(11.5,
                            weight: FontWeight.w600,
                            color: soldOut ? const Color(0xFFBA1A1A) : pal.onSurfaceVariant)),
                  ),
                  if (soldOut)
                    PillButton(
                      label: 'Stok Habis',
                      icon: Icons.remove_shopping_cart_outlined,
                      bg: pal.surfaceHigh,
                      fg: pal.onSurfaceVariant.withValues(alpha: 0.5),
                      fontSize: 12,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    )
                  else ...[
                    if (p.variants.isNotEmpty) ...[
                      PillButton(
                        label: 'Varian',
                        trailingIcon: Icons.tune_rounded,
                        onTap: () => showVariantSheet(context, p),
                        bg: pal.surfaceContainer,
                        hoverBg: pal.surfaceHigh,
                        fg: pal.primary,
                        fontSize: 12,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                      ),
                      const SizedBox(width: 6),
                    ],
                    PillButton(
                      label: 'Tambah',
                      icon: Icons.add_rounded,
                      onTap: () => quickAdd(context, p),
                      bg: pal.primary,
                      hoverBg: pal.primaryContainer,
                      fg: Colors.white,
                      fontSize: 12,
                      shadow: true,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    ));
  }
}
