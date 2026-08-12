import 'package:flutter/material.dart';
import '../models/item_compra.dart';

class CadastroItemScreen extends StatefulWidget {
  final String produto;
  final double? precoKg;
  final double? total;
  final String? moeda;
  final double? peso;

  const CadastroItemScreen({
    super.key,
    required this.produto,
    this.peso,
    this.precoKg,
    this.total,
    this.moeda,
  });

  @override
  State<CadastroItemScreen> createState() =>
      _CadastroItemScreenState();
}

class _CadastroItemScreenState
    extends State<CadastroItemScreen> {

      String categoriaSelecionada = 'Hortifruti';

@override
void initState() {
  super.initState();
  debugPrint(
    'CATEGORIA INICIAL: $categoriaSelecionada',
  );
}


  @override
  Widget build(BuildContext context) {
    final produtoController =
        TextEditingController(text: widget.produto);

    final pesoController =
        TextEditingController(
     text: widget.peso?.toString() ?? '',
);

    final precoController =
        TextEditingController(
      text: widget.precoKg?.toString() ?? '',
    );

    final totalController =
        TextEditingController(
      text: widget.total?.toString() ?? '',
    );

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

TextField(
  controller: pesoController,
  decoration: const InputDecoration(
    labelText: 'Peso (kg)',
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
  onChanged: (value) {
  setState(() {
    categoriaSelecionada = value!;
  });

  debugPrint(
    'CATEGORIA SELECIONADA: $categoriaSelecionada',
  );
},

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
           final peso =
    double.tryParse(
      pesoController.text
          .replaceAll(',', '.'),
    ) ??
    0;

final preco =
    double.tryParse(
      precoController.text
          .replaceAll(',', '.'),
    ) ??
    0;

final item = ItemCompra(
  produto: produtoController.text,
  categoria: categoriaSelecionada,
  moeda: widget.moeda,
  peso: peso,
  precoKg: preco,
  total: peso * preco,
);   

debugPrint(
  'SALVANDO CATEGORIA: $categoriaSelecionada',
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