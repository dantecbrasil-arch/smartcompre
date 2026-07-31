import 'package:flutter/material.dart';

class ListasScreen extends StatelessWidget {
  const ListasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Minhas Listas'),
      ),
      body: const Center(
        child: Text(
          'Nenhuma lista salva ainda.',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}