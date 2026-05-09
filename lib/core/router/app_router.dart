import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/scanner/screens/scan_screen.dart';
import '../../features/menu/screens/menu_screen.dart';
import '../../features/menu/screens/item_detail_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/order/screens/confirm_screen.dart';
import '../../features/order/screens/tracking_screen.dart';
import '../../shared/models/models.dart';

/// Application route configuration using go_router.
final GoRouter appRouter = GoRouter(
  initialLocation: '/scan',
  routes: <RouteBase>[
    GoRoute(
      path: '/scan',
      name: 'scan',
      builder: (BuildContext context, GoRouterState state) {
        return const ScanScreen();
      },
    ),
    GoRoute(
      path: '/menu/:tableId',
      name: 'menu',
      builder: (BuildContext context, GoRouterState state) {
        final tableId = state.pathParameters['tableId']!;
        return MenuScreen(tableId: tableId);
      },
    ),
    GoRoute(
      path: '/menu/:tableId/item',
      name: 'itemDetail',
      builder: (BuildContext context, GoRouterState state) {
        final tableId = state.pathParameters['tableId']!;
        final item = state.extra as MenuItem;
        return ItemDetailScreen(item: item, tableId: tableId);
      },
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (BuildContext context, GoRouterState state) {
        return const CartScreen();
      },
    ),
    GoRoute(
      path: '/confirm/:orderId',
      name: 'confirm',
      builder: (BuildContext context, GoRouterState state) {
        final orderId = state.pathParameters['orderId']!;
        return ConfirmScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/tracking/:orderId',
      name: 'tracking',
      builder: (BuildContext context, GoRouterState state) {
        final orderId = state.pathParameters['orderId']!;
        return TrackingScreen(orderId: orderId);
      },
    ),
  ],
);
