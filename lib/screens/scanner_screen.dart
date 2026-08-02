import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Produto'),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isProcessing) return;

          final barcode = capture.barcodes.first;

          if (barcode.rawValue != null) {
            _isProcessing = true;

            Navigator.pop(
              context,
              barcode.rawValue,
            );
          }
        },
      ),
    );
  }
}