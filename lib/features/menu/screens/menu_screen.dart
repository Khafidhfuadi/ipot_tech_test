import 'package:flutter/material.dart';

/// Menu listing screen for a specific table.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.tableId});

  final String tableId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu - Table $tableId')),
      body: Center(
        child: Text('Menu Screen for table: $tableId'),
      ),
    );
  }
}
