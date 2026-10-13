import 'package:flutter/material.dart';

import '../core/constants/categorias_por_tipo.dart';
import '../data/catalogo/categorias_por_tipo_repository.dart';

class CategoriasTipoScreen extends StatefulWidget {
  final String tipoEstabelecimento;

  const CategoriasTipoScreen({
    super.key,
    required this.tipoEstabelecimento,
  });

  @override
  State<CategoriasTipoScreen> createState() =>
      _CategoriasTipoScreenState();
}

class _CategoriasTipoScreenState
    extends State<CategoriasTipoScreen> {

  late List<String> categorias;

  @override
void initState() {
  super.initState();

  categorias = [];

  _carregarCategorias();
}

Future<void> _carregarCategorias() async {
  final categoriasPadrao =
      CategoriasPorTipo.obter(
    widget.tipoEstabelecimento,
  );

  final categoriasUsuario =
      await CategoriasPorTipoRepository
          .obterCategorias(
    widget.tipoEstabelecimento,
  );

  final todas = [
    ...categoriasPadrao,
    ...categoriasUsuario,
  ];

  todas.sort(
    (a, b) => a
        .toLowerCase()
        .compareTo(
          b.toLowerCase(),
        ),
  );

  setState(() {
    categorias = todas;
  });
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categorias - '
          '${widget.tipoEstabelecimento}',
        ),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: () async {
  final controller =
      TextEditingController();

  final novaCategoria =
      await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Nova Categoria',
        ),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(
            labelText: 'Categoria',
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
            onPressed: () {
              Navigator.pop(
                context,
                controller.text.trim(),
              );
            },
            child: const Text(
              'Salvar',
            ),
          ),
        ],
      );
    },
  );

  if (novaCategoria == null ||
    novaCategoria.isEmpty) {
  return;
}

final existe = categorias.any(
  (c) =>
      c.toLowerCase() ==
      novaCategoria.toLowerCase(),
);

if (existe) {
  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content: Text(
        'Categoria já existe',
      ),
    ),
  );

  return;
}

await CategoriasPorTipoRepository
    .adicionarCategoria(
  widget.tipoEstabelecimento,
  novaCategoria,
);

await _carregarCategorias();

ScaffoldMessenger.of(context)
    .showSnackBar(
  SnackBar(
    content: Text(
      'Categoria criada: '
      '$novaCategoria',
    ),
  ),
);
},
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: categorias.length,

        itemBuilder: (context, index) {
          final categoria =
              categorias[index];

          final categoriaPadrao =
    CategoriasPorTipo.obter(
      widget.tipoEstabelecimento,
    ).contains(categoria);

return ListTile(
  leading: const Icon(
    Icons.category,
  ),

  title: Text(categoria),

  trailing: categoriaPadrao
      ? const Icon(
          Icons.lock,
          color: Colors.grey,
        )
      : SizedBox(
    width: 96,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        IconButton(
          icon: const Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          onPressed: () async {
            final controller =
                TextEditingController(
              text: categoria,
            );

            final novoNome =
                await showDialog<String>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Editar Categoria',
                  ),
                  content: TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(
                      labelText: 'Categoria',
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
                      onPressed: () {
                        Navigator.pop(
                          context,
                          controller.text.trim(),
                        );
                      },
                      child: const Text(
                        'Salvar',
                      ),
                    ),
                  ],
                );
              },
            );

            if (novoNome == null ||
                novoNome.isEmpty) {
              return;
            }

            await CategoriasPorTipoRepository
                .editarCategoria(
              widget.tipoEstabelecimento,
              categoria,
              novoNome,
            );

            await _carregarCategorias();
          },
        ),

        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () async {
            final confirmar =
                await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Excluir Categoria',
                  ),
                  content: Text(
                    'Deseja excluir "$categoria"?',
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
                    TextButton(
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

            await CategoriasPorTipoRepository
                .excluirCategoria(
              widget.tipoEstabelecimento,
              categoria,
            );

            await _carregarCategorias();
          },
        ),
      ],
    ),
  ),
);
        },
      ),
    );
  }
}