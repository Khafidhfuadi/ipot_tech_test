import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/models.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/menu_provider.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/shimmer_menu_card.dart';
import 'package:intl/intl.dart';

/// Menu listing screen styled like the reference design.
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key, required this.tableId});

  final String tableId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(menuProvider(tableId));

    return menuAsync.when(
      loading: () => _LoadingView(tableId: tableId),
      error: (error, _) => _ErrorView(
        tableId: tableId,
        error: error,
        onRetry: () => ref.invalidate(menuProvider(tableId)),
      ),
      data: (menu) => _MenuBody(tableId: tableId, menu: menu),
    );
  }
}

// -- Loading ------------------------------------------------------------------

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.tableId});
  final String tableId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, 'Memuat...', tableId, 0),
            const SizedBox(height: 16),
            const Expanded(child: ShimmerMenuGrid()),
          ],
        ),
      ),
    );
  }
}

// -- Error --------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.tableId,
    required this.error,
    required this.onRetry,
  });
  final String tableId;
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text('Gagal memuat menu', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -- Menu Body ----------------------------------------------------------------

class _MenuBody extends ConsumerStatefulWidget {
  const _MenuBody({required this.tableId, required this.menu});
  final String tableId;
  final MenuResponse menu;

  @override
  ConsumerState<_MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends ConsumerState<_MenuBody> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategoryId;

  List<MenuCategory> get _sortedCategories {
    final cats = List<MenuCategory>.from(widget.menu.categories);
    cats.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return cats;
  }

  List<MenuItem> get _filteredItems {
    var items = widget.menu.items.toList();

    // Filter by category
    if (_selectedCategoryId != null) {
      items = items.where((i) => i.categoryId == _selectedCategoryId).toList();
    }

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      items = items.where((i) => i.name.toLowerCase().contains(q)).toList();
    }

    return items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAddItem(MenuItem item) {
    if (item.customizationGroups.isNotEmpty) {
      // Navigate to detail page
      context.push('/menu/${widget.tableId}/item', extra: item);
    } else {
      ref.read(cartProvider.notifier).addItem(item);
      _showAddedSnackBar(item.name);
    }
  }

  void _showAddedSnackBar(String name) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name ditambahkan ke keranjang'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartItemCountProvider);
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(
                context,
                widget.menu.restaurant.name,
                widget.tableId,
                cartCount,
              ),
            ),

            // Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search for a dish...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  ),
                ),
              ),
            ),

            // Categories header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.grid_view_rounded, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),

            // Category chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _sortedCategories.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _CategoryChip(
                        label: 'All',
                        icon: Icons.restaurant,
                        isSelected: _selectedCategoryId == null,
                        onTap: () => setState(() => _selectedCategoryId = null),
                      );
                    }
                    final cat = _sortedCategories[index - 1];
                    return _CategoryChip(
                      label: cat.name,
                      icon: _categoryIcon(cat.name),
                      isSelected: _selectedCategoryId == cat.id,
                      onTap: () => setState(() => _selectedCategoryId = cat.id),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Menu grid or empty
            if (items.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyView(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => MenuItemCard(
                      item: items[index],
                      onTap: () => context.push(
                        '/menu/${widget.tableId}/item',
                        extra: items[index],
                      ),
                      onAdd: () => _onAddItem(items[index]),
                    ),
                    childCount: items.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                ),
              ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),

      // Bottom cart bar
      bottomNavigationBar: cartCount > 0
          ? _CartBottomBar(
              cartCount: cartCount,
              cartTotal: ref.watch(cartTotalProvider),
              onTap: () => context.push('/cart'),
            )
          : null,
    );
  }

  IconData _categoryIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('appetizer') || lower.contains('snack')) {
      return Icons.tapas;
    }
    if (lower.contains('sashimi') ||
        lower.contains('fish') ||
        lower.contains('seafood')) {
      return Icons.set_meal;
    }
    if (lower.contains('main') ||
        lower.contains('rice') ||
        lower.contains('ramen')) {
      return Icons.lunch_dining;
    }
    if (lower.contains('drink') ||
        lower.contains('tea') ||
        lower.contains('coffee')) {
      return Icons.local_cafe;
    }
    if (lower.contains('dessert') || lower.contains('sweet')) {
      return Icons.cake;
    }
    return Icons.restaurant;
  }
}

// -- Shared header ------------------------------------------------------------

Widget _buildHeader(
  BuildContext context,
  String restaurantName,
  String tableId,
  int cartCount,
) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade700),
              ),
              Text(
                restaurantName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.table_bar, size: 16, color: AppTheme.coral),
                  const SizedBox(width: 4),
                  Text(
                    'Table $tableId',
                    style: const TextStyle(
                      color: AppTheme.coral,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Cart icon with badge
        GestureDetector(
          onTap: () => context.push('/cart'),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFF333333),
                  size: 22,
                ),
              ),
              if (cartCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.coral,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$cartCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

// -- Category chip ------------------------------------------------------------

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.coralLight : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.coral : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppTheme.coral : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.coral : const Color(0xFF3A3A3A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -- Empty view ---------------------------------------------------------------

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.restaurant_menu, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Menu tidak tersedia',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// -- Bottom cart bar ----------------------------------------------------------

final _currencyFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

class _CartBottomBar extends StatelessWidget {
  const _CartBottomBar({
    required this.cartCount,
    required this.cartTotal,
    required this.onTap,
  });

  final int cartCount;
  final double cartTotal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.coral,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.coral.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text.rich(
              TextSpan(
                text: 'View Cart ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '($cartCount products)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              _currencyFormat.format(cartTotal),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            //icon right
            SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.coral,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
