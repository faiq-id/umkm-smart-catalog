// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoreEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoreEvent()';
}


}

/// @nodoc
class $StoreEventCopyWith<$Res>  {
$StoreEventCopyWith(StoreEvent _, $Res Function(StoreEvent) __);
}


/// Adds pattern-matching-related methods to [StoreEvent].
extension StoreEventPatterns on StoreEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SwitchTheme value)?  switchTheme,TResult Function( _SearchChanged value)?  searchChanged,TResult Function( _CategoryChanged value)?  categoryChanged,TResult Function( _FilterAvailableOnlyToggled value)?  filterAvailableOnlyToggled,TResult Function( _AddToCart value)?  addToCart,TResult Function( _UpdateCartQty value)?  updateCartQty,TResult Function( _RemoveFromCart value)?  removeFromCart,TResult Function( _ClaimPromo value)?  claimPromo,TResult Function( _SetTableNumber value)?  setTableNumber,TResult Function( _SetOrderType value)?  setOrderType,TResult Function( _PlaceOrder value)?  placeOrder,TResult Function( _AdminUpdateStock value)?  adminUpdateStock,TResult Function( _AdminUpdateProduct value)?  adminUpdateProduct,TResult Function( _AdminUpdateOrderStatus value)?  adminUpdateOrderStatus,TResult Function( _AdminToggleOpen value)?  adminToggleOpen,TResult Function( _AdminTogglePromo value)?  adminTogglePromo,TResult Function( _AdminUpdateStoreInfo value)?  adminUpdateStoreInfo,TResult Function( _AdminAddProduct value)?  adminAddProduct,TResult Function( _AdminSaveProduct value)?  adminSaveProduct,TResult Function( _AdminDeleteProduct value)?  adminDeleteProduct,TResult Function( _AdminUpdatePromoBanner value)?  adminUpdatePromoBanner,TResult Function( _RemoteStoreSynced value)?  remoteStoreSynced,TResult Function( _RemoteProductsSynced value)?  remoteProductsSynced,TResult Function( _RemoteSyncFailed value)?  remoteSyncFailed,TResult Function( _AdminEnsureCloudSeeded value)?  adminEnsureCloudSeeded,TResult Function( _AdminResetToTemplate value)?  adminResetToTemplate,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwitchTheme() when switchTheme != null:
return switchTheme(_that);case _SearchChanged() when searchChanged != null:
return searchChanged(_that);case _CategoryChanged() when categoryChanged != null:
return categoryChanged(_that);case _FilterAvailableOnlyToggled() when filterAvailableOnlyToggled != null:
return filterAvailableOnlyToggled(_that);case _AddToCart() when addToCart != null:
return addToCart(_that);case _UpdateCartQty() when updateCartQty != null:
return updateCartQty(_that);case _RemoveFromCart() when removeFromCart != null:
return removeFromCart(_that);case _ClaimPromo() when claimPromo != null:
return claimPromo(_that);case _SetTableNumber() when setTableNumber != null:
return setTableNumber(_that);case _SetOrderType() when setOrderType != null:
return setOrderType(_that);case _PlaceOrder() when placeOrder != null:
return placeOrder(_that);case _AdminUpdateStock() when adminUpdateStock != null:
return adminUpdateStock(_that);case _AdminUpdateProduct() when adminUpdateProduct != null:
return adminUpdateProduct(_that);case _AdminUpdateOrderStatus() when adminUpdateOrderStatus != null:
return adminUpdateOrderStatus(_that);case _AdminToggleOpen() when adminToggleOpen != null:
return adminToggleOpen(_that);case _AdminTogglePromo() when adminTogglePromo != null:
return adminTogglePromo(_that);case _AdminUpdateStoreInfo() when adminUpdateStoreInfo != null:
return adminUpdateStoreInfo(_that);case _AdminAddProduct() when adminAddProduct != null:
return adminAddProduct(_that);case _AdminSaveProduct() when adminSaveProduct != null:
return adminSaveProduct(_that);case _AdminDeleteProduct() when adminDeleteProduct != null:
return adminDeleteProduct(_that);case _AdminUpdatePromoBanner() when adminUpdatePromoBanner != null:
return adminUpdatePromoBanner(_that);case _RemoteStoreSynced() when remoteStoreSynced != null:
return remoteStoreSynced(_that);case _RemoteProductsSynced() when remoteProductsSynced != null:
return remoteProductsSynced(_that);case _RemoteSyncFailed() when remoteSyncFailed != null:
return remoteSyncFailed(_that);case _AdminEnsureCloudSeeded() when adminEnsureCloudSeeded != null:
return adminEnsureCloudSeeded(_that);case _AdminResetToTemplate() when adminResetToTemplate != null:
return adminResetToTemplate(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SwitchTheme value)  switchTheme,required TResult Function( _SearchChanged value)  searchChanged,required TResult Function( _CategoryChanged value)  categoryChanged,required TResult Function( _FilterAvailableOnlyToggled value)  filterAvailableOnlyToggled,required TResult Function( _AddToCart value)  addToCart,required TResult Function( _UpdateCartQty value)  updateCartQty,required TResult Function( _RemoveFromCart value)  removeFromCart,required TResult Function( _ClaimPromo value)  claimPromo,required TResult Function( _SetTableNumber value)  setTableNumber,required TResult Function( _SetOrderType value)  setOrderType,required TResult Function( _PlaceOrder value)  placeOrder,required TResult Function( _AdminUpdateStock value)  adminUpdateStock,required TResult Function( _AdminUpdateProduct value)  adminUpdateProduct,required TResult Function( _AdminUpdateOrderStatus value)  adminUpdateOrderStatus,required TResult Function( _AdminToggleOpen value)  adminToggleOpen,required TResult Function( _AdminTogglePromo value)  adminTogglePromo,required TResult Function( _AdminUpdateStoreInfo value)  adminUpdateStoreInfo,required TResult Function( _AdminAddProduct value)  adminAddProduct,required TResult Function( _AdminSaveProduct value)  adminSaveProduct,required TResult Function( _AdminDeleteProduct value)  adminDeleteProduct,required TResult Function( _AdminUpdatePromoBanner value)  adminUpdatePromoBanner,required TResult Function( _RemoteStoreSynced value)  remoteStoreSynced,required TResult Function( _RemoteProductsSynced value)  remoteProductsSynced,required TResult Function( _RemoteSyncFailed value)  remoteSyncFailed,required TResult Function( _AdminEnsureCloudSeeded value)  adminEnsureCloudSeeded,required TResult Function( _AdminResetToTemplate value)  adminResetToTemplate,}){
final _that = this;
switch (_that) {
case _SwitchTheme():
return switchTheme(_that);case _SearchChanged():
return searchChanged(_that);case _CategoryChanged():
return categoryChanged(_that);case _FilterAvailableOnlyToggled():
return filterAvailableOnlyToggled(_that);case _AddToCart():
return addToCart(_that);case _UpdateCartQty():
return updateCartQty(_that);case _RemoveFromCart():
return removeFromCart(_that);case _ClaimPromo():
return claimPromo(_that);case _SetTableNumber():
return setTableNumber(_that);case _SetOrderType():
return setOrderType(_that);case _PlaceOrder():
return placeOrder(_that);case _AdminUpdateStock():
return adminUpdateStock(_that);case _AdminUpdateProduct():
return adminUpdateProduct(_that);case _AdminUpdateOrderStatus():
return adminUpdateOrderStatus(_that);case _AdminToggleOpen():
return adminToggleOpen(_that);case _AdminTogglePromo():
return adminTogglePromo(_that);case _AdminUpdateStoreInfo():
return adminUpdateStoreInfo(_that);case _AdminAddProduct():
return adminAddProduct(_that);case _AdminSaveProduct():
return adminSaveProduct(_that);case _AdminDeleteProduct():
return adminDeleteProduct(_that);case _AdminUpdatePromoBanner():
return adminUpdatePromoBanner(_that);case _RemoteStoreSynced():
return remoteStoreSynced(_that);case _RemoteProductsSynced():
return remoteProductsSynced(_that);case _RemoteSyncFailed():
return remoteSyncFailed(_that);case _AdminEnsureCloudSeeded():
return adminEnsureCloudSeeded(_that);case _AdminResetToTemplate():
return adminResetToTemplate(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SwitchTheme value)?  switchTheme,TResult? Function( _SearchChanged value)?  searchChanged,TResult? Function( _CategoryChanged value)?  categoryChanged,TResult? Function( _FilterAvailableOnlyToggled value)?  filterAvailableOnlyToggled,TResult? Function( _AddToCart value)?  addToCart,TResult? Function( _UpdateCartQty value)?  updateCartQty,TResult? Function( _RemoveFromCart value)?  removeFromCart,TResult? Function( _ClaimPromo value)?  claimPromo,TResult? Function( _SetTableNumber value)?  setTableNumber,TResult? Function( _SetOrderType value)?  setOrderType,TResult? Function( _PlaceOrder value)?  placeOrder,TResult? Function( _AdminUpdateStock value)?  adminUpdateStock,TResult? Function( _AdminUpdateProduct value)?  adminUpdateProduct,TResult? Function( _AdminUpdateOrderStatus value)?  adminUpdateOrderStatus,TResult? Function( _AdminToggleOpen value)?  adminToggleOpen,TResult? Function( _AdminTogglePromo value)?  adminTogglePromo,TResult? Function( _AdminUpdateStoreInfo value)?  adminUpdateStoreInfo,TResult? Function( _AdminAddProduct value)?  adminAddProduct,TResult? Function( _AdminSaveProduct value)?  adminSaveProduct,TResult? Function( _AdminDeleteProduct value)?  adminDeleteProduct,TResult? Function( _AdminUpdatePromoBanner value)?  adminUpdatePromoBanner,TResult? Function( _RemoteStoreSynced value)?  remoteStoreSynced,TResult? Function( _RemoteProductsSynced value)?  remoteProductsSynced,TResult? Function( _RemoteSyncFailed value)?  remoteSyncFailed,TResult? Function( _AdminEnsureCloudSeeded value)?  adminEnsureCloudSeeded,TResult? Function( _AdminResetToTemplate value)?  adminResetToTemplate,}){
final _that = this;
switch (_that) {
case _SwitchTheme() when switchTheme != null:
return switchTheme(_that);case _SearchChanged() when searchChanged != null:
return searchChanged(_that);case _CategoryChanged() when categoryChanged != null:
return categoryChanged(_that);case _FilterAvailableOnlyToggled() when filterAvailableOnlyToggled != null:
return filterAvailableOnlyToggled(_that);case _AddToCart() when addToCart != null:
return addToCart(_that);case _UpdateCartQty() when updateCartQty != null:
return updateCartQty(_that);case _RemoveFromCart() when removeFromCart != null:
return removeFromCart(_that);case _ClaimPromo() when claimPromo != null:
return claimPromo(_that);case _SetTableNumber() when setTableNumber != null:
return setTableNumber(_that);case _SetOrderType() when setOrderType != null:
return setOrderType(_that);case _PlaceOrder() when placeOrder != null:
return placeOrder(_that);case _AdminUpdateStock() when adminUpdateStock != null:
return adminUpdateStock(_that);case _AdminUpdateProduct() when adminUpdateProduct != null:
return adminUpdateProduct(_that);case _AdminUpdateOrderStatus() when adminUpdateOrderStatus != null:
return adminUpdateOrderStatus(_that);case _AdminToggleOpen() when adminToggleOpen != null:
return adminToggleOpen(_that);case _AdminTogglePromo() when adminTogglePromo != null:
return adminTogglePromo(_that);case _AdminUpdateStoreInfo() when adminUpdateStoreInfo != null:
return adminUpdateStoreInfo(_that);case _AdminAddProduct() when adminAddProduct != null:
return adminAddProduct(_that);case _AdminSaveProduct() when adminSaveProduct != null:
return adminSaveProduct(_that);case _AdminDeleteProduct() when adminDeleteProduct != null:
return adminDeleteProduct(_that);case _AdminUpdatePromoBanner() when adminUpdatePromoBanner != null:
return adminUpdatePromoBanner(_that);case _RemoteStoreSynced() when remoteStoreSynced != null:
return remoteStoreSynced(_that);case _RemoteProductsSynced() when remoteProductsSynced != null:
return remoteProductsSynced(_that);case _RemoteSyncFailed() when remoteSyncFailed != null:
return remoteSyncFailed(_that);case _AdminEnsureCloudSeeded() when adminEnsureCloudSeeded != null:
return adminEnsureCloudSeeded(_that);case _AdminResetToTemplate() when adminResetToTemplate != null:
return adminResetToTemplate(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String storeId)?  switchTheme,TResult Function( String query)?  searchChanged,TResult Function( String categoryId)?  categoryChanged,TResult Function()?  filterAvailableOnlyToggled,TResult Function( Product product,  List<String> options,  int? unitPrice,  int qty)?  addToCart,TResult Function( String cartKey,  int delta)?  updateCartQty,TResult Function( String cartKey)?  removeFromCart,TResult Function()?  claimPromo,TResult Function( String? tableNumber)?  setTableNumber,TResult Function( String orderType)?  setOrderType,TResult Function( String customer,  String note,  void Function(String waMessage)? onSuccess)?  placeOrder,TResult Function( String productId,  int stock)?  adminUpdateStock,TResult Function( String productId,  String? name,  String? desc,  int? price,  int? originalPrice,  bool clearDiscount)?  adminUpdateProduct,TResult Function( String orderId,  OrderStatus status)?  adminUpdateOrderStatus,TResult Function( bool? openOverride)?  adminToggleOpen,TResult Function( bool active)?  adminTogglePromo,TResult Function( String? name,  String? tagline,  String? address,  String? whatsapp,  String? instagram)?  adminUpdateStoreInfo,TResult Function( Product product)?  adminAddProduct,TResult Function( Product product)?  adminSaveProduct,TResult Function( String productId)?  adminDeleteProduct,TResult Function( String? title,  String? desc,  String? bannerImage,  String? badge)?  adminUpdatePromoBanner,TResult Function( String storeId,  RemoteStoreDoc doc)?  remoteStoreSynced,TResult Function( String storeId,  List<Product>? products)?  remoteProductsSynced,TResult Function( String message)?  remoteSyncFailed,TResult Function()?  adminEnsureCloudSeeded,TResult Function()?  adminResetToTemplate,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwitchTheme() when switchTheme != null:
return switchTheme(_that.storeId);case _SearchChanged() when searchChanged != null:
return searchChanged(_that.query);case _CategoryChanged() when categoryChanged != null:
return categoryChanged(_that.categoryId);case _FilterAvailableOnlyToggled() when filterAvailableOnlyToggled != null:
return filterAvailableOnlyToggled();case _AddToCart() when addToCart != null:
return addToCart(_that.product,_that.options,_that.unitPrice,_that.qty);case _UpdateCartQty() when updateCartQty != null:
return updateCartQty(_that.cartKey,_that.delta);case _RemoveFromCart() when removeFromCart != null:
return removeFromCart(_that.cartKey);case _ClaimPromo() when claimPromo != null:
return claimPromo();case _SetTableNumber() when setTableNumber != null:
return setTableNumber(_that.tableNumber);case _SetOrderType() when setOrderType != null:
return setOrderType(_that.orderType);case _PlaceOrder() when placeOrder != null:
return placeOrder(_that.customer,_that.note,_that.onSuccess);case _AdminUpdateStock() when adminUpdateStock != null:
return adminUpdateStock(_that.productId,_that.stock);case _AdminUpdateProduct() when adminUpdateProduct != null:
return adminUpdateProduct(_that.productId,_that.name,_that.desc,_that.price,_that.originalPrice,_that.clearDiscount);case _AdminUpdateOrderStatus() when adminUpdateOrderStatus != null:
return adminUpdateOrderStatus(_that.orderId,_that.status);case _AdminToggleOpen() when adminToggleOpen != null:
return adminToggleOpen(_that.openOverride);case _AdminTogglePromo() when adminTogglePromo != null:
return adminTogglePromo(_that.active);case _AdminUpdateStoreInfo() when adminUpdateStoreInfo != null:
return adminUpdateStoreInfo(_that.name,_that.tagline,_that.address,_that.whatsapp,_that.instagram);case _AdminAddProduct() when adminAddProduct != null:
return adminAddProduct(_that.product);case _AdminSaveProduct() when adminSaveProduct != null:
return adminSaveProduct(_that.product);case _AdminDeleteProduct() when adminDeleteProduct != null:
return adminDeleteProduct(_that.productId);case _AdminUpdatePromoBanner() when adminUpdatePromoBanner != null:
return adminUpdatePromoBanner(_that.title,_that.desc,_that.bannerImage,_that.badge);case _RemoteStoreSynced() when remoteStoreSynced != null:
return remoteStoreSynced(_that.storeId,_that.doc);case _RemoteProductsSynced() when remoteProductsSynced != null:
return remoteProductsSynced(_that.storeId,_that.products);case _RemoteSyncFailed() when remoteSyncFailed != null:
return remoteSyncFailed(_that.message);case _AdminEnsureCloudSeeded() when adminEnsureCloudSeeded != null:
return adminEnsureCloudSeeded();case _AdminResetToTemplate() when adminResetToTemplate != null:
return adminResetToTemplate();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String storeId)  switchTheme,required TResult Function( String query)  searchChanged,required TResult Function( String categoryId)  categoryChanged,required TResult Function()  filterAvailableOnlyToggled,required TResult Function( Product product,  List<String> options,  int? unitPrice,  int qty)  addToCart,required TResult Function( String cartKey,  int delta)  updateCartQty,required TResult Function( String cartKey)  removeFromCart,required TResult Function()  claimPromo,required TResult Function( String? tableNumber)  setTableNumber,required TResult Function( String orderType)  setOrderType,required TResult Function( String customer,  String note,  void Function(String waMessage)? onSuccess)  placeOrder,required TResult Function( String productId,  int stock)  adminUpdateStock,required TResult Function( String productId,  String? name,  String? desc,  int? price,  int? originalPrice,  bool clearDiscount)  adminUpdateProduct,required TResult Function( String orderId,  OrderStatus status)  adminUpdateOrderStatus,required TResult Function( bool? openOverride)  adminToggleOpen,required TResult Function( bool active)  adminTogglePromo,required TResult Function( String? name,  String? tagline,  String? address,  String? whatsapp,  String? instagram)  adminUpdateStoreInfo,required TResult Function( Product product)  adminAddProduct,required TResult Function( Product product)  adminSaveProduct,required TResult Function( String productId)  adminDeleteProduct,required TResult Function( String? title,  String? desc,  String? bannerImage,  String? badge)  adminUpdatePromoBanner,required TResult Function( String storeId,  RemoteStoreDoc doc)  remoteStoreSynced,required TResult Function( String storeId,  List<Product>? products)  remoteProductsSynced,required TResult Function( String message)  remoteSyncFailed,required TResult Function()  adminEnsureCloudSeeded,required TResult Function()  adminResetToTemplate,}) {final _that = this;
switch (_that) {
case _SwitchTheme():
return switchTheme(_that.storeId);case _SearchChanged():
return searchChanged(_that.query);case _CategoryChanged():
return categoryChanged(_that.categoryId);case _FilterAvailableOnlyToggled():
return filterAvailableOnlyToggled();case _AddToCart():
return addToCart(_that.product,_that.options,_that.unitPrice,_that.qty);case _UpdateCartQty():
return updateCartQty(_that.cartKey,_that.delta);case _RemoveFromCart():
return removeFromCart(_that.cartKey);case _ClaimPromo():
return claimPromo();case _SetTableNumber():
return setTableNumber(_that.tableNumber);case _SetOrderType():
return setOrderType(_that.orderType);case _PlaceOrder():
return placeOrder(_that.customer,_that.note,_that.onSuccess);case _AdminUpdateStock():
return adminUpdateStock(_that.productId,_that.stock);case _AdminUpdateProduct():
return adminUpdateProduct(_that.productId,_that.name,_that.desc,_that.price,_that.originalPrice,_that.clearDiscount);case _AdminUpdateOrderStatus():
return adminUpdateOrderStatus(_that.orderId,_that.status);case _AdminToggleOpen():
return adminToggleOpen(_that.openOverride);case _AdminTogglePromo():
return adminTogglePromo(_that.active);case _AdminUpdateStoreInfo():
return adminUpdateStoreInfo(_that.name,_that.tagline,_that.address,_that.whatsapp,_that.instagram);case _AdminAddProduct():
return adminAddProduct(_that.product);case _AdminSaveProduct():
return adminSaveProduct(_that.product);case _AdminDeleteProduct():
return adminDeleteProduct(_that.productId);case _AdminUpdatePromoBanner():
return adminUpdatePromoBanner(_that.title,_that.desc,_that.bannerImage,_that.badge);case _RemoteStoreSynced():
return remoteStoreSynced(_that.storeId,_that.doc);case _RemoteProductsSynced():
return remoteProductsSynced(_that.storeId,_that.products);case _RemoteSyncFailed():
return remoteSyncFailed(_that.message);case _AdminEnsureCloudSeeded():
return adminEnsureCloudSeeded();case _AdminResetToTemplate():
return adminResetToTemplate();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String storeId)?  switchTheme,TResult? Function( String query)?  searchChanged,TResult? Function( String categoryId)?  categoryChanged,TResult? Function()?  filterAvailableOnlyToggled,TResult? Function( Product product,  List<String> options,  int? unitPrice,  int qty)?  addToCart,TResult? Function( String cartKey,  int delta)?  updateCartQty,TResult? Function( String cartKey)?  removeFromCart,TResult? Function()?  claimPromo,TResult? Function( String? tableNumber)?  setTableNumber,TResult? Function( String orderType)?  setOrderType,TResult? Function( String customer,  String note,  void Function(String waMessage)? onSuccess)?  placeOrder,TResult? Function( String productId,  int stock)?  adminUpdateStock,TResult? Function( String productId,  String? name,  String? desc,  int? price,  int? originalPrice,  bool clearDiscount)?  adminUpdateProduct,TResult? Function( String orderId,  OrderStatus status)?  adminUpdateOrderStatus,TResult? Function( bool? openOverride)?  adminToggleOpen,TResult? Function( bool active)?  adminTogglePromo,TResult? Function( String? name,  String? tagline,  String? address,  String? whatsapp,  String? instagram)?  adminUpdateStoreInfo,TResult? Function( Product product)?  adminAddProduct,TResult? Function( Product product)?  adminSaveProduct,TResult? Function( String productId)?  adminDeleteProduct,TResult? Function( String? title,  String? desc,  String? bannerImage,  String? badge)?  adminUpdatePromoBanner,TResult? Function( String storeId,  RemoteStoreDoc doc)?  remoteStoreSynced,TResult? Function( String storeId,  List<Product>? products)?  remoteProductsSynced,TResult? Function( String message)?  remoteSyncFailed,TResult? Function()?  adminEnsureCloudSeeded,TResult? Function()?  adminResetToTemplate,}) {final _that = this;
switch (_that) {
case _SwitchTheme() when switchTheme != null:
return switchTheme(_that.storeId);case _SearchChanged() when searchChanged != null:
return searchChanged(_that.query);case _CategoryChanged() when categoryChanged != null:
return categoryChanged(_that.categoryId);case _FilterAvailableOnlyToggled() when filterAvailableOnlyToggled != null:
return filterAvailableOnlyToggled();case _AddToCart() when addToCart != null:
return addToCart(_that.product,_that.options,_that.unitPrice,_that.qty);case _UpdateCartQty() when updateCartQty != null:
return updateCartQty(_that.cartKey,_that.delta);case _RemoveFromCart() when removeFromCart != null:
return removeFromCart(_that.cartKey);case _ClaimPromo() when claimPromo != null:
return claimPromo();case _SetTableNumber() when setTableNumber != null:
return setTableNumber(_that.tableNumber);case _SetOrderType() when setOrderType != null:
return setOrderType(_that.orderType);case _PlaceOrder() when placeOrder != null:
return placeOrder(_that.customer,_that.note,_that.onSuccess);case _AdminUpdateStock() when adminUpdateStock != null:
return adminUpdateStock(_that.productId,_that.stock);case _AdminUpdateProduct() when adminUpdateProduct != null:
return adminUpdateProduct(_that.productId,_that.name,_that.desc,_that.price,_that.originalPrice,_that.clearDiscount);case _AdminUpdateOrderStatus() when adminUpdateOrderStatus != null:
return adminUpdateOrderStatus(_that.orderId,_that.status);case _AdminToggleOpen() when adminToggleOpen != null:
return adminToggleOpen(_that.openOverride);case _AdminTogglePromo() when adminTogglePromo != null:
return adminTogglePromo(_that.active);case _AdminUpdateStoreInfo() when adminUpdateStoreInfo != null:
return adminUpdateStoreInfo(_that.name,_that.tagline,_that.address,_that.whatsapp,_that.instagram);case _AdminAddProduct() when adminAddProduct != null:
return adminAddProduct(_that.product);case _AdminSaveProduct() when adminSaveProduct != null:
return adminSaveProduct(_that.product);case _AdminDeleteProduct() when adminDeleteProduct != null:
return adminDeleteProduct(_that.productId);case _AdminUpdatePromoBanner() when adminUpdatePromoBanner != null:
return adminUpdatePromoBanner(_that.title,_that.desc,_that.bannerImage,_that.badge);case _RemoteStoreSynced() when remoteStoreSynced != null:
return remoteStoreSynced(_that.storeId,_that.doc);case _RemoteProductsSynced() when remoteProductsSynced != null:
return remoteProductsSynced(_that.storeId,_that.products);case _RemoteSyncFailed() when remoteSyncFailed != null:
return remoteSyncFailed(_that.message);case _AdminEnsureCloudSeeded() when adminEnsureCloudSeeded != null:
return adminEnsureCloudSeeded();case _AdminResetToTemplate() when adminResetToTemplate != null:
return adminResetToTemplate();case _:
  return null;

}
}

}

/// @nodoc


class _SwitchTheme implements StoreEvent {
  const _SwitchTheme(this.storeId);
  

 final  String storeId;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwitchThemeCopyWith<_SwitchTheme> get copyWith => __$SwitchThemeCopyWithImpl<_SwitchTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwitchTheme&&(identical(other.storeId, storeId) || other.storeId == storeId));
}


@override
int get hashCode => Object.hash(runtimeType,storeId);

@override
String toString() {
  return 'StoreEvent.switchTheme(storeId: $storeId)';
}


}

/// @nodoc
abstract mixin class _$SwitchThemeCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$SwitchThemeCopyWith(_SwitchTheme value, $Res Function(_SwitchTheme) _then) = __$SwitchThemeCopyWithImpl;
@useResult
$Res call({
 String storeId
});




}
/// @nodoc
class __$SwitchThemeCopyWithImpl<$Res>
    implements _$SwitchThemeCopyWith<$Res> {
  __$SwitchThemeCopyWithImpl(this._self, this._then);

  final _SwitchTheme _self;
  final $Res Function(_SwitchTheme) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeId = null,}) {
  return _then(_SwitchTheme(
null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SearchChanged implements StoreEvent {
  const _SearchChanged(this.query);
  

 final  String query;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchChangedCopyWith<_SearchChanged> get copyWith => __$SearchChangedCopyWithImpl<_SearchChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'StoreEvent.searchChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class _$SearchChangedCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$SearchChangedCopyWith(_SearchChanged value, $Res Function(_SearchChanged) _then) = __$SearchChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class __$SearchChangedCopyWithImpl<$Res>
    implements _$SearchChangedCopyWith<$Res> {
  __$SearchChangedCopyWithImpl(this._self, this._then);

  final _SearchChanged _self;
  final $Res Function(_SearchChanged) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(_SearchChanged(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _CategoryChanged implements StoreEvent {
  const _CategoryChanged(this.categoryId);
  

 final  String categoryId;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryChangedCopyWith<_CategoryChanged> get copyWith => __$CategoryChangedCopyWithImpl<_CategoryChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryChanged&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId);

@override
String toString() {
  return 'StoreEvent.categoryChanged(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$CategoryChangedCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$CategoryChangedCopyWith(_CategoryChanged value, $Res Function(_CategoryChanged) _then) = __$CategoryChangedCopyWithImpl;
@useResult
$Res call({
 String categoryId
});




}
/// @nodoc
class __$CategoryChangedCopyWithImpl<$Res>
    implements _$CategoryChangedCopyWith<$Res> {
  __$CategoryChangedCopyWithImpl(this._self, this._then);

  final _CategoryChanged _self;
  final $Res Function(_CategoryChanged) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = null,}) {
  return _then(_CategoryChanged(
null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _FilterAvailableOnlyToggled implements StoreEvent {
  const _FilterAvailableOnlyToggled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterAvailableOnlyToggled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoreEvent.filterAvailableOnlyToggled()';
}


}




/// @nodoc


class _AddToCart implements StoreEvent {
  const _AddToCart({required this.product, final  List<String> options = const [], this.unitPrice, this.qty = 1}): _options = options;
  

 final  Product product;
 final  List<String> _options;
@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  int? unitPrice;
@JsonKey() final  int qty;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddToCartCopyWith<_AddToCart> get copyWith => __$AddToCartCopyWithImpl<_AddToCart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddToCart&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.qty, qty) || other.qty == qty));
}


@override
int get hashCode => Object.hash(runtimeType,product,const DeepCollectionEquality().hash(_options),unitPrice,qty);

@override
String toString() {
  return 'StoreEvent.addToCart(product: $product, options: $options, unitPrice: $unitPrice, qty: $qty)';
}


}

/// @nodoc
abstract mixin class _$AddToCartCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$AddToCartCopyWith(_AddToCart value, $Res Function(_AddToCart) _then) = __$AddToCartCopyWithImpl;
@useResult
$Res call({
 Product product, List<String> options, int? unitPrice, int qty
});


$ProductCopyWith<$Res> get product;

}
/// @nodoc
class __$AddToCartCopyWithImpl<$Res>
    implements _$AddToCartCopyWith<$Res> {
  __$AddToCartCopyWithImpl(this._self, this._then);

  final _AddToCart _self;
  final $Res Function(_AddToCart) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,Object? options = null,Object? unitPrice = freezed,Object? qty = null,}) {
  return _then(_AddToCart(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

/// @nodoc


class _UpdateCartQty implements StoreEvent {
  const _UpdateCartQty({required this.cartKey, required this.delta});
  

 final  String cartKey;
 final  int delta;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateCartQtyCopyWith<_UpdateCartQty> get copyWith => __$UpdateCartQtyCopyWithImpl<_UpdateCartQty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateCartQty&&(identical(other.cartKey, cartKey) || other.cartKey == cartKey)&&(identical(other.delta, delta) || other.delta == delta));
}


@override
int get hashCode => Object.hash(runtimeType,cartKey,delta);

@override
String toString() {
  return 'StoreEvent.updateCartQty(cartKey: $cartKey, delta: $delta)';
}


}

/// @nodoc
abstract mixin class _$UpdateCartQtyCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$UpdateCartQtyCopyWith(_UpdateCartQty value, $Res Function(_UpdateCartQty) _then) = __$UpdateCartQtyCopyWithImpl;
@useResult
$Res call({
 String cartKey, int delta
});




}
/// @nodoc
class __$UpdateCartQtyCopyWithImpl<$Res>
    implements _$UpdateCartQtyCopyWith<$Res> {
  __$UpdateCartQtyCopyWithImpl(this._self, this._then);

  final _UpdateCartQty _self;
  final $Res Function(_UpdateCartQty) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cartKey = null,Object? delta = null,}) {
  return _then(_UpdateCartQty(
cartKey: null == cartKey ? _self.cartKey : cartKey // ignore: cast_nullable_to_non_nullable
as String,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _RemoveFromCart implements StoreEvent {
  const _RemoveFromCart(this.cartKey);
  

 final  String cartKey;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveFromCartCopyWith<_RemoveFromCart> get copyWith => __$RemoveFromCartCopyWithImpl<_RemoveFromCart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveFromCart&&(identical(other.cartKey, cartKey) || other.cartKey == cartKey));
}


@override
int get hashCode => Object.hash(runtimeType,cartKey);

@override
String toString() {
  return 'StoreEvent.removeFromCart(cartKey: $cartKey)';
}


}

/// @nodoc
abstract mixin class _$RemoveFromCartCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$RemoveFromCartCopyWith(_RemoveFromCart value, $Res Function(_RemoveFromCart) _then) = __$RemoveFromCartCopyWithImpl;
@useResult
$Res call({
 String cartKey
});




}
/// @nodoc
class __$RemoveFromCartCopyWithImpl<$Res>
    implements _$RemoveFromCartCopyWith<$Res> {
  __$RemoveFromCartCopyWithImpl(this._self, this._then);

  final _RemoveFromCart _self;
  final $Res Function(_RemoveFromCart) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cartKey = null,}) {
  return _then(_RemoveFromCart(
null == cartKey ? _self.cartKey : cartKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ClaimPromo implements StoreEvent {
  const _ClaimPromo();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClaimPromo);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoreEvent.claimPromo()';
}


}




/// @nodoc


class _SetTableNumber implements StoreEvent {
  const _SetTableNumber(this.tableNumber);
  

 final  String? tableNumber;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetTableNumberCopyWith<_SetTableNumber> get copyWith => __$SetTableNumberCopyWithImpl<_SetTableNumber>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetTableNumber&&(identical(other.tableNumber, tableNumber) || other.tableNumber == tableNumber));
}


@override
int get hashCode => Object.hash(runtimeType,tableNumber);

@override
String toString() {
  return 'StoreEvent.setTableNumber(tableNumber: $tableNumber)';
}


}

/// @nodoc
abstract mixin class _$SetTableNumberCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$SetTableNumberCopyWith(_SetTableNumber value, $Res Function(_SetTableNumber) _then) = __$SetTableNumberCopyWithImpl;
@useResult
$Res call({
 String? tableNumber
});




}
/// @nodoc
class __$SetTableNumberCopyWithImpl<$Res>
    implements _$SetTableNumberCopyWith<$Res> {
  __$SetTableNumberCopyWithImpl(this._self, this._then);

  final _SetTableNumber _self;
  final $Res Function(_SetTableNumber) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tableNumber = freezed,}) {
  return _then(_SetTableNumber(
freezed == tableNumber ? _self.tableNumber : tableNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _SetOrderType implements StoreEvent {
  const _SetOrderType(this.orderType);
  

 final  String orderType;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetOrderTypeCopyWith<_SetOrderType> get copyWith => __$SetOrderTypeCopyWithImpl<_SetOrderType>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetOrderType&&(identical(other.orderType, orderType) || other.orderType == orderType));
}


@override
int get hashCode => Object.hash(runtimeType,orderType);

@override
String toString() {
  return 'StoreEvent.setOrderType(orderType: $orderType)';
}


}

/// @nodoc
abstract mixin class _$SetOrderTypeCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$SetOrderTypeCopyWith(_SetOrderType value, $Res Function(_SetOrderType) _then) = __$SetOrderTypeCopyWithImpl;
@useResult
$Res call({
 String orderType
});




}
/// @nodoc
class __$SetOrderTypeCopyWithImpl<$Res>
    implements _$SetOrderTypeCopyWith<$Res> {
  __$SetOrderTypeCopyWithImpl(this._self, this._then);

  final _SetOrderType _self;
  final $Res Function(_SetOrderType) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orderType = null,}) {
  return _then(_SetOrderType(
null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PlaceOrder implements StoreEvent {
  const _PlaceOrder({required this.customer, this.note = '', this.onSuccess});
  

 final  String customer;
@JsonKey() final  String note;
 final  void Function(String waMessage)? onSuccess;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceOrderCopyWith<_PlaceOrder> get copyWith => __$PlaceOrderCopyWithImpl<_PlaceOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaceOrder&&(identical(other.customer, customer) || other.customer == customer)&&(identical(other.note, note) || other.note == note)&&(identical(other.onSuccess, onSuccess) || other.onSuccess == onSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,customer,note,onSuccess);

@override
String toString() {
  return 'StoreEvent.placeOrder(customer: $customer, note: $note, onSuccess: $onSuccess)';
}


}

/// @nodoc
abstract mixin class _$PlaceOrderCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$PlaceOrderCopyWith(_PlaceOrder value, $Res Function(_PlaceOrder) _then) = __$PlaceOrderCopyWithImpl;
@useResult
$Res call({
 String customer, String note, void Function(String waMessage)? onSuccess
});




}
/// @nodoc
class __$PlaceOrderCopyWithImpl<$Res>
    implements _$PlaceOrderCopyWith<$Res> {
  __$PlaceOrderCopyWithImpl(this._self, this._then);

  final _PlaceOrder _self;
  final $Res Function(_PlaceOrder) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? customer = null,Object? note = null,Object? onSuccess = freezed,}) {
  return _then(_PlaceOrder(
customer: null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,onSuccess: freezed == onSuccess ? _self.onSuccess : onSuccess // ignore: cast_nullable_to_non_nullable
as void Function(String waMessage)?,
  ));
}


}

/// @nodoc


class _AdminUpdateStock implements StoreEvent {
  const _AdminUpdateStock({required this.productId, required this.stock});
  

 final  String productId;
 final  int stock;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUpdateStockCopyWith<_AdminUpdateStock> get copyWith => __$AdminUpdateStockCopyWithImpl<_AdminUpdateStock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUpdateStock&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.stock, stock) || other.stock == stock));
}


@override
int get hashCode => Object.hash(runtimeType,productId,stock);

@override
String toString() {
  return 'StoreEvent.adminUpdateStock(productId: $productId, stock: $stock)';
}


}

/// @nodoc
abstract mixin class _$AdminUpdateStockCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$AdminUpdateStockCopyWith(_AdminUpdateStock value, $Res Function(_AdminUpdateStock) _then) = __$AdminUpdateStockCopyWithImpl;
@useResult
$Res call({
 String productId, int stock
});




}
/// @nodoc
class __$AdminUpdateStockCopyWithImpl<$Res>
    implements _$AdminUpdateStockCopyWith<$Res> {
  __$AdminUpdateStockCopyWithImpl(this._self, this._then);

  final _AdminUpdateStock _self;
  final $Res Function(_AdminUpdateStock) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? stock = null,}) {
  return _then(_AdminUpdateStock(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _AdminUpdateProduct implements StoreEvent {
  const _AdminUpdateProduct({required this.productId, this.name, this.desc, this.price, this.originalPrice, this.clearDiscount = false});
  

 final  String productId;
 final  String? name;
 final  String? desc;
 final  int? price;
 final  int? originalPrice;
@JsonKey() final  bool clearDiscount;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUpdateProductCopyWith<_AdminUpdateProduct> get copyWith => __$AdminUpdateProductCopyWithImpl<_AdminUpdateProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUpdateProduct&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.clearDiscount, clearDiscount) || other.clearDiscount == clearDiscount));
}


@override
int get hashCode => Object.hash(runtimeType,productId,name,desc,price,originalPrice,clearDiscount);

@override
String toString() {
  return 'StoreEvent.adminUpdateProduct(productId: $productId, name: $name, desc: $desc, price: $price, originalPrice: $originalPrice, clearDiscount: $clearDiscount)';
}


}

/// @nodoc
abstract mixin class _$AdminUpdateProductCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$AdminUpdateProductCopyWith(_AdminUpdateProduct value, $Res Function(_AdminUpdateProduct) _then) = __$AdminUpdateProductCopyWithImpl;
@useResult
$Res call({
 String productId, String? name, String? desc, int? price, int? originalPrice, bool clearDiscount
});




}
/// @nodoc
class __$AdminUpdateProductCopyWithImpl<$Res>
    implements _$AdminUpdateProductCopyWith<$Res> {
  __$AdminUpdateProductCopyWithImpl(this._self, this._then);

  final _AdminUpdateProduct _self;
  final $Res Function(_AdminUpdateProduct) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = freezed,Object? desc = freezed,Object? price = freezed,Object? originalPrice = freezed,Object? clearDiscount = null,}) {
  return _then(_AdminUpdateProduct(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as int?,clearDiscount: null == clearDiscount ? _self.clearDiscount : clearDiscount // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _AdminUpdateOrderStatus implements StoreEvent {
  const _AdminUpdateOrderStatus({required this.orderId, required this.status});
  

 final  String orderId;
 final  OrderStatus status;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUpdateOrderStatusCopyWith<_AdminUpdateOrderStatus> get copyWith => __$AdminUpdateOrderStatusCopyWithImpl<_AdminUpdateOrderStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUpdateOrderStatus&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,status);

@override
String toString() {
  return 'StoreEvent.adminUpdateOrderStatus(orderId: $orderId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AdminUpdateOrderStatusCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$AdminUpdateOrderStatusCopyWith(_AdminUpdateOrderStatus value, $Res Function(_AdminUpdateOrderStatus) _then) = __$AdminUpdateOrderStatusCopyWithImpl;
@useResult
$Res call({
 String orderId, OrderStatus status
});




}
/// @nodoc
class __$AdminUpdateOrderStatusCopyWithImpl<$Res>
    implements _$AdminUpdateOrderStatusCopyWith<$Res> {
  __$AdminUpdateOrderStatusCopyWithImpl(this._self, this._then);

  final _AdminUpdateOrderStatus _self;
  final $Res Function(_AdminUpdateOrderStatus) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? status = null,}) {
  return _then(_AdminUpdateOrderStatus(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,
  ));
}


}

/// @nodoc


class _AdminToggleOpen implements StoreEvent {
  const _AdminToggleOpen(this.openOverride);
  

 final  bool? openOverride;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminToggleOpenCopyWith<_AdminToggleOpen> get copyWith => __$AdminToggleOpenCopyWithImpl<_AdminToggleOpen>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminToggleOpen&&(identical(other.openOverride, openOverride) || other.openOverride == openOverride));
}


@override
int get hashCode => Object.hash(runtimeType,openOverride);

@override
String toString() {
  return 'StoreEvent.adminToggleOpen(openOverride: $openOverride)';
}


}

/// @nodoc
abstract mixin class _$AdminToggleOpenCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$AdminToggleOpenCopyWith(_AdminToggleOpen value, $Res Function(_AdminToggleOpen) _then) = __$AdminToggleOpenCopyWithImpl;
@useResult
$Res call({
 bool? openOverride
});




}
/// @nodoc
class __$AdminToggleOpenCopyWithImpl<$Res>
    implements _$AdminToggleOpenCopyWith<$Res> {
  __$AdminToggleOpenCopyWithImpl(this._self, this._then);

  final _AdminToggleOpen _self;
  final $Res Function(_AdminToggleOpen) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? openOverride = freezed,}) {
  return _then(_AdminToggleOpen(
freezed == openOverride ? _self.openOverride : openOverride // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

/// @nodoc


class _AdminTogglePromo implements StoreEvent {
  const _AdminTogglePromo(this.active);
  

 final  bool active;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminTogglePromoCopyWith<_AdminTogglePromo> get copyWith => __$AdminTogglePromoCopyWithImpl<_AdminTogglePromo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminTogglePromo&&(identical(other.active, active) || other.active == active));
}


@override
int get hashCode => Object.hash(runtimeType,active);

@override
String toString() {
  return 'StoreEvent.adminTogglePromo(active: $active)';
}


}

/// @nodoc
abstract mixin class _$AdminTogglePromoCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$AdminTogglePromoCopyWith(_AdminTogglePromo value, $Res Function(_AdminTogglePromo) _then) = __$AdminTogglePromoCopyWithImpl;
@useResult
$Res call({
 bool active
});




}
/// @nodoc
class __$AdminTogglePromoCopyWithImpl<$Res>
    implements _$AdminTogglePromoCopyWith<$Res> {
  __$AdminTogglePromoCopyWithImpl(this._self, this._then);

  final _AdminTogglePromo _self;
  final $Res Function(_AdminTogglePromo) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? active = null,}) {
  return _then(_AdminTogglePromo(
null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _AdminUpdateStoreInfo implements StoreEvent {
  const _AdminUpdateStoreInfo({this.name, this.tagline, this.address, this.whatsapp, this.instagram});
  

 final  String? name;
 final  String? tagline;
 final  String? address;
 final  String? whatsapp;
 final  String? instagram;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUpdateStoreInfoCopyWith<_AdminUpdateStoreInfo> get copyWith => __$AdminUpdateStoreInfoCopyWithImpl<_AdminUpdateStoreInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUpdateStoreInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.address, address) || other.address == address)&&(identical(other.whatsapp, whatsapp) || other.whatsapp == whatsapp)&&(identical(other.instagram, instagram) || other.instagram == instagram));
}


@override
int get hashCode => Object.hash(runtimeType,name,tagline,address,whatsapp,instagram);

@override
String toString() {
  return 'StoreEvent.adminUpdateStoreInfo(name: $name, tagline: $tagline, address: $address, whatsapp: $whatsapp, instagram: $instagram)';
}


}

/// @nodoc
abstract mixin class _$AdminUpdateStoreInfoCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$AdminUpdateStoreInfoCopyWith(_AdminUpdateStoreInfo value, $Res Function(_AdminUpdateStoreInfo) _then) = __$AdminUpdateStoreInfoCopyWithImpl;
@useResult
$Res call({
 String? name, String? tagline, String? address, String? whatsapp, String? instagram
});




}
/// @nodoc
class __$AdminUpdateStoreInfoCopyWithImpl<$Res>
    implements _$AdminUpdateStoreInfoCopyWith<$Res> {
  __$AdminUpdateStoreInfoCopyWithImpl(this._self, this._then);

  final _AdminUpdateStoreInfo _self;
  final $Res Function(_AdminUpdateStoreInfo) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? tagline = freezed,Object? address = freezed,Object? whatsapp = freezed,Object? instagram = freezed,}) {
  return _then(_AdminUpdateStoreInfo(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,whatsapp: freezed == whatsapp ? _self.whatsapp : whatsapp // ignore: cast_nullable_to_non_nullable
as String?,instagram: freezed == instagram ? _self.instagram : instagram // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _AdminAddProduct implements StoreEvent {
  const _AdminAddProduct({required this.product});
  

 final  Product product;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminAddProductCopyWith<_AdminAddProduct> get copyWith => __$AdminAddProductCopyWithImpl<_AdminAddProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminAddProduct&&(identical(other.product, product) || other.product == product));
}


@override
int get hashCode => Object.hash(runtimeType,product);

@override
String toString() {
  return 'StoreEvent.adminAddProduct(product: $product)';
}


}

/// @nodoc
abstract mixin class _$AdminAddProductCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$AdminAddProductCopyWith(_AdminAddProduct value, $Res Function(_AdminAddProduct) _then) = __$AdminAddProductCopyWithImpl;
@useResult
$Res call({
 Product product
});


$ProductCopyWith<$Res> get product;

}
/// @nodoc
class __$AdminAddProductCopyWithImpl<$Res>
    implements _$AdminAddProductCopyWith<$Res> {
  __$AdminAddProductCopyWithImpl(this._self, this._then);

  final _AdminAddProduct _self;
  final $Res Function(_AdminAddProduct) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,}) {
  return _then(_AdminAddProduct(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,
  ));
}

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

/// @nodoc


class _AdminSaveProduct implements StoreEvent {
  const _AdminSaveProduct({required this.product});
  

 final  Product product;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminSaveProductCopyWith<_AdminSaveProduct> get copyWith => __$AdminSaveProductCopyWithImpl<_AdminSaveProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminSaveProduct&&(identical(other.product, product) || other.product == product));
}


@override
int get hashCode => Object.hash(runtimeType,product);

@override
String toString() {
  return 'StoreEvent.adminSaveProduct(product: $product)';
}


}

/// @nodoc
abstract mixin class _$AdminSaveProductCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$AdminSaveProductCopyWith(_AdminSaveProduct value, $Res Function(_AdminSaveProduct) _then) = __$AdminSaveProductCopyWithImpl;
@useResult
$Res call({
 Product product
});


$ProductCopyWith<$Res> get product;

}
/// @nodoc
class __$AdminSaveProductCopyWithImpl<$Res>
    implements _$AdminSaveProductCopyWith<$Res> {
  __$AdminSaveProductCopyWithImpl(this._self, this._then);

  final _AdminSaveProduct _self;
  final $Res Function(_AdminSaveProduct) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,}) {
  return _then(_AdminSaveProduct(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,
  ));
}

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

/// @nodoc


class _AdminDeleteProduct implements StoreEvent {
  const _AdminDeleteProduct({required this.productId});
  

 final  String productId;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminDeleteProductCopyWith<_AdminDeleteProduct> get copyWith => __$AdminDeleteProductCopyWithImpl<_AdminDeleteProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminDeleteProduct&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'StoreEvent.adminDeleteProduct(productId: $productId)';
}


}

/// @nodoc
abstract mixin class _$AdminDeleteProductCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$AdminDeleteProductCopyWith(_AdminDeleteProduct value, $Res Function(_AdminDeleteProduct) _then) = __$AdminDeleteProductCopyWithImpl;
@useResult
$Res call({
 String productId
});




}
/// @nodoc
class __$AdminDeleteProductCopyWithImpl<$Res>
    implements _$AdminDeleteProductCopyWith<$Res> {
  __$AdminDeleteProductCopyWithImpl(this._self, this._then);

  final _AdminDeleteProduct _self;
  final $Res Function(_AdminDeleteProduct) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(_AdminDeleteProduct(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AdminUpdatePromoBanner implements StoreEvent {
  const _AdminUpdatePromoBanner({this.title, this.desc, this.bannerImage, this.badge});
  

 final  String? title;
 final  String? desc;
 final  String? bannerImage;
 final  String? badge;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUpdatePromoBannerCopyWith<_AdminUpdatePromoBanner> get copyWith => __$AdminUpdatePromoBannerCopyWithImpl<_AdminUpdatePromoBanner>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUpdatePromoBanner&&(identical(other.title, title) || other.title == title)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.bannerImage, bannerImage) || other.bannerImage == bannerImage)&&(identical(other.badge, badge) || other.badge == badge));
}


@override
int get hashCode => Object.hash(runtimeType,title,desc,bannerImage,badge);

@override
String toString() {
  return 'StoreEvent.adminUpdatePromoBanner(title: $title, desc: $desc, bannerImage: $bannerImage, badge: $badge)';
}


}

/// @nodoc
abstract mixin class _$AdminUpdatePromoBannerCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$AdminUpdatePromoBannerCopyWith(_AdminUpdatePromoBanner value, $Res Function(_AdminUpdatePromoBanner) _then) = __$AdminUpdatePromoBannerCopyWithImpl;
@useResult
$Res call({
 String? title, String? desc, String? bannerImage, String? badge
});




}
/// @nodoc
class __$AdminUpdatePromoBannerCopyWithImpl<$Res>
    implements _$AdminUpdatePromoBannerCopyWith<$Res> {
  __$AdminUpdatePromoBannerCopyWithImpl(this._self, this._then);

  final _AdminUpdatePromoBanner _self;
  final $Res Function(_AdminUpdatePromoBanner) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? desc = freezed,Object? bannerImage = freezed,Object? badge = freezed,}) {
  return _then(_AdminUpdatePromoBanner(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String?,bannerImage: freezed == bannerImage ? _self.bannerImage : bannerImage // ignore: cast_nullable_to_non_nullable
as String?,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _RemoteStoreSynced implements StoreEvent {
  const _RemoteStoreSynced({required this.storeId, required this.doc});
  

 final  String storeId;
 final  RemoteStoreDoc doc;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteStoreSyncedCopyWith<_RemoteStoreSynced> get copyWith => __$RemoteStoreSyncedCopyWithImpl<_RemoteStoreSynced>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteStoreSynced&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.doc, doc) || other.doc == doc));
}


@override
int get hashCode => Object.hash(runtimeType,storeId,doc);

@override
String toString() {
  return 'StoreEvent.remoteStoreSynced(storeId: $storeId, doc: $doc)';
}


}

/// @nodoc
abstract mixin class _$RemoteStoreSyncedCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$RemoteStoreSyncedCopyWith(_RemoteStoreSynced value, $Res Function(_RemoteStoreSynced) _then) = __$RemoteStoreSyncedCopyWithImpl;
@useResult
$Res call({
 String storeId, RemoteStoreDoc doc
});




}
/// @nodoc
class __$RemoteStoreSyncedCopyWithImpl<$Res>
    implements _$RemoteStoreSyncedCopyWith<$Res> {
  __$RemoteStoreSyncedCopyWithImpl(this._self, this._then);

  final _RemoteStoreSynced _self;
  final $Res Function(_RemoteStoreSynced) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeId = null,Object? doc = null,}) {
  return _then(_RemoteStoreSynced(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,doc: null == doc ? _self.doc : doc // ignore: cast_nullable_to_non_nullable
as RemoteStoreDoc,
  ));
}


}

/// @nodoc


class _RemoteProductsSynced implements StoreEvent {
  const _RemoteProductsSynced({required this.storeId, final  List<Product>? products}): _products = products;
  

 final  String storeId;
 final  List<Product>? _products;
 List<Product>? get products {
  final value = _products;
  if (value == null) return null;
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteProductsSyncedCopyWith<_RemoteProductsSynced> get copyWith => __$RemoteProductsSyncedCopyWithImpl<_RemoteProductsSynced>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteProductsSynced&&(identical(other.storeId, storeId) || other.storeId == storeId)&&const DeepCollectionEquality().equals(other._products, _products));
}


@override
int get hashCode => Object.hash(runtimeType,storeId,const DeepCollectionEquality().hash(_products));

@override
String toString() {
  return 'StoreEvent.remoteProductsSynced(storeId: $storeId, products: $products)';
}


}

/// @nodoc
abstract mixin class _$RemoteProductsSyncedCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$RemoteProductsSyncedCopyWith(_RemoteProductsSynced value, $Res Function(_RemoteProductsSynced) _then) = __$RemoteProductsSyncedCopyWithImpl;
@useResult
$Res call({
 String storeId, List<Product>? products
});




}
/// @nodoc
class __$RemoteProductsSyncedCopyWithImpl<$Res>
    implements _$RemoteProductsSyncedCopyWith<$Res> {
  __$RemoteProductsSyncedCopyWithImpl(this._self, this._then);

  final _RemoteProductsSynced _self;
  final $Res Function(_RemoteProductsSynced) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeId = null,Object? products = freezed,}) {
  return _then(_RemoteProductsSynced(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,products: freezed == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>?,
  ));
}


}

/// @nodoc


class _RemoteSyncFailed implements StoreEvent {
  const _RemoteSyncFailed(this.message);
  

 final  String message;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteSyncFailedCopyWith<_RemoteSyncFailed> get copyWith => __$RemoteSyncFailedCopyWithImpl<_RemoteSyncFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteSyncFailed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'StoreEvent.remoteSyncFailed(message: $message)';
}


}

/// @nodoc
abstract mixin class _$RemoteSyncFailedCopyWith<$Res> implements $StoreEventCopyWith<$Res> {
  factory _$RemoteSyncFailedCopyWith(_RemoteSyncFailed value, $Res Function(_RemoteSyncFailed) _then) = __$RemoteSyncFailedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$RemoteSyncFailedCopyWithImpl<$Res>
    implements _$RemoteSyncFailedCopyWith<$Res> {
  __$RemoteSyncFailedCopyWithImpl(this._self, this._then);

  final _RemoteSyncFailed _self;
  final $Res Function(_RemoteSyncFailed) _then;

/// Create a copy of StoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_RemoteSyncFailed(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AdminEnsureCloudSeeded implements StoreEvent {
  const _AdminEnsureCloudSeeded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminEnsureCloudSeeded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoreEvent.adminEnsureCloudSeeded()';
}


}




/// @nodoc


class _AdminResetToTemplate implements StoreEvent {
  const _AdminResetToTemplate();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminResetToTemplate);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoreEvent.adminResetToTemplate()';
}


}




// dart format on
