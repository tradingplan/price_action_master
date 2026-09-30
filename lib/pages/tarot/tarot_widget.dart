import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../tarot/carta.dart';
import '../../tarot/tarot_service.dart';
import 'tarot_model.dart';

export 'tarot_model.dart';

class TarotIconHelper {
  static const Map<String, IconData> _iconMap = {
    'zap': Icons.bolt,
    'ghost': Icons.sentiment_very_dissatisfied,
    'scissors': Icons.content_cut,
    'shield-alert': Icons.gpp_maybe_outlined,
    'hourglass': Icons.hourglass_top,
    'flame': Icons.local_fire_department,
    'search-check': Icons.manage_search,
    'repeat': Icons.repeat,
    'compass': Icons.explore_outlined,
    'trending-up': Icons.trending_up,
    'octagon-x': Icons.highlight_off,
    'activity': Icons.insights,
    'radio': Icons.sensors,
    'book-x': Icons.menu_book,
    'shuffle': Icons.shuffle,
    'battery-low': Icons.battery_alert,
    'clipboard-list': Icons.assignment_outlined,
    'shield-check': Icons.verified_user_outlined,
    'notebook-pen': Icons.edit_note,
    'power': Icons.power_settings_new,
    'eye': Icons.visibility_outlined,
    'scale': Icons.balance,
  };

  static IconData getIcon(String iconeName) {
    final icon = _iconMap[iconeName];
    if (icon != null) {
      return icon;
    }
    debugPrint('TarotIconHelper: Ícone "$iconeName" não encontrado no mapa estático. Usando fallback neutro.');
    return Icons.psychology_outlined;
  }
}

class TarotWidget extends StatefulWidget {
  final TarotService? service;

  const TarotWidget({
    super.key,
    this.service,
  });

  static String routeName = 'TarotTrader';
  static String routePath = '/tarotTrader';

  @override
  State<TarotWidget> createState() => _TarotWidgetState();
}

class _TarotWidgetState extends State<TarotWidget> with SingleTickerProviderStateMixin {
  late TarotModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late TarotService _tarotService;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  bool _isLoading = true;
  bool _isDrawn = false;
  bool _isAnimating = false;
  Leitura? _leituraAtual;
  Carta? _cartaAtual;
  bool _isHowToRecognizeExpanded = false;

  static const Color colorBear = Color(0xFFE22A22);
  static const Color colorBull = Color(0xFF1FA938);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TarotModel());
    _tarotService = widget.service ?? TarotService();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    _initData();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    setState(() {
      _isLoading = true;
    });

    if (!_tarotService.isLoaded) {
      await _tarotService.carregar();
    }

    final leituraHoje = await _tarotService.obterLeituraDeHoje();
    if (leituraHoje != null) {
      final carta = _tarotService.getCartaById(leituraHoje.cartaId);
      setState(() {
        _leituraAtual = leituraHoje;
        _cartaAtual = carta;
        _isDrawn = true;
        _isLoading = false;
      });
      _flipController.value = 1.0;
    } else {
      setState(() {
        _leituraAtual = null;
        _cartaAtual = null;
        _isDrawn = false;
        _isLoading = false;
      });
      _flipController.value = 0.0;
    }
  }

  Future<void> _puxarCarta() async {
    if (_isAnimating || _isDrawn) return;

    setState(() {
      _isAnimating = true;
    });

    try {
      final leitura = await _tarotService.puxarCarta();
      final carta = _tarotService.getCartaById(leitura.cartaId);

      if (!mounted) return;
      setState(() {
        _leituraAtual = leitura;
        _cartaAtual = carta;
        _isDrawn = true;
      });

      _flipController.forward(from: 0.0).then((_) {
        if (mounted) {
          setState(() {
            _isAnimating = false;
          });
        }
      });
    } catch (e) {
      debugPrint('Erro ao puxar carta: $e');
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: true,
          title: Text(
            'Tarot Trader',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: _isLoading
              ? Center(
                  child: SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Cabeçalho da seção
                        _buildHeader(context),
                        const SizedBox(height: 24.0),

                        // 2 & 3. Carta virada ou revelada com animação 3D
                        Center(
                          child: _buildCardFlipper(context),
                        ),
                        const SizedBox(height: 20.0),

                        // Botão "Puxar carta do dia" (apenas se ainda não sorteou)
                        if (!_isDrawn && !_isAnimating) ...[
                          Center(
                            child: SizedBox(
                              width: 240.0,
                              height: 48.0,
                              child: ElevatedButton(
                                key: const ValueKey('puxar_carta_button'),
                                onPressed: _puxarCarta,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: FlutterFlowTheme.of(context).primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 0.0,
                                ),
                                child: const Text(
                                  'Puxar carta do dia',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                        ],

                        // Se a carta foi sorteada/revelada, mostra os blocos complementares
                        if (_isDrawn && _cartaAtual != null && _leituraAtual != null) ...[
                          // 4. Card "SABEDORIA PRÁTICA"
                          _buildSabedoriaCard(context, _cartaAtual!),
                          const SizedBox(height: 16.0),

                          // 7. Dois indicadores lado a lado (PSYCH_LOAD e BIAS_CORRELATION)
                          _buildIndicatorsRow(context, _leituraAtual!),
                          const SizedBox(height: 16.0),

                          // 5. Bloco recolhível "Como reconhecer" e "Antídoto"
                          _buildCollapsibleDetails(context, _cartaAtual!),
                          const SizedBox(height: 16.0),

                          // 6. Card de protocolo (aviso do JSON)
                          _buildProtocolCard(context, _tarotService.aviso),
                          const SizedBox(height: 32.0),
                        ],
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // 1. Cabeçalho
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CONTROLE DE VIÉS COGNITIVO',
          style: TextStyle(
            color: colorBull,
            fontSize: 12.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          'Reflexão Psicológica Diária',
          style: TextStyle(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'O trading de alta performance exige controle emocional rigoroso. Puxe sua carta do dia para obter uma análise do seu arquétipo comportamental atual e evitar armadilhas cognitivas.',
          style: TextStyle(
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 14.0,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // 2 & 3. Card Flipper com rotação no eixo Y
  Widget _buildCardFlipper(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * math.pi;
        final isFrontVisible = angle >= (math.pi / 2);

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: isFrontVisible
              ? Transform(
                  transform: Matrix4.identity()..rotateY(math.pi),
                  alignment: Alignment.center,
                  child: _buildCardFront(context, _cartaAtual),
                )
              : _buildCardBack(context),
        );
      },
    );
  }

  // Verso da Carta (Virada para baixo)
  Widget _buildCardBack(BuildContext context) {
    return Container(
      width: 240.0,
      height: 360.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.3),
          width: 2.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(2.0, 2.0),
            blurRadius: 0.0,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 216.0,
          height: 336.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.2),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 44.0,
                color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12.0),
              Text(
                'TAROT TRADER',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.7),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Frente da Carta (Revelada)
  Widget _buildCardFront(BuildContext context, Carta? carta) {
    if (carta == null) return _buildCardBack(context);

    final Color polarityColor = carta.isBull ? colorBull : colorBear;

    return Container(
      key: const ValueKey('carta_revelada_container'),
      width: 240.0,
      height: 360.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: polarityColor,
          width: 2.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(2.0, 2.0),
            blurRadius: 0.0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Topo: Número e status pequeno
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${carta.numero.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: polarityColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(width: 4.0),
              Flexible(
                child: Text(
                  'ARQUÉTIPO REVELADO',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: polarityColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 8.5,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          // Centro: Círculo com Ícone
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: polarityColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                TarotIconHelper.getIcon(carta.icone),
                size: 40.0,
                color: polarityColor,
              ),
            ),
          ),

          // Nome do Arquétipo e Emoção
          Column(
            children: [
              Text(
                carta.arquetipo.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: polarityColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8.0),
              Divider(
                color: polarityColor.withValues(alpha: 0.3),
                thickness: 1.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
              const SizedBox(height: 4.0),
              Text(
                carta.emocao.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: polarityColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),

          // Rodapé do Card: Polaridade
          Text(
            carta.isBull ? 'HÁBITO DISCIPLINADO' : 'ARMADILHA COMPORTAMENTAL',
            style: TextStyle(
              color: polarityColor,
              fontWeight: FontWeight.w600,
              fontSize: 10.0,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // 4. Card "SABEDORIA PRÁTICA"
  Widget _buildSabedoriaCard(BuildContext context, Carta carta) {
    final Color polarityColor = carta.isBull ? colorBull : colorBear;

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: polarityColor,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            offset: Offset(2.0, 2.0),
            blurRadius: 0.0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: polarityColor,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'SABEDORIA PRÁTICA',
                style: TextStyle(
                  color: polarityColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.0,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            carta.sabedoria,
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 14.0,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  String _formatBiasStatus(String status) {
    switch (status) {
      case 'STABLE_FLOW':
        return 'Fluxo Estável';
      case 'CAUTION_DRIFT':
        return 'Atenção ao Desvio';
      case 'UNSTABLE_OVERLOAD':
        return 'Sobrecarga Instável';
      case 'CRITICAL_TILT':
        return 'Tilt Crítico';
      default:
        return status;
    }
  }

  // 7. Dois indicadores lado a lado (Carga Emocional e Estado de Viés)
  Widget _buildIndicatorsRow(BuildContext context, Leitura leitura) {
    final bool isStable = leitura.biasStatus == 'STABLE_FLOW';
    final Color biasColor = isStable ? colorBull : colorBear;
    final double progress = (leitura.psychLoad / 100.0).clamp(0.0, 1.0);

    return Row(
      children: [
        // Carga Emocional
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.2),
                width: 1.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  offset: Offset(2.0, 2.0),
                  blurRadius: 0.0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CARGA EMOCIONAL',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '${leitura.psychLoad}%',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8.0,
                    backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      leitura.psychLoad >= 60 ? colorBear : (leitura.psychLoad >= 40 ? Colors.orange : colorBull),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12.0),

        // Estado de Viés
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: biasColor.withValues(alpha: 0.5),
                width: 1.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  offset: Offset(2.0, 2.0),
                  blurRadius: 0.0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ESTADO DE VIÉS',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  _formatBiasStatus(leitura.biasStatus),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: biasColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 5. Bloco recolhível "Como reconhecer" e "Antídoto"
  Widget _buildCollapsibleDetails(BuildContext context, Carta carta) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            offset: Offset(2.0, 2.0),
            blurRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isHowToRecognizeExpanded = !_isHowToRecognizeExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Como reconhecer & Antídoto',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                    ),
                  ),
                  Icon(
                    _isHowToRecognizeExpanded ? Icons.expand_less : Icons.expand_more,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ],
              ),
            ),
          ),
          if (_isHowToRecognizeExpanded) ...[
            const Divider(height: 1.0, thickness: 1.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COMO RECONHECER OS SINAIS',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ...carta.sinais.map(
                    (sinal) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6.0, right: 8.0),
                            width: 6.0,
                            height: 6.0,
                            decoration: BoxDecoration(
                              color: carta.isBull ? colorBull : colorBear,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              sinal,
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 13.5,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  Text(
                    'ANTÍDOTO COMPORTAMENTAL',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(
                      carta.antidoto,
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 6. Card de protocolo (aviso do JSON)
  Widget _buildProtocolCard(BuildContext context, String aviso) {
    if (aviso.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            offset: Offset(2.0, 2.0),
            blurRadius: 0.0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 20.0,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              aviso,
              style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 12.0,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
