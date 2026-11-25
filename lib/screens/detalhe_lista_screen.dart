import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/listas_repository.dart';
import 'camera_screen.dart';
import '../models/item_compra.dart';
import '../core/constants/categorias_por_tipo.dart';
import '../core/utils/categoria_normalizer.dart';
import '../core/utils/nome_produto_manual_normalizer.dart';
import '../core/utils/ordenacao_alfabetica.dart';
import '../data/catalogo/categorias_por_tipo_repository.dart';

class DetalheListaScreen extends StatefulWidget {
  final Map<String, dynamic> lista;

  const DetalheListaScreen({super.key, required this.lista});

  @override
  State<DetalheListaScreen> createState() => _DetalheListaScreenState();
}

class _DetalheListaScreenState extends State<DetalheListaScreen> {
  late List<Map<String, dynamic>> produtos;

  double get totalAtual {
    return produtos.fold(
      0.0,
      (total, produto) => total + (produto['subtotal'] as num).toDouble(),
    );
  }

  String get _tipoEstabelecimento {
    final tipo = widget.lista['tipo'];

    if (tipo is! String || tipo.trim().isEmpty) {
      return 'Outros';
    }

    return tipo;
  }

  Future<ResultadoCategoriasOrdenadas> _carregarCategoriasDoTipo({
    String? categoriaSelecionada,
  }) async {
    final categoriasPadrao = CategoriasPorTipo.obter(_tipoEstabelecimento);
    final categoriasPersonalizadas =
        await CategoriasPorTipoRepository.obterCategorias(_tipoEstabelecimento);

    return combinarCategoriasOrdenadas(
      categoriasPadrao,
      categoriasPersonalizadas,
      categoriaSelecionada: categoriaSelecionada,
    );
  }

  @override
  void initState() {
    super.initState();

    produtos = List<Map<String, dynamic>>.from(widget.lista['produtos'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ');

    final formatoData = DateFormat('dd/MM/yyyy');
    final valorData = widget.lista['data'];
    final dataCriacao = valorData is DateTime
        ? valorData
        : valorData is String
        ? DateTime.tryParse(valorData.trim())
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(widget.lista['nomeLista'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lista['nomeLista'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📍 ${widget.lista['nomeLocal'] ?? 'Local não informado'}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  '🏠 ${widget.lista['endereco'] ?? '-'}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  '🏷 ${widget.lista['tipo'] ?? '-'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              '📅 ${dataCriacao == null ? 'Data não informada' : formatoData.format(dataCriacao)}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  final produto = produtos[index];

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${produtos.length - index}'),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(formatoMoeda.format(produto['subtotal'])),

                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final nomeController = TextEditingController(
                                text: produto['nome'],
                              );

                              final pesoController = TextEditingController(
                                text: (produto['peso'] ?? '').toString(),
                              );

                              final categoriaController = TextEditingController(
                                text: produto['categoria'],
                              );

                              final quantidadeController =
                                  TextEditingController(
                                    text: produto['quantidade'].toString(),
                                  );

                              final precoController = TextEditingController(
                                text: produto['preco'].toString(),
                              );

                              final resultadoCategorias =
                                  await _carregarCategoriasDoTipo(
                                    categoriaSelecionada:
                                        categoriaController.text,
                                  );

                              if (!context.mounted) return;

                              categoriaController.text =
                                  resultadoCategorias.categoriaSelecionada!;

                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setDialogState) {
                                      final categoriasDropdown =
                                          resultadoCategorias.categorias;

                                      return AlertDialog(
                                        title: const Text('Editar Produto'),
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

                                              const SizedBox(height: 10),
                                              InputDecorator(
                                                decoration:
                                                    const InputDecoration(
                                                      labelText: 'Categoria',
                                                    ),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    value: categoriaController
                                                        .text,
                                                    isExpanded: true,
                                                    items: categoriasDropdown
                                                        .map(
                                                          (categoria) =>
                                                              DropdownMenuItem(
                                                                value:
                                                                    categoria,
                                                                child: Text(
                                                                  categoria,
                                                                ),
                                                              ),
                                                        )
                                                        .toList(),
                                                    onChanged: (valor) {
                                                      categoriaController.text =
                                                          valor ?? 'Outros';
                                                      setDialogState(() {});
                                                    },
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(height: 10),

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
                                                      labelText: 'Quantidade',
                                                    ),
                                              ),

                                              const SizedBox(height: 10),

                                              TextField(
                                                controller: precoController,
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
                                            child: const Text('Cancelar'),
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
                                              final nome =
                                                  normalizarNomeProdutoManual(
                                                    nomeController.text,
                                                  );

                                              setState(() {
                                                produto['nome'] = nome;

                                                produto['categoria'] =
                                                    categoriaController.text;

                                                produto['peso'] = peso;

                                                produto['quantidade'] =
                                                    quantidade;

                                                produto['preco'] = preco;

                                                produto['subtotal'] =
                                                    double.parse(
                                                      (peso > 0
                                                              ? peso * preco
                                                              : quantidade *
                                                                    preco)
                                                          .toStringAsFixed(2),
                                                    );

                                                produto['nome'] = nome;

                                                widget.lista['produtos'] =
                                                    produtos;

                                                widget.lista['total'] = produtos
                                                    .fold(
                                                      0.0,
                                                      (total, produto) =>
                                                          total +
                                                          (produto['subtotal']
                                                                  as num)
                                                              .toDouble(),
                                                    );
                                              });

                                              await ListasRepository.salvarListas();

                                              if (!context.mounted) return;

                                              Navigator.pop(context);

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Produto atualizado!',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text('Salvar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final messenger = ScaffoldMessenger.of(context);

                              final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Excluir produto'),
                                    content: const Text(
                                      'Deseja realmente excluir este produto?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text('Excluir'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (!mounted) return;

                              if (confirmar == true) {
                                setState(() {
                                  produtos.removeAt(index);

                                  widget.lista['produtos'] = produtos;

                                  widget.lista['total'] = totalAtual;
                                });

                                await ListasRepository.salvarListas();

                                if (!mounted) return;

                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Produto removido com sucesso!',
                                    ),
                                  ),
                                );
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 5),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final item = await Navigator.push<ItemCompra>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CameraScreen(
                            tipoEstabelecimento:
                                widget.lista['tipo'] ?? 'Outros',
                          ),
                        ),
                      );

                      if (!context.mounted) return;

                      if (item == null) {
                        return;
                      }

                      setState(() {
                        produtos.insert(0, {
                          'nome': item.produto,
                          'peso': item.peso,
                          'categoria': item.categoria,
                          'quantidade': item.quantidade,
                          'preco': item.precoKg ?? item.total ?? 0.0,
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
                    onPressed: () async {
                      final categoriasSemSelecao =
                          await _carregarCategoriasDoTipo();

                      if (!context.mounted) return;

                      final categoriaInicial =
                          categoriasSemSelecao.categorias.contains('Outros')
                          ? 'Outros'
                          : CategoriasPorTipo.obter(_tipoEstabelecimento).first;
                      final resultadoCategorias = combinarCategoriasOrdenadas(
                        categoriasSemSelecao.categorias,
                        const [],
                        categoriaSelecionada: categoriaInicial,
                      );
                      final categoriasDropdown = resultadoCategorias.categorias;

                      final nomeController = TextEditingController();

                      final categoriaController = TextEditingController(
                        text: resultadoCategorias.categoriaSelecionada!,
                      );

                      final pesoController = TextEditingController();

                      final quantidadeController = TextEditingController(
                        text: '1',
                      );

                      final precoController = TextEditingController();

                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setDialogState) {
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

                                      InputDecorator(
                                        decoration: const InputDecoration(
                                          labelText: 'Categoria',
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: categoriaController.text,
                                            isExpanded: true,
                                            items: categoriasDropdown
                                                .map(
                                                  (categoria) =>
                                                      DropdownMenuItem<String>(
                                                        value: categoria,
                                                        child: Text(categoria),
                                                      ),
                                                )
                                                .toList(),
                                            onChanged: (valor) {
                                              categoriaController.text =
                                                  valor ?? 'Outros';
                                              setDialogState(() {});
                                            },
                                          ),
                                        ),
                                      ),

                                      TextField(
                                        controller: pesoController,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
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
                                            precoController.text.replaceAll(
                                              ',',
                                              '.',
                                            ),
                                          ) ??
                                          0;

                                      final peso =
                                          double.tryParse(
                                            pesoController.text.replaceAll(
                                              ',',
                                              '.',
                                            ),
                                          ) ??
                                          0;

                                      final subtotal = peso > 0
                                          ? peso * preco
                                          : quantidade * preco;
                                      final nome = normalizarNomeProdutoManual(
                                        nomeController.text,
                                      );
                                      final categoria = normalizarCategoria(
                                        categoriaController.text,
                                      );

                                      setState(() {
                                        produtos.insert(0, {
                                          'nome': nome,
                                          'categoria': categoria,
                                          'peso': peso,
                                          'quantidade': quantidade,
                                          'preco': preco,
                                          'subtotal': subtotal,
                                        });

                                        widget.lista['produtos'] = produtos;

                                        widget.lista['total'] = totalAtual;
                                      });

                                      await ListasRepository.salvarListas();

                                      if (!context.mounted) return;

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Salvar'),
                                  ),
                                ],
                              );
                            },
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
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
