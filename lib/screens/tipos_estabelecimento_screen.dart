import 'package:flutter/material.dart';

import '../core/tipos_estabelecimento.dart';
import '../data/tipos_estabelecimento_repository.dart';

class TiposEstabelecimentoScreen extends StatefulWidget {
  const TiposEstabelecimentoScreen({super.key});

  @override
  State<TiposEstabelecimentoScreen> createState() =>
      _TiposEstabelecimentoScreenState();
}

class _TiposEstabelecimentoScreenState
    extends State<TiposEstabelecimentoScreen> {
  List<String> _tipos = [];
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

  Future<String?> _solicitarNome({String? nomeAtual}) {
    return showDialog<String>(
      context: context,
      builder: (_) => _NomeTipoDialog(nomeAtual: nomeAtual),
    );
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _adicionarTipo() async {
    final nome = await _solicitarNome();
    if (nome == null) return;

    try {
      await TiposEstabelecimentoRepository.adicionarTipo(nome);
      await _carregarTipos();
    } on TiposEstabelecimentoRepositoryException catch (error) {
      if (!mounted) return;
      _mostrarMensagem(error.message);
    }
  }

  Future<void> _editarTipo(String tipo) async {
    final novoNome = await _solicitarNome(nomeAtual: tipo);
    if (novoNome == null) return;

    try {
      await TiposEstabelecimentoRepository.editarTipo(tipo, novoNome);
      await _carregarTipos();
    } on TiposEstabelecimentoRepositoryException catch (error) {
      if (!mounted) return;
      _mostrarMensagem(error.message);
    }
  }

  Future<void> _excluirTipo(String tipo) async {
    int quantidadeListas;
    try {
      quantidadeListas =
          await TiposEstabelecimentoRepository.contarListasVinculadas(tipo);
    } on FormatException {
      if (!mounted) return;
      _mostrarMensagem(
        'Não foi possível verificar as listas vinculadas ao tipo.',
      );
      return;
    }

    if (!mounted) return;

    if (quantidadeListas > 0) {
      final mensagem = quantidadeListas == 1
          ? 'Não é possível excluir "$tipo": existe 1 lista vinculada.'
          : 'Não é possível excluir "$tipo": existem $quantidadeListas '
                'listas vinculadas.';
      _mostrarMensagem(mensagem);
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir tipo'),
          content: Text(
            'Deseja excluir "$tipo"? Estabelecimentos e produtos do catálogo '
            'associados a esse tipo passarão para "Outros".',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    try {
      await TiposEstabelecimentoRepository.excluirTipo(tipo);
      await _carregarTipos();
      if (!mounted) return;
      _mostrarMensagem('Tipo "$tipo" excluído.');
    } on TiposEstabelecimentoRepositoryException catch (error) {
      if (!mounted) return;
      _mostrarMensagem(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tipos de estabelecimento')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Adicionar tipo',
        onPressed: _adicionarTipo,
        child: const Icon(Icons.add),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tipos.length,
              itemBuilder: (context, index) {
                final tipo = _tipos[index];
                final tipoNativo = TiposEstabelecimento.todos.contains(tipo);

                return ListTile(
                  leading: const Icon(Icons.store),
                  title: Text(tipo),
                  trailing: tipoNativo
                      ? const Icon(Icons.lock, color: Colors.grey)
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Editar tipo',
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editarTipo(tipo),
                            ),
                            IconButton(
                              tooltip: 'Excluir tipo',
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _excluirTipo(tipo),
                            ),
                          ],
                        ),
                );
              },
            ),
    );
  }
}

class _NomeTipoDialog extends StatefulWidget {
  const _NomeTipoDialog({this.nomeAtual});

  final String? nomeAtual;

  @override
  State<_NomeTipoDialog> createState() => _NomeTipoDialogState();
}

class _NomeTipoDialogState extends State<_NomeTipoDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.nomeAtual ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.nomeAtual == null ? 'Novo tipo' : 'Editar tipo'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Tipo de estabelecimento'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
