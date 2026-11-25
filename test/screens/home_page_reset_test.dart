import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartcompre/data/listas_repository.dart';
import 'package:smartcompre/main.dart';
import 'package:smartcompre/screens/produtos_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'estabelecimentos': jsonEncode([
        {
          'id': 'mercado-1',
          'nome': 'Mercado Central',
          'endereco': 'Rua Um, 10',
          'cidade': 'São Paulo',
          'tipo': 'Mercado',
        },
      ]),
    });
    ListasRepository.listasSalvas = [];
  });

  Finder campoComRotulo(String rotulo) {
    return find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == rotulo,
    );
  }

  testWidgets(
    'limpa o formulário ao voltar da tela de produtos e preserva a lista',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      await tester.tap(campoComRotulo('Estabelecimento'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mercado Central'));
      await tester.pumpAndSettle();
      await tester.enterText(
        campoComRotulo('Nome da Lista'),
        'compras da semana',
      );
      await tester.pump();

      expect(
        tester
            .widget<TextField>(campoComRotulo('Estabelecimento'))
            .controller!
            .text,
        'Mercado Central',
      );
      expect(
        tester
            .widget<ElevatedButton>(
              find.widgetWithText(ElevatedButton, '🛒 Criar Lista'),
            )
            .onPressed,
        isNotNull,
      );
      await tester.ensureVisible(find.text('🛒 Criar Lista'));
      await tester.tap(find.text('🛒 Criar Lista'));
      await tester.pumpAndSettle();

      expect(ListasRepository.listasSalvas, hasLength(1));
      expect(find.byType(ProdutosScreen), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<TextField>(campoComRotulo('Estabelecimento'))
            .controller!
            .text,
        isEmpty,
      );
      expect(
        tester
            .widget<TextField>(campoComRotulo('Nome da Lista'))
            .controller!
            .text,
        isEmpty,
      );
      expect(find.textContaining('🏷 Mercado'), findsNothing);
      expect(ListasRepository.listasSalvas, hasLength(1));
      expect(
        ListasRepository.listasSalvas.single['nomeLista'],
        'Compras da semana',
      );
    },
  );

  testWidgets(
    'limpa o formulário ao voltar de Minhas Listas sem apagar registros',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      await tester.enterText(campoComRotulo('Nome da Lista'), 'rascunho');
      await tester.tap(find.text('📋 Minhas Listas'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<TextField>(campoComRotulo('Nome da Lista'))
            .controller!
            .text,
        isEmpty,
      );
      expect(ListasRepository.listasSalvas, isEmpty);
    },
  );
}
