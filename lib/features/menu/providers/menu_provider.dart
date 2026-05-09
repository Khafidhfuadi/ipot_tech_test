import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../shared/models/models.dart';

/// Provider for the API client singleton.
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

/// Family provider keyed by tableId so each table gets its own menu state.
final menuProvider = AsyncNotifierProvider.family<MenuNotifier, MenuResponse, String>(
  MenuNotifier.new,
);

/// Search query state for filtering menu items.
final menuSearchQueryProvider = StateProvider<String>((ref) => '');

/// Notifier that fetches and manages menu data for a specific table.
class MenuNotifier extends FamilyAsyncNotifier<MenuResponse, String> {
  @override
  Future<MenuResponse> build(String arg) async {
    return _fetchMenu(arg);
  }

  Future<MenuResponse> _fetchMenu(String tableId) async {
    final apiClient = ref.read(apiClientProvider);
    return apiClient.getMenu(tableId);
  }

  /// Re-fetches the menu data.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchMenu(arg));
  }

  /// Returns items filtered by search query.
  List<MenuItem> filteredItems(List<MenuItem> items, String query) {
    if (query.isEmpty) return items;
    final lowerQuery = query.toLowerCase();
    return items
        .where((item) => item.name.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
