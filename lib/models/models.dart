import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';

@freezed
abstract class StorePalette with _$StorePalette {
  const factory StorePalette({
    required Color primary,
    required Color primaryContainer,
    required Color onPrimaryMuted,
    required Color secondary,
    required Color secondaryDeep,
    required Color secondarySoft,
    required Color surface,
    required Color surfaceLow,
    required Color surfaceLowest,
    required Color surfaceContainer,
    required Color surfaceHigh,
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color outline,
    required Color outlineVariant,
    required Color darkCardTop,
    required Color darkCardBottom,
    required Color darkCardBorder,
    required Color darkCardText,
    required Color glow,
    required Color mapBase,
  }) = _StorePalette;
}

@freezed
abstract class VariantOption with _$VariantOption {
  const factory VariantOption({
    required String label,
    String? desc,
    @Default(0) int price,
  }) = _VariantOption;
}

@freezed
abstract class VariantGroup with _$VariantGroup {
  const factory VariantGroup({
    required String title,
    required List<VariantOption> options,
    @Default(false) bool required,
    @Default(false) bool multi,
  }) = _VariantGroup;
}

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String label,
    required IconData icon,
  }) = _Category;
}

@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    required String name,
    required String desc,
    required String category,
    required String badge,
    required int price,
    int? originalPrice,
    required String image,
    required double rating,
    required int reviews,
    required String featureLabel,
    required IconData featureIcon,
    required String emoji,
    @Default(20) int stock,
    @Default(0) int soldToday,
    @Default([]) List<VariantGroup> variants,
  }) = _Product;

  bool get soldOut => stock <= 0;
  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  int get discountPercent =>
      hasDiscount ? (((originalPrice! - price) / originalPrice!) * 100).round() : 0;
}

@freezed
abstract class OpenHour with _$OpenHour {
  const factory OpenHour({
    required String days,
    required String time,
    required String note,
    @Default(false) bool closed,
  }) = _OpenHour;
}

@freezed
abstract class DaySchedule with _$DaySchedule {
  const factory DaySchedule({
    required int openMinute,
    required int closeMinute,
  }) = _DaySchedule;
}

@freezed
abstract class Promo with _$Promo {
  const factory Promo({
    required String badge,
    required String eyebrow,
    required String title,
    required String desc,
    required String cta,
    required int percent,
    required int maxDiscount,
    required int endHour,
    required String code,
  }) = _Promo;
}

@freezed
abstract class StoreProfile with _$StoreProfile {
  const factory StoreProfile({
    required String id,
    required String emoji,
    required String themeLabel,
    required String shortThemeLabel,
    required String name,
    required String shortName,
    required String area,
    required String type,
    required String tagline,
    required String bio,
    required String established,
    required double rating,
    required String reviewsLabel,
    required String highlightBadge,
    required IconData highlightIcon,
    required String address,
    required String shortAddress,
    required String instagram,
    required String tiktok,
    required String whatsapp,
    required String banner,
    required IconData logoIcon,
    required Promo promo,
    required List<Category> categories,
    required List<Product> products,
    required List<OpenHour> hours,
    required Map<int, DaySchedule> schedule,
    required String searchHint,
    required String catalogEyebrow,
    required String catalogTitle,
    required String locationTitle,
    required String parkingLabel,
    required String qrTitle,
    required String qrDesc,
    required String qrUnitLabel,
    required String reserveLabel,
    required String footerDesc,
    required List<String> footerExplore,
    required List<String> footerTags,
    required StorePalette palette,
  }) = _StoreProfile;
}

@freezed
abstract class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({
    required Product product,
    @Default([]) List<String> options,
    required int unitPrice,
    @Default(1) int qty,
  }) = _CartItem;

  int get total => unitPrice * qty;
  String get key => '${product.id}|${options.join(',')}';
}

enum OrderStatus { baru, diproses, siap, selesai }

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
        OrderStatus.baru => 'Baru',
        OrderStatus.diproses => 'Diproses',
        OrderStatus.siap => 'Siap Diambil',
        OrderStatus.selesai => 'Selesai',
      };
  Color get color => switch (this) {
        OrderStatus.baru => const Color(0xFF2563EB),
        OrderStatus.diproses => const Color(0xFFD97706),
        OrderStatus.siap => const Color(0xFF7C3AED),
        OrderStatus.selesai => const Color(0xFF059669),
      };
}

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String customer,
    required List<String> items,
    required int total,
    required DateTime time,
    required String channel,
    @Default(OrderStatus.baru) OrderStatus status,
  }) = _Order;
}
