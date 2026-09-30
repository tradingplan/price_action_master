import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'schema/platform_course_models.dart';

class LocalDataManager {
  static SharedPreferences? _prefs;
  static const String _certSecretSalt = 'PRICE_ACTION_MASTER_KEY_2026_OFFLINE';

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

  // --- MOTOR DE REPETIÇÃO ESPAÇADA (LEITNER SYSTEM) ---

  static int _getIntervalDaysForBox(int box) {
    switch (box) {
      case 1:
        return 1; // Box 1: revisão diária
      case 2:
        return 3; // Box 2: revisão a cada 3 dias
      case 3:
        return 7; // Box 3: revisão a cada 7 dias
      case 4:
        return 14; // Box 4: revisão a cada 14 dias
      case 5:
        return 30; // Box 5: conhecimento consolidado (30 dias)
      default:
        return 1;
    }
  }

  static String _formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static Future<List<PlatformSpacedRepetitionItem>> getSpacedRepetitionItems() async {
    final list = await _readJsonList('spaced_repetition.json');
    return list.map((item) => PlatformSpacedRepetitionItem.fromJson(item as Map<String, dynamic>)).toList();
  }

  static Future<PlatformSpacedRepetitionItem> recordSpacedRepetitionReview({
    required String id,
    required String courseId,
    required String moduleId,
    required String title,
    required bool isCorrect,
  }) async {
    final items = await getSpacedRepetitionItems();
    final now = DateTime.now();
    final nowIso = now.toIso8601String();

    final existingIndex = items.indexWhere((it) => it.id == id);
    int newBox = 1;
    int consecutive = 0;
    int total = 1;

    if (existingIndex != -1) {
      final existing = items[existingIndex];
      total = existing.totalReviews + 1;
      if (isCorrect) {
        newBox = (existing.box < 5) ? existing.box + 1 : 5;
        consecutive = existing.consecutiveCorrect + 1;
      } else {
        newBox = 1; // Se errou, retorna imediatamente para a Box 1
        consecutive = 0;
      }
    } else {
      if (isCorrect) {
        newBox = 2;
        consecutive = 1;
      } else {
        newBox = 1;
        consecutive = 0;
      }
    }

    final intervalDays = _getIntervalDaysForBox(newBox);
    final nextReviewDate = _formatDate(now.add(Duration(days: intervalDays)));

    final updatedItem = PlatformSpacedRepetitionItem(
      id: id,
      courseId: courseId,
      moduleId: moduleId,
      title: title,
      box: newBox,
      lastReviewedAt: nowIso,
      nextReviewDate: nextReviewDate,
      consecutiveCorrect: consecutive,
      totalReviews: total,
    );

    if (existingIndex != -1) {
      items[existingIndex] = updatedItem;
    } else {
      items.add(updatedItem);
    }

    await _writeJsonList('spaced_repetition.json', items.map((i) => i.toJson()).toList());
    return updatedItem;
  }

  static Future<List<PlatformSpacedRepetitionItem>> getDueReviewItems() async {
    final items = await getSpacedRepetitionItems();
    final today = _formatDate(DateTime.now());
    return items.where((item) => item.nextReviewDate.compareTo(today) <= 0).toList();
  }

  // --- CERTIFICADOS DIGITAIS OFFLINE (SHA-256) ---

  static String _generateVerificationHash({
    required String certId,
    required String courseId,
    required String studentName,
    required String issuedAt,
    required int xpEarned,
    required int correctAnswers,
  }) {
    final payload = '$certId:$courseId:$studentName:$issuedAt:$xpEarned:$correctAnswers:$_certSecretSalt';
    return sha256.convert(utf8.encode(payload)).toString();
  }

  static Future<PlatformCertificate> generateCertificate({
    required String courseId,
    required String studentName,
    required int xpEarned,
    required int correctAnswers,
  }) async {
    final existing = await getCertificateForCourse(courseId);
    if (existing != null) {
      return existing;
    }

    final certId = 'cert_${courseId}_${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
    final issuedAt = DateTime.now().toIso8601String();
    final hash = _generateVerificationHash(
      certId: certId,
      courseId: courseId,
      studentName: studentName,
      issuedAt: issuedAt,
      xpEarned: xpEarned,
      correctAnswers: correctAnswers,
    );

    final cert = PlatformCertificate(
      id: certId,
      courseId: courseId,
      studentName: studentName,
      issuedAt: issuedAt,
      verificationHash: hash,
      metadata: PlatformCertificateMetadata(
        xpEarned: xpEarned,
        correctAnswers: correctAnswers,
      ),
    );

    final certs = await getCertificates();
    certs.add(cert);
    await _writeJsonList('certificates.json', certs.map((c) => c.toJson()).toList());
    return cert;
  }

  static Future<List<PlatformCertificate>> getCertificates() async {
    final list = await _readJsonList('certificates.json');
    return list.map((c) => PlatformCertificate.fromJson(c as Map<String, dynamic>)).toList();
  }

  static Future<PlatformCertificate?> getCertificateForCourse(String courseId) async {
    final certs = await getCertificates();
    final index = certs.indexWhere((c) => c.courseId == courseId);
    if (index != -1) return certs[index];
    return null;
  }

  static bool verifyCertificate(PlatformCertificate cert) {
    final expectedHash = _generateVerificationHash(
      certId: cert.id,
      courseId: cert.courseId,
      studentName: cert.studentName,
      issuedAt: cert.issuedAt,
      xpEarned: cert.metadata.xpEarned,
      correctAnswers: cert.metadata.correctAnswers,
    );
    return cert.verificationHash == expectedHash;
  }

  // --- LIMPAR TODOS OS DADOS ---
  static Future<void> clearAllData() async {
    await _prefs?.clear();
    try {
      final quizFile = await _getLocalFile('quiz_history.json');
      if (await quizFile.exists()) await quizFile.delete();
      final tradeFile = await _getLocalFile('trade_history.json');
      if (await tradeFile.exists()) await tradeFile.delete();
      final srFile = await _getLocalFile('spaced_repetition.json');
      if (await srFile.exists()) await srFile.delete();
      final certFile = await _getLocalFile('certificates.json');
      if (await certFile.exists()) await certFile.delete();
    } catch (e) {
      print('Error clearing local files: $e');
    }
  }
}
