import 'dart:convert';
import 'package:flutter/services.dart';
import '../schema/strategy_model.dart';

abstract class StrategyRepository {
  Future<List<StrategyModel>> getAllStrategies();
  Future<StrategyModel?> getStrategyById(String id);
  Future<List<String>> getCategories();
}

class LocalStrategyRepository implements StrategyRepository {
  static final LocalStrategyRepository _instance = LocalStrategyRepository._internal();
  factory LocalStrategyRepository() => _instance;
  LocalStrategyRepository._internal();

  List<StrategyModel>? _cache;

  @override
  Future<List<StrategyModel>> getAllStrategies() async {
    if (_cache != null) {
      return _cache!;
    }

    try {
      final String jsonStr = await rootBundle.loadString('content/estrategias/estrategias.json');
      final List<dynamic> rawList = json.decode(jsonStr) as List<dynamic>;
      _cache = rawList
          .map((item) => StrategyModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return _cache!;
    } catch (e) {
      // ignore: avoid_print
      print('LocalStrategyRepository error: $e');
      return [];
    }
  }

  @override
  Future<StrategyModel?> getStrategyById(String id) async {
    final list = await getAllStrategies();
    try {
      return list.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    final list = await getAllStrategies();
    final categories = <String>{'Todas'};
    for (final s in list) {
      if (s.categoria.isNotEmpty) {
        categories.add(s.categoria);
      }
    }
    return categories.toList();
  }
}

