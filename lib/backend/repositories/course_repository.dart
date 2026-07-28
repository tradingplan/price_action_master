import 'dart:convert';
import 'package:flutter/services.dart';
import '../schema/platform_course_models.dart';

abstract class CourseRepository {
  Future<List<PlatformCourse>> getAllCourses();
  Future<PlatformCourse?> getCourseById(String id);
}

class LocalCourseRepository implements CourseRepository {
  // Catálogo estático usado como fallback em caso de falha de leitura do manifesto (ex: testes unitários)
  static const List<String> _fallbackCourseIds = ['candlesticks', 'figuras', 'smc', 'elliott', 'gestao_risco', 'wyckoff'];

  @override
  Future<List<PlatformCourse>> getAllCourses() async {
    final List<PlatformCourse> courses = [];
    List<String> ids = [];

    try {
      final String manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent) as Map<String, dynamic>;
      
      // Filtrar os assets de cursos
      final List<String> coursePaths = manifestMap.keys
          .where((String key) => key.startsWith('content/courses/') && key.endsWith('.json'))
          .toList();

      for (final path in coursePaths) {
        final String filename = path.split('/').last;
        final String id = filename.substring(0, filename.length - 5); // remover '.json'
        if (id.isNotEmpty) {
          ids.add(id);
        }
      }
    } catch (e) {
      print('LocalCourseRepository: Erro ao listar assets dinamicamente: $e. Usando fallback.');
      ids = List.from(_fallbackCourseIds);
    }

    // Se por algum motivo a lista dinâmica veio vazia, usa o fallback
    if (ids.isEmpty) {
      ids = List.from(_fallbackCourseIds);
    }

    for (final id in ids) {
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
