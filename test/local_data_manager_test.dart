import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:price_action_master/backend/local_data_manager.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock do SharedPreferences
  SharedPreferences.setMockInitialValues({});

  // Mock do PathProvider de forma compatível com Flutter moderno
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (MethodCall methodCall) async {
      return '.'; // Retorna o diretório atual de execução dos testes
    },
  );

  setUp(() async {
    await LocalDataManager.init();
    await LocalDataManager.clearAllData();
  });

  test('Deve obter o saldo padrão do simulador e atualizá-lo', () async {
    expect(LocalDataManager.getSimulatorBalance(), 10000.0);
    await LocalDataManager.setSimulatorBalance(12500.50);
    expect(LocalDataManager.getSimulatorBalance(), 12500.50);
  });

  test('Deve gravar e obter a data e ID da última carta tirada no Tarot', () async {
    expect(LocalDataManager.getLastTarotDrawDate(), isNull);
    expect(LocalDataManager.getLastTarotCardId(), isNull);

    await LocalDataManager.setLastTarotDrawDate('2026-07-27');
    await LocalDataManager.setLastTarotCardId('a_torre');

    expect(LocalDataManager.getLastTarotDrawDate(), '2026-07-27');
    expect(LocalDataManager.getLastTarotCardId(), 'a_torre');
  });

  test('Deve persistir tentativas de Quizzes no arquivo JSON local', () async {
    var history = await LocalDataManager.getQuizHistory();
    expect(history, isEmpty);

    await LocalDataManager.saveQuizAttempt(
      category: 'CANDLESTICKS',
      score: 5,
      totalQuestions: 5,
      date: '2026-07-27',
    );

    history = await LocalDataManager.getQuizHistory();
    expect(history, isNotEmpty);
    expect(history.length, 1);
    expect(history[0]['category'], 'CANDLESTICKS');
    expect(history[0]['score'], 5);
    expect(history[0]['totalQuestions'], 5);
    expect(history[0]['date'], '2026-07-27');
  });

  test('Deve persistir ordens executadas no Simulador no arquivo JSON local', () async {
    var history = await LocalDataManager.getTradeHistory();
    expect(history, isEmpty);

    await LocalDataManager.saveTradeOrder(
      asset: 'WIN',
      type: 'COMPRA',
      contracts: 5,
      entryPrice: 120500.0,
      exitPrice: 120700.0,
      pointsProfit: 200.0,
      financialProfit: 200.0,
      date: '2026-07-27',
    );

    history = await LocalDataManager.getTradeHistory();
    expect(history, isNotEmpty);
    expect(history.length, 1);
    expect(history[0]['asset'], 'WIN');
    expect(history[0]['type'], 'COMPRA');
    expect(history[0]['contracts'], 5);
    expect(history[0]['pointsProfit'], 200.0);
    expect(history[0]['financialProfit'], 200.0);
  });
}
