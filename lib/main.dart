import 'package:flutter/material.dart';
import 'screens/produtos_screen.dart';
import 'screens/listas_screen.dart';
import 'data/listas_repository.dart';

Future<void> main() async {
  print('APP INICIOU');

  WidgetsFlutterBinding.ensureInitialized();

  await ListasRepository.carregarListas();

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
            children: [
              const Icon(
                Icons.shopping_cart,
                size: 130,
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              const Text(
                'Bem-vindo ao SmartCompre',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: 250,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ProdutosScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '🛒 Criar Lista',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 250,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ListasScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '📋 Minhas Listas',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}