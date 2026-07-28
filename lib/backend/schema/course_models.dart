class Course {
  final String id;
  final String title;
  final String description;
  final List<Module> modules;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.modules,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      modules: (json['modules'] as List<dynamic>?)
              ?.map((m) => Module.fromJson(m))
              .toList() ??
          [],
    );
  }
}

class Module {
  final String id;
  final String title;
  final String description;
  final List<Lesson> lessons;
  final List<Example> examples;
  final List<Exercise> exercises;
  final List<QuizQuestion> quizzes;
  final List<Challenge> challenges;

  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    required this.examples,
    required this.exercises,
    required this.quizzes,
    required this.challenges,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((l) => Lesson.fromJson(l))
              .toList() ??
          [],
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) => Example.fromJson(e))
              .toList() ??
          [],
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromJson(e))
              .toList() ??
          [],
      quizzes: (json['quizzes'] as List<dynamic>?)
              ?.map((q) => QuizQuestion.fromJson(q))
              .toList() ??
          [],
      challenges: (json['challenges'] as List<dynamic>?)
              ?.map((c) => Challenge.fromJson(c))
              .toList() ??
          [],
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final String content;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}

class Example {
  final String id;
  final String title;
  final String description;
  final String chartType;

  Example({
    required this.id,
    required this.title,
    required this.description,
    required this.chartType,
  });

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      chartType: json['chartType'] ?? '',
    );
  }
}

class Exercise {
  final String id;
  final String instruction;
  final List<String> checklist;

  Exercise({
    required this.id,
    required this.instruction,
    required this.checklist,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      instruction: json['instruction'] ?? '',
      checklist: List<String>.from(json['checklist'] ?? []),
    );
  }
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.dynamicExplanation, // generic name to support different schema
  }) : explanation = dynamicExplanation;

  final String dynamicExplanation;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctIndex: json['correctIndex'] ?? 0,
      dynamicExplanation: json['explanation'] ?? '',
    );
  }
}

class Challenge {
  final String id;
  final String title;
  final String description;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
