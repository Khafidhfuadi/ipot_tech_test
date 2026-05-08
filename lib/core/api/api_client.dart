import 'dart:convert';

import 'package:dio/dio.dart';

import '../../shared/models/models.dart';
import 'mock_data.dart';

/// API client wrapping Dio with offline fallback support.
class ApiClient {
  ApiClient({String? baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? 'https://api.example.com/v1',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  final Dio _dio;

  /// Exposed for testing / adding interceptors.
  Dio get dio => _dio;

  // ---------------------------------------------------------------------------
  // Menu
  // ---------------------------------------------------------------------------

  /// Fetches the menu for a given [tableId].
  /// Falls back to mock data when the request fails or the device is offline.
  Future<MenuResponse> getMenu(String tableId) async {
    try {
      final response = await _dio.get('/menu', queryParameters: {
        'tableId': tableId,
      });
      return MenuResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      // Fallback to mock data on any error (network, server, timeout, etc.)
      final mockJson =
          json.decode(MockData.kMockMenuJson) as Map<String, dynamic>;

      // Patch the tableId into the mock restaurant data so it reflects
      // the requested table.
      (mockJson['restaurant'] as Map<String, dynamic>)['tableId'] = tableId;

      return MenuResponse.fromJson(mockJson);
    }
  }

  // ---------------------------------------------------------------------------
  // Orders
  // ---------------------------------------------------------------------------

  /// Creates a new order from the given [request].
  Future<OrderResponse> createOrder(OrderRequest request) async {
    final response = await _dio.post(
      '/orders',
      data: request.toJson(),
    );
    return OrderResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Retrieves the current status for [orderId].
  Future<OrderResponse> getOrderStatus(String orderId) async {
    final response = await _dio.get('/orders/$orderId');
    return OrderResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
