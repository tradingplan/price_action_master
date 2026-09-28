import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_master/pages/course/module_panel_widget.dart';

void main() {
  testWidgets('Aba Quiz percorre todas as perguntas do módulo', (WidgetTester tester) async {
    final course = json.decode(File('content/courses/candlesticks.json').readAsStringSync())
        as Map<String, dynamic>;
    final moduleData = (course['modules'] as List).first as Map<String, dynamic>;
    final quizzes = moduleData['quizzes'] as List;
    expect(quizzes.length, greaterThan(1));

    await tester.pumpWidget(MaterialApp(
      home: ModulePanelWidget(courseId: 'candlesticks', moduleData: moduleData),
    ));

    await tester.tap(find.text('Quiz'));
    await tester.pumpAndSettle();

    for (var i = 0; i < quizzes.length; i++) {
      final quiz = quizzes[i] as Map<String, dynamic>;
      expect(find.text('Pergunta ${i + 1} de ${quizzes.length}'), findsOneWidget);
      expect(find.text(quiz['question'] as String), findsOneWidget);

      final option = find.text((quiz['options'] as List)[quiz['correctIndex'] as int] as String);
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pump();

      final isLast = i == quizzes.length - 1;
      expect(find.text('Próxima Pergunta'), isLast ? findsNothing : findsOneWidget);
      if (!isLast) {
        await tester.ensureVisible(find.text('Próxima Pergunta'));
        await tester.tap(find.text('Próxima Pergunta'));
        await tester.pump();
      }
    }
  });
}
