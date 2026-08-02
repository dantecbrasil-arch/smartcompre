import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/listas_repository.dart';

class DetalheListaScreen extends StatelessWidget {
  final Map<String, dynamic> lista;

  const DetalheListaScreen({
    super.key,
    required this.lista,
  });

  @override
  Widget build(BuildContext context) {
    final produtos =
    List<Map<String, dynamic>>.from(
      lista['produtos'] ?? [],
    );

    final formatoMoeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
    );

    final formatoData = DateFormat(
      'dd/MM/yyyy',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lista['nomeLista'],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              lista['nomeLista'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
  'Data: ${formatoData.format(DateTime.parse(lista['data']))}',
  style: const TextStyle(
    fontSize: 16,
  ),
),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
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
  '🏷️ ${produto['categoria']} | '
  '${produto['quantidade']} x '
  '${formatoMoeda.format(produto['preco'])}',
),

                      trailing: Text(
                        formatoMoeda.format(
                          produto['subtotal'],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Text(
              'Total: ${formatoMoeda.format(lista['total'])}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}