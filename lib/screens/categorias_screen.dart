import 'package:flutter/material.dart';
import '../data/catalogo/categorias_repository.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() =>
      _CategoriasScreenState();
}

class _CategoriasScreenState
    extends State<CategoriasScreen> {

  String? categoriaDestacada;

  final ScrollController
    _scrollController =
        ScrollController();


  Future<void> _adicionarCategoria() async {
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

    try {

  await CategoriasRepository.adicionar(
    novaCategoria,
  );

  setState(() {});

} catch (e) {

  setState(() {
    categoriaDestacada =
      novaCategoria;
  });

  final index =
    CategoriasRepository
        .categorias
        .indexWhere(
  (c) =>
      c.toLowerCase() ==
      novaCategoria.toLowerCase(),
);

if (index >= 0) {

  Future.delayed(
    const Duration(
      milliseconds: 300,
    ),
    () {

      _scrollController.animateTo(
        index * 72.0,
        duration: const Duration(
          milliseconds: 500,
        ),
        curve: Curves.easeInOut,
      );

    },
  );

}

  if (!mounted) return;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Categoria existente',
        ),
        content: Text(
          'A categoria "$novaCategoria" já está cadastrada.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
            ),
          ),
        ],
      );
    },
  );

}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _adicionarCategoria,
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount:
            CategoriasRepository
                .categorias
                .length,
        itemBuilder: (context, index) {
          final categoria =
              CategoriasRepository
                  .categorias[index];

      return Container(
  color:
      categoriaDestacada != null &&
              categoria.toLowerCase() ==
                  categoriaDestacada!
                      .toLowerCase()
          ? Colors.green.shade100
          : null,
  child: ListTile(
    leading: const Icon(
      Icons.category,
    ),
    title: Text(
      categoria,
      style: TextStyle(
        fontWeight:
            categoriaDestacada != null &&
                    categoria.toLowerCase() ==
                        categoriaDestacada!
                            .toLowerCase()
                ? FontWeight.bold
                : FontWeight.normal,
      ),
    ),

  trailing: SizedBox(
    width: 96,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
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

            if (novoNome != null &&
                novoNome.isNotEmpty) {
              await CategoriasRepository.editar(
                categoria,
                novoNome,
              );

              setState(() {});
            }
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

    if (confirmar == true) {
      await CategoriasRepository
          .excluir(categoria);

      setState(() {});
    }
  },
),
      ],
    ),
  ),
  ),
);  

        },
      ),
    );
  }
}
