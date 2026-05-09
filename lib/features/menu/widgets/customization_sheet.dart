import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/models/models.dart';

final _currencyFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 0,
);

/// Bottom sheet for selecting menu item customization options.
class CustomizationSheet extends StatefulWidget {
  const CustomizationSheet({
    super.key,
    required this.item,
    required this.onConfirm,
  });

  final MenuItem item;
  final void Function(List<CustomizationOption> selectedOptions) onConfirm;

  /// Shows the customization sheet as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required MenuItem item,
    required void Function(List<CustomizationOption> selectedOptions) onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CustomizationSheet(item: item, onConfirm: onConfirm),
    );
  }

  @override
  State<CustomizationSheet> createState() => _CustomizationSheetState();
}

class _CustomizationSheetState extends State<CustomizationSheet> {
  /// Tracks selected option IDs per group.
  /// Key = groupId, Value = set of selected optionIds.
  late final Map<String, Set<String>> _selections;

  @override
  void initState() {
    super.initState();
    _selections = {
      for (final group in widget.item.customizationGroups) group.id: <String>{},
    };
  }

  /// Collects all selected CustomizationOption objects across all groups.
  List<CustomizationOption> get _allSelectedOptions {
    final result = <CustomizationOption>[];
    for (final group in widget.item.customizationGroups) {
      final selectedIds = _selections[group.id] ?? {};
      for (final option in group.options) {
        if (selectedIds.contains(option.id)) {
          result.add(option);
        }
      }
    }
    return result;
  }

  /// Calculates extra price from all selected options.
  double get _extrasTotal {
    return _allSelectedOptions.fold<double>(
      0,
      (sum, opt) => sum + opt.priceModifier,
    );
  }

  /// Checks if all required groups have at least one selection.
  bool get _isValid {
    for (final group in widget.item.customizationGroups) {
      if (group.required) {
        final selectedIds = _selections[group.id] ?? {};
        if (selectedIds.isEmpty) return false;
      }
    }
    return true;
  }

  void _toggleOption(CustomizationGroup group, CustomizationOption option) {
    setState(() {
      final selected = _selections[group.id]!;

      if (group.maxSelections == 1) {
        // Radio behavior: replace selection
        if (selected.contains(option.id)) {
          // Allow deselect only if not required
          if (!group.required) selected.clear();
        } else {
          selected.clear();
          selected.add(option.id);
        }
      } else {
        // Checkbox behavior: toggle
        if (selected.contains(option.id)) {
          selected.remove(option.id);
        } else if (selected.length < group.maxSelections) {
          selected.add(option.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalPrice = widget.item.price + _extrasTotal;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                widget.item.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _currencyFormat.format(widget.item.price),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              // Groups & options
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    for (final group in widget.item.customizationGroups)
                      _buildGroup(theme, group),
                  ],
                ),
              ),

              // Total + confirm button
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _currencyFormat.format(totalPrice),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isValid
                          ? () {
                              widget.onConfirm(_allSelectedOptions);
                              Navigator.of(context).pop();
                            }
                          : null,
                      child: const Text('Tambahkan ke Keranjang'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGroup(ThemeData theme, CustomizationGroup group) {
    final selectedIds = _selections[group.id] ?? {};
    final isSingleSelect = group.maxSelections == 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group header
          Row(
            children: [
              Text(
                group.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
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
                    color: theme.colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Wajib',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              if (!isSingleSelect) ...[
                const Spacer(),
                Text(
                  'Maks. ${group.maxSelections}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),

          // Options
          ...group.options.map((option) {
            final isSelected = selectedIds.contains(option.id);

            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () => _toggleOption(group, option),
              leading: isSingleSelect
                  ? Radio<bool>(
                      value: true,
                      groupValue: isSelected ? true : null,
                      onChanged: (_) => _toggleOption(group, option),
                    )
                  : Checkbox(
                      value: isSelected,
                      onChanged: (_) => _toggleOption(group, option),
                    ),
              title: Text(option.name),
              trailing: option.priceModifier > 0
                  ? Text(
                      '+${_currencyFormat.format(option.priceModifier)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : null,
            );
          }),
        ],
      ),
    );
  }
}
