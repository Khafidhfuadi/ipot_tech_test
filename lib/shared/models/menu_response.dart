import 'package:freezed_annotation/freezed_annotation.dart';

import 'menu_category.dart';
import 'menu_item.dart';
import 'restaurant.dart';

part 'menu_response.freezed.dart';
part 'menu_response.g.dart';

@freezed
class MenuResponse with _$MenuResponse {
  const factory MenuResponse({
    required Restaurant restaurant,
    required List<MenuCategory> categories,
    required List<MenuItem> items,
  }) = _MenuResponse;

  factory MenuResponse.fromJson(Map<String, dynamic> json) =>
      _$MenuResponseFromJson(json);
}
