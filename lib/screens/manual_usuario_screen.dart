import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ManualUsuarioScreen extends StatefulWidget {
  const ManualUsuarioScreen({super.key});

  @override
  State<ManualUsuarioScreen> createState() => _ManualUsuarioScreenState();
}

class _ManualUsuarioScreenState extends State<ManualUsuarioScreen> {
  late final Future<String> _manual;

  @override
  void initState() {
    super.initState();
    _manual = rootBundle.loadString('docs/MANUAL_DO_USUARIO.md');
  }

  TextSpan _textoComNegrito(String texto) {
    final spans = <InlineSpan>[];
    final marcador = RegExp(r'\*\*(.+?)\*\*');
    var indiceAnterior = 0;

    for (final correspondencia in marcador.allMatches(texto)) {
      if (correspondencia.start > indiceAnterior) {
        spans.add(
          TextSpan(
            text: texto.substring(indiceAnterior, correspondencia.start),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: correspondencia.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      indiceAnterior = correspondencia.end;
    }

    if (indiceAnterior < texto.length) {
      spans.add(TextSpan(text: texto.substring(indiceAnterior)));
    }

    return TextSpan(children: spans);
  }

  List<Widget> _renderizarManual(String conteudo) {
    final widgets = <Widget>[];
    final linhasParagrafo = <String>[];

    void adicionarParagrafo() {
      if (linhasParagrafo.isEmpty) return;

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text.rich(
            _textoComNegrito(linhasParagrafo.join(' ')),
            style: const TextStyle(fontSize: 16, height: 1.45),
          ),
        ),
      );
      linhasParagrafo.clear();
    }

    for (final linhaOriginal in conteudo.split('\n')) {
      final linha = linhaOriginal.trim();

      if (linha.isEmpty) {
        adicionarParagrafo();
        continue;
      }

      if (linha == '---') {
        adicionarParagrafo();
        widgets.add(const Divider(height: 28));
        continue;
      }

      final titulo = RegExp(r'^(#{1,3})\s+(.+)$').firstMatch(linha);
      if (titulo != null) {
        adicionarParagrafo();
        final nivel = titulo.group(1)!.length;
        final tamanhos = {1: 26.0, 2: 21.0, 3: 18.0};
        widgets.add(
          Padding(
            padding: EdgeInsets.only(top: nivel == 1 ? 4 : 16, bottom: 8),
            child: Text(
              titulo.group(2)!,
              style: TextStyle(
                fontSize: tamanhos[nivel],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        continue;
      }

      final item = RegExp(r'^-\s+(.+)$').firstMatch(linha);
      if (item != null) {
        adicionarParagrafo();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text.rich(
                    _textoComNegrito(item.group(1)!),
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        );
        continue;
      }

      final itemNumerado = RegExp(r'^(\d+)\.\s+(.+)$').firstMatch(linha);
      if (itemNumerado != null) {
        adicionarParagrafo();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${itemNumerado.group(1)}.  ',
                  style: const TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    itemNumerado.group(2)!,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        );
        continue;
      }

      linhasParagrafo.add(linha);
    }

    adicionarParagrafo();
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda / Manual do Usuário')),
      body: FutureBuilder<String>(
        future: _manual,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SelectableText(
                  'Não foi possível carregar o manual.\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return SelectionArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: _renderizarManual(snapshot.data!),
            ),
          );
        },
      ),
    );
  }
}
