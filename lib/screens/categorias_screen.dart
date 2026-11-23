import 'package:flutter/material.dart';
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
