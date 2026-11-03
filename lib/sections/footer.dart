import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_state.dart';
import '../pages/store_page.dart';
import '../ui/common.dart';

class StoreFooter extends StatelessWidget {
  const StoreFooter({super.key, required this.onNav});
  final ValueChanged<NavSection> onNav;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        final store = state.store;
        final pal = store.palette;
        final mobile = Bp.mobile(context);
        final wide = MediaQuery.sizeOf(context).width >= 900;

        return Container(
          width: double.infinity,
          color: pal.surfaceLow,
          padding: EdgeInsets.only(top: 48, bottom: mobile ? 110 : 96),
          child: ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: _BrandColumn(store: store)),
                          const SizedBox(width: 32),
                          Expanded(flex: 3, child: _ExploreColumn(store: store, onNav: onNav)),
                          const SizedBox(width: 32),
                          Expanded(flex: 4, child: _HoursColumn(store: store, onNav: onNav)),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _BrandColumn(store: store),
                          const SizedBox(height: 32),
                          _ExploreColumn(store: store, onNav: onNav),
                          const SizedBox(height: 32),
                          _HoursColumn(store: store, onNav: onNav),
                        ],
                      ),
                const SizedBox(height: 48),
                Divider(color: pal.outlineVariant.withValues(alpha: 0.4)),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 10,
                  children: [
                    Text(
                      '© ${DateTime.now().year} ${store.name}. Hak cipta dilindungi.',
                      style: Txt.sans(12.5, color: pal.onSurfaceVariant),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hover(
                          onTap: () => showToast(context, 'Halaman Kebijakan Privasi'),
                          builder: (context, h) => Text(
                            'Kebijakan Privasi',
                            style: Txt.sans(12.5,
                                color: h ? pal.primary : pal.onSurfaceVariant,
                                decoration: h ? TextDecoration.underline : null),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Hover(
                          onTap: () => showToast(context, 'Ketentuan Pemesanan'),
                          builder: (context, h) => Text(
                            'Ketentuan Pemesanan',
                            style: Txt.sans(12.5,
                                color: h ? pal.primary : pal.onSurfaceVariant,
                                decoration: h ? TextDecoration.underline : null),
                          ),
                        ),
                      ],
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

class _BrandColumn extends StatelessWidget {
  const _BrandColumn({required this.store});
  final dynamic store;

  @override
  Widget build(BuildContext context) {
    final pal = store.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: pal.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(store.logoIcon, color: pal.secondarySoft, size: 20),
            ),
            const SizedBox(width: 10),
            Text(store.name,
                style: Txt.serif(22, weight: FontWeight.w600, color: pal.primary)),
          ],
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Text(store.footerDesc,
              style: Txt.sans(13.5, color: pal.onSurfaceVariant, height: 1.6)),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in store.footerTags)
              Tag(tag, bg: pal.surfaceContainer, fg: pal.onSurfaceVariant),
          ],
        ),
      ],
    );
  }
}

class _ExploreColumn extends StatelessWidget {
  const _ExploreColumn({required this.store, required this.onNav});
  final dynamic store;
  final ValueChanged<NavSection> onNav;

  @override
  Widget build(BuildContext context) {
    final pal = store.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('EKSPLORASI',
            style: Txt.sans(12, weight: FontWeight.w800, color: pal.primary, spacing: 1.2)),
        const SizedBox(height: 14),
        for (final item in store.footerExplore)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Hover(
              onTap: () => onNav(NavSection.katalog),
              builder: (context, h) => Text(
                item,
                style: Txt.sans(13.5,
                    color: h ? pal.secondary : pal.onSurfaceVariant,
                    weight: h ? FontWeight.w600 : FontWeight.w400),
              ),
            ),
          ),
      ],
    );
  }
}

class _HoursColumn extends StatelessWidget {
  const _HoursColumn({required this.store, required this.onNav});
  final dynamic store;
  final ValueChanged<NavSection> onNav;

  @override
  Widget build(BuildContext context) {
    final pal = store.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ATELIER & JAM OPERASIONAL',
            style: Txt.sans(12, weight: FontWeight.w800, color: pal.primary, spacing: 1.2)),
        const SizedBox(height: 14),
        Text(store.address,
            style: Txt.sans(13.5, color: pal.onSurfaceVariant, height: 1.5)),
        const SizedBox(height: 10),
        Text(
          'Selasa – Minggu: 07.00 – 19.00 WIB\nSenin: Tutup Panggang',
          style: Txt.sans(13.5, color: pal.onSurfaceVariant, height: 1.5),
        ),
        const SizedBox(height: 14),
        Hover(
          onTap: () => onNav(NavSection.lokasi),
          builder: (context, h) => Text(
            'Reservasi Meja & Pre-order →',
            style: Txt.sans(13.5,
                weight: FontWeight.w700,
                color: h ? pal.primary : pal.secondary,
                decoration: h ? TextDecoration.underline : null),
          ),
        ),
      ],
    );
  }
}

