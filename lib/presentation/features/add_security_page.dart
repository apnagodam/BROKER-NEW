// ─── Add Security ─────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

class AddSecurityPage extends StatelessWidget {
  const AddSecurityPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text('Add Security'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center( 
        child: Text('Add Security — UI coming soon'),
      ),
    );
  }
}