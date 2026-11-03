// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoreState {

 String get currentStoreId; Map<String, StoreProfile> get stores; Map<String, List<Order>> get orders; List<CartItem> get cart; String get searchQuery; String get selectedCategory; bool get availableOnly; bool get promoClaimed; bool get promoActive; bool? get openOverride; String? get tableNumber; String get orderType;
/// Create a copy of StoreState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreStateCopyWith<StoreState> get copyWith => _$StoreStateCopyWithImpl<StoreState>(this as StoreState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreState&&(identical(other.currentStoreId, currentStoreId) || other.currentStoreId == currentStoreId)&&const DeepCollectionEquality().equals(other.stores, stores)&&const DeepCollectionEquality().equals(other.orders, orders)&&const DeepCollectionEquality().equals(other.cart, cart)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.availableOnly, availableOnly) || other.availableOnly == availableOnly)&&(identical(other.promoClaimed, promoClaimed) || other.promoClaimed == promoClaimed)&&(identical(other.promoActive, promoActive) || other.promoActive == promoActive)&&(identical(other.openOverride, openOverride) || other.openOverride == openOverride)&&(identical(other.tableNumber, tableNumber) || other.tableNumber == tableNumber)&&(identical(other.orderType, orderType) || other.orderType == orderType));
}


@override
int get hashCode => Object.hash(runtimeType,currentStoreId,const DeepCollectionEquality().hash(stores),const DeepCollectionEquality().hash(orders),const DeepCollectionEquality().hash(cart),searchQuery,selectedCategory,availableOnly,promoClaimed,promoActive,openOverride,tableNumber,orderType);

@override
String toString() {
  return 'StoreState(currentStoreId: $currentStoreId, stores: $stores, orders: $orders, cart: $cart, searchQuery: $searchQuery, selectedCategory: $selectedCategory, availableOnly: $availableOnly, promoClaimed: $promoClaimed, promoActive: $promoActive, openOverride: $openOverride, tableNumber: $tableNumber, orderType: $orderType)';
}


}

/// @nodoc
abstract mixin class $StoreStateCopyWith<$Res>  {
  factory $StoreStateCopyWith(StoreState value, $Res Function(StoreState) _then) = _$StoreStateCopyWithImpl;
@useResult
$Res call({
 String currentStoreId, Map<String, StoreProfile> stores, Map<String, List<Order>> orders, List<CartItem> cart, String searchQuery, String selectedCategory, bool availableOnly, bool promoClaimed, bool promoActive, bool? openOverride, String? tableNumber, String orderType
});




}
/// @nodoc
class _$StoreStateCopyWithImpl<$Res>
    implements $StoreStateCopyWith<$Res> {
  _$StoreStateCopyWithImpl(this._self, this._then);

  final StoreState _self;
  final $Res Function(StoreState) _then;

/// Create a copy of StoreState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStoreId = null,Object? stores = null,Object? orders = null,Object? cart = null,Object? searchQuery = null,Object? selectedCategory = null,Object? availableOnly = null,Object? promoClaimed = null,Object? promoActive = null,Object? openOverride = freezed,Object? tableNumber = freezed,Object? orderType = null,}) {
  return _then(_self.copyWith(
currentStoreId: null == currentStoreId ? _self.currentStoreId : currentStoreId // ignore: cast_nullable_to_non_nullable
as String,stores: null == stores ? _self.stores : stores // ignore: cast_nullable_to_non_nullable
as Map<String, StoreProfile>,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as Map<String, List<Order>>,cart: null == cart ? _self.cart : cart // ignore: cast_nullable_to_non_nullable
as List<CartItem>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String,availableOnly: null == availableOnly ? _self.availableOnly : availableOnly // ignore: cast_nullable_to_non_nullable
as bool,promoClaimed: null == promoClaimed ? _self.promoClaimed : promoClaimed // ignore: cast_nullable_to_non_nullable
as bool,promoActive: null == promoActive ? _self.promoActive : promoActive // ignore: cast_nullable_to_non_nullable
as bool,openOverride: freezed == openOverride ? _self.openOverride : openOverride // ignore: cast_nullable_to_non_nullable
as bool?,tableNumber: freezed == tableNumber ? _self.tableNumber : tableNumber // ignore: cast_nullable_to_non_nullable
as String?,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreState].
extension StoreStatePatterns on StoreState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreState value)  $default,){
final _that = this;
switch (_that) {
case _StoreState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreState value)?  $default,){
final _that = this;
switch (_that) {
case _StoreState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currentStoreId,  Map<String, StoreProfile> stores,  Map<String, List<Order>> orders,  List<CartItem> cart,  String searchQuery,  String selectedCategory,  bool availableOnly,  bool promoClaimed,  bool promoActive,  bool? openOverride,  String? tableNumber,  String orderType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreState() when $default != null:
return $default(_that.currentStoreId,_that.stores,_that.orders,_that.cart,_that.searchQuery,_that.selectedCategory,_that.availableOnly,_that.promoClaimed,_that.promoActive,_that.openOverride,_that.tableNumber,_that.orderType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currentStoreId,  Map<String, StoreProfile> stores,  Map<String, List<Order>> orders,  List<CartItem> cart,  String searchQuery,  String selectedCategory,  bool availableOnly,  bool promoClaimed,  bool promoActive,  bool? openOverride,  String? tableNumber,  String orderType)  $default,) {final _that = this;
switch (_that) {
case _StoreState():
return $default(_that.currentStoreId,_that.stores,_that.orders,_that.cart,_that.searchQuery,_that.selectedCategory,_that.availableOnly,_that.promoClaimed,_that.promoActive,_that.openOverride,_that.tableNumber,_that.orderType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currentStoreId,  Map<String, StoreProfile> stores,  Map<String, List<Order>> orders,  List<CartItem> cart,  String searchQuery,  String selectedCategory,  bool availableOnly,  bool promoClaimed,  bool promoActive,  bool? openOverride,  String? tableNumber,  String orderType)?  $default,) {final _that = this;
switch (_that) {
case _StoreState() when $default != null:
return $default(_that.currentStoreId,_that.stores,_that.orders,_that.cart,_that.searchQuery,_that.selectedCategory,_that.availableOnly,_that.promoClaimed,_that.promoActive,_that.openOverride,_that.tableNumber,_that.orderType);case _:
  return null;

}
}

}

/// @nodoc


class _StoreState extends StoreState {
  const _StoreState({required this.currentStoreId, required final  Map<String, StoreProfile> stores, required final  Map<String, List<Order>> orders, final  List<CartItem> cart = const [], this.searchQuery = '', this.selectedCategory = 'all', this.availableOnly = false, this.promoClaimed = false, this.promoActive = true, this.openOverride, this.tableNumber, this.orderType = 'Dine-in'}): _stores = stores,_orders = orders,_cart = cart,super._();
  

@override final  String currentStoreId;
 final  Map<String, StoreProfile> _stores;
@override Map<String, StoreProfile> get stores {
  if (_stores is EqualUnmodifiableMapView) return _stores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stores);
}

 final  Map<String, List<Order>> _orders;
@override Map<String, List<Order>> get orders {
  if (_orders is EqualUnmodifiableMapView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_orders);
}

 final  List<CartItem> _cart;
@override@JsonKey() List<CartItem> get cart {
  if (_cart is EqualUnmodifiableListView) return _cart;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cart);
}

@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  String selectedCategory;
@override@JsonKey() final  bool availableOnly;
@override@JsonKey() final  bool promoClaimed;
@override@JsonKey() final  bool promoActive;
@override final  bool? openOverride;
@override final  String? tableNumber;
@override@JsonKey() final  String orderType;

/// Create a copy of StoreState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreStateCopyWith<_StoreState> get copyWith => __$StoreStateCopyWithImpl<_StoreState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreState&&(identical(other.currentStoreId, currentStoreId) || other.currentStoreId == currentStoreId)&&const DeepCollectionEquality().equals(other._stores, _stores)&&const DeepCollectionEquality().equals(other._orders, _orders)&&const DeepCollectionEquality().equals(other._cart, _cart)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.availableOnly, availableOnly) || other.availableOnly == availableOnly)&&(identical(other.promoClaimed, promoClaimed) || other.promoClaimed == promoClaimed)&&(identical(other.promoActive, promoActive) || other.promoActive == promoActive)&&(identical(other.openOverride, openOverride) || other.openOverride == openOverride)&&(identical(other.tableNumber, tableNumber) || other.tableNumber == tableNumber)&&(identical(other.orderType, orderType) || other.orderType == orderType));
}


@override
int get hashCode => Object.hash(runtimeType,currentStoreId,const DeepCollectionEquality().hash(_stores),const DeepCollectionEquality().hash(_orders),const DeepCollectionEquality().hash(_cart),searchQuery,selectedCategory,availableOnly,promoClaimed,promoActive,openOverride,tableNumber,orderType);

@override
String toString() {
  return 'StoreState(currentStoreId: $currentStoreId, stores: $stores, orders: $orders, cart: $cart, searchQuery: $searchQuery, selectedCategory: $selectedCategory, availableOnly: $availableOnly, promoClaimed: $promoClaimed, promoActive: $promoActive, openOverride: $openOverride, tableNumber: $tableNumber, orderType: $orderType)';
}


}

/// @nodoc
abstract mixin class _$StoreStateCopyWith<$Res> implements $StoreStateCopyWith<$Res> {
  factory _$StoreStateCopyWith(_StoreState value, $Res Function(_StoreState) _then) = __$StoreStateCopyWithImpl;
@override @useResult
$Res call({
 String currentStoreId, Map<String, StoreProfile> stores, Map<String, List<Order>> orders, List<CartItem> cart, String searchQuery, String selectedCategory, bool availableOnly, bool promoClaimed, bool promoActive, bool? openOverride, String? tableNumber, String orderType
});




}
/// @nodoc
class __$StoreStateCopyWithImpl<$Res>
    implements _$StoreStateCopyWith<$Res> {
  __$StoreStateCopyWithImpl(this._self, this._then);

  final _StoreState _self;
  final $Res Function(_StoreState) _then;

/// Create a copy of StoreState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStoreId = null,Object? stores = null,Object? orders = null,Object? cart = null,Object? searchQuery = null,Object? selectedCategory = null,Object? availableOnly = null,Object? promoClaimed = null,Object? promoActive = null,Object? openOverride = freezed,Object? tableNumber = freezed,Object? orderType = null,}) {
  return _then(_StoreState(
currentStoreId: null == currentStoreId ? _self.currentStoreId : currentStoreId // ignore: cast_nullable_to_non_nullable
as String,stores: null == stores ? _self._stores : stores // ignore: cast_nullable_to_non_nullable
as Map<String, StoreProfile>,orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as Map<String, List<Order>>,cart: null == cart ? _self._cart : cart // ignore: cast_nullable_to_non_nullable
as List<CartItem>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String,availableOnly: null == availableOnly ? _self.availableOnly : availableOnly // ignore: cast_nullable_to_non_nullable
as bool,promoClaimed: null == promoClaimed ? _self.promoClaimed : promoClaimed // ignore: cast_nullable_to_non_nullable
as bool,promoActive: null == promoActive ? _self.promoActive : promoActive // ignore: cast_nullable_to_non_nullable
as bool,openOverride: freezed == openOverride ? _self.openOverride : openOverride // ignore: cast_nullable_to_non_nullable
as bool?,tableNumber: freezed == tableNumber ? _self.tableNumber : tableNumber // ignore: cast_nullable_to_non_nullable
as String?,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
