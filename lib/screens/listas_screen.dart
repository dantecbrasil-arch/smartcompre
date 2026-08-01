import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/listas_repository.dart';
import 'detalhe_lista_screen.dart';

class ListasScreen extends StatelessWidget {
  const ListasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listas = ListasRepository.listasSalvas;

    final formatoMoeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
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

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetalheListaScreen(
        lista: lista,
      ),
    ),
  );
},
                    leading: const Icon(
                      Icons.list_alt,
                    ),
                    title: Text(
                      lista['nomeLista'],
                    ),
                    subtitle: Text(
                      'Total: ${formatoMoeda.format(lista['total'])}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}