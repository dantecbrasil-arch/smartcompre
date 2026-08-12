import 'package:flutter/material.dart';
import '../models/item_compra.dart';

class CadastroItemScreen extends StatelessWidget {
  final String produto;
  final double? precoKg;
  final double? total;

  const CadastroItemScreen({
    super.key,
    required this.produto,
    this.precoKg,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    final produtoController =
        TextEditingController(text: produto);

    final precoController =
        TextEditingController(
      text: precoKg?.toString() ?? '',
    );

    final totalController =
        TextEditingController(
      text: total?.toString() ?? '',
    );

    String categoriaSelecionada = 'Hortifruti';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
  controller: produtoController,
  decoration: const InputDecoration(
    labelText: 'Produto',
  ),
),

DropdownButtonFormField<String>(
  value: categoriaSelecionada,
  decoration: const InputDecoration(
    labelText: 'Categoria',
  ),
  items: const [
    DropdownMenuItem(
      value: 'Mercearia',
      child: Text('Mercearia'),
    ),
    DropdownMenuItem(
      value: 'Laticínios',
      child: Text('Laticínios'),
    ),
    DropdownMenuItem(
      value: 'Carnes',
      child: Text('Carnes'),
    ),
    DropdownMenuItem(
      value: 'Bebidas',
      child: Text('Bebidas'),
    ),
    DropdownMenuItem(
      value: 'Limpeza',
      child: Text('Limpeza'),
    ),
    DropdownMenuItem(
      value: 'Hortifruti',
      child: Text('Hortifruti'),
    ),
    DropdownMenuItem(
      value: 'Farmácia',
      child: Text('Farmácia'),
    ),
    DropdownMenuItem(
      value: 'Outros',
      child: Text('Outros'),
    ),
  ],
  onChanged: (value) {},
),

const SizedBox(height: 16),

TextField(
  controller: precoController,
  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
  decoration: const InputDecoration(
    labelText: 'Preço/Kg',
  ),
),

const SizedBox(height: 16),

TextField(
  controller: totalController,
  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
  decoration: const InputDecoration(
    labelText: 'Total',
  ),
),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                final item = ItemCompra(
                  produto: produtoController.text,
                  categoria: 'Hortifruti',
                  precoKg: double.tryParse(
                    precoController.text
                        .replaceAll(',', '.')
                        .trim(),
),
                  total: double.tryParse(
                    totalController.text
                        .replaceAll(',', '.')
                        .trim(),
),
);

                Navigator.pop(
                  context,
                  item,
                );
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}