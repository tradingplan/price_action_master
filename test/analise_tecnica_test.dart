import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_master/pages/analise_tecnica/analise_tecnica_widget.dart';
import 'package:price_action_master/pages/detalhe_a_t/detalhe_a_t_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  late List<Map<String, dynamic>> concepts;

  setUpAll(() {
    concepts = (json.decode(
      File('content/reference/conceitos.json').readAsStringSync(),
    ) as List)
        .cast<Map<String, dynamic>>();
  });

  testWidgets('Análise Técnica lista os conceitos lidos localmente',
      (WidgetTester tester) async {
    expect(concepts, isNotEmpty);

    await tester.pumpWidget(const MaterialApp(home: AnaliseTecnicaWidget()));
    // Aguarda o carregamento assíncrono via rootBundle (LocalConceptRepository)
    for (var i = 0;
        i < 10 && find.byType(SpinKitFadingGrid).evaluate().isNotEmpty;
        i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    for (final concept in concepts) {
      expect(find.text(concept['title'] as String), findsOneWidget);
      expect(find.text(concept['icon'] as String), findsOneWidget);
    }
  });

  testWidgets('Detalhe do conceito decodifica o Map recebido pela rota',
      (WidgetTester tester) async {
    final concept = concepts.first;

    await tester.pumpWidget(MaterialApp(
      home: DetalheATWidget(singleAT: concept),
    ));
    await tester.pump();
    // A imagem de rede (chartImage) sempre falha no binding de teste
    // (HTTP 400 forçado pelo flutter_test); isso não é um bug do widget.
    tester.takeException();

    expect(find.text(concept['title'] as String), findsWidgets);
    expect(find.text(concept['description'] as String), findsOneWidget);
  });
}
