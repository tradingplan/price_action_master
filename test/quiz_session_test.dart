import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_master/pages/course/quiz_session_widget.dart';

void main() {
  testWidgets('Simulado agrega as perguntas de todos os cursos', (WidgetTester tester) async {
    var expected = 0;
    for (final f in Directory('content/courses').listSync().whereType<File>()) {
      if (!f.path.endsWith('.json')) continue;
      final course = json.decode(f.readAsStringSync()) as Map<String, dynamic>;
      for (final m in course['modules'] as List) {
        expected += ((m as Map<String, dynamic>)['quizzes'] as List).length;
      }
    }
    expect(expected, greaterThan(0));

    await tester.pumpWidget(const MaterialApp(home: QuizSessionWidget()));
    // Aguarda o carregamento assíncrono dos cursos via rootBundle
    for (var i = 0; i < 10 && find.byType(CircularProgressIndicator).evaluate().isNotEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('$expected perguntas realistas de mercado'), findsOneWidget);
  });
}
