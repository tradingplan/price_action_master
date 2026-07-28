import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_master/backend/schema/platform_course_models.dart';

void main() {
  group('Platform Domain Parser Tests (Golden Samples)', () {
    test('Should parse Course Golden Sample correctly', () {
      final file = File('content/examples/course/course_example.json');
      expect(file.existsSync(), isTrue);

      final jsonStr = file.readAsStringSync();
      final jsonMap = json.decode(jsonStr) as Map<String, dynamic>;

      final course = PlatformCourse.fromJson(jsonMap);
      expect(course.id, equals('smc_course'));
      expect(course.title, equals('Smart Money Concepts (Exemplo)'));
      expect(course.version, equals(1));
      expect(course.modules, hasLength(1));

      final serialized = course.toJson();
      expect(serialized['id'], equals('smc_course'));
      expect(serialized['modules'], hasLength(1));
    });

    test('Should parse Module Golden Sample correctly', () {
      final file = File('content/examples/module/module_example.json');
      expect(file.existsSync(), isTrue);

      final jsonStr = file.readAsStringSync();
      final jsonMap = json.decode(jsonStr) as Map<String, dynamic>;

      final module = PlatformModule.fromJson(jsonMap);
      expect(module.id, equals('candlesticks_m1'));
      expect(module.title, equals('Velas de Reversão (Exemplo)'));
      expect(module.xpValue, equals(150));
      expect(module.lessons, hasLength(1));

      final serialized = module.toJson();
      expect(serialized['id'], equals('candlesticks_m1'));
    });

    test('Should parse Lesson Golden Sample correctly', () {
      final file = File('content/examples/lesson/lesson_example.json');
      expect(file.existsSync(), isTrue);

      final jsonStr = file.readAsStringSync();
      final jsonMap = json.decode(jsonStr) as Map<String, dynamic>;

      final lesson = PlatformLesson.fromJson(jsonMap);
      expect(lesson.id, equals('lesson_example_1'));
      expect(lesson.title, equals('A Reversão de Martelo no Suporte'));
      expect(lesson.content, contains('força vendedora perdeu o controle'));

      final serialized = lesson.toJson();
      expect(serialized['id'], equals('lesson_example_1'));
    });

    test('Should parse Exercise Golden Sample correctly', () {
      final file = File('content/examples/exercise/exercise_example.json');
      expect(file.existsSync(), isTrue);

      final jsonStr = file.readAsStringSync();
      final jsonMap = json.decode(jsonStr) as Map<String, dynamic>;

      final exercise = PlatformExercise.fromJson(jsonMap);
      expect(exercise.id, equals('exercise_example_1'));
      expect(exercise.checklist, hasLength(4));
      expect(exercise.checklist.first, contains('suporte anterior'));

      final serialized = exercise.toJson();
      expect(serialized['id'], equals('exercise_example_1'));
    });

    test('Should parse Quiz Golden Sample correctly', () {
      final file = File('content/examples/quiz/quiz_example.json');
      expect(file.existsSync(), isTrue);

      final jsonStr = file.readAsStringSync();
      final jsonMap = json.decode(jsonStr) as Map<String, dynamic>;

      final quiz = PlatformQuiz.fromJson(jsonMap);
      expect(quiz.id, equals('quiz_example_1'));
      expect(quiz.options, hasLength(3));
      expect(quiz.correctIndex, equals(1));
      expect(quiz.explanation, contains('território de preço da onda 1'));

      final serialized = quiz.toJson();
      expect(serialized['id'], equals('quiz_example_1'));
    });

    test('Should parse Challenge Golden Sample correctly', () {
      final file = File('content/examples/challenge/challenge_example.json');
      expect(file.existsSync(), isTrue);

      final jsonStr = file.readAsStringSync();
      final jsonMap = json.decode(jsonStr) as Map<String, dynamic>;

      final challenge = PlatformChallenge.fromJson(jsonMap);
      expect(challenge.id, equals('challenge_example_1'));
      expect(challenge.title, contains('Linha de Pescoço'));

      final serialized = challenge.toJson();
      expect(serialized['id'], equals('challenge_example_1'));
    });
  });
}
