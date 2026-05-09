import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/models.dart';

/// Provider for the shopping cart state.
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

/// Computed provider for the total price of all items in the cart.
final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold<double>(0, (sum, item) => sum + item.totalPrice);
});

/// Computed provider for total item count.
final cartItemCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold<int>(0, (sum, item) => sum + item.quantity);
});

/// Manages the list of cart items.
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  /// Adds an item to the cart. If the same menuItem + selectedOptions combo
  /// already exists, increments the quantity instead.
  void addItem(MenuItem menuItem, {List<CustomizationOption> selectedOptions = const []}) {
    final existingIndex = state.indexWhere((cartItem) =>
        cartItem.menuItem.id == menuItem.id &&
        _optionsMatch(cartItem.selectedOptions, selectedOptions));

    if (existingIndex >= 0) {
      final existing = state[existingIndex];
      final updated = CartItem(
        menuItem: existing.menuItem,
        quantity: existing.quantity + 1,
        selectedOptions: existing.selectedOptions,
      );
      state = [
        ...state.sublist(0, existingIndex),
        updated,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [
        ...state,
        CartItem(
          menuItem: menuItem,
          quantity: 1,
          selectedOptions: selectedOptions,
        ),
      ];
    }
  }

  /// Updates quantity of an item at [index]. Removes if quantity <= 0.
  void updateQuantity(int index, int quantity) {
    if (index < 0 || index >= state.length) return;
    if (quantity <= 0) {
      removeItem(index);
      return;
    }
    final item = state[index];
    final updated = CartItem(
      menuItem: item.menuItem,
      quantity: quantity,
      selectedOptions: item.selectedOptions,
    );
    state = [
      ...state.sublist(0, index),
      updated,
      ...state.sublist(index + 1),
    ];
  }

  /// Removes an item at [index].
  void removeItem(int index) {
    if (index < 0 || index >= state.length) return;
    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  /// Clears all items from the cart.
  void clear() {
    state = [];
  }

  /// Checks if two option lists contain the same options (by id).
  bool _optionsMatch(
    List<CustomizationOption> a,
    List<CustomizationOption> b,
  ) {
    if (a.length != b.length) return false;
    final aIds = a.map((o) => o.id).toSet();
    final bIds = b.map((o) => o.id).toSet();
    return aIds.containsAll(bIds) && bIds.containsAll(aIds);
  }
}
