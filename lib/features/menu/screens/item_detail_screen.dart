import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/models.dart';
import '../../cart/providers/cart_provider.dart';

final _currencyFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

/// Full-page item detail with hero image, description, add-ons, notes,
/// and an "Add to orders" bottom bar.
class ItemDetailScreen extends ConsumerStatefulWidget {
  const ItemDetailScreen({
    super.key,
    required this.item,
    required this.tableId,
  });

  final MenuItem item;
  final String tableId;

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  /// Tracks the quantity selected per option id.
  late final Map<String, int> _optionQuantities;
  final _notesController = TextEditingController();
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _optionQuantities = {};
    // Initialize required single-select groups with first option
    for (final group in widget.item.customizationGroups) {
      if (group.required &&
          group.maxSelections == 1 &&
          group.options.isNotEmpty) {
        _optionQuantities[group.options.first.id] = 1;
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// Calculates extras total from selected add-on quantities.
  double get _extrasTotal {
    double total = 0;
    for (final group in widget.item.customizationGroups) {
      for (final option in group.options) {
        final qty = _optionQuantities[option.id] ?? 0;
        total += option.priceModifier * qty;
      }
    }
    return total;
  }

  double get _totalPrice => (widget.item.price + _extrasTotal) * _quantity;

  /// Builds the list of selected CustomizationOption objects.
  List<CustomizationOption> get _selectedOptions {
    final result = <CustomizationOption>[];
    for (final group in widget.item.customizationGroups) {
      for (final option in group.options) {
        final qty = _optionQuantities[option.id] ?? 0;
        if (qty > 0) {
          // Add the option qty times to match the quantity model
          result.add(option);
        }
      }
    }
    return result;
  }

  bool get _isValid {
    for (final group in widget.item.customizationGroups) {
      if (group.required) {
        final hasSelection = group.options.any(
          (o) => (_optionQuantities[o.id] ?? 0) > 0,
        );
        if (!hasSelection) return false;
      }
    }
    return true;
  }

  int _selectedCountInGroup(CustomizationGroup group) {
    return group.options.fold<int>(
      0,
      (sum, o) => sum + (_optionQuantities[o.id] ?? 0),
    );
  }

  void _toggleSingleSelect(
    CustomizationGroup group,
    CustomizationOption option,
  ) {
    setState(() {
      // Clear other options in this group
      for (final o in group.options) {
        _optionQuantities.remove(o.id);
      }
      _optionQuantities[option.id] = 1;
    });
  }

  void _incrementOption(CustomizationGroup group, CustomizationOption option) {
    setState(() {
      final current = _optionQuantities[option.id] ?? 0;
      final groupCount = _selectedCountInGroup(group);
      if (groupCount < group.maxSelections) {
        _optionQuantities[option.id] = current + 1;
      }
    });
  }

  void _decrementOption(CustomizationOption option) {
    setState(() {
      final current = _optionQuantities[option.id] ?? 0;
      if (current > 0) {
        _optionQuantities[option.id] = current - 1;
      }
    });
  }

  void _addToCart() {
    ref
        .read(cartProvider.notifier)
        .addItem(widget.item, selectedOptions: _selectedOptions);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.item.name} ditambahkan ke keranjang'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Collapsing hero image -> pinned app bar with item name
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: _CircleButton(
                icon: Icons.chevron_left,
                onTap: () => context.pop(),
              ),
            ),
            title: null,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                // When collapsed, top padding + kToolbarHeight
                final top = MediaQuery.of(context).padding.top;
                final collapseThreshold = top + kToolbarHeight + 30;
                final isCollapsed = constraints.maxHeight <= collapseThreshold;

                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: isCollapsed
                      ? Text(
                          widget.item.name,
                          style: const TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      widget.item.imageUrl != null &&
                              widget.item.imageUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.item.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => _heroPlaceholder(),
                              errorWidget: (_, __, ___) => _heroPlaceholder(),
                            )
                          : _heroPlaceholder(),
                      // Bottom gradient
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.white,
                                Colors.white.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Item info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    widget.item.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.item.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _currencyFormat.format(widget.item.price),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppTheme.coral,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                ],
              ),
            ),
          ),

          // Full description
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                widget.item.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF444444),
                  height: 1.5,
                ),
              ),
            ),
          ),

          // Customization groups (Add Ons)
          if (widget.item.customizationGroups.isNotEmpty) ...[
            for (final group in widget.item.customizationGroups)
              SliverToBoxAdapter(child: _buildGroup(theme, group)),
          ],

          // Notes
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      hintText: 'Tidak pake bawang yaa...',
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // Bottom bar: total + add button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quantity selector
                _QuantitySelector(
                  quantity: _quantity,
                  onDecrement: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                  onIncrement: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: _isValid ? _addToCart : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.coral,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: _isValid ? AppTheme.coral : Colors.grey.shade300,
                  ),
                ),
                child: Text('Add - ${_currencyFormat.format(_totalPrice)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroPlaceholder() {
    return Container(
      color: const Color(0xFFF0F0F0),
      child: Icon(Icons.restaurant_menu, size: 64, color: Colors.grey.shade300),
    );
  }

  Widget _buildGroup(ThemeData theme, CustomizationGroup group) {
    final isSingleSelect = group.maxSelections == 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                group.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              if (group.required) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.coralLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Wajib',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.coral,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Options
          ...group.options.map((option) {
            final qty = _optionQuantities[option.id] ?? 0;

            if (isSingleSelect) {
              return _SingleSelectOptionTile(
                option: option,
                isSelected: qty > 0,
                onTap: () => _toggleSingleSelect(group, option),
              );
            }

            return _MultiSelectOptionTile(
              option: option,
              quantity: qty,
              onIncrement: () => _incrementOption(group, option),
              onDecrement: () => _decrementOption(option),
            );
          }),
        ],
      ),
    );
  }
}

// -- Widgets ------------------------------------------------------------------

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.coral, size: 22),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.onIncrement,
    this.onDecrement,
  });
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _miniButton(Icons.remove, onDecrement),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        _miniButton(Icons.add, onIncrement),
      ],
    );
  }

  Widget _miniButton(IconData icon, VoidCallback? onTap) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? AppTheme.coralLight : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppTheme.coral : Colors.grey.shade400,
        ),
      ),
    );
  }
}

class _SingleSelectOptionTile extends StatelessWidget {
  const _SingleSelectOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });
  final CustomizationOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    option.name,
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 15,
                    ),
                  ),
                  if (option.priceModifier > 0) ...[
                    const SizedBox(width: 6),
                    Text(
                      '(+${_formatShort(option.priceModifier)})',
                      style: const TextStyle(
                        color: AppTheme.coral,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppTheme.coral : const Color(0xFF999999),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _MultiSelectOptionTile extends StatelessWidget {
  const _MultiSelectOptionTile({
    required this.option,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });
  final CustomizationOption option;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  option.name,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 15,
                  ),
                ),
                if (option.priceModifier > 0) ...[
                  const SizedBox(width: 6),
                  Text(
                    '(+${_formatShort(option.priceModifier)})',
                    style: const TextStyle(color: AppTheme.coral, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
          if (quantity > 0) ...[
            GestureDetector(
              onTap: onDecrement,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppTheme.coralLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.remove,
                  size: 14,
                  color: AppTheme.coral,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '$quantity',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppTheme.coral,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Formats price in short form: 10000 -> "10K"
String _formatShort(double price) {
  if (price >= 1000) {
    final k = (price / 1000).toStringAsFixed(0);
    return '${k}K';
  }
  return _currencyFormat.format(price);
}
