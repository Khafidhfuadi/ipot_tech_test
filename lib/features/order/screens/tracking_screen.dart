import 'package:flutter/material.dart';

/// Order tracking screen.
class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: Center(
        child: Text('Tracking Screen for order: $orderId'),
      ),
    );
  }
}
