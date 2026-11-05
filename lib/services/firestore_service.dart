import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

/// Snapshot data toko yang disimpan di dokumen `stores/{storeId}`.
class RemoteStoreDoc {
  const RemoteStoreDoc({
    required this.exists,
    this.name,
    this.tagline,
    this.address,
    this.whatsapp,
    this.instagram,
    this.banner,
    this.promoActive,
    this.hasOpenOverride = false,
    this.openOverride,
    this.promo,
  });

  final bool exists;
  final String? name;
  final String? tagline;
  final String? address;
  final String? whatsapp;
  final String? instagram;
  final String? banner;
  final bool? promoActive;
  final bool hasOpenOverride;
  final bool? openOverride;
  final Promo? promo;
}

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  /// Peta konstan antara kunci teks dan `const IconData` agar aman dari
  /// tree-shaking ikon saat `flutter build web --release`.
  static const Map<String, IconData> _iconByKey = {
    'local_fire_department_outlined': Icons.local_fire_department_outlined,
    'timer_outlined': Icons.timer_outlined,
    'eco_outlined': Icons.eco_outlined,
    'coffee_maker_outlined': Icons.coffee_maker_outlined,
    'star_half_rounded': Icons.star_half_rounded,
    'bakery_dining_outlined': Icons.bakery_dining_outlined,
    'event_available_outlined': Icons.event_available_outlined,
    'brush_outlined': Icons.brush_outlined,
    'ac_unit_rounded': Icons.ac_unit_rounded,
    'grain': Icons.grain,
    'workspace_premium_outlined': Icons.workspace_premium_outlined,
    'verified_user_outlined': Icons.verified_user_outlined,
    'handshake_outlined': Icons.handshake_outlined,
    'water_drop_outlined': Icons.water_drop_outlined,
    'local_laundry_service_outlined': Icons.local_laundry_service_outlined,
    'videocam_outlined': Icons.videocam_outlined,
    'star_rounded': Icons.star_rounded,
  };

  static String iconToKey(IconData icon) {
    for (final entry in _iconByKey.entries) {
      if (entry.value.codePoint == icon.codePoint) {
        return entry.key;
      }
    }
    return 'star_rounded';
  }

  static IconData keyToIcon(String? key) {
    if (key == null) return Icons.star_rounded;
    return _iconByKey[key] ?? Icons.star_rounded;
  }

  DocumentReference<Map<String, dynamic>> _storeRef(String storeId) =>
      _db.collection('stores').doc(_cleanId(storeId));

  CollectionReference<Map<String, dynamic>> _productsRef(String storeId) =>
      _storeRef(storeId).collection('products');

  static String _cleanId(String raw) {
    final cleaned = raw.trim().replaceAll('/', '_');
    if (cleaned.isEmpty) return 'item';
    return cleaned.length > 96 ? cleaned.substring(0, 96) : cleaned;
  }

  static String _clip(String value, int maxLen, {String fallback = ''}) {
    final trimmed = value.trim();
    final effective = trimmed.isEmpty ? fallback : trimmed;
    return effective.length > maxLen
        ? effective.substring(0, maxLen)
        : effective;
  }

  // ---------------------------------------------------------------------------
  // Real-time Streams (Publik & Admin)
  // ---------------------------------------------------------------------------

  Stream<RemoteStoreDoc> watchStore(String storeId) {
    return _storeRef(storeId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) {
        return const RemoteStoreDoc(exists: false);
      }
      final d = snap.data()!;
      Promo? promo;
      final rawPromo = d['promo'];
      if (rawPromo is Map) {
        promo = Promo(
          badge: (rawPromo['badge'] as String?) ?? '',
          eyebrow: (rawPromo['eyebrow'] as String?) ?? '',
          title: (rawPromo['title'] as String?) ?? '',
          desc: (rawPromo['desc'] as String?) ?? '',
          cta: (rawPromo['cta'] as String?) ?? 'Klaim Promo',
          percent: (rawPromo['percent'] as num?)?.toInt() ?? 0,
          maxDiscount: (rawPromo['maxDiscount'] as num?)?.toInt() ?? 0,
          endHour: (rawPromo['endHour'] as num?)?.toInt() ?? 12,
          code: (rawPromo['code'] as String?) ?? '',
        );
      }
      return RemoteStoreDoc(
        exists: true,
        name: d['name'] as String?,
        tagline: d['tagline'] as String?,
        address: d['address'] as String?,
        whatsapp: d['whatsapp'] as String?,
        instagram: d['instagram'] as String?,
        banner: d['banner'] as String?,
        promoActive: d['promoActive'] as bool?,
        hasOpenOverride: d.containsKey('openOverride'),
        openOverride: d['openOverride'] as bool?,
        promo: promo,
      );
    });
  }

  Stream<List<Product>?> watchProducts(String storeId) {
    return _productsRef(storeId).snapshots().map((snap) {
      if (snap.docs.isEmpty) return null;
      final indexed = snap.docs.map((doc) {
        final data = doc.data();
        final sortOrder = (data['sortOrder'] as num?)?.toInt() ?? 9999;
        return (sortOrder, _productFromMap(doc.id, data));
      }).toList()
        ..sort((a, b) => a.$1.compareTo(b.$1));
      return indexed.map((e) => e.$2).toList();
    });
  }

  // ---------------------------------------------------------------------------
  // Initial Seeding & Admin Writes
  // ---------------------------------------------------------------------------

  /// Memastikan dokumen toko & daftar produk awal sudah ada di Firestore.
  /// Hanya menulis jika dokumen `stores/{storeId}` belum pernah dibuat.
  Future<bool> ensureStoreSeeded({
    required StoreProfile templateStore,
    required bool promoActive,
    required bool? openOverride,
  }) async {
    final storeDoc = await _storeRef(templateStore.id).get();
    if (storeDoc.exists) return false;

    await overwriteStoreWithSeed(
      templateStore: templateStore,
      promoActive: promoActive,
      openOverride: openOverride,
    );
    return true;
  }

  /// Menulis penuh profil toko dan seluruh daftar produknya ke Firestore.
  Future<void> overwriteStoreWithSeed({
    required StoreProfile templateStore,
    required bool promoActive,
    required bool? openOverride,
  }) async {
    final batch = _db.batch();
    final sRef = _storeRef(templateStore.id);
    batch.set(
      sRef,
      _storeToMap(
        templateStore,
        promoActive: promoActive,
        openOverride: openOverride,
      ),
    );

    final existingProducts = await _productsRef(templateStore.id).get();
    final incomingIds =
        templateStore.products.map((p) => _cleanId(p.id)).toSet();
    for (final doc in existingProducts.docs) {
      if (!incomingIds.contains(doc.id)) {
        batch.delete(doc.reference);
      }
    }

    for (final (idx, product) in templateStore.products.indexed) {
      final cleanId = _cleanId(product.id);
      final pRef = _productsRef(templateStore.id).doc(cleanId);
      batch.set(
        pRef,
        _productToMap(product.copyWith(id: cleanId), sortOrder: idx),
      );
    }

    await batch.commit();
  }

  Future<void> saveStoreMetadata({
    required StoreProfile store,
    required bool promoActive,
    required bool? openOverride,
  }) async {
    await ensureStoreSeeded(
      templateStore: store,
      promoActive: promoActive,
      openOverride: openOverride,
    );
    await _storeRef(store.id).set(
      _storeToMap(
        store,
        promoActive: promoActive,
        openOverride: openOverride,
      ),
    );
  }

  Future<void> saveProduct({
    required StoreProfile currentStore,
    required Product product,
    required int sortOrder,
    required bool promoActive,
    required bool? openOverride,
  }) async {
    await ensureStoreSeeded(
      templateStore: currentStore,
      promoActive: promoActive,
      openOverride: openOverride,
    );
    final cleanId = _cleanId(product.id);
    await _productsRef(currentStore.id).doc(cleanId).set(
          _productToMap(
            product.copyWith(id: cleanId),
            sortOrder: sortOrder.clamp(0, 999999),
          ),
        );
  }

  Future<void> deleteProduct({
    required StoreProfile currentStore,
    required String productId,
    required bool promoActive,
    required bool? openOverride,
  }) async {
    await ensureStoreSeeded(
      templateStore: currentStore,
      promoActive: promoActive,
      openOverride: openOverride,
    );
    await _productsRef(currentStore.id).doc(_cleanId(productId)).delete();
  }

  // ---------------------------------------------------------------------------
  // Serializers (Selaras dengan `firestore.rules`)
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> _storeToMap(
    StoreProfile s, {
    required bool promoActive,
    required bool? openOverride,
  }) {
    final p = s.promo;
    return {
      'name': _clip(s.name, 120, fallback: 'Toko UMKM'),
      'tagline': _clip(s.tagline, 300),
      'address': _clip(s.address, 400),
      'whatsapp': _clip(s.whatsapp, 30),
      'instagram': _clip(s.instagram, 100),
      'banner': _clip(s.banner, 1000),
      'promoActive': promoActive,
      'openOverride': openOverride,
      'promo': {
        'badge': _clip(p.badge, 80),
        'eyebrow': _clip(p.eyebrow, 120),
        'title': _clip(p.title, 200),
        'desc': _clip(p.desc, 600),
        'cta': _clip(p.cta, 80),
        'percent': p.percent.clamp(0, 100),
        'maxDiscount': p.maxDiscount.clamp(0, 100000000),
        'endHour': p.endHour.clamp(0, 24),
        'code': _clip(p.code, 60),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static Map<String, dynamic> _productToMap(
    Product p, {
    required int sortOrder,
  }) {
    final cleanId = _cleanId(p.id);
    return {
      'id': cleanId,
      'name': _clip(p.name, 160, fallback: 'Menu Baru'),
      'desc': _clip(p.desc, 1000),
      'category': _clip(p.category, 80, fallback: 'utama'),
      'badge': _clip(p.badge, 80),
      'price': p.price.clamp(0, 1000000000),
      'originalPrice': p.originalPrice?.clamp(0, 1000000000),
      'image': _clip(p.image, 1000),
      'rating': p.rating.clamp(0.0, 5.0).toDouble(),
      'reviews': p.reviews < 0 ? 0 : p.reviews,
      'featureLabel': _clip(p.featureLabel, 120),
      'featureIconKey': _clip(iconToKey(p.featureIcon), 80),
      'emoji': _clip(p.emoji, 32, fallback: '🍽️'),
      'stock': p.stock.clamp(0, 999999),
      'soldToday': p.soldToday < 0 ? 0 : p.soldToday,
      'sortOrder': sortOrder.clamp(0, 999999),
      'variants': p.variants.take(20).map((vg) {
        return {
          'title': _clip(vg.title, 100),
          'required': vg.required,
          'multi': vg.multi,
          'options': vg.options.take(30).map((opt) {
            return {
              'label': _clip(opt.label, 100),
              'desc': opt.desc == null ? null : _clip(opt.desc!, 200),
              'price': opt.price.clamp(0, 1000000000),
            };
          }).toList(),
        };
      }).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static Product _productFromMap(String docId, Map<String, dynamic> d) {
    final rawVariants = d['variants'];
    final variants = <VariantGroup>[];
    if (rawVariants is List) {
      for (final item in rawVariants) {
        if (item is Map) {
          final rawOpts = item['options'];
          final opts = <VariantOption>[];
          if (rawOpts is List) {
            for (final o in rawOpts) {
              if (o is Map) {
                opts.add(
                  VariantOption(
                    label: (o['label'] as String?) ?? '',
                    desc: o['desc'] as String?,
                    price: (o['price'] as num?)?.toInt() ?? 0,
                  ),
                );
              }
            }
          }
          variants.add(
            VariantGroup(
              title: (item['title'] as String?) ?? 'Pilihan',
              required: (item['required'] as bool?) ?? false,
              multi: (item['multi'] as bool?) ?? false,
              options: opts,
            ),
          );
        }
      }
    }

    final rawOrig = d['originalPrice'];
    return Product(
      id: (d['id'] as String?) ?? docId,
      name: (d['name'] as String?) ?? 'Menu',
      desc: (d['desc'] as String?) ?? '',
      category: (d['category'] as String?) ?? 'all',
      badge: (d['badge'] as String?) ?? '',
      price: (d['price'] as num?)?.toInt() ?? 0,
      originalPrice: rawOrig is num ? rawOrig.toInt() : null,
      image: (d['image'] as String?) ?? '',
      rating: (d['rating'] as num?)?.toDouble() ?? 4.9,
      reviews: (d['reviews'] as num?)?.toInt() ?? 0,
      featureLabel: (d['featureLabel'] as String?) ?? 'Tersedia',
      featureIcon: keyToIcon(d['featureIconKey'] as String?),
      emoji: (d['emoji'] as String?) ?? '🍽️',
      stock: (d['stock'] as num?)?.toInt() ?? 0,
      soldToday: (d['soldToday'] as num?)?.toInt() ?? 0,
      variants: variants,
    );
  }
}

