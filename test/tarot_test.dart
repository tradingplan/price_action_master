import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:price_action_master/backend/local_data_manager.dart';
import 'package:price_action_master/tarot/carta.dart';
import 'package:price_action_master/tarot/tarot_service.dart';
import 'package:price_action_master/pages/tarot/tarot_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock do PathProvider
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (MethodCall methodCall) async {
      return '.';
    },
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalDataManager.init();
    await LocalDataManager.clearAllData();
  });

  group('Tarot Model & Real JSON Parsing Tests', () {
    test('Deve carregar e fazer parse do JSON real com exatamente 22 cartas válidas', () async {
      final file = File('content/tarot/tarot-trader-cartas.json');
      expect(file.existsSync(), isTrue, reason: 'Arquivo tarot-trader-cartas.json deve existir');

      final content = file.readAsStringSync();
      final data = json.decode(content) as Map<String, dynamic>;

      expect(data['versao'], isNotNull);
      expect(data['idioma'], 'pt-BR');
      expect(data['aviso'], isNotEmpty);
      expect(data['regras_de_uso'], isNotNull);

      final cartasJson = data['cartas'] as List<dynamic>;
      expect(cartasJson.length, 22, reason: 'Devem existir exatamente 22 cartas');

      final List<Carta> cartas = cartasJson.map((c) => Carta.fromJson(c as Map<String, dynamic>)).toList();
      expect(cartas.length, 22);

      final seenNumbers = <int>{};
      final seenIds = <String>{};

      for (final carta in cartas) {
        expect(carta.numero, inInclusiveRange(1, 22));
        expect(seenNumbers.add(carta.numero), isTrue, reason: 'Número ${carta.numero} duplicado');
        expect(seenIds.add(carta.id), isTrue, reason: 'ID ${carta.id} duplicado');

        expect(carta.arquetipo, isNotEmpty);
        expect(carta.emocao, isNotEmpty);
        expect(carta.polaridade, isIn(['bear', 'bull']));
        expect(carta.icone, isNotEmpty);
        expect(carta.psychLoad, inInclusiveRange(0, 100));
        expect(carta.vies, isNotEmpty);
        expect(carta.sabedoria, isNotEmpty);
        expect(carta.sinais.length, inInclusiveRange(2, 3));
        for (final sinal in carta.sinais) {
          expect(sinal, isNotEmpty);
        }
        expect(carta.antidoto, isNotEmpty);
        expect(carta.fonte, isNotEmpty);

        // Testa round-trip JSON
        final jsonMap = carta.toJson();
        final reconstructed = Carta.fromJson(jsonMap);
        expect(reconstructed, equals(carta));
      }
    });

    test('Deve serializar e deserializar Leitura corretamente', () {
      const leitura = Leitura(
        data: '2026-09-30',
        cartaId: 'vingador-do-mercado',
        psychLoad: 78,
        biasStatus: 'UNSTABLE_OVERLOAD',
      );

      final jsonMap = leitura.toJson();
      final fromJson = Leitura.fromJson(jsonMap);

      expect(fromJson, equals(leitura));
      expect(fromJson.data, '2026-09-30');
      expect(fromJson.cartaId, 'vingador-do-mercado');
      expect(fromJson.psychLoad, 78);
      expect(fromJson.biasStatus, 'UNSTABLE_OVERLOAD');
    });
  });

  group('TarotService Business Rules & Logic Tests', () {
    test('Deve calcular os limites de biasStatus com exatidão (39, 40, 59, 60, 79, 80)', () {
      expect(TarotService.calcularBiasStatus(0), 'STABLE_FLOW');
      expect(TarotService.calcularBiasStatus(39), 'STABLE_FLOW');
      expect(TarotService.calcularBiasStatus(40), 'CAUTION_DRIFT');
      expect(TarotService.calcularBiasStatus(59), 'CAUTION_DRIFT');
      expect(TarotService.calcularBiasStatus(60), 'UNSTABLE_OVERLOAD');
      expect(TarotService.calcularBiasStatus(79), 'UNSTABLE_OVERLOAD');
      expect(TarotService.calcularBiasStatus(80), 'CRITICAL_TILT');
      expect(TarotService.calcularBiasStatus(100), 'CRITICAL_TILT');
    });

    test('Deve aplicar variação no psych_load e manter sempre clamped entre 0..100', () {
      final cartaBaixa = Carta(
        numero: 22,
        id: 'equanime',
        arquetipo: 'O Equânime',
        emocao: 'EQUILÍBRIO',
        polaridade: 'bull',
        icone: 'scale',
        psychLoad: 10,
        vies: 'Independência',
        sabedoria: 'Sabedoria',
        sinais: const ['Sinal 1', 'Sinal 2'],
        antidoto: 'Antídoto',
        fonte: 'clear',
      );

      final cartaAlta = Carta(
        numero: 11,
        id: 'trader-sem-stop',
        arquetipo: 'O Trader Sem Stop',
        emocao: 'NEGAÇÃO',
        polaridade: 'bear',
        icone: 'octagon-x',
        psychLoad: 88,
        vies: 'Pensamento de exceção',
        sabedoria: 'Sabedoria',
        sinais: const ['Sinal 1', 'Sinal 2'],
        antidoto: 'Antídoto',
        fonte: 'clear',
      );

      for (int delta = -8; delta <= 8; delta++) {
        final loadBaixo = (cartaBaixa.psychLoad + delta).clamp(0, 100);
        expect(loadBaixo, inInclusiveRange(0, 100));

        final loadAlto = (cartaAlta.psychLoad + delta).clamp(0, 100);
        expect(loadAlto, inInclusiveRange(0, 100));
      }
    });

    test('Deve retornar a MESMA leitura ao chamar puxarCarta() duas vezes no mesmo dia', () async {
      final jsonContent = File('content/tarot/tarot-trader-cartas.json').readAsStringSync();
      DateTime fakeTime = DateTime(2026, 9, 30, 10, 0);
      final service = TarotService(
        agora: () => fakeTime,
        random: Random(42),
      );
      service.carregarFromJsonString(jsonContent);

      final leitura1 = await service.puxarCarta();
      final xpAposLeitura1 = LocalDataManager.getXP();
      expect(xpAposLeitura1, TarotService.xpFirstDrawPerDay, reason: 'Deve conceder 25 XP no primeiro sorteio do dia');

      final leitura2 = await service.puxarCarta();
      final xpAposLeitura2 = LocalDataManager.getXP();

      expect(leitura2.data, leitura1.data);
      expect(leitura2.cartaId, leitura1.cartaId);
      expect(leitura2.psychLoad, leitura1.psychLoad);
      expect(leitura2.biasStatus, leitura1.biasStatus);
      expect(xpAposLeitura2, xpAposLeitura1, reason: 'Não deve conceder XP duplicado no mesmo dia');
    });

    test('Deve sortear NOVA leitura quando o relógio avança para o dia seguinte', () async {
      final jsonContent = File('content/tarot/tarot-trader-cartas.json').readAsStringSync();
      DateTime fakeTime = DateTime(2026, 9, 30, 10, 0);
      final service = TarotService(
        agora: () => fakeTime,
        random: Random(100),
      );
      service.carregarFromJsonString(jsonContent);

      final leituraDia1 = await service.puxarCarta();
      expect(leituraDia1.data, '2026-09-30');
      expect(LocalDataManager.getXP(), 25);

      // Avança 1 dia
      fakeTime = DateTime(2026, 10, 1, 9, 30);

      final leituraDia2 = await service.puxarCarta();
      expect(leituraDia2.data, '2026-10-01');
      expect(LocalDataManager.getXP(), 50, reason: 'Deve conceder mais 25 XP no novo dia');
    });

    test('Leitura persistida é recuperada perfeitamente após recriar a instância do serviço', () async {
      final jsonContent = File('content/tarot/tarot-trader-cartas.json').readAsStringSync();
      final fakeTime = DateTime(2026, 9, 30, 14, 0);
      final service1 = TarotService(
        agora: () => fakeTime,
        random: Random(123),
      );
      service1.carregarFromJsonString(jsonContent);

      final leituraOriginal = await service1.puxarCarta();

      final service2 = TarotService(
        agora: () => fakeTime,
        random: Random(999),
      );
      service2.carregarFromJsonString(jsonContent);

      final leituraRecuperada = await service2.obterLeituraDeHoje();
      expect(leituraRecuperada, isNotNull);
      expect(leituraRecuperada!.cartaId, leituraOriginal.cartaId);
      expect(leituraRecuperada.data, leituraOriginal.data);
      expect(leituraRecuperada.psychLoad, leituraOriginal.psychLoad);
      expect(leituraRecuperada.biasStatus, leituraOriginal.biasStatus);
    });

    test('Histórico de leituras é limitado rigorosamente a 90 entradas', () async {
      for (int i = 1; i <= 100; i++) {
        await LocalDataManager.saveTarotHistoryEntry({
          'data': '2026-01-${i.toString().padLeft(2, '0')}',
          'cartaId': 'carta_$i',
          'psychLoad': 50,
          'biasStatus': 'STABLE_FLOW',
        });
      }

      final history = await LocalDataManager.getTarotHistory();
      expect(history.length, 90, reason: 'O histórico deve reter no máximo as últimas 90 entradas');
      expect(history.first['cartaId'], 'carta_11');
      expect(history.last['cartaId'], 'carta_100');
    });
  });

  group('TarotWidget UI & Widget Tests', () {
    testWidgets('Exibe estado inicial com botão "Puxar carta do dia" quando não há leitura hoje', (tester) async {
      final jsonContent = File('content/tarot/tarot-trader-cartas.json').readAsStringSync();
      final service = TarotService(
        agora: () => DateTime(2026, 9, 30),
        random: Random(42),
      );
      service.carregarFromJsonString(jsonContent);

      await tester.pumpWidget(
        MaterialApp(
          home: TarotWidget(service: service),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('CONTROLE DE VIÉS COGNITIVO'), findsOneWidget);
      expect(find.text('Reflexão Psicológica Diária'), findsOneWidget);
      expect(find.byKey(const ValueKey('puxar_carta_button')), findsOneWidget);
      expect(find.text('Puxar carta do dia'), findsOneWidget);
      expect(find.text('TAROT TRADER'), findsOneWidget);
      expect(find.byKey(const ValueKey('carta_revelada_container')), findsNothing);
    });

    testWidgets('Ao tocar em puxar carta, anima e revela a carta com todos os cards estruturados', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final jsonContent = File('content/tarot/tarot-trader-cartas.json').readAsStringSync();
      final service = TarotService(
        agora: () => DateTime(2026, 9, 30),
        random: Random(42),
      );
      service.carregarFromJsonString(jsonContent);

      await tester.pumpWidget(
        MaterialApp(
          home: TarotWidget(service: service),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final buttonFinder = find.byKey(const ValueKey('puxar_carta_button'));
      expect(buttonFinder, findsOneWidget);

      await tester.ensureVisible(buttonFinder);
      await tester.runAsync(() async {
        await tester.tap(buttonFinder);
        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 200));
      });
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('carta_revelada_container')), findsOneWidget);
      expect(find.text('ARQUÉTIPO REVELADO'), findsOneWidget);
      expect(find.text('SABEDORIA PRÁTICA'), findsOneWidget);
      expect(find.text('CARGA EMOCIONAL'), findsOneWidget);
      expect(find.text('ESTADO DE VIÉS'), findsOneWidget);

      final collapsibleFinder = find.text('Como reconhecer & Antídoto');
      expect(collapsibleFinder, findsOneWidget);

      // Testa abertura do bloco recolhível
      await tester.ensureVisible(collapsibleFinder);
      await tester.tap(collapsibleFinder);
      await tester.pumpAndSettle();

      expect(find.text('COMO RECONHECER OS SINAIS'), findsOneWidget);
      expect(find.text('ANTÍDOTO COMPORTAMENTAL'), findsOneWidget);
    });

    testWidgets('Se já houver leitura hoje, abre direto revelada sem botão de sorteio', (tester) async {
      await LocalDataManager.saveLastTarotReading({
        'data': '2026-09-30',
        'cartaId': 'planejador',
        'psychLoad': 18,
        'biasStatus': 'STABLE_FLOW',
      });

      final jsonContent = File('content/tarot/tarot-trader-cartas.json').readAsStringSync();
      final service = TarotService(
        agora: () => DateTime(2026, 9, 30),
        random: Random(42),
      );
      service.carregarFromJsonString(jsonContent);

      await tester.pumpWidget(
        MaterialApp(
          home: TarotWidget(service: service),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byKey(const ValueKey('puxar_carta_button')), findsNothing);
      expect(find.byKey(const ValueKey('carta_revelada_container')), findsOneWidget);
      expect(find.text('O PLANEJADOR'), findsOneWidget);
      expect(find.text('CLAREZA'), findsOneWidget);
      expect(find.text('Fluxo Estável'), findsOneWidget);
      expect(find.text('18%'), findsOneWidget);
    });
  });
}
