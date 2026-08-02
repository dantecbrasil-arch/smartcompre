import 'package:flutter/material.dart';
import '../models/item_compra.dart';

class ListaComprasScreen extends StatelessWidget {
  final List<ItemCompra> itens;

  const ListaComprasScreen({
    super.key,
    required this.itens,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
      ),
      body: itens.isEmpty
          ? const Center(
              child: Text('Nenhum item cadastrado'),
            )
          : ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, index) {
                final item = itens[index];

                return ListTile(
                  title: Text(item.produto),
                  subtitle: Text(
                    'Preço/Kg: ${item.precoKg ?? "-"}',
                  ),
                  trailing: Text(
                    'R\$ ${item.total?.toStringAsFixed(2) ?? "0.00"}',
                  ),
                );
              },
            ),
    );
  }
}