import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/models.dart';
import '../utils/format.dart';

part 'store_state.freezed.dart';

@freezed
abstract class StoreState with _$StoreState {
  const StoreState._();

  const factory StoreState({
    required String currentStoreId,
    required Map<String, StoreProfile> stores,
    required Map<String, List<Order>> orders,
    @Default([]) List<CartItem> cart,
    @Default('') String searchQuery,
    @Default('all') String selectedCategory,
    @Default(false) bool availableOnly,
    @Default(false) bool promoClaimed,
    @Default(true) bool promoActive,
    bool? openOverride,
    String? tableNumber,
    @Default('Dine-in') String orderType,
    @Default(false) bool cloudConnected,
    @Default(false) bool cloudSeeded,
    @Default(false) bool cloudSyncing,
    String? cloudError,
  }) = _StoreState;

  StoreProfile get store => stores[currentStoreId]!;
  List<StoreProfile> get allStores => stores.values.toList();
  List<Order> get currentOrders => orders[currentStoreId] ?? const [];

  int get cartCount => cart.fold(0, (a, b) => a + b.qty);
  int get subtotal => cart.fold(0, (a, b) => a + b.total);
  int get discount {
    if (!promoClaimed || !promoActive) return 0;
    final d = (subtotal * store.promo.percent / 100).round();
    return d > store.promo.maxDiscount ? store.promo.maxDiscount : d;
  }

  int get total => subtotal - discount;
  String get lastItemName => cart.isEmpty ? '' : cart.last.product.name;

  int qtyInCart(Product p) =>
      cart.where((c) => c.product.id == p.id).fold(0, (a, b) => a + b.qty);

  bool isOpenAt(DateTime now) {
    if (openOverride != null) return openOverride!;
    final day = store.schedule[now.weekday];
    if (day == null) return false;
    final m = now.hour * 60 + now.minute;
    return m >= day.openMinute && m < day.closeMinute;
  }

  String statusDetail(DateTime now) {
    if (openOverride == true) return 'Dibuka manual oleh admin';
    if (openOverride == false) return 'Ditutup sementara oleh admin';
    final today = store.schedule[now.weekday];
    final m = now.hour * 60 + now.minute;
    if (today != null && m >= today.openMinute && m < today.closeMinute) {
      return 'Hingga ${formatMinute(today.closeMinute)} WIB';
    }
    if (today != null && m < today.openMinute) {
      return 'Buka hari ini ${formatMinute(today.openMinute)} WIB';
    }
    for (var i = 1; i <= 7; i++) {
      final wd = ((now.weekday - 1 + i) % 7) + 1;
      final s = store.schedule[wd];
      if (s != null) {
        final label = i == 1 ? 'besok' : dayName(wd);
        return 'Buka $label ${formatMinute(s.openMinute)} WIB';
      }
    }
    return 'Tutup';
  }

  List<Product> get filteredProducts {
    final q = searchQuery.toLowerCase().trim();
    return store.products.where((p) {
      if (selectedCategory != 'all' && p.category != selectedCategory) return false;
      if (availableOnly && p.soldOut) return false;
      if (q.isEmpty) return true;
      return '${p.name} ${p.desc} ${p.badge} ${p.featureLabel}'.toLowerCase().contains(q);
    }).toList();
  }
}
