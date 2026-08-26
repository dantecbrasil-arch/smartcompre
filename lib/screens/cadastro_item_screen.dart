import 'package:flutter/material.dart';
import '../models/item_compra.dart';
import '../data/catalogo/catalogo_repository.dart';
import '../data/catalogo/produto_catalogo.dart';
import '../data/catalogo/categorias_repository.dart';

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

  final _catalogo = CatalogoRepository.instance;

  late TextEditingController produtoController;
  late TextEditingController pesoController;
  late TextEditingController precoController;
  late TextEditingController totalController;

      double totalOcrOriginal = 0;

      bool erroPeso = false;
      bool erroPreco = false;

      String categoriaSelecionada = 'Hortifruti';

      int quantidade = 1;

@override
void initState() {
  super.initState();

  produtoController =
      TextEditingController(
    text: widget.produto,
  );

  pesoController =
    TextEditingController(
  text: widget.peso?.toString() ?? '',
);

precoController =
    TextEditingController(
  text: widget.precoKg?.toString() ?? '',
);

totalController =
    TextEditingController(
  text: widget.total?.toString() ?? '',
);

totalOcrOriginal =
    widget.total ?? 0;

  final produtoExistente =
      _catalogo.buscarProduto(
    widget.produto,
  );

  if (produtoExistente != null) {
    categoriaSelecionada =
        produtoExistente.categoria;

    debugPrint(
      'CATEGORIA RECUPERADA: '
      '${produtoExistente.categoria}',
    );
  }

  debugPrint(
    'CATEGORIA INICIAL: $categoriaSelecionada',
  );
}

void atualizarTotal() {
  final peso =
      double.tryParse(
        pesoController.text.replaceAll(',', '.'),
      ) ??
      0;

  final preco =
      double.tryParse(
        precoController.text.replaceAll(',', '.'),
      ) ??
      0;

  if (peso > 0 && preco > 0) {
    totalController.text =
        (peso * preco)
            .toStringAsFixed(2);
  }
}


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Cadastrar Produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
  controller: produtoController,
  decoration: const InputDecoration(
    labelText: 'Produto',
  ),
),

TextField(
  controller: pesoController,
  onChanged: (_) => atualizarTotal(),
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Peso (kg)',
    labelStyle: TextStyle(
      color: erroPeso ? Colors.red : null,
    ),
    errorText: erroPeso
        ? 'Peso obrigatório'
        : null,
  ),
),

DropdownButtonFormField<String>(
  value: categoriaSelecionada,
  decoration: const InputDecoration(
    labelText: 'Categoria',
  ),
  items: CategoriasRepository.categorias
    .map(
      (categoria) => DropdownMenuItem(
        value: categoria,
        child: Text(categoria),
      ),
    )
    .toList(),
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
  onChanged: (_) => atualizarTotal(),

  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
  decoration: InputDecoration(
    labelText: 'Preço/Kg',
    labelStyle: TextStyle(
      color: erroPreco ? Colors.red : null,
    ),
    errorText: erroPreco
        ? 'Preço/Kg obrigatório'
        : null,
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

const SizedBox(height: 16),

const Text(
  'Quantidade',
  style: TextStyle(
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 8),

Row(
  mainAxisAlignment:
      MainAxisAlignment.center,
  children: [
    IconButton(
      onPressed: () {
        if (quantidade > 1) {
          setState(() {
            quantidade--;
          });
        }
      },
      icon: const Icon(Icons.remove),
    ),

    Text(
      quantidade.toString(),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    IconButton(
      onPressed: () {
        setState(() {
          quantidade++;
        });
      },
      icon: const Icon(Icons.add),
    ),
  ],
),

const SizedBox(height: 16),

Text(
  'Subtotal: R\$ ${(((double.tryParse(
    totalController.text.replaceAll(',', '.'),
  ) ?? 0) * quantidade)
      .toStringAsFixed(2)
      .replaceAll('.', ','))}',
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
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

final total =
    double.tryParse(
      totalController.text
          .replaceAll(',', '.'),
    ) ??
    0;

final subtotalCalculado =
    double.parse(
      (
        peso > 0 && preco > 0
            ? peso * preco
            : total
      ).toStringAsFixed(2),
    );

final diferencaOCR =
    (subtotalCalculado - 
            totalOcrOriginal)
        .abs();

if (peso > 0 &&
    preco > 0 &&
    total > 0 &&
    diferencaOCR > 1.00) {
      
debugPrint(
  'VALIDACAO OCR => '
  'peso=$peso '
  'preco=$preco '
  'total=$total '
  'totalOcrOriginal=$totalOcrOriginal '
  'subtotalCalculado=$subtotalCalculado '
  'diferencaOCR=$diferencaOCR',
);
 

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        '⚠️ Possível erro de leitura',
      ),
      content: Text(
        'Peso: $peso\n'
        'Preço/Kg: $preco\n'
        'Total OCR: $total\n'
        'Valor calculado: $subtotalCalculado',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Corrigir',
          ),
        ),
      ],
    ),
  );

  return;
}


if (preco > 0 && peso <= 0) {

  setState(() {
    erroPeso = true;
    erroPreco = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'INSIRA O PESO PARA SALVAR.',
      ),
    ),
  );

  return;
}

if (peso > 0 && preco <= 0) {

  setState(() {
    erroPreco = true;
    erroPeso = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'INSIRA O PREÇO/KG PARA SALVAR.',
      ),
    ),
  );

  return;
}

setState(() {
  erroPeso = false;
  erroPreco = false;
});

final ehProdutoUnidade =
    peso <= 0 &&
    preco <= 0 &&
    total > 0;

final item = ItemCompra(
  produto: produtoController.text,
  categoria: categoriaSelecionada,
  moeda: widget.moeda,
  peso: peso,
  quantidade: quantidade,
  precoKg: ehProdutoUnidade
      ? total
      : preco,
  total: double.parse(
  (subtotalCalculado * quantidade)
      .toStringAsFixed(2),
),
);

debugPrint(
  'SALVANDO CATEGORIA: $categoriaSelecionada',
);

debugPrint(
  'ITEM FINAL => '
  '${item.produto} | '
  '${item.peso} | '
  '${item.precoKg} | '
  '${item.total}',
);

CatalogoRepository.instance.salvarProduto(
  ProdutoCatalogo(
    nome: produtoController.text,
    categoria: categoriaSelecionada,
  ),
);

debugPrint(
  'PRODUTO ADICIONADO AO CATALOGO',
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