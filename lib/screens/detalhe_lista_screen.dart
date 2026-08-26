import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/listas_repository.dart';
import 'camera_screen.dart';
import '../models/item_compra.dart';

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

if (false)
  SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
    onPressed: () {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

           ListTile(
  leading: const Icon(Icons.camera_alt),
  title: const Text(
    'Capturar Etiqueta',
  ),
  onTap: () async {
    Navigator.pop(context);

    final item =
        await Navigator.push<ItemCompra>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const CameraScreen(),
      ),
    );

    if (item != null) {
      setState(() {
        produtos.insert(0, {
          'nome': item.produto,
          'peso': item.peso,
          'categoria': item.categoria,
          'quantidade': item.quantidade,
          'preco': item.precoKg ??
               item.total ??
               0.0,
          'subtotal': item.total ?? 0,
        });

        widget.lista['produtos'] =
            produtos;

        widget.lista['total'] =
            totalAtual;
      });

      await ListasRepository.salvarListas();
    }
  },
), 

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(
                'Inserir Manualmente',
              ),
              onTap: () {
                Navigator.pop(context);

                final nomeController =
                    TextEditingController();

                final categoriaController =
                    TextEditingController(
                  text: 'Outros',
                );

                      final pesoController =
                          TextEditingController(
                            text: '',
                   );
                   
  

                final quantidadeController =
                    TextEditingController(
                  text: '1',
                );

                final precoController =
                    TextEditingController();

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Adicionar Produto',
                      ),
                      content:
                          SingleChildScrollView(
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            TextField(
                              controller:
                                  nomeController,
                              decoration:
                                  const InputDecoration(
                                labelText: 'Nome',
                              ),
                            ),
                            TextField(
                              controller:
                                  categoriaController,
                              decoration:
                                  const InputDecoration(
                                labelText:
                                    'Categoria',
                              ),
                            ),
                            TextField(
                              controller: pesoController,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Peso (kg)',
                             ),
                            ),
                            TextField(
                              controller:
                                  quantidadeController,
                              keyboardType:
                                  TextInputType
                                      .number,
                              decoration:
                                  const InputDecoration(
                                labelText:
                                    'Quantidade',
                              ),
                            ),
                            TextField(
                              controller:
                                  precoController,
                              keyboardType:
                                  const TextInputType
                                      .numberWithOptions(
                                decimal: true,
                              ),
                              decoration:
                                  const InputDecoration(
                                labelText: 'Preço',
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          child:
                              const Text(
                            'Cancelar',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final quantidade =
                                int.tryParse(
                                      quantidadeController
                                          .text,
                                    ) ??
                                    1;

                            final preco =
                                double.tryParse(
                                      precoController
                                          .text
                                          .replaceAll(
                                            ',',
                                            '.',
                                          ),
                                    ) ??
                                    0;

                            final peso =
                                double.tryParse(
                                      pesoController
                                           .text
                                           .replaceAll(',', '.'),
                                    ) ??
                                    0;

                            setState(() {
                              produtos.add({
                                'nome':
                                    nomeController
                                        .text,
                                'categoria':
                                    categoriaController
                                        .text,
                                'quantidade':
                                    quantidade,
                                'preco':
                                    preco,
                                'subtotal':
                                    quantidade *
                                        preco,
                              });

                              widget.lista[
                                  'produtos'] = produtos;

                              widget.lista[
                                  'total'] =
                                  totalAtual;
                            });

                            await ListasRepository
                                .salvarListas();

                            if (mounted) {
                              Navigator.pop(
                                context,
                              );
                            }
                          },
                          child:
                              const Text(
                            'Salvar',
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

                    ],
        ),
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
                      leading: CircleAvatar(
                        child: Text(
                          '${produtos.length - index}',
                        ),
                      ),
                      title: Text(
                        produto['nome'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                   ),
                      subtitle: Text(
                        'Categoria: ${produto['categoria']}\n'
                        'Peso: ${produto['peso'] ?? '-'} kg\n'
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

final pesoController =
    TextEditingController(
  text: (produto['peso'] ?? '').toString(),
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
        controller: pesoController,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
  decoration: const InputDecoration(
    labelText: 'Peso (kg)',
  ),
),
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

  final peso =
      double.tryParse(
        pesoController.text
           .replaceAll(',', '.'),
      ) ??
      0;

  setState(() {
    produto['nome'] =
        nomeController.text;

    produto['categoria'] =
        categoriaController.text;

    produto['peso'] = peso;

    produto['quantidade'] =
        quantidade;

    produto['preco'] = preco;

    produto['subtotal'] =
    double.parse(
      (
        peso > 0
            ? peso * preco
            : quantidade * preco
      ).toStringAsFixed(2),
    );


    produto['nome'] =
    nomeController.text;

    widget.lista['produtos'] = produtos;

    widget.lista['total'] = produtos.fold(
  0.0,
  (total, produto) =>
      total +
      (produto['subtotal'] as num).toDouble(),
     );
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
                                  produtos.removeAt(index);

                                  widget.lista['produtos'] = 
                                      produtos;

                                  widget.lista['total'] =
                                     totalAtual;
                                });

                                await ListasRepository.salvarListas();

                                if (mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
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

            const Center(
              child: Text(
                'Adicionar Produto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

const SizedBox(height: 5),

Row(
  children: [
    Expanded(
      child: ElevatedButton.icon(
onPressed: () async {

  final item =
      await Navigator.push<ItemCompra>(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const CameraScreen(),
    ),
  );

  if (item == null) {
    return;
  }

  setState(() {

    produtos.insert(0, {
      'nome': item.produto,
      'peso': item.peso,
      'categoria': item.categoria,
      'quantidade': item.quantidade,
      'preco': item.precoKg ??
          item.total ??
          0.0,
      'subtotal': item.total ?? 0.0,
    });

    widget.lista['produtos'] = produtos;

    widget.lista['total'] = totalAtual;
  });

  await ListasRepository.salvarListas();
},
icon: const Icon(Icons.camera_alt),
label: const Text(
  'Capturar',
  style: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  ),
 ),
),
),

    const SizedBox(width: 10),

    Expanded(
      child: ElevatedButton.icon(
        onPressed: () {
  final nomeController =
      TextEditingController();

  final categoriaController =
      TextEditingController(
    text: 'Outros',
  );

  final pesoController =
      TextEditingController();

  final quantidadeController =
      TextEditingController(
    text: '1',
  );

  final precoController =
      TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Adicionar Produto',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: nomeController,
                decoration:
                    const InputDecoration(
                  labelText: 'Nome',
                ),
              ),

              TextField(
                controller:
                    categoriaController,
                decoration:
                    const InputDecoration(
                  labelText: 'Categoria',
                ),
              ),

              TextField(
                controller: pesoController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                    const InputDecoration(
                  labelText: 'Peso (kg)',
                ),
              ),

              TextField(
                controller:
                    quantidadeController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Quantidade',
                ),
              ),

              TextField(
                controller:
                    precoController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                    const InputDecoration(
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

          ElevatedButton(
            onPressed: () async {

              final quantidade =
                  int.tryParse(
                        quantidadeController
                            .text,
                      ) ??
                      1;

              final preco =
                  double.tryParse(
                        precoController.text
                            .replaceAll(
                              ',',
                              '.',
                            ),
                      ) ??
                      0;

              final peso =
                  double.tryParse(
                        pesoController.text
                            .replaceAll(
                              ',',
                              '.',
                            ),
                      ) ??
                      0;

              final subtotal =
                  peso > 0
                      ? peso * preco
                      : quantidade * preco;

              setState(() {

                produtos.add({
                  'nome':
                      nomeController.text,
                  'categoria':
                      categoriaController
                          .text,
                  'peso': peso,
                  'quantidade':
                      quantidade,
                  'preco': preco,
                  'subtotal': subtotal,
                });

                widget.lista[
                    'produtos'] = produtos;

                widget.lista[
                    'total'] = totalAtual;
              });

              await ListasRepository
                  .salvarListas();

              if (mounted) {
                Navigator.pop(
                  context,
                );
              }
            },
            child:
                const Text('Salvar'),
          ),
        ],
      );
    },
  );
},
        icon: const Icon(Icons.edit),
        label: const Text(
          'Digitar',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  ],
),

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