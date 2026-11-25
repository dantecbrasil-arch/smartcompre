import 'package:flutter/material.dart';

import '../core/constants/categorias_por_tipo.dart';
import '../core/utils/categoria_normalizer.dart';
import '../core/utils/ordenacao_alfabetica.dart';
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

  if (!mounted) return;

  final resultado = combinarCategoriasOrdenadas(
    categoriasPadrao,
    categoriasUsuario,
  );

  setState(() {
    categorias = resultado.categorias;
  });
}

void _mostrarMensagemCategoria(String mensagem) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensagem),
    ),
  );
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

  if (!context.mounted) return;

  if (novaCategoria == null) {
    return;
}

final nomeNormalizado =
    normalizarCategoria(novaCategoria);

if (nomeNormalizado.isEmpty) {
  _mostrarMensagemCategoria(
    'O nome da categoria não pode ficar vazio.',
  );
  return;
}

final existe = categorias.any(
  (categoria) =>
      normalizarCategoria(categoria) ==
      nomeNormalizado,
);

if (existe) {
  _mostrarMensagemCategoria(
    'Categoria já existe neste tipo de estabelecimento.',
  );

  return;
}

try {
  await CategoriasPorTipoRepository
      .adicionarCategoria(
    widget.tipoEstabelecimento,
    nomeNormalizado,
  );
} on CategoriaRepositoryException catch (error) {
  if (!context.mounted) return;

  _mostrarMensagemCategoria(error.message);
  return;
}

await _carregarCategorias();

if (!context.mounted) return;

ScaffoldMessenger.of(context)
    .showSnackBar(
  SnackBar(
    content: Text(
      'Categoria criada: '
      '$nomeNormalizado',
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
              ).any(
                (categoriaPadrao) =>
                    normalizarCategoria(categoriaPadrao) ==
                    normalizarCategoria(categoria),
              );

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

            if (!context.mounted) return;

            if (novoNome == null) {
              return;
            }

            final nomeNormalizado =
                normalizarCategoria(novoNome);

            if (nomeNormalizado.isEmpty) {
              _mostrarMensagemCategoria(
                'O nome da categoria não pode ficar vazio.',
              );
              return;
            }

            final existe = categorias.asMap().entries.any(
                  (entry) =>
                      entry.key != index &&
                      normalizarCategoria(entry.value) ==
                          nomeNormalizado,
                );

            if (existe) {
              _mostrarMensagemCategoria(
                'Categoria já existe neste tipo de estabelecimento.',
              );
              return;
            }

            try {
              await CategoriasPorTipoRepository
                  .editarCategoria(
                widget.tipoEstabelecimento,
                categoria,
                nomeNormalizado,
              );
            } on CategoriaRepositoryException catch (error) {
              if (!context.mounted) return;

              _mostrarMensagemCategoria(error.message);
              return;
            }

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

            if (!context.mounted) return;

            if (confirmar != true) {
              return;
            }

            try {
              await CategoriasPorTipoRepository
                  .excluirCategoria(
                widget.tipoEstabelecimento,
                categoria,
              );
            } on CategoriaRepositoryException catch (error) {
              if (!context.mounted) return;

              _mostrarMensagemCategoria(error.message);
              return;
            }

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