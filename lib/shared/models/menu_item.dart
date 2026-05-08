import 'package:freezed_annotation/freezed_annotation.dart';

import 'customization_group.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

@freezed
class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required String name,
    required String description,
    required double price,
    required String categoryId,
    String? imageUrl,
    @Default([]) List<CustomizationGroup> customizationGroups,
  }) = _MenuItem;

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}
