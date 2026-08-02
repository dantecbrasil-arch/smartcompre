import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  static Future<String> extrairTexto(
    String caminhoImagem,
  ) async {
    try {

      debugPrint('OCR INICIO');
      debugPrint('ARQUIVO: $caminhoImagem');

      final inputImage =
          InputImage.fromFilePath(caminhoImagem);

      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );

      debugPrint('ANTES PROCESSIMAGE');

      final resultado =
          await textRecognizer.processImage(
        inputImage,
      );

      debugPrint('DEPOIS PROCESSIMAGE');

      await textRecognizer.close();

      debugPrint(
        'TEXTO ENCONTRADO: ${resultado.text}',
      );

      return resultado.text;

    } catch (e, stackTrace) {

      debugPrint('ERRO OCR: $e');
      debugPrint(stackTrace.toString());

      rethrow;
    }
  }
}