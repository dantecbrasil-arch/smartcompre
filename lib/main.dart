import 'package:flutter/material.dart';
import 'screens/produtos_screen.dart';

void main() {
  runApp(const SmartCompreApp());
}

class SmartCompreApp extends StatelessWidget {
  const SmartCompreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartCompre',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartCompre'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_cart,
                size: 100,
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              const Text(
                'Bem-vindo ao SmartCompre',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ProdutosScreen(),
    ),
  );
},
                child: const Text('🛒 Criar Lista'),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
          
                onPressed: () {},
                child: const Text('📷 Escanear Produtos'),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {},
                child: const Text('📋 Minhas Listas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}