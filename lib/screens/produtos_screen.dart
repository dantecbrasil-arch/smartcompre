import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/listas_repository.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  final TextEditingController nomeListaController =
      TextEditingController();

  final List<Map<String, dynamic>> produtos = [];

String filtroBusca = '';

final List<String> categorias = [
  'Mercearia',
  'Laticínios',
  'Carnes',
  'Bebidas',
  'Limpeza',
  'Hortifruti',
  'Farmácia',
  'Outros',
];

  double total = 0.0;

  final formatoMoeda = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$ ',
  );

  void recalcularTotal() {
    total = 0;

    for (var produto in produtos) {
      total += produto['subtotal'];
    }
  }

  void adicionarProduto() {
    final nomeController = TextEditingController();

    final quantidadeController =
        TextEditingController(text: '1');
String categoriaSelecionada = 'Mercearia';

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
              DropdownButtonFormField<String>(
  value: categoriaSelecionada,
  decoration: const InputDecoration(
    labelText: 'Categoria',
  ),
  items: categorias.map((categoria) {
    return DropdownMenuItem(
      value: categoria,
      child: Text(categoria),
    );
  }).toList(),
  onChanged: (value) {
    categoriaSelecionada = value!;
  },
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
              onPressed: () => Navigator.pop(context),
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
  'categoria': categoriaSelecionada,
  'quantidade': quantidade,
  'preco': preco,
  'subtotal': subtotal,
}); 

                  recalcularTotal();
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

  void editarProduto(int index) {
    final produto = produtos[index];

String categoriaSelecionada =
    produto['categoria'] ?? 'Mercearia';

    final nomeController = TextEditingController(
      text: produto['nome'],
    );

    final quantidadeController =
        TextEditingController(
      text: produto['quantidade'].toString(),
    );

    final precoController =
        TextEditingController(
      text: produto['preco']
          .toStringAsFixed(2)
          .replaceAll('.', ','),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Produto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
                ),
              ),

DropdownButtonFormField<String>(
  value: categoriaSelecionada,
  decoration: const InputDecoration(
    labelText: 'Categoria',
  ),
  items: categorias.map((categoria) {
    return DropdownMenuItem(
      value: categoria,
      child: Text(categoria),
    );
  }).toList(),
  onChanged: (value) {
    categoriaSelecionada = value!;
  },
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
              onPressed: () => Navigator.pop(context),
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
                  
produtos[index] = {
  'nome': nome,
  'categoria': categoriaSelecionada,
  'quantidade': quantidade,
  'preco': preco,
  'subtotal': subtotal,
};
                  recalcularTotal();
                });

                Navigator.pop(context);
              },
              child: const Text(
                'Salvar Alterações',
              ),
            ),
          ],
        );
      },
    );
  }

  void excluirProduto(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Produto'),
          content: Text(
            'Deseja excluir ${produtos[index]['nome']}?',
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
                setState(() {
                  produtos.removeAt(index);

                  recalcularTotal();
                });

                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

void salvarLista() {
  if (nomeListaController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Informe o nome da lista.',
        ),
      ),
    );
    return;
  }

  if (produtos.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Adicione ao menos um produto.',
        ),
      ),
    );
    return;
  }

  ListasRepository.listasSalvas.add({
  'nomeLista': nomeListaController.text,
  'data': DateTime.now(),
  'total': total,
  'produtos': List.from(produtos),
});

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Lista "${nomeListaController.text}" salva com sucesso!',
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {

final produtosFiltrados =
    produtos.where((produto) {
  return produto['nome']
      .toLowerCase()
      .contains(filtroBusca);
}).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Criar Lista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
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
              label: const Text(
                'Escanear Produto',
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: adicionarProduto,
              icon: const Icon(Icons.add),
              label: const Text(
                'Adicionar Manualmente',
              ),
            ),

            const SizedBox(height: 20),

            Row(
  children: [
    const Text(
      'Produtos Adicionados',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    const Spacer(),

if (filtroBusca.isNotEmpty)
  TextButton.icon(
    onPressed: () {
      setState(() {
        filtroBusca = '';
      });
    },
    icon: const Icon(
      Icons.arrow_back,
      size: 18,
    ),
    label: const Text('Voltar'),
  ),

TextButton.icon(
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Buscar Produto',
          ),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Digite o nome...',
            ),
            onChanged: (value) {
              setState(() {
                filtroBusca =
                    value.toLowerCase();
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Concluir',
              ),
            ),
          ],
        );
      },
    );
  },
  icon: const Icon(
    Icons.search,
    size: 18,
  ),
  label: const Text(
    'Pesquisar',
  ),
),
  ],
),

            const SizedBox(height: 10),

            Expanded(
              child: produtos.isEmpty
                  ? const Text(
                      'Nenhum produto adicionado.',
                    )
                  : ListView.builder(
                      itemCount: produtosFiltrados.length,
                      itemBuilder:
                          (context, index) {
                        final produto = produtosFiltrados[index];

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

                            trailing: Row(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                Text(
                                  formatoMoeda.format(
                                    produto['subtotal'],
                                  ),
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    editarProduto(
                                      index,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color:
                                        Colors.blue,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    excluirProduto(
                                      index,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
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
                onPressed: salvarLista,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Salvar Lista',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}