import 'package:freezed_annotation/freezed_annotation.dart';

import 'customization_option.dart';
import 'menu_item.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({
    required MenuItem menuItem,
    required int quantity,
    @Default([]) List<CustomizationOption> selectedOptions,
  }) = _CartItem;

  /// Total price including base price and selected customization modifiers.
  double get totalPrice {
    final optionsExtra = selectedOptions.fold<double>(
      0,
      (sum, option) => sum + option.priceModifier,
    );
    return (menuItem.price + optionsExtra) * quantity;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
