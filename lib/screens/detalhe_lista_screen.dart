import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/listas_repository.dart';

class DetalheListaScreen extends StatefulWidget {
  final Map<String, dynamic> lista;

  const DetalheListaScreen({
    super.key,
    required this.lista,
  });

  @override
  State<DetalheListaScreen> createState() =>
      _DetalheListaScreenState();
}

class _DetalheListaScreenState
    extends State<DetalheListaScreen> {
  late List<Map<String, dynamic>> produtos;

  double get totalAtual {
    return produtos.fold(
      0.0,
      (total, produto) =>
          total +
          (produto['subtotal'] as num).toDouble(),
    );
  }

  @override
  void initState() {
    super.initState();

    produtos = List<Map<String, dynamic>>.from(
      widget.lista['produtos'] ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          widget.lista['nomeLista'],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              widget.lista['nomeLista'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Data: ${formatoData.format(DateTime.parse(widget.lista['data']))}',
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
                        produto['nome'],
                      ),
                      subtitle: Text(
                        'Categoria: ${produto['categoria']}\n'
                        '${produto['quantidade']} x '
                        '${formatoMoeda.format(produto['preco'])}',
                      ),
                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Text(
                            formatoMoeda.format(
                              produto['subtotal'],
                            ),
                          ),

                          IconButton(
  icon: const Icon(
    Icons.edit,
    color: Colors.blue,
  ),
  onPressed: () async {
    final nomeController =
        TextEditingController(
      text: produto['nome'],
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Editar Produto',
          ),
          content: TextField(
            controller: nomeController,
            decoration:
                const InputDecoration(
              labelText:
                  'Nome do Produto',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  produto['nome'] =
                      nomeController.text;
                });

                await ListasRepository
                    .salvarListas();

                if (mounted) {
                  Navigator.pop(
                    context,
                  );
                }
              },
              child: const Text(
                'Salvar',
              ),
            ),
          ],
        );
      },
    );
  },
),
                              onPressed: () {
                                // editar produto
                                },
                                ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed:
                                () async {
                              final confirmar =
                                  await showDialog<bool>(
                                context:
                                    context,
                                builder:
                                    (context) {
                                  return AlertDialog(
                                    title:
                                        const Text(
                                      'Excluir produto',
                                    ),
                                    content:
                                        const Text(
                                      'Deseja realmente excluir este produto?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () {
                                          Navigator.pop(
                                            context,
                                            false,
                                          );
                                        },
                                        child:
                                            const Text(
                                          'Cancelar',
                                        ),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () {
                                          Navigator.pop(
                                            context,
                                            true,
                                          );
                                        },
                                        child:
                                            const Text(
                                          'Excluir',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmar == true) {
  setState(() {
    produtos.removeAt(
      index,
    );

    widget.lista['produtos'] =
        produtos;

    widget.lista['total'] =
        totalAtual;
  });

  await ListasRepository.salvarListas();

  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Produto removido com sucesso!',
        ),
      ),
    );
  }
}
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Total: ${formatoMoeda.format(totalAtual)}',
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