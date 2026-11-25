import 'package:flutter/material.dart';

import '../core/tipos_estabelecimento.dart';
import '../data/tipos_estabelecimento_repository.dart';
import 'categorias_tipo_screen.dart';
import 'tipos_estabelecimento_screen.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  List<String> _tipos = TiposEstabelecimento.todos;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTipos();
  }

  Future<void> _carregarTipos() async {
    final tipos = await TiposEstabelecimentoRepository.carregarTodos();

    if (!mounted) return;

    setState(() {
      _tipos = tipos;
      _carregando = false;
    });
  }

  Future<void> _abrirGerenciamentoTipos() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const TiposEstabelecimentoScreen()),
    );

    if (!mounted) return;
    await _carregarTipos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        actions: [
          IconButton(
            tooltip: 'Gerenciar tipos de estabelecimento',
            icon: const Icon(Icons.tune),
            onPressed: _abrirGerenciamentoTipos,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tipos.length,
              itemBuilder: (context, index) {
                final tipo = _tipos[index];

                return ListTile(
                  leading: const Icon(Icons.store),
                  title: Text(tipo),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoriasTipoScreen(tipoEstabelecimento: tipo),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
