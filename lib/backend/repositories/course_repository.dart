import 'dart:convert';
import 'package:flutter/services.dart';
import '../schema/platform_course_models.dart';

abstract class CourseRepository {
  Future<List<PlatformCourse>> getAllCourses();
  Future<PlatformCourse?> getCourseById(String id);
}

class LocalCourseRepository implements CourseRepository {
  // Catálogo estático de cursos conhecidos pela plataforma
  static const List<String> _courseIds = ['candlesticks', 'figuras', 'smc', 'elliott', 'gestao_risco'];

  @override
  Future<List<PlatformCourse>> getAllCourses() async {
    final List<PlatformCourse> courses = [];
    for (final id in _courseIds) {
      final course = await getCourseById(id);
      if (course != null) {
        courses.add(course);
      }
    }
    return courses;
  }

  @override
  Future<PlatformCourse?> getCourseById(String id) async {
    try {
      final String jsonStr = await rootBundle.loadString('content/courses/$id.json');
      final Map<String, dynamic> rawJson = json.decode(jsonStr) as Map<String, dynamic>;
      return PlatformCourse.fromJson(rawJson);
    } catch (e) {
      // Registrar falha de leitura (ex: arquivo ausente ou malformado)
      print('Platform Data Layer: Error loading course asset for "$id": $e');
      return null;
    }
  }
}
