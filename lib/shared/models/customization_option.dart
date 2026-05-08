import 'package:freezed_annotation/freezed_annotation.dart';

part 'customization_option.freezed.dart';
part 'customization_option.g.dart';

@freezed
class CustomizationOption with _$CustomizationOption {
  const factory CustomizationOption({
    required String id,
    required String name,
    required double priceModifier,
  }) = _CustomizationOption;

  factory CustomizationOption.fromJson(Map<String, dynamic> json) =>
      _$CustomizationOptionFromJson(json);
}
