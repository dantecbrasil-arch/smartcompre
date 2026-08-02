import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ocr_service.dart';

class CapturaEtiquetaScreen extends StatefulWidget {
  const CapturaEtiquetaScreen({super.key});

  @override
  State<CapturaEtiquetaScreen> createState() =>
      _CapturaEtiquetaScreenState();
}

class _CapturaEtiquetaScreenState
    extends State<CapturaEtiquetaScreen> {

  XFile? imagem;
  String mensagem = 'Nenhuma imagem';
  String textoOCR = '';

@override
void initState() {
  super.initState();
  debugPrint('CAPTURA INITSTATE');
}


@override
void dispose() {
  debugPrint('CAPTURA DISPOSE');
  super.dispose();
}

  Future<void> tirarFoto() async {
  try {
    final picker = ImagePicker();

    debugPrint('ANTES PICKIMAGE');
    
    debugPrint('PEDINDO CAMERA');
    
    final foto = await picker.pickImage(
      source: ImageSource.gallery,
    );
    
    debugPrint('DEPOIS PICKIMAGE');

  if (foto == null) {
  return;
}

debugPrint('PASSO 1 - FOTO CONFIRMADA');

if (!mounted) return;

setState(() {
  imagem = foto;
  mensagem = 'FOTO RECEBIDA';
});  

debugPrint('PASSO 2 - SETSTATE FOTO');

debugPrint('ARQUIVO: ${foto.path}');
debugPrint('TAMANHO: ${await File(foto.path).length()}');

debugPrint('PASSO 3 - ARQUIVO OK');

await Future.delayed(
  const Duration(milliseconds: 500),
);

debugPrint('PASSO 4 - DELAY OK');

String texto = '';

try {

  debugPrint('CHAMANDO OCR');

  texto = await OCRService.extrairTexto(
    foto.path,
  );

  debugPrint('OCR RETORNOU');

} catch (e, stackTrace) {
  debugPrint('ERRO OCR: $e');
  debugPrint(stackTrace.toString());

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('ERRO OCR: $e'),
    ),
  );

  return;
}

if (!mounted) return;

setState(() {
  imagem = foto;
  textoOCR = texto;
  mensagem = 'OCR concluído';
});

  } catch (e) {
    debugPrint('ERRO FOTO: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturar Etiqueta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: tirarFoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Tirar Foto'),
            ),

            const SizedBox(height: 20),

            Text(
              mensagem,
              textAlign: TextAlign.center,
            ),

const SizedBox(height: 20),

SelectableText(
  textoOCR,
),

            const SizedBox(height: 20),

            if (imagem != null)
              Image.file(
                File(imagem!.path),
                height: 300,
                fit: BoxFit.contain,
              ),
          ],
        ),
      ),
    );
  }
}