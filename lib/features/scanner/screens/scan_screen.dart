import 'package:flutter/material.dart';

/// QR/barcode scanner screen.
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan')),
      body: const Center(
        child: Text('Scan Screen'),
      ),
    );
  }
}
