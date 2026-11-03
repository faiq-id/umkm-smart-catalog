import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/store_data.dart';
import '../models/models.dart';
import '../utils/format.dart';
import 'store_event.dart';
import 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(_initialState()) {
    on<StoreEvent>((event, emit) {
      event.when(
        switchTheme: (storeId) => _onSwitchTheme(storeId, emit),
        searchChanged: (query) => _onSearchChanged(query, emit),
        categoryChanged: (categoryId) => _onCategoryChanged(categoryId, emit),
        filterAvailableOnlyToggled: () => _onFilterAvailableOnlyToggled(emit),
        addToCart: (product, options, unitPrice, qty) =>
            _onAddToCart(product, options, unitPrice, qty, emit),
        updateCartQty: (cartKey, delta) =>
            _onUpdateCartQty(cartKey, delta, emit),
        removeFromCart: (cartKey) => _onRemoveFromCart(cartKey, emit),
        claimPromo: () => _onClaimPromo(emit),
        setTableNumber: (tableNumber) => _onSetTableNumber(tableNumber, emit),
        setOrderType: (orderType) => _onSetOrderType(orderType, emit),
        placeOrder: (customer, note, onSuccess) =>
            _onPlaceOrder(customer, note, onSuccess, emit),
        adminUpdateStock: (productId, stock) =>
            _onAdminUpdateStock(productId, stock, emit),
        adminUpdateProduct: (productId, name, desc, price, originalPrice, clearDiscount) =>
            _onAdminUpdateProduct(productId, name, desc, price, originalPrice, clearDiscount, emit),
        adminUpdateOrderStatus: (orderId, status) =>
            _onAdminUpdateOrderStatus(orderId, status, emit),
        adminToggleOpen: (openOverride) =>
            _onAdminToggleOpen(openOverride, emit),
        adminTogglePromo: (active) => _onAdminTogglePromo(active, emit),
        adminUpdateStoreInfo: (name, tagline, address, whatsapp, instagram) =>
            _onAdminUpdateStoreInfo(name, tagline, address, whatsapp, instagram, emit),
        adminAddProduct: (product) => _onAdminAddProduct(product, emit),
        adminSaveProduct: (product) => _onAdminSaveProduct(product, emit),
        adminDeleteProduct: (productId) => _onAdminDeleteProduct(productId, emit),
        adminUpdatePromoBanner: (title, desc, bannerImage, badge) =>
            _onAdminUpdatePromoBanner(title, desc, bannerImage, badge, emit),
      );
    });
  }

  static StoreState _initialState() {
    final sList = [buildBakery(), buildCoffee(), buildPet()];
    final stores = {for (final s in sList) s.id: s};
    final orders = {for (final s in sList) s.id: _seedOrders(s)};
    return StoreState(
      currentStoreId: 'bakery',
      stores: stores,
      orders: orders,
    );
  }

  void _onSwitchTheme(String storeId, Emitter<StoreState> emit) {
    if (storeId == state.currentStoreId) return;
    emit(state.copyWith(
      currentStoreId: storeId,
      cart: const [],
      promoClaimed: false,
      tableNumber: null,
      openOverride: null,
      searchQuery: '',
      selectedCategory: 'all',
      availableOnly: false,
    ));
  }

  void _onSearchChanged(String query, Emitter<StoreState> emit) {
    emit(state.copyWith(searchQuery: query));
  }

  void _onCategoryChanged(String categoryId, Emitter<StoreState> emit) {
    emit(state.copyWith(selectedCategory: categoryId));
  }

  void _onFilterAvailableOnlyToggled(Emitter<StoreState> emit) {
    emit(state.copyWith(availableOnly: !state.availableOnly));
  }

  void _onAddToCart(
      Product product, List<String> options, int? unitPrice, int qty, Emitter<StoreState> emit) {
    if (product.soldOut) return;
    final currentQty = state.qtyInCart(product);
    if (currentQty + qty > product.stock) return;

    final item = CartItem(
      product: product,
      options: options,
      unitPrice: unitPrice ?? product.price,
      qty: qty,
    );

    final cart = List<CartItem>.from(state.cart);
    final idx = cart.indexWhere((c) => c.key == item.key);
    if (idx >= 0) {
      final existing = cart[idx];
      cart[idx] = existing.copyWith(qty: existing.qty + qty);
    } else {
      cart.add(item);
    }

    emit(state.copyWith(cart: cart));
  }

  void _onUpdateCartQty(String cartKey, int delta, Emitter<StoreState> emit) {
    final cart = List<CartItem>.from(state.cart);
    final idx = cart.indexWhere((c) => c.key == cartKey);
    if (idx < 0) return;

    final item = cart[idx];
    if (delta > 0 && state.qtyInCart(item.product) + delta > item.product.stock) {
      return;
    }

    final newQty = item.qty + delta;
    if (newQty <= 0) {
      cart.removeAt(idx);
    } else {
      cart[idx] = item.copyWith(qty: newQty);
    }
    emit(state.copyWith(cart: cart));
  }

  void _onRemoveFromCart(String cartKey, Emitter<StoreState> emit) {
    final cart = List<CartItem>.from(state.cart)..removeWhere((c) => c.key == cartKey);
    emit(state.copyWith(cart: cart));
  }

  void _onClaimPromo(Emitter<StoreState> emit) {
    emit(state.copyWith(promoClaimed: true));
  }

  void _onSetTableNumber(String? tableNumber, Emitter<StoreState> emit) {
    emit(state.copyWith(
      tableNumber: tableNumber,
      orderType: tableNumber != null ? 'Dine-in' : state.orderType,
    ));
  }

  void _onSetOrderType(String orderType, Emitter<StoreState> emit) {
    emit(state.copyWith(orderType: orderType));
  }

  void _onPlaceOrder(String customer, String note,
      void Function(String waMessage)? onSuccess, Emitter<StoreState> emit) {
    if (state.cart.isEmpty) return;

    final store = state.store;
    final b = StringBuffer()
      ..writeln('Halo ${store.shortName}, saya ingin memesan:')
      ..writeln();
    for (final (i, c) in state.cart.indexed) {
      b.writeln('${i + 1}. ${c.product.name} x${c.qty} — ${rupiah(c.total)}');
      if (c.options.isNotEmpty) b.writeln('   • ${c.options.join(', ')}');
    }
    b
      ..writeln()
      ..writeln('Subtotal: ${rupiah(state.subtotal)}');
    if (state.discount > 0) {
      b.writeln('Promo ${store.promo.code}: -${rupiah(state.discount)}');
    }
    b
      ..writeln('*Total: ${rupiah(state.total)}*')
      ..writeln()
      ..writeln('Nama: ${customer.isEmpty ? '-' : customer}')
      ..writeln(
          'Layanan: ${state.orderType == 'Delivery' ? '🛵 Pesan Antar (Delivery)' : '🛍️ Ambil di Gerai (Self-Pickup)'}');
    if (note.isNotEmpty) {
      b.writeln(state.orderType == 'Delivery'
          ? 'Alamat / Catatan: $note'
          : 'Catatan: $note');
    }

    final waMessage = b.toString();

    final order = Order(
      id: '#${1040 + state.currentOrders.length + 1}',
      customer: customer.isEmpty ? 'Pelanggan Web' : customer,
      items: state.cart.map((c) => '${c.qty}x ${c.product.name}').toList(),
      total: state.total,
      time: DateTime.now(),
      channel: 'WhatsApp · ${state.orderType == 'Delivery' ? 'Delivery' : 'Pickup'}',
    );

    // Update stock & sold count
    final updatedProducts = List<Product>.from(store.products);
    for (final c in state.cart) {
      final pIndex = updatedProducts.indexWhere((p) => p.id == c.product.id);
      if (pIndex >= 0) {
        final p = updatedProducts[pIndex];
        updatedProducts[pIndex] = p.copyWith(
          stock: (p.stock - c.qty).clamp(0, 99999).toInt(),
          soldToday: p.soldToday + c.qty,
        );
      }
    }

    final updatedStores = Map<String, StoreProfile>.from(state.stores);
    updatedStores[state.currentStoreId] =
        store.copyWith(products: updatedProducts);

    final updatedOrders = Map<String, List<Order>>.from(state.orders);
    final currentList = List<Order>.from(state.currentOrders)..insert(0, order);
    updatedOrders[state.currentStoreId] = currentList;

    emit(state.copyWith(
      stores: updatedStores,
      orders: updatedOrders,
      cart: const [],
      promoClaimed: false,
    ));

    onSuccess?.call(waMessage);
  }

  void _onAdminUpdateStock(String productId, int stock, Emitter<StoreState> emit) {
    final store = state.store;
    final products = List<Product>.from(store.products);
    final idx = products.indexWhere((p) => p.id == productId);
    if (idx >= 0) {
      products[idx] = products[idx].copyWith(stock: stock.clamp(0, 9999).toInt());
      final updatedStores = Map<String, StoreProfile>.from(state.stores);
      updatedStores[state.currentStoreId] = store.copyWith(products: products);
      emit(state.copyWith(stores: updatedStores));
    }
  }

  void _onAdminUpdateProduct(
      String productId,
      String? name,
      String? desc,
      int? price,
      int? originalPrice,
      bool clearDiscount,
      Emitter<StoreState> emit) {
    final store = state.store;
    final products = List<Product>.from(store.products);
    final idx = products.indexWhere((p) => p.id == productId);
    if (idx >= 0) {
      var p = products[idx];
      if (name != null) p = p.copyWith(name: name);
      if (desc != null) p = p.copyWith(desc: desc);
      if (price != null) p = p.copyWith(price: price);
      if (clearDiscount) {
        p = p.copyWith(originalPrice: null);
      } else if (originalPrice != null) {
        p = p.copyWith(originalPrice: originalPrice);
      }
      products[idx] = p;
      final updatedStores = Map<String, StoreProfile>.from(state.stores);
      updatedStores[state.currentStoreId] = store.copyWith(products: products);
      emit(state.copyWith(stores: updatedStores));
    }
  }

  void _onAdminUpdateOrderStatus(
      String orderId, OrderStatus status, Emitter<StoreState> emit) {
    final ordersList = List<Order>.from(state.currentOrders);
    final idx = ordersList.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      ordersList[idx] = ordersList[idx].copyWith(status: status);
      final updatedOrders = Map<String, List<Order>>.from(state.orders);
      updatedOrders[state.currentStoreId] = ordersList;
      emit(state.copyWith(orders: updatedOrders));
    }
  }

  void _onAdminToggleOpen(bool? openOverride, Emitter<StoreState> emit) {
    emit(state.copyWith(openOverride: openOverride));
  }

  void _onAdminTogglePromo(bool active, Emitter<StoreState> emit) {
    emit(state.copyWith(promoActive: active));
  }

  void _onAdminUpdateStoreInfo(
      String? name,
      String? tagline,
      String? address,
      String? whatsapp,
      String? instagram,
      Emitter<StoreState> emit) {
    var s = state.store;
    if (name != null && name.trim().isNotEmpty) {
      s = s.copyWith(name: name.trim());
    }
    if (tagline != null) s = s.copyWith(tagline: tagline);
    if (address != null) s = s.copyWith(address: address);
    if (whatsapp != null) {
      s = s.copyWith(whatsapp: whatsapp.replaceAll(RegExp(r'[^0-9]'), ''));
    }
    if (instagram != null) s = s.copyWith(instagram: instagram);

    final updatedStores = Map<String, StoreProfile>.from(state.stores);
    updatedStores[state.currentStoreId] = s;
    emit(state.copyWith(stores: updatedStores));
  }

  void _onAdminAddProduct(Product product, Emitter<StoreState> emit) {
    final store = state.store;
    final products = List<Product>.from(store.products);
    products.insert(0, product);
    final updatedStores = Map<String, StoreProfile>.from(state.stores);
    updatedStores[state.currentStoreId] = store.copyWith(products: products);
    emit(state.copyWith(stores: updatedStores));
  }

  void _onAdminSaveProduct(Product product, Emitter<StoreState> emit) {
    final store = state.store;
    final products = List<Product>.from(store.products);
    final idx = products.indexWhere((p) => p.id == product.id);
    if (idx >= 0) {
      products[idx] = product;
    } else {
      products.insert(0, product);
    }
    final updatedStores = Map<String, StoreProfile>.from(state.stores);
    updatedStores[state.currentStoreId] = store.copyWith(products: products);
    emit(state.copyWith(stores: updatedStores));
  }

  void _onAdminDeleteProduct(String productId, Emitter<StoreState> emit) {
    final store = state.store;
    final products = List<Product>.from(store.products)
      ..removeWhere((p) => p.id == productId);
    final updatedStores = Map<String, StoreProfile>.from(state.stores);
    updatedStores[state.currentStoreId] = store.copyWith(products: products);
    emit(state.copyWith(stores: updatedStores));
  }

  void _onAdminUpdatePromoBanner(
      String? title,
      String? desc,
      String? bannerImage,
      String? badge,
      Emitter<StoreState> emit) {
    var s = state.store;
    if (bannerImage != null && bannerImage.trim().isNotEmpty) {
      s = s.copyWith(banner: bannerImage.trim());
    }
    var p = s.promo;
    if (title != null && title.trim().isNotEmpty) {
      p = p.copyWith(title: title.trim());
    }
    if (desc != null && desc.trim().isNotEmpty) {
      p = p.copyWith(desc: desc.trim());
    }
    if (badge != null && badge.trim().isNotEmpty) {
      p = p.copyWith(badge: badge.trim());
    }
    s = s.copyWith(promo: p);
    final updatedStores = Map<String, StoreProfile>.from(state.stores);
    updatedStores[state.currentStoreId] = s;
    emit(state.copyWith(stores: updatedStores));
  }

  static List<Order> _seedOrders(StoreProfile s) {
    final now = DateTime.now();
    final names = ['Rina A.', 'Budi S.', 'Sarah K.', 'Dimas P.', 'Ayu L.', 'Kevin T.'];
    final statuses = [
      OrderStatus.baru,
      OrderStatus.diproses,
      OrderStatus.siap,
      OrderStatus.selesai,
      OrderStatus.selesai,
      OrderStatus.selesai,
    ];
    final channels = [
      'QR ${s.qrUnitLabel} 07',
      'WhatsApp · Take Away',
      'QR ${s.qrUnitLabel} 03',
      'WhatsApp · Delivery',
      'Instagram DM',
      'QR ${s.qrUnitLabel} 11',
    ];
    return List.generate(6, (i) {
      final p1 = s.products[i % s.products.length];
      final p2 = s.products[(i + 2) % s.products.length];
      final q = 1 + i % 2;
      return Order(
        id: '#${1040 - i}',
        customer: names[i],
        items: ['${q}x ${p1.name}', '1x ${p2.name}'],
        total: p1.price * q + p2.price,
        time: now.subtract(Duration(minutes: 6 + i * 23)),
        channel: channels[i],
        status: statuses[i],
      );
    });
  }
}
