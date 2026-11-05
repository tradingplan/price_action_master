import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_master/backend/schema/strategy_model.dart';
import 'package:price_action_master/services/pro_access_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Playbook de Estratégias & PRO Testes', () {
    test('Validação do JSON e parsing das 20 estratégias', () async {
      final file = File('content/estrategias/estrategias.json');
      expect(file.existsSync(), isTrue, reason: 'Arquivo estrategias.json deve existir');

      final jsonStr = await file.readAsString();
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;

      expect(list.length, equals(20), reason: 'Devem existir exatamente 20 estratégias');

      final strategies = list
          .map((item) => StrategyModel.fromJson(item as Map<String, dynamic>))
          .toList();

      expect(strategies.length, equals(20));

      final freeStrategies = strategies.where((s) => !s.isPro).toList();
      final proStrategies = strategies.where((s) => s.isPro).toList();

      expect(freeStrategies.length, greaterThanOrEqualTo(3),
          reason: 'Deve haver estratégias gratuitas no Free tier');
      expect(proStrategies.length, greaterThanOrEqualTo(15),
          reason: 'A maioria dos setups avançados (SMC) deve ser PRO');

      for (final s in strategies) {
        expect(s.id.isNotEmpty, isTrue);
        expect(s.nome.isNotEmpty, isTrue);
        expect(s.categoria.isNotEmpty, isTrue);
        expect(s.checklist.isNotEmpty, isTrue,
            reason: 'Toda estratégia deve ter itens no checklist pré-trade');
        expect(s.content.isNotEmpty, isTrue);
      }
    });

    test('ProAccessService gerencia estado PRO localmente', () async {
      SharedPreferences.setMockInitialValues({});
      final service = ProAccessService();
      await service.initialize();

      expect(service.isPro, isFalse);

      await service.unlockProLifetime();
      expect(service.isPro, isTrue);

      final restored = await service.restorePurchase();
      expect(restored, isTrue);
    });
  });
}

