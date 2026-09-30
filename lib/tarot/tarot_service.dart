import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../backend/local_data_manager.dart';
import 'carta.dart';

class TarotService {
  static const String assetPath = 'content/tarot/tarot-trader-cartas.json';
  static const int xpFirstDrawPerDay = 25;

  final DateTime Function() _agora;
  final Random _random;

  List<Carta> _cartas = [];
  String _aviso = '';
  String _versao = '1.0';
  String _idioma = 'pt-BR';
  Map<String, dynamic> _regrasDeUso = {};
  bool _isLoaded = false;

  TarotService({
    DateTime Function()? agora,
    Random? random,
  })  : _agora = agora ?? DateTime.now,
        _random = random ?? Random();

  List<Carta> get cartas => List.unmodifiable(_cartas);
  String get aviso => _aviso;
  String get versao => _versao;
  String get idioma => _idioma;
  Map<String, dynamic> get regrasDeUso => _regrasDeUso;
  bool get isLoaded => _isLoaded;

  /// Carrega diretamente a partir de um Map de dados
  void carregarFromData(Map<String, dynamic> data) {
    _versao = data['versao'] as String? ?? '1.0';
    _idioma = data['idioma'] as String? ?? 'pt-BR';
    _aviso = data['aviso'] as String? ?? '';
    _regrasDeUso = (data['regras_de_uso'] as Map<String, dynamic>?) ?? {};

    final List<dynamic> rawCartas = data['cartas'] as List<dynamic>? ?? [];
    _cartas = rawCartas.map((c) => Carta.fromJson(c as Map<String, dynamic>)).toList();
    _isLoaded = true;
  }

  /// Carrega diretamente a partir de uma string JSON
  void carregarFromJsonString(String jsonStr) {
    final Map<String, dynamic> data = json.decode(jsonStr) as Map<String, dynamic>;
    carregarFromData(data);
  }

  /// Carrega o catálogo de cartas e metadados a partir do asset JSON
  Future<void> carregar({String path = assetPath}) async {
    final String jsonStr = await rootBundle.loadString(path);
    carregarFromJsonString(jsonStr);
  }

  /// Calcula o status de viés com base no psychLoad
  static String calcularBiasStatus(int psychLoad) {
    if (psychLoad >= 80) {
      return 'CRITICAL_TILT';
    } else if (psychLoad >= 60) {
      return 'UNSTABLE_OVERLOAD';
    } else if (psychLoad >= 40) {
      return 'CAUTION_DRIFT';
    } else {
      return 'STABLE_FLOW';
    }
  }

  /// Retorna a data de hoje formatada em YYYY-MM-DD local do aparelho
  String getHojeFormatado() {
    final dt = _agora();
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Retorna a carta pelo seu ID
  Carta? getCartaById(String id) {
    try {
      return _cartas.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Obtém a leitura de hoje se já tiver sido sorteada
  Future<Leitura?> obterLeituraDeHoje() async {
    final last = LocalDataManager.getLastTarotReading();
    if (last == null) return null;

    final leitura = Leitura.fromJson(last);
    final hoje = getHojeFormatado();

    if (leitura.data == hoje && leitura.cartaId.isNotEmpty) {
      return leitura;
    }
    return null;
  }

  /// Puxa a carta do dia:
  /// 1. Se hoje já houver leitura, retorna a mesma.
  /// 2. Se não houver, sorteia uma nova carta, aplica variação (-8 a +8), calcula status e persiste.
  Future<Leitura> puxarCarta() async {
    if (!_isLoaded) {
      await carregar();
    }

    if (_cartas.isEmpty) {
      throw StateError('O baralho de Tarot não possui cartas carregadas.');
    }

    final hoje = getHojeFormatado();
    final last = LocalDataManager.getLastTarotReading();

    if (last != null) {
      final leituraExistente = Leitura.fromJson(last);
      if (leituraExistente.data == hoje && leituraExistente.cartaId.isNotEmpty) {
        return leituraExistente;
      }
    }

    // Sorteia uma nova carta
    final int index = _random.nextInt(_cartas.length);
    final Carta cartaEscolhida = _cartas[index];

    // Variação aleatória de -8 a +8
    final int variacao = _random.nextInt(17) - 8;
    final int psychLoadFinal = (cartaEscolhida.psychLoad + variacao).clamp(0, 100);
    final String status = calcularBiasStatus(psychLoadFinal);

    final novaLeitura = Leitura(
      data: hoje,
      cartaId: cartaEscolhida.id,
      psychLoad: psychLoadFinal,
      biasStatus: status,
    );

    // Persistência local no LocalDataManager
    await LocalDataManager.saveLastTarotReading(novaLeitura.toJson());
    await LocalDataManager.saveTarotHistoryEntry(novaLeitura.toJson());

    // Concede XP na primeira leitura do dia
    await LocalDataManager.addXP(xpFirstDrawPerDay);

    return novaLeitura;
  }
}
