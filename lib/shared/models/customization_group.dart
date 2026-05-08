import 'package:freezed_annotation/freezed_annotation.dart';

import 'customization_option.dart';

part 'customization_group.freezed.dart';
part 'customization_group.g.dart';

@freezed
class CustomizationGroup with _$CustomizationGroup {
  const factory CustomizationGroup({
    required String id,
    required String name,
    required bool required,
    required int maxSelections,
    required List<CustomizationOption> options,
  }) = _CustomizationGroup;

  factory CustomizationGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomizationGroupFromJson(json);
}
