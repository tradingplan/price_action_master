import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class AdService {
  // IDs Reais do AdMob fornecidos pelo usuário
  static const String androidAppId = 'ca-app-pub-8743976567848644~9150295307';
  static const String androidBannerUnitId = 'ca-app-pub-8743976567848644/3393290334';

  // IDs Oficiais de Teste do Google AdMob (para evitar banimento durante desenvolvimento)
  static const String testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String testBannerIOS = 'ca-app-pub-3940256099942544/2934735716';

  /// Retorna o ID correto do bloco de anúncios:
  /// - Em modo de Desenvolvimento (debug): retorna o ID de teste do Google.
  /// - Em modo de Produção (release): retorna o seu ID real oficial.
  static String get bannerAdUnitId {
    if (kDebugMode) {
      if (!kIsWeb && Platform.isIOS) {
        return testBannerIOS;
      }
      return testBannerAndroid;
    }

    // Em Release (App de produção na Google Play / App Store)
    if (!kIsWeb && Platform.isIOS) {
      // Caso configure um Ad Unit específico para iOS no futuro
      return testBannerIOS;
    }
    return androidBannerUnitId;
  }
}
