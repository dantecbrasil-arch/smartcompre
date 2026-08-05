import 'package:flutter/material.dart';
import 'screens/produtos_screen.dart';
import 'screens/listas_screen.dart';
import 'data/listas_repository.dart';

Future<void> main() async {
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController localController =
      TextEditingController();

  final TextEditingController listaController =
      TextEditingController();

  @override
  void dispose() {
    localController.dispose();
    listaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habilitarCriacao =
        localController.text.trim().isNotEmpty &&
        listaController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartCompre'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
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

                const SizedBox(height: 30),

                TextField(
                  controller: localController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Local',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.store),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: listaController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Lista',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.list_alt),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: 250,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: habilitarCriacao
    ? () async {

        ListasRepository.listasSalvas.add({
          'nomeLocal': localController.text.trim(),
          'nomeLista': listaController.text.trim(),
          'data': DateTime.now().toIso8601String(),
          'total': 0.0,
          'produtos': [],
        });

        await ListasRepository.salvarListas();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProdutosScreen(
              nomeLocal: localController.text.trim(),
              nomeLista: listaController.text.trim(),
            ),
          ),
        );
      }
    : null,
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
                          builder: (_) =>
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
      ),
    );
  }
}