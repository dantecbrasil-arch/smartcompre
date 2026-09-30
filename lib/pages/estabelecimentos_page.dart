import 'package:flutter/material.dart';

import '../models/estabelecimento.dart';
import '../repositorios/estabelecimentos_repository.dart';
import '../core/tipos_estabelecimento.dart';

class EstabelecimentosPage extends StatefulWidget {
  const EstabelecimentosPage({
    super.key,
  });

  @override
  State<EstabelecimentosPage> createState() =>
      _EstabelecimentosPageState();
}

class _EstabelecimentosPageState
    extends State<EstabelecimentosPage> {
  final _repository =
      EstabelecimentosRepository();

  List<Estabelecimento> _estabelecimentos = [];
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista =
        await _repository.carregar();

    setState(() {
      _estabelecimentos = lista;
    });

    debugPrint(
      'ESTABELECIMENTOS: ${lista.length}',
    );
  }

  Future<void> _abrirCadastro({
  Estabelecimento? estabelecimento,
}) async {
    final nomeController =
    TextEditingController(
  text: estabelecimento?.nome ?? '',
);

final cidadeController =
    TextEditingController(
  text: estabelecimento?.cidade ?? '',
);

final enderecoController =
    TextEditingController(
  text: estabelecimento?.endereco ?? '',
);

String tipoSelecionado =
    estabelecimento?.tipo ??
    TiposEstabelecimento.mercado;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              title: const Text(
                'Novo Estabelecimento',
              ),
              content: SingleChildScrollView(
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

                    const SizedBox(
                      height: 12,
                    ),

                    DropdownButtonFormField<
                        String>(
                      value:
                          tipoSelecionado,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Tipo',
                      ),
                      items:
                          TiposEstabelecimento
                              .todos
                              .map(
                                (tipo) =>
                                    DropdownMenuItem(
                                  value:
                                      tipo,
                                  child:
                                      Text(
                                    tipo,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) {
                        setDialogState(
                          () {
                            tipoSelecionado =
                                value!;
                          },
                        );
                      },
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextField(
                      controller:
                          cidadeController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Cidade',
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextField(
                      controller:
                          enderecoController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Endereço',
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
                  child: const Text(
                    'Cancelar',
                  ),
                ),
                ElevatedButton(
  onPressed: () async {
    if (nomeController.text
        .trim()
        .isEmpty) {
      return;
    }

    final lista =
        await _repository.carregar();

    if (estabelecimento != null) {
  final index = lista.indexWhere(
    (e) => e.id == estabelecimento.id,
  );

  if (index != -1) {
    lista[index] = Estabelecimento(
      id: estabelecimento.id,
      nome: nomeController.text.trim(),
      endereco: enderecoController.text.trim(),
      cidade: cidadeController.text.trim(),
      tipo: tipoSelecionado,
      placeId: estabelecimento.placeId,
      latitude: estabelecimento.latitude,
      longitude: estabelecimento.longitude,
    );
  }
} else {
  lista.add(
    Estabelecimento(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      nome: nomeController.text.trim(),
      endereco: enderecoController.text.trim(),
      cidade: cidadeController.text.trim(),
      tipo: tipoSelecionado,
    ),
  );
}

    await _repository.salvar(
      lista,
    );

    if (!mounted) return;

    Navigator.pop(
      context,
    );

    await _carregar();
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
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final estabelecimentosFiltrados =
    _estabelecimentos.where((e) {
  final texto =
      '${e.nome} ${e.endereco} ${e.tipo}'
          .toLowerCase();

  return texto.contains(
    _filtro.toLowerCase(),
  );
}).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estabelecimentos',
        ),
        actions: [
          IconButton(
            onPressed: _abrirCadastro,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: const InputDecoration(
          hintText:
              'Pesquisar estabelecimento',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _filtro = value;
          });
        },
      ),
    ),
    Expanded(
      child: estabelecimentosFiltrados
              .isEmpty
          ? const Center(
              child: Text(
                'Nenhum estabelecimento encontrado',
              ),
            )
          : ListView.builder(
              itemCount:
                  estabelecimentosFiltrados
                      .length,
              itemBuilder:
                  (context, index) {
                final estabelecimento =
                    estabelecimentosFiltrados[
                        index];

                return ListTile(
  leading: const Icon(
    Icons.store,
  ),

  title: Row(
    children: [
      Expanded(
        child: Text(
          estabelecimento.nome,
        ),
      ),

      IconButton(
  onPressed: () async {
    await _abrirCadastro(
      estabelecimento: estabelecimento,
    );
  },
        icon: const Icon(
          Icons.edit,
          color: Colors.blue,
        ),
      ),

      IconButton(
        onPressed: () async {
  final confirmar =
      await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Excluir estabelecimento',
        ),
        content: Text(
          '${estabelecimento.nome}\n\n'
          '📍 ${estabelecimento.endereco}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                false,
              );
            },
            child: const Text(
              'Cancelar',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                true,
              );
            },
            child: const Text(
              'Excluir',
            ),
          ),
        ],
      );
    },
  );

  if (confirmar != true) {
    return;
  }

  final lista =
      await _repository.carregar();

  lista.removeWhere(
    (e) => e.id == estabelecimento.id,
  );

  await _repository.salvar(
    lista,
  );

  await _carregar();
},
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    ],
  ),

  subtitle: Text(
    '📍 ${estabelecimento.endereco.isEmpty ? "Endereço não informado" : estabelecimento.endereco}\n'
    '🏷 ${estabelecimento.tipo}',
  ),

  onTap: () {
    Navigator.pop(
      context,
      estabelecimento,
    );
  },
);
              },
            ),
    ),
  ],
),
    );
  }
}