import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smartcompre/services/ocr_service.dart';
import 'package:smartcompre/services/etiqueta_parser.dart';
import 'package:smartcompre/screens/cadastro_item_screen.dart';
import 'package:smartcompre/models/item_compra.dart';
import 'package:smartcompre/screens/lista_compras_screen.dart';
import '../data/listas_repository.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;

  String _produto = '';
  double? _precoKg;
  double? _total;

final List<ItemCompra> _itens = [];

  @override
  void initState() {
    super.initState();
    iniciarCamera();
  }

  Future<void> iniciarCamera() async {
    try {
      final cameras = await availableCameras();

      debugPrint('CAMERAS ENCONTRADAS: ${cameras.length}');

      final camera = cameras.first;

      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
      );

      await _controller!.initialize();

      debugPrint('CAMERA INICIALIZADA');

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('ERRO CAMERA: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
  appBar: AppBar(
    title: const Text('SmartCompre'),
    actions: [
      IconButton(
        icon: const Icon(Icons.list),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ListaComprasScreen(
                itens: _itens,
              ),
            ),
          );
        },
      ),
    ],
  ),
  body: Stack(
    children: [
      CameraPreview(_controller!),

      if (_produto.isNotEmpty)
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            color: Colors.black87,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Produto: $_produto',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Preço/Kg: ${_precoKg ?? "-"}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Total: ${_total ?? "-"}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final foto = await _controller!.takePicture();

            debugPrint('====================');
            debugPrint('FOTO CAPTURADA');
            debugPrint('CAMINHO: ${foto.path}');
            debugPrint('====================');

            final texto = await OCRService.extrairTexto(
              foto.path,
            );

            final dados = EtiquetaParser.extrair(texto);

            debugPrint('PRODUTO: ${dados.produto}');
            debugPrint('PRECO KG: ${dados.precoKg}');
            debugPrint('TOTAL: ${dados.total}');

            setState(() {
              _produto = dados.produto;
              _precoKg = dados.precoKg;
              _total = dados.total;
            });

            final item = await Navigator.push<ItemCompra>(
  context,
  MaterialPageRoute(
    builder: (_) => CadastroItemScreen(
      produto: dados.produto,
      precoKg: dados.precoKg,
      total: dados.total,
    ),
  ),
);

if (item != null) {
  setState(() {
    _itens.add(item);
  });

  final listaExistente = ListasRepository.listasSalvas
    .where((lista) => lista['nomeLista'] == 'Etiqueta OCR')
    .toList();

if (listaExistente.isEmpty) {
  ListasRepository.listasSalvas.add({
    'nomeLista': 'Etiqueta OCR',
    'data': DateTime.now().toIso8601String(),
    'total': item.total ?? 0,
    'produtos': [
      {
        'nome': item.produto,
        'categoria': 'Hortifruti',
        'quantidade': 1,
        'preco': item.precoKg ?? 0,
        'subtotal': item.total ?? 0,
      }
    ],
  });
} else {
  final lista = listaExistente.first;

  final produtos =
      List<Map<String, dynamic>>.from(
    lista['produtos'],
  );

  produtos.add({
    'nome': item.produto,
    'categoria': 'Hortifruti',
    'quantidade': 1,
    'preco': item.precoKg ?? 0,
    'subtotal': item.total ?? 0,
  });

  lista['produtos'] = produtos;

  lista['total'] =
      (lista['total'] ?? 0) +
      (item.total ?? 0);
}

await ListasRepository.salvarListas();

  debugPrint('ITEM ADICIONADO: ${item.produto}');
}

            debugPrint('====================');
            debugPrint('OCR RETORNOU');
            debugPrint(texto);
            debugPrint('====================');
          } catch (e) {
            debugPrint('ERRO FOTO: $e');
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}