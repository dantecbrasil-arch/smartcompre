import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:smartcompre/services/ocr_service.dart';
import 'package:smartcompre/services/etiqueta_parser.dart';
import 'package:smartcompre/screens/cadastro_item_screen.dart';
import 'package:smartcompre/models/item_compra.dart';
import 'package:smartcompre/screens/lista_compras_screen.dart';
import 'package:smartcompre/models/opcao_preco.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;

final GlobalKey _frameKey = GlobalKey();

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
        ResolutionPreset.high,
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

Future<String> recortarCentro(String caminho) async {

  final arquivo =
      File(caminho);

  final bytes =
      await arquivo.readAsBytes();

  final imagem =
      img.decodeImage(bytes);

  if (imagem == null) {
    return caminho;
  }

  final largura = imagem.width;
  final altura = imagem.height;

  final larguraRecorte = 640;
  final alturaRecorte = 240;

  final x = 26;

  final y = 560;

  final recorte = img.copyCrop(
    imagem,
    x: x,
    y: y,
    width: larguraRecorte,
    height: alturaRecorte,
  );

  final novoArquivo = File(
    '${arquivo.parent.path}/ocr_crop.jpg',
  );

  await novoArquivo.writeAsBytes(
    img.encodeJpg(recorte),
  );


  return novoArquivo.path;
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

      Center(
  child: Container(
    key: _frameKey,
    width: 380,
    height: 150,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.green,
        width: 4,
      ),
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
    ),
    
  ),
),

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
      floatingActionButtonLocation:
    FloatingActionButtonLocation.centerFloat,

floatingActionButton:
    Padding(
      padding: const EdgeInsets.only(
        bottom: 140,
      ),
      child: SizedBox(
      width: 200,
      height: 90,
      child: FloatingActionButton(
        backgroundColor: Colors.green,
        elevation: 8,
        onPressed: () async {
       

          try {
            
            final foto = await _controller!.takePicture();

            debugPrint('====================');
            debugPrint('FOTO CAPTURADA');
            debugPrint('CAMINHO: ${foto.path}');
            debugPrint('====================');

            final caminhoRecortado =
                await recortarCentro(foto.path);


            debugPrint(
              'IMAGEM RECORTADA: $caminhoRecortado',
            );
            final texto =
               await OCRService.extrairTexto(
              caminhoRecortado,
            );

            debugPrint('====================');
            debugPrint('TEXTO OCR BRUTO');
            debugPrint(texto);
            debugPrint('===================='); 

            final dados = EtiquetaParser.extrair(texto);

            double? totalSelecionado =
                dados.total;

           
             for (final opcao in dados.opcoesPreco) {
              debugPrint(
                '${opcao.descricao} => ${opcao.valor}',
              );
             }


             if (dados.temMultiplosPrecos) {

  final opcaoEscolhida =
      await showDialog<OpcaoPreco>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text(
          'Múltiplos preços',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: dados.opcoesPreco.map(
            (opcao) {
              return ListTile(
                title: Text(
                  opcao.descricao,
                ),
                subtitle: Text(
                  'R\$ ${opcao.valor.toStringAsFixed(2)}',
                ),
                onTap: () {
                  Navigator.pop(
                    context,
                    opcao,
                  );
                },
              );
            },
          ).toList(),
        ),
      );
    },
  );

  if (opcaoEscolhida == null) {
    return;
  }

  totalSelecionado =
      opcaoEscolhida.valor;

  debugPrint(
    'ESCOLHEU: ${opcaoEscolhida.descricao}',
  );
}



            setState(() {
              _produto = dados.produto;
              _precoKg = dados.precoKg;
              _total = totalSelecionado;
            });

            final item = await Navigator.push<ItemCompra>(
  context,
  MaterialPageRoute(
    builder: (_) => 
    CadastroItemScreen(
      produto: dados.produto,
      peso: dados.peso,
      precoKg: dados.precoKg,
      moeda: dados.moeda,
      total: totalSelecionado,
    ),
  ),
);

if (item != null) {
  debugPrint(
    'ITEM RETORNOU => '
    '${item.produto} | '
    '${item.categoria} | '
    '${item.moeda} | '
    '${item.peso} | '
    '${item.precoKg} | '
    '${item.total}',
  );

  _itens.insert(0, item);

  debugPrint(
    'TOTAL ITENS: ${_itens.length}',
  );

  Navigator.pop(context, item);
}




            debugPrint('====================');
            debugPrint('OCR RETORNOU');
            debugPrint(texto);
            debugPrint('====================');
          } catch (e) {
            debugPrint('ERRO FOTO: $e');
          }
        },
        child: const Icon(
          Icons.camera_alt,
           size: 50,
        ),
      ),
    ),
  ),
);
}

}
