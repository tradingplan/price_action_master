import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProAccessService extends ChangeNotifier {
  static final ProAccessService _instance = ProAccessService._internal();
  factory ProAccessService() => _instance;
  ProAccessService._internal();

  static const String _prefKeyIsPro = 'pam_user_is_pro_lifetime';

  bool _isPro = false;
  bool _isInitialized = false;

  bool get isPro => _isPro;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _isPro = prefs.getBool(_prefKeyIsPro) ?? false;
    } catch (e) {
      // ignore: avoid_print
      print('ProAccessService: Failed to read local Pro state: $e');
      _isPro = false;
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Desbloqueia o plano PRO vitalício localmente
  Future<void> unlockProLifetime() async {
    _isPro = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKeyIsPro, true);
    } catch (e) {
      // ignore: avoid_print
      print('ProAccessService: Error persisting Pro state: $e');
    }
    notifyListeners();
  }

  /// Restaura compras prévias (útil para suporte ou reinstalação)
  Future<bool> restorePurchase() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isPro = prefs.getBool(_prefKeyIsPro) ?? false;
      notifyListeners();
      return _isPro;
    } catch (e) {
      return false;
    }
  }

  /// Para testes de desenvolvimento/depuração (alternar status)
  Future<void> toggleProForTesting() async {
    _isPro = !_isPro;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKeyIsPro, _isPro);
    } catch (_) {}
    notifyListeners();
  }
}

