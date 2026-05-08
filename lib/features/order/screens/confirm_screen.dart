import 'package:flutter/material.dart';

/// Order confirmation screen.
class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Order')),
      body: Center(
        child: Text('Confirm Screen for order: $orderId'),
      ),
    );
  }
}
