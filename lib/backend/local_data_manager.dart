import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataManager {
  static SharedPreferences? _prefs;

  // Inicializa o SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- PERSISTÊNCIA CHAVE-VALOR SIMPLES (SharedPreferences) ---

  // Saldo do Simulador de Trading
  static double getSimulatorBalance() {
    return _prefs?.getDouble('sim_balance') ?? 10000.0;
  }

  static Future<void> setSimulatorBalance(double newBalance) async {
    await _prefs?.setDouble('sim_balance', newBalance);
  }

  // Data da última tiragem de carta do Tarot (formato YYYY-MM-DD)
  static String? getLastTarotDrawDate() {
    return _prefs?.getString('last_tarot_date');
  }

  static Future<void> setLastTarotDrawDate(String dateStr) async {
    await _prefs?.setString('last_tarot_date', dateStr);
  }

  // ID da última carta tirada no Tarot
  static String? getLastTarotCardId() {
    return _prefs?.getString('last_tarot_card_id');
  }

  static Future<void> setLastTarotCardId(String cardId) async {
    await _prefs?.setString('last_tarot_card_id', cardId);
  }

  // --- REGISTROS DE HISTÓRICO ESTRUTURADOS (JSON no disco local) ---

  // Retorna a referência de arquivo local na pasta de documentos do aplicativo
  static Future<File> _getLocalFile(String filename) async {
    // Nota: Em testes isolados do Flutter (desktop/unit test), o path_provider
    // pode exigir inicialização de caminhos temporários. Por padrão, no app real,
    // getApplicationDocumentsDirectory() retorna o diretório sandbox correto.
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$filename');
  }

  // Genérico: Grava uma lista de mapas em um arquivo local
  static Future<void> _writeJsonList(String filename, List<dynamic> list) async {
    try {
      final file = await _getLocalFile(filename);
      await file.writeAsString(json.encode(list));
    } catch (e) {
      print('Error writing local JSON file $filename: $e');
    }
  }

  // Genérico: Lê uma lista de mapas de um arquivo local
  static Future<List<dynamic>> _readJsonList(String filename) async {
    try {
      final file = await _getLocalFile(filename);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      return json.decode(content) as List<dynamic>;
    } catch (e) {
      print('Error reading local JSON file $filename: $e');
      return [];
    }
  }

  // --- HISTÓRICO DE QUIZZES ---

  static Future<void> saveQuizAttempt({
    required String category,
    required int score,
    required int totalQuestions,
    required String date,
  }) async {
    final history = await _readJsonList('quiz_history.json');
    history.add({
      'category': category,
      'score': score,
      'totalQuestions': totalQuestions,
      'date': date,
    });
    await _writeJsonList('quiz_history.json', history);
  }

  static Future<List<dynamic>> getQuizHistory() async {
    return await _readJsonList('quiz_history.json');
  }

  // --- HISTÓRICO DE OPERAÇÕES DO SIMULADOR ---

  static Future<void> saveTradeOrder({
    required String asset,
    required String type, // 'COMPRA' ou 'VENDA'
    required int contracts,
    required double entryPrice,
    required double exitPrice,
    required double pointsProfit,
    required double financialProfit,
    required String date,
  }) async {
    final history = await _readJsonList('trade_history.json');
    history.add({
      'asset': asset,
      'type': type,
      'contracts': contracts,
      'entryPrice': entryPrice,
      'exitPrice': exitPrice,
      'pointsProfit': pointsProfit,
      'financialProfit': financialProfit,
      'date': date,
    });
    await _writeJsonList('trade_history.json', history);
  }

  static Future<List<dynamic>> getTradeHistory() async {
    return await _readJsonList('trade_history.json');
  }

  // --- PROGRESSO DE CURSOS E MÓDULOS ---
  static bool isModuleCompleted(String courseId, String moduleId) {
    return _prefs?.getBool('completed_${courseId}_${moduleId}') ?? false;
  }

  static Future<void> setModuleCompleted(String courseId, String moduleId, bool completed) async {
    await _prefs?.setBool('completed_${courseId}_${moduleId}', completed);
  }

  // --- CONTROLE DE XP DO USUÁRIO ---
  static int getXP() {
    return _prefs?.getInt('user_xp') ?? 0;
  }

  static Future<void> addXP(int points) async {
    final current = getXP();
    await _prefs?.setInt('user_xp', current + points);
  }

  // --- LIMPAR TODOS OS DADOS ---
  static Future<void> clearAllData() async {
    await _prefs?.clear();
    try {
      final quizFile = await _getLocalFile('quiz_history.json');
      if (await quizFile.exists()) await quizFile.delete();
      final tradeFile = await _getLocalFile('trade_history.json');
      if (await tradeFile.exists()) await tradeFile.delete();
    } catch (e) {
      print('Error clearing local files: $e');
    }
  }
}
