import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartcompre/screens/tipos_estabelecimento_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'mantém o controller válido durante o fechamento do diálogo de cadastro',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: TiposEstabelecimentoScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Adicionar tipo'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Mercado Local');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Mercado Local'), findsOneWidget);
    },
  );

  testWidgets(
    'mostra a quantidade de listas ao bloquear a exclusão de um tipo',
    (tester) async {
      tester.view.physicalSize = const Size(800, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({
        'tipos_estabelecimento_usuario': jsonEncode(['Mercado do Bairro']),
        'listas_salvas': jsonEncode([
          {'id': 1, 'tipo': 'Mercado do Bairro'},
          {'id': 2, 'tipo': 'Mercado do Bairro'},
        ]),
      });

      await tester.pumpWidget(
        const MaterialApp(home: TiposEstabelecimentoScreen()),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Não é possível excluir "Mercado do Bairro": existem 2 '
          'listas vinculadas.',
        ),
        findsOneWidget,
      );
      expect(find.text('Mercado do Bairro'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
