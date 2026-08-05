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
  '📍 ${widget.lista['nomeLocal'] ?? 'Local não informado'}',
  style: const TextStyle(
    fontSize: 16,
  ),
),

const SizedBox(height: 6),

Text(
  '📅 ${formatoData.format(DateTime.parse(widget.lista['data']))}',
  style: const TextStyle(
    fontSize: 16,
  ),
),

            const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
  final nomeController = TextEditingController();
  final categoriaController =
      TextEditingController(text: 'Outros');
  final quantidadeController =
      TextEditingController(text: '1');
  final precoController =
      TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Adicionar Produto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              TextField(
                controller: categoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
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
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Preço',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final quantidade =
                  int.tryParse(
                        quantidadeController.text,
                      ) ??
                      1;

              final preco =
                  double.tryParse(
                        precoController.text
                            .replaceAll(',', '.'),
                      ) ??
                      0;

              setState(() {
                produtos.add({
                  'nome': nomeController.text,
                  'categoria':
                      categoriaController.text,
                  'quantidade': quantidade,
                  'preco': preco,
                  'subtotal':
                      quantidade * preco,
                });

                widget.lista['produtos'] =
                    produtos;

                widget.lista['total'] =
                    totalAtual;
              });

              await ListasRepository
                  .salvarListas();

              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      );
    },
  );
},
    icon: const Icon(Icons.add),
    label: const Text(
      'Adicionar Produto',
    ),
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

final categoriaController =
    TextEditingController(
  text: produto['categoria'],
);

final quantidadeController =
    TextEditingController(
  text: produto['quantidade'].toString(),
);

final precoController =
    TextEditingController(
  text: produto['preco'].toString(),
);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Editar Produto',
          ),
          content: SingleChildScrollView(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextField(
        controller: nomeController,
        decoration: const InputDecoration(
          labelText: 'Nome',
        ),
      ),

      const SizedBox(height: 10),

      TextField(
        controller: categoriaController,
        decoration: const InputDecoration(
          labelText: 'Categoria',
        ),
      ),

      const SizedBox(height: 10),

      TextField(
        controller: quantidadeController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Quantidade',
        ),
      ),

      const SizedBox(height: 10),

      TextField(
        controller: precoController,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        decoration: const InputDecoration(
          labelText: 'Preço',
        ),
      ),
    ],
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
  final quantidade =
      int.tryParse(
        quantidadeController.text,
      ) ??
      0;

  final preco =
      double.tryParse(
        precoController.text
            .replaceAll(',', '.'),
      ) ??
      0;

  setState(() {
    produto['nome'] =
        nomeController.text;

    produto['categoria'] =
        categoriaController.text;

    produto['quantidade'] =
        quantidade;

    produto['preco'] = preco;

    produto['subtotal'] =
        quantidade * preco;

    widget.lista['total'] =
        totalAtual;
  });

  await ListasRepository
      .salvarListas();

  if (mounted) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Produto atualizado!',
        ),
      ),
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