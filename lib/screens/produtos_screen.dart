import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  final TextEditingController nomeListaController =
      TextEditingController();

  final List<Map<String, dynamic>> produtos = [];

  double total = 0.0;

  final formatoMoeda = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$ ',
  );

  void adicionarProduto() {
    final nomeController = TextEditingController();

    final quantidadeController =
        TextEditingController(text: '1');

    final precoController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Produto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
                ),
              ),
              TextField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                ),
              ),
              TextField(
                controller: precoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preço Unitário',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final nome = nomeController.text;

                final quantidade =
                    int.tryParse(
                          quantidadeController.text,
                        ) ??
                        1;

                final textoPreco = precoController.text
                    .replaceAll('.', '')
                    .replaceAll(',', '.');

                final preco =
                    double.tryParse(textoPreco) ?? 0.0;

                final subtotal =
                    quantidade * preco;

                setState(() {
                  produtos.add({
                    'nome': nome,
                    'quantidade': quantidade,
                    'preco': preco,
                    'subtotal': subtotal,
                  });

                  total += subtotal;
                });

                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Criar Lista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nome da Lista',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: nomeListaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ex: Compra do Mês',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt),
              label: const Text('Escanear Produto'),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: adicionarProduto,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Manualmente'),
            ),

            const SizedBox(height: 20),

            const Text(
              'Produtos Adicionados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: produtos.isEmpty
                  ? const Text(
                      'Nenhum produto adicionado.',
                    )
                  : ListView.builder(
                      itemCount: produtos.length,
                      itemBuilder: (context, index) {
                        final produto =
                            produtos[index];

                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.shopping_cart,
                            ),
                            title: Text(
                              '${produto['nome']} | '
                              '${produto['quantidade']} x '
                              '${formatoMoeda.format(produto['preco'])}',
                            ),
                            trailing: Text(
                              formatoMoeda.format(
                                produto['subtotal'],
                              ),
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            Text(
              'Total: ${formatoMoeda.format(total)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save),
                label: const Text('Salvar Lista'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}