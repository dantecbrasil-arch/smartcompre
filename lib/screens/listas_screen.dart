import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/listas_repository.dart';
import 'detalhe_lista_screen.dart';

class ListasScreen extends StatefulWidget {
  const ListasScreen({super.key});

  @override
  State<ListasScreen> createState() => _ListasScreenState();
}

class _ListasScreenState extends State<ListasScreen> {
  void excluirLista(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Lista'),
          content: Text(
            'Deseja excluir "${ListasRepository.listasSalvas[index]['nomeLista']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  ListasRepository.listasSalvas.removeAt(index);
                    ListasRepository.salvarListas();
                });

                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listas = ListasRepository.listasSalvas;

    final formatoMoeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
    );

    final formatoData = DateFormat(
      'dd/MM/yyyy',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Minhas Listas'),
      ),
      body: listas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma lista salva ainda.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              itemCount: listas.length,
              itemBuilder: (context, index) {
  final lista = listas[index];

  final quantidadeItens =
      (lista['produtos'] as List).length;


                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          DetalheListaScreen(
        lista: lista,
      ),
    ),
  );

  await ListasRepository.carregarListas();

  setState(() {});
},
                    leading: const Icon(
                      Icons.list_alt,
                    ),
                    title: Text(
  lista['nomeLista'],
),
subtitle: Text(
  '📍 ${lista['nomeLocal'] ?? 'Local não informado'}\n'
  '📅 ${formatoData.format(DateTime.parse(lista['data']))}\n'
  '🛒 $quantidadeItens itens\n'
  '💰 Total: ${formatoMoeda.format(lista['total'])}',
),

                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        excluirLista(index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}