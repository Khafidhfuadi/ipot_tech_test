import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_request.freezed.dart';
part 'order_request.g.dart';

@freezed
class OrderItemRequest with _$OrderItemRequest {
  const factory OrderItemRequest({
    required String menuItemId,
    required int quantity,
    @Default([]) List<String> selectedOptionIds,
  }) = _OrderItemRequest;

  factory OrderItemRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderItemRequestFromJson(json);
}

@freezed
class OrderRequest with _$OrderRequest {
  const factory OrderRequest({
    required String tableId,
    required List<OrderItemRequest> items,
    @Default('') String customerNote,
  }) = _OrderRequest;

  factory OrderRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderRequestFromJson(json);
}
