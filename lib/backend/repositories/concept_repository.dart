import 'dart:convert';
import 'package:flutter/services.dart';
import '../schema/platform_concept_model.dart';

abstract class ConceptRepository {
  Future<List<PlatformConcept>> getAllConcepts();
}

class LocalConceptRepository implements ConceptRepository {
  static const String _assetPath = 'content/reference/conceitos.json';

  @override
  Future<List<PlatformConcept>> getAllConcepts() async {
    try {
      final String jsonStr = await rootBundle.loadString(_assetPath);
      final List<dynamic> rawList = json.decode(jsonStr) as List<dynamic>;
      return rawList
          .map((c) => PlatformConcept.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Platform Data Layer: Error loading concepts asset: $e');
      return [];
    }
  }
}
