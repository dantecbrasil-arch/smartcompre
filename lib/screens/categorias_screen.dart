import 'package:flutter/material.dart';
import '../data/catalogo/categorias_repository.dart';
import '../core/tipos_estabelecimento.dart';
import 'categorias_tipo_screen.dart';

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
    ),
    body: ListView.builder(
      itemCount:
          TiposEstabelecimento.todos.length,
      itemBuilder: (context, index) {
        final tipo =
            TiposEstabelecimento.todos[index];

        return ListTile(
          leading: const Icon(
            Icons.store,
          ),
          title: Text(tipo),
          trailing: const Icon(
            Icons.chevron_right,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CategoriasTipoScreen(
                  tipoEstabelecimento:
                      tipo,
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
}
