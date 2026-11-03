import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/models.dart';

part 'store_event.freezed.dart';

@freezed
abstract class StoreEvent with _$StoreEvent {
  const factory StoreEvent.switchTheme(String storeId) = _SwitchTheme;
  const factory StoreEvent.searchChanged(String query) = _SearchChanged;
  const factory StoreEvent.categoryChanged(String categoryId) = _CategoryChanged;
  const factory StoreEvent.filterAvailableOnlyToggled() = _FilterAvailableOnlyToggled;
  const factory StoreEvent.addToCart({
    required Product product,
    @Default([]) List<String> options,
    int? unitPrice,
    @Default(1) int qty,
  }) = _AddToCart;
  const factory StoreEvent.updateCartQty({
    required String cartKey,
    required int delta,
  }) = _UpdateCartQty;
  const factory StoreEvent.removeFromCart(String cartKey) = _RemoveFromCart;
  const factory StoreEvent.claimPromo() = _ClaimPromo;
  const factory StoreEvent.setTableNumber(String? tableNumber) = _SetTableNumber;
  const factory StoreEvent.setOrderType(String orderType) = _SetOrderType;
  const factory StoreEvent.placeOrder({
    required String customer,
    @Default('') String note,
    void Function(String waMessage)? onSuccess,
  }) = _PlaceOrder;
  const factory StoreEvent.adminUpdateStock({
    required String productId,
    required int stock,
  }) = _AdminUpdateStock;
  const factory StoreEvent.adminUpdateProduct({
    required String productId,
    String? name,
    String? desc,
    int? price,
    int? originalPrice,
    @Default(false) bool clearDiscount,
  }) = _AdminUpdateProduct;
  const factory StoreEvent.adminUpdateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) = _AdminUpdateOrderStatus;
  const factory StoreEvent.adminToggleOpen(bool? openOverride) = _AdminToggleOpen;
  const factory StoreEvent.adminTogglePromo(bool active) = _AdminTogglePromo;
  const factory StoreEvent.adminUpdateStoreInfo({
    String? name,
    String? tagline,
    String? address,
    String? whatsapp,
    String? instagram,
  }) = _AdminUpdateStoreInfo;
  const factory StoreEvent.adminAddProduct({
    required Product product,
  }) = _AdminAddProduct;
  const factory StoreEvent.adminSaveProduct({
    required Product product,
  }) = _AdminSaveProduct;
  const factory StoreEvent.adminDeleteProduct({
    required String productId,
  }) = _AdminDeleteProduct;
  const factory StoreEvent.adminUpdatePromoBanner({
    String? title,
    String? desc,
    String? bannerImage,
    String? badge,
  }) = _AdminUpdatePromoBanner;
}
