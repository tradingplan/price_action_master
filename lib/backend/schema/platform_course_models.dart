class PlatformCourse {
  final String id;
  final String title;
  final String description;
  final int version;
  final List<PlatformModule> modules;

  PlatformCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.version,
    required this.modules,
  });

  factory PlatformCourse.fromJson(Map<String, dynamic> json) {
    return PlatformCourse(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      version: json['version'] as int? ?? 1,
      modules: (json['modules'] as List<dynamic>?)
              ?.map((m) => PlatformModule.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'version': version,
        'modules': modules.map((m) => m.toJson()).toList(),
      };
}

class PlatformModule {
  final String id;
  final String title;
  final String description;
  final int xpValue;
  final List<PlatformLesson> lessons;
  final List<PlatformExample> examples;
  final List<PlatformExercise> exercises;
  final List<PlatformQuiz> quizzes;
  final List<PlatformChallenge> challenges;

  PlatformModule({
    required this.id,
    required this.title,
    required this.description,
    required this.xpValue,
    required this.lessons,
    required this.examples,
    required this.exercises,
    required this.quizzes,
    required this.challenges,
  });

  factory PlatformModule.fromJson(Map<String, dynamic> json) {
    return PlatformModule(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      xpValue: json['xpValue'] as int? ?? 0,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((l) => PlatformLesson.fromJson(l as Map<String, dynamic>))
              .toList() ??
          [],
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) => PlatformExample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => PlatformExercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      quizzes: (json['quizzes'] as List<dynamic>?)
              ?.map((q) => PlatformQuiz.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
      challenges: (json['challenges'] as List<dynamic>?)
              ?.map((c) => PlatformChallenge.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'xpValue': xpValue,
        'lessons': lessons.map((l) => l.toJson()).toList(),
        'examples': examples.map((e) => e.toJson()).toList(),
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'quizzes': quizzes.map((q) => q.toJson()).toList(),
        'challenges': challenges.map((c) => c.toJson()).toList(),
      };
}

class PlatformLesson {
  final String id;
  final String title;
  final String content;

  PlatformLesson({
    required this.id,
    required this.title,
    required this.content,
  });

  factory PlatformLesson.fromJson(Map<String, dynamic> json) {
    return PlatformLesson(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
      };
}

class PlatformExample {
  final String id;
  final String title;
  final String description;
  final String? chartType;
  final PlatformVectorCanvas? vectorCanvas;

  PlatformExample({
    required this.id,
    required this.title,
    required this.description,
    this.chartType,
    this.vectorCanvas,
  });

  factory PlatformExample.fromJson(Map<String, dynamic> json) {
    return PlatformExample(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      chartType: json['chartType'] as String?,
      vectorCanvas: json['vectorCanvas'] != null
          ? PlatformVectorCanvas.fromJson(json['vectorCanvas'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        if (chartType != null) 'chartType': chartType,
        if (vectorCanvas != null) 'vectorCanvas': vectorCanvas!.toJson(),
      };
}

class PlatformVectorCanvas {
  final double width;
  final double height;
  final List<PlatformVectorElement> elements;

  PlatformVectorCanvas({
    required this.width,
    required this.height,
    required this.elements,
  });

  factory PlatformVectorCanvas.fromJson(Map<String, dynamic> json) {
    return PlatformVectorCanvas(
      width: (json['width'] as num? ?? 200.0).toDouble(),
      height: (json['height'] as num? ?? 100.0).toDouble(),
      elements: (json['elements'] as List<dynamic>?)
              ?.map((e) => PlatformVectorElement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'elements': elements.map((e) => e.toJson()).toList(),
      };
}

class PlatformVectorElement {
  final String type;
  final double? x1;
  final double? y1;
  final double? x2;
  final double? y2;
  final double? cx;
  final double? cy;
  final double? r;
  final double? x;
  final double? y;
  final String? content;
  final String? colorStyle;

  PlatformVectorElement({
    required this.type,
    this.x1,
    this.y1,
    this.x2,
    this.y2,
    this.cx,
    this.cy,
    this.r,
    this.x,
    this.y,
    this.content,
    this.colorStyle,
  });

  factory PlatformVectorElement.fromJson(Map<String, dynamic> json) {
    return PlatformVectorElement(
      type: json['type'] as String? ?? 'line',
      x1: (json['x1'] as num?)?.toDouble(),
      y1: (json['y1'] as num?)?.toDouble(),
      x2: (json['x2'] as num?)?.toDouble(),
      y2: (json['y2'] as num?)?.toDouble(),
      cx: (json['cx'] as num?)?.toDouble(),
      cy: (json['cy'] as num?)?.toDouble(),
      r: (json['r'] as num?)?.toDouble(),
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
      content: json['content'] as String?,
      colorStyle: json['colorStyle'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        if (x1 != null) 'x1': x1,
        if (y1 != null) 'y1': y1,
        if (x2 != null) 'x2': x2,
        if (y2 != null) 'y2': y2,
        if (cx != null) 'cx': cx,
        if (cy != null) 'cy': cy,
        if (r != null) 'r': r,
        if (x != null) 'x': x,
        if (y != null) 'y': y,
        if (content != null) 'content': content,
        if (colorStyle != null) 'colorStyle': colorStyle,
      };
}

class PlatformExercise {
  final String id;
  final String instruction;
  final List<String> checklist;

  PlatformExercise({
    required this.id,
    required this.instruction,
    required this.checklist,
  });

  factory PlatformExercise.fromJson(Map<String, dynamic> json) {
    return PlatformExercise(
      id: json['id'] as String? ?? '',
      instruction: json['instruction'] as String? ?? '',
      checklist: (json['checklist'] as List<dynamic>?)?.map((c) => c as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'instruction': instruction,
        'checklist': checklist,
      };
}

class PlatformQuiz {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  PlatformQuiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory PlatformQuiz.fromJson(Map<String, dynamic> json) {
    return PlatformQuiz(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)?.map((o) => o as String).toList() ?? [],
      correctIndex: json['correctIndex'] as int? ?? 0,
      explanation: json['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'options': options,
        'correctIndex': correctIndex,
        'explanation': explanation,
      };
}

class PlatformChallenge {
  final String id;
  final String title;
  final String description;

  PlatformChallenge({
    required this.id,
    required this.title,
    required this.description,
  });

  factory PlatformChallenge.fromJson(Map<String, dynamic> json) {
    return PlatformChallenge(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
      };
}

class PlatformProgress {
  final String userId;
  final List<PlatformCourseProgress> completedCourses;
  final List<PlatformModuleProgress> completedModules;

  PlatformProgress({
    required this.userId,
    required this.completedCourses,
    required this.completedModules,
  });

  factory PlatformProgress.fromJson(Map<String, dynamic> json) {
    return PlatformProgress(
      userId: json['userId'] as String? ?? '',
      completedCourses: (json['completedCourses'] as List<dynamic>?)
              ?.map((c) => PlatformCourseProgress.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      completedModules: (json['completedModules'] as List<dynamic>?)
              ?.map((m) => PlatformModuleProgress.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'completedCourses': completedCourses.map((c) => c.toJson()).toList(),
        'completedModules': completedModules.map((m) => m.toJson()).toList(),
      };
}

class PlatformCourseProgress {
  final String courseId;
  final String completedAt;
  final bool certificateEarned;

  PlatformCourseProgress({
    required this.courseId,
    required this.completedAt,
    required this.certificateEarned,
  });

  factory PlatformCourseProgress.fromJson(Map<String, dynamic> json) {
    return PlatformCourseProgress(
      courseId: json['courseId'] as String? ?? '',
      completedAt: json['completedAt'] as String? ?? '',
      certificateEarned: json['certificateEarned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'completedAt': completedAt,
        'certificateEarned': certificateEarned,
      };
}

class PlatformModuleProgress {
  final String courseId;
  final String moduleId;
  final String completedAt;
  final int score;

  PlatformModuleProgress({
    required this.courseId,
    required this.moduleId,
    required this.completedAt,
    required this.score,
  });

  factory PlatformModuleProgress.fromJson(Map<String, dynamic> json) {
    return PlatformModuleProgress(
      courseId: json['courseId'] as String? ?? '',
      moduleId: json['moduleId'] as String? ?? '',
      completedAt: json['completedAt'] as String? ?? '',
      score: json['score'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'moduleId': moduleId,
        'completedAt': completedAt,
        'score': score,
      };
}

class PlatformCertificate {
  final String id;
  final String courseId;
  final String studentName;
  final String issuedAt;
  final String verificationHash;
  final PlatformCertificateMetadata metadata;

  PlatformCertificate({
    required this.id,
    required this.courseId,
    required this.studentName,
    required this.issuedAt,
    required this.verificationHash,
    required this.metadata,
  });

  factory PlatformCertificate.fromJson(Map<String, dynamic> json) {
    return PlatformCertificate(
      id: json['id'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      issuedAt: json['issuedAt'] as String? ?? '',
      verificationHash: json['verificationHash'] as String? ?? '',
      metadata: PlatformCertificateMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'studentName': studentName,
        'issuedAt': issuedAt,
        'verificationHash': verificationHash,
        'metadata': metadata.toJson(),
      };
}

class PlatformCertificateMetadata {
  final int xpEarned;
  final int correctAnswers;

  PlatformCertificateMetadata({
    required this.xpEarned,
    required this.correctAnswers,
  });

  factory PlatformCertificateMetadata.fromJson(Map<String, dynamic> json) {
    return PlatformCertificateMetadata(
      xpEarned: json['xpEarned'] as int? ?? 0,
      correctAnswers: json['correctAnswers'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'xpEarned': xpEarned,
        'correctAnswers': correctAnswers,
      };
}

class PlatformAnalytics {
  final List<PlatformAnalyticsEvent> events;

  PlatformAnalytics({
    required this.events,
  });

  factory PlatformAnalytics.fromJson(Map<String, dynamic> json) {
    return PlatformAnalytics(
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => PlatformAnalyticsEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'events': events.map((e) => e.toJson()).toList(),
      };
}

class PlatformAnalyticsEvent {
  final String timestamp;
  final String eventType;
  final String courseId;
  final String moduleId;
  final int durationSeconds;

  PlatformAnalyticsEvent({
    required this.timestamp,
    required this.eventType,
    required this.courseId,
    required this.moduleId,
    required this.durationSeconds,
  });

  factory PlatformAnalyticsEvent.fromJson(Map<String, dynamic> json) {
    return PlatformAnalyticsEvent(
      timestamp: json['timestamp'] as String? ?? '',
      eventType: json['eventType'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      moduleId: json['moduleId'] as String? ?? '',
      durationSeconds: json['durationSeconds'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'eventType': eventType,
        'courseId': courseId,
        'moduleId': moduleId,
        'durationSeconds': durationSeconds,
      };
}
