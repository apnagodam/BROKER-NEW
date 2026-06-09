import 'package:flutter/material.dart';
 
// ─── Trade Power Statement ────────────────────────────────────────────────────
class TradePowerStatementPage extends StatelessWidget {
  const TradePowerStatementPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Power Statement'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Trade Power Statement — UI coming soon'),
      ),
    );
  }
}