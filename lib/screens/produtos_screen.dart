import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/listas_repository.dart';
import 'package:smartcompre/screens/camera_screen.dart';
import 'package:smartcompre/models/item_compra.dart';
import 'listas_screen.dart';

class ProdutosScreen extends StatefulWidget {
  final String nomeLocal;
  final String nomeLista;

  const ProdutosScreen({
    super.key,
    required this.nomeLocal,
    required this.nomeLista,
  });

  @override
  State<ProdutosScreen> createState() =>
      _ProdutosScreenState();
}

class _ProdutosScreenState
    extends State<ProdutosScreen> {

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
              onPressed: () async {
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

final indiceLista =
    ListasRepository.listasSalvas.indexWhere(
  (lista) =>
      lista['nomeLista'] ==
      widget.nomeLista,
);

if (indiceLista != -1) {
  ListasRepository.listasSalvas[indiceLista]
      ['produtos'] = produtos;

  ListasRepository.listasSalvas[indiceLista]
      ['total'] = total;

  await ListasRepository.salvarListas();
}

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
        title: const Text('🛒 Cadastro de Produtos'),
      ),
      body: SafeArea(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
  widget.nomeLista,
  style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 8),

Text(
  '📍 ${widget.nomeLocal}',
  style: const TextStyle(
    fontSize: 16,
    color: Colors.grey,
  ),
),

const SizedBox(height: 20),
        

        Row(
          children: [
            const Expanded(
              child: Text(
                'Produtos Adicionados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            if (filtroBusca.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    filtroBusca = '';
                  });
                },
                icon: const Icon(Icons.arrow_back),
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
                        decoration:
                            const InputDecoration(
                          hintText:
                              'Digite o nome...',
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
                          child:
                              const Text('Concluir'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Pesquisar'),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Expanded(
          child: produtosFiltrados.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum produto adicionado.',
                  ),
                )
              : ListView.builder(
                  itemCount:
                      produtosFiltrados.length,
                  itemBuilder:
                      (context, index) {
                    final produto =
                        produtosFiltrados[index];

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
                        subtitle: Text(
                          'Subtotal: ${formatoMoeda.format(produto['subtotal'])}',
                        ),
                        trailing: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                editarProduto(
                                  index,
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
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

        const SizedBox(height: 10),

SizedBox(
  width: double.infinity,
  height: 60,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ListasScreen(),
        ),
      );
    },
    icon: const Icon(Icons.list_alt),
    label: const Text(
      'Minhas Listas',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

const SizedBox(height: 12),

Text(
  '💰 Total: ${formatoMoeda.format(total)}',
  style: const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 12),

Row(
  children: [

    Expanded(
  child: ElevatedButton.icon(
    onPressed: () async {
      final item =
          await Navigator.push<ItemCompra>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const CameraScreen(),
        ),
      );

      if (item != null) {
        setState(() {
          produtos.add({
            'nome': item.produto,
            'categoria': 'Hortifruti',
            'quantidade': 1,
            'preco': item.precoKg ?? 0,
            'subtotal': item.total ?? 0,
          });

          recalcularTotal();
        });

        final indiceLista =
            ListasRepository.listasSalvas.indexWhere(
          (lista) =>
              lista['nomeLista'] ==
              widget.nomeLista,
        );

        if (indiceLista != -1) {
          ListasRepository
                  .listasSalvas[indiceLista]
              ['produtos'] = produtos;

          ListasRepository
                  .listasSalvas[indiceLista]
              ['total'] = total;

          await ListasRepository.salvarListas();
        }
      }
    },
    icon: const Icon(
      Icons.photo_camera,
      size: 28,
    ),
    label: const Text(
      'Capturar',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(60),
    ),
  ),
),
    const SizedBox(width: 8),

  Expanded(
  child: ElevatedButton.icon(
    onPressed: adicionarProduto,
    icon: const Icon(
      Icons.edit,
      size: 28,
    ),
    label: const Text(
      'Digitar',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(60),
    ),
  ),
),

  ],
),
const SizedBox(height: 16),

SizedBox(
  width: double.infinity,
  height: 60,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ListasScreen(),
        ),
      );
    },
    icon: const Icon(Icons.list_alt),
    label: const Text(
      'Minhas Listas',
    ),
  ),
),
      ],
    ),
  ),
),
  
bottomNavigationBar: Container(
  height: 120,
  color: Colors.grey.shade200,
  child: const Center(
    child: Text(
      'Espaço para Banner',
    ),
  ),
),
  
);
}
}
