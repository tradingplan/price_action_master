import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/local_data_manager.dart';
import 'tarot_model.dart';
export 'tarot_model.dart';

class TarotWidget extends StatefulWidget {
  const TarotWidget({super.key});

  static String routeName = 'TarotTrader';
  static String routePath = '/tarotTrader';

  @override
  State<TarotWidget> createState() => _TarotWidgetState();
}

class _TarotWidgetState extends State<TarotWidget> with SingleTickerProviderStateMixin {
  late TarotModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  List<dynamic> _cards = [];
  Map<String, dynamic>? _selectedCard;
  bool _isLoading = true;
  bool _isAlreadyDrawnToday = false;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TarotModel());

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlipped = true;
        });
        _saveDrawState();
      }
    });

    _loadTarotData();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _model.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _fallbackCards = [
    {
      "id": "monk",
      "nome": "O Monge Disciplinado",
      "bias": "NEUTRO / ESTÁVEL",
      "icon": "🧘",
      "advice": "Sua mente está calma e focada. Hoje não é dia de caçar operações ou forçar entradas por tédio. Defina seu preço de interesse, aguarde pacientemente a mitigação de um Order Block ou preenchimento de FVG, e deixe a liquidez do mercado vir até você. Lucro é o subproduto de uma mente tranquila."
    },
    {
      "id": "gambler",
      "nome": "O Jogador Impulsivo",
      "bias": "ALTO RISCO / GANÂNCIA",
      "icon": "🎲",
      "advice": "Cuidado com o overtrading e a ganância. Quem corre atrás do preço acaba pagando caro. Operar fora do plano ou tentar 'recuperar' perdas de forma emocional (revenge trading) é a receita certa para a ruína. Se bater o stop-loss ou meta diária, feche a plataforma imediatamente e vá caminhar."
    },
    {
      "id": "executor",
      "nome": "O Executor Hesitante",
      "bias": "MEDO / INSEGURANÇA",
      "icon": "⏳",
      "advice": "O medo de perder bloqueia a clareza para lucrar. Se a estrutura do preço acionou o seu gatilho técnico e todas as regras do seu checklist estão marcadas, execute a ordem sem hesitação. O risco já foi dimensionado. Aceite que o stop é parte do jogo estatístico e confie no seu setup."
    },
    {
      "id": "bottom_fisher",
      "nome": "O Caçador de Topo/Fundo",
      "bias": "ANSIEDADE / PRECIPITAÇÃO",
      "icon": "🎣",
      "advice": "Tentar adivinhar fundos e topos sem confirmação é jogar contra a correnteza institucional. Pare de tentar prever reversões antes de um CHoCH (Change of Character) claro. Opere a favor do fluxo dominante e do BOS (Break of Structure). A tendência é sua melhor aliada."
    },
    {
      "id": "revenge_trader",
      "nome": "O Vingador do Mercado",
      "bias": "FÚRIA / RAIVA",
      "icon": "⚡",
      "advice": "O mercado é impessoal e não deve nada a você. Tentar 'bater de frente' com a tendência para se vingar de um prejuízo anterior só trará perdas ainda maiores. A perda faz parte do custo operacional do trader profissional. Aceite-a, respire fundo, e volte somente amanhã."
    },
    {
      "id": "risk_master",
      "nome": "O Mestre do Risco",
      "bias": "ALTAMENTE CONSISTENTE",
      "icon": "🛡️",
      "advice": "Você compreende que a consistência reside no controle estrito das perdas. Mantenha o gerenciamento de risco cirúrgico. Cada operação deve arriscar no máximo 1% do seu capital total. Lembre-se: sua prioridade número um é sobreviver ao dia de hoje para poder operar amanhã."
    }
  ];

  Future<void> _loadTarotData() async {
    try {
      final String jsonStr = await rootBundle.loadString('assets/jsons/tarot_cards.json');
      _cards = json.decode(jsonStr);
    } catch (e) {
      print('Error loading Tarot cards asset: $e. Using memory fallback.');
      _cards = List.from(_fallbackCards);
    }

    try {
      if (_cards.isEmpty) {
        _cards = List.from(_fallbackCards);
      }

      final String today = DateTime.now().toIso8601String().substring(0, 10);
      final String? lastDrawDate = LocalDataManager.getLastTarotDrawDate();
      final String? lastCardId = LocalDataManager.getLastTarotCardId();

      if (lastDrawDate == today && lastCardId != null) {
        // Já tirou carta hoje
        final existingCard = _cards.firstWhere(
          (c) => c['id'] == lastCardId,
          orElse: () => null,
        );
        if (existingCard != null) {
          setState(() {
            _selectedCard = existingCard;
            _isAlreadyDrawnToday = true;
            _isFlipped = true;
            _flipController.value = 1.0; // Pula a animação
            _isLoading = false;
          });
          return;
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error parsing Tarot cards state: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _drawRandomCard() {
    if (_flipController.isAnimating || _isFlipped || _isAlreadyDrawnToday) return;

    final random = Random();
    final drawn = _cards[random.nextInt(_cards.length)];

    setState(() {
      _selectedCard = drawn;
    });

    _flipController.forward();
  }

  Future<void> _saveDrawState() async {
    if (_selectedCard == null) return;
    final String today = DateTime.now().toIso8601String().substring(0, 10);
    await LocalDataManager.setLastTarotDrawDate(today);
    await LocalDataManager.setLastTarotCardId(_selectedCard!['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Tarot Trader',
      color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => context.pop(),
            child: Icon(
              Icons.chevron_left_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 32.0,
            ),
          ),
          title: Text(
            'Tarot Trader',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          elevation: 0.5,
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Header
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CONTROLE DE VIÉS COGNITIVO',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                      color: FlutterFlowTheme.of(context).secondary,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                'Reflexão Psicológica Diária',
                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                      fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'O trading de alta performance exige controle emocional rigoroso. Puxe sua carta do dia para obter uma análise do seu arquétipo comportamental atual e evitar armadilhas cognitivas.',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      fontSize: 11.0,
                                      lineHeight: 1.4,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24.0),

                        // Card Flip Area
                        Center(
                          child: Container(
                            width: 240.0,
                            height: 360.0,
                            child: AnimatedBuilder(
                              animation: _flipAnimation,
                              builder: (context, child) {
                                final angle = _flipAnimation.value * pi;
                                final isBack = angle < pi / 2;

                                return Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001) // perspective
                                    ..rotateY(angle),
                                  alignment: Alignment.center,
                                  child: isBack
                                      ? _buildCardBack()
                                      : Transform(
                                          transform: Matrix4.identity()..rotateY(pi),
                                          alignment: Alignment.center,
                                          child: _buildCardFront(),
                                        ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),

                        // Actionable Wisdom Panel
                        if (_isFlipped && _selectedCard != null) ...[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: _getThemeColor(context).withAlpha(100),
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.psychology_outlined,
                                      color: _getThemeColor(context),
                                      size: 24.0,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      'SABEDORIA PRÁTICA',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                            color: _getThemeColor(context),
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  _selectedCard!['advice'] ?? '',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        fontSize: 13.0,
                                        lineHeight: 1.5,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],

                        // Warning Protocol panel
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: FlutterFlowTheme.of(context).error,
                                size: 24.0,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PROTOCOLO DE REFLEXÃO PSICOLÓGICA',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 9.0,
                                          ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      'Este terminal foi desenhado para autoanálise emocional e controle de vieses internos. Ele não fornece sinais de operação ou conselhos financeiros. Utilize a leitura de hoje para guiar sua paciência operacional, não para tentar adivinhar a direção do preço.',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            fontSize: 9.5,
                                            lineHeight: 1.3,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Stats Readout (hacker style)
                        if (_isFlipped && _selectedCard != null)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'PSYCH_LOAD',
                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              fontSize: 9.0,
                                            ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: _selectedCard!['id'] == 'monk' || _selectedCard!['id'] == 'risk_master' ? 0.20 : 0.75,
                                              color: _getThemeColor(context),
                                              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            _selectedCard!['id'] == 'monk' || _selectedCard!['id'] == 'risk_master' ? '20%' : '75%',
                                            style: TextStyle(
                                              color: _getThemeColor(context),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'BIAS_CORRELATION',
                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              fontSize: 9.0,
                                            ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      Text(
                                        _selectedCard!['id'] == 'monk' || _selectedCard!['id'] == 'risk_master'
                                            ? 'STABLE_FLOW_ALPHA'
                                            : 'UNSTABLE_OVERLOAD',
                                        style: TextStyle(
                                          color: _getThemeColor(context),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 50.0),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return GestureDetector(
      onTap: _drawRandomCard,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[950],
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFFFD700), width: 3.0), // Gold border
          boxShadow: [
            BoxShadow(
              color: Colors.green.withAlpha(50),
              blurRadius: 12.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFFD700).withAlpha(100), width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFFFD700),
                  size: 54.0,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'TOQUE PARA REVELAR SEU VIÉS',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                        color: const Color(0xFFFFD700),
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    if (_selectedCard == null) return Container();

    final themeColor = _getThemeColor(context);
    final String emoji = _selectedCard!['icon'] ?? '🧘';
    final String nome = _selectedCard!['nome'] ?? '';
    final String bias = _selectedCard!['bias'] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: themeColor, width: 3.0),
        boxShadow: [
          BoxShadow(
            color: themeColor.withAlpha(60),
            blurRadius: 16.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: themeColor.withAlpha(25),
              shape: BoxShape.circle,
              border: Border.all(color: themeColor, width: 2.0),
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 36.0),
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            nome.toUpperCase(),
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            _isAlreadyDrawnToday ? 'HOJE: ARQUÉTIPO SELECIONADO' : 'ARQUÉTIPO REVELADO',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 8.0,
                  letterSpacing: 0.5,
                ),
          ),
          const Divider(height: 24.0, thickness: 1.0),
          Text(
            bias,
            style: TextStyle(
              color: themeColor,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Color _getThemeColor(BuildContext context) {
    if (_selectedCard == null) return FlutterFlowTheme.of(context).primary;
    final String id = _selectedCard!['id'] ?? '';
    if (id == 'monk' || id == 'risk_master') {
      return FlutterFlowTheme.of(context).success;
    } else if (id == 'executor' || id == 'bottom_fisher') {
      return Colors.orange;
    } else {
      return FlutterFlowTheme.of(context).error;
    }
  }
}
