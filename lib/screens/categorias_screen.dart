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

    await CategoriasRepository.adicionar(
      novaCategoria,
    );

    setState(() {});
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
        itemCount:
            CategoriasRepository
                .categorias
                .length,
        itemBuilder: (context, index) {
          final categoria =
              CategoriasRepository
                  .categorias[index];

      return ListTile(
  leading: const Icon(
    Icons.category,
  ),
  title: Text(categoria),
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
);  
        },
      ),
    );
  }
}