import 'dart:async';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../components/trading_plan_promo_banner.dart';
import '../../components/ad_banner_placeholder.dart';
import 'market_hours_model.dart';
export 'market_hours_model.dart';

class MarketSessionData {
  final String id;
  final String name;
  final String flag;
  final String city;
  final String exchange;
  final String localTimezone;
  final String localHours;
  final int openHourBrt;
  final int openMinuteBrt;
  final int closeHourBrt;
  final int closeMinuteBrt;
  final int? preMarketHourBrt;
  final int? preMarketMinuteBrt;
  final Color themeColor;
  final List<String> primaryAssets;
  final String volatilityLevel;
  final String strategyNotes;

  const MarketSessionData({
    required this.id,
    required this.name,
    required this.flag,
    required this.city,
    required this.exchange,
    required this.localTimezone,
    required this.localHours,
    required this.openHourBrt,
    required this.openMinuteBrt,
    required this.closeHourBrt,
    required this.closeMinuteBrt,
    this.preMarketHourBrt,
    this.preMarketMinuteBrt,
    required this.themeColor,
    required this.primaryAssets,
    required this.volatilityLevel,
    required this.strategyNotes,
  });
}

class KillzoneData {
  final String name;
  final String session;
  final String hoursBrt;
  final int startMinutesOfDayBrt;
  final int endMinutesOfDayBrt;
  final String impactBadge;
  final Color impactColor;
  final String description;
  final IconData icon;

  const KillzoneData({
    required this.name,
    required this.session,
    required this.hoursBrt,
    required this.startMinutesOfDayBrt,
    required this.endMinutesOfDayBrt,
    required this.impactBadge,
    required this.impactColor,
    required this.description,
    required this.icon,
  });
}

class MarketHoursWidget extends StatefulWidget {
  const MarketHoursWidget({super.key});

  static String routeName = 'MarketHours';
  static String routePath = '/market-hours';

  @override
  State<MarketHoursWidget> createState() => _MarketHoursWidgetState();
}

class _MarketHoursWidgetState extends State<MarketHoursWidget> with SingleTickerProviderStateMixin {
  late MarketHoursModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Timer? _ticker;
  DateTime _currentUtc = DateTime.now().toUtc();
  bool _isUsDst = true; // Horário de verão dos EUA (Default: ativo de Março a Novembro)
  int _selectedTabIndex = 0;

  DateTime get _currentBrt => _currentUtc.subtract(const Duration(hours: 3));

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MarketHoursModel());

    // Detecta se atualmente estamos em período aproximado de DST americano (segundo domingo de março ao primeiro de novembro)
    final now = DateTime.now();
    _isUsDst = now.month > 3 && now.month < 11;

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _currentUtc = DateTime.now().toUtc();
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _model.dispose();
    super.dispose();
  }

  List<MarketSessionData> _getSessions() {
    return [
      // 1. B3 (BRASIL)
      const MarketSessionData(
        id: 'b3',
        name: 'B3 · Brasil',
        flag: '🇧🇷',
        city: 'São Paulo',
        exchange: 'B3 (Brasil, Bolsa, Balcão)',
        localTimezone: 'BRT (UTC-3)',
        localHours: '09:00 - 18:00 (Futuros) · 10:00 - 17:00/18:00 (À Vista)',
        openHourBrt: 9,
        openMinuteBrt: 0,
        closeHourBrt: 18,
        closeMinuteBrt: 0,
        preMarketHourBrt: 8,
        preMarketMinuteBrt: 45,
        themeColor: Color(0xFF10B981),
        primaryAssets: ['Mini Índice (WIN)', 'Mini Dólar (WDO)', 'Ações Petrobras/Vale/Bancos', 'Juros DI'],
        volatilityLevel: 'Alta (10:00 - 12:30)',
        strategyNotes: 'O mini índice acelera às 10:00 com o mercado à vista e às 10:30 com NYSE. O ajuste diário ocorre próximo ao fechamento.',
      ),

      // 2. NOVA YORK (EUA)
      MarketSessionData(
        id: 'ny',
        name: 'Nova York · EUA',
        flag: '🇺🇸',
        city: 'Nova York',
        exchange: 'NYSE · NASDAQ · CME Group',
        localTimezone: _isUsDst ? 'EDT (UTC-4)' : 'EST (UTC-5)',
        localHours: '09:30 - 16:00 ET (Cash Market)',
        openHourBrt: _isUsDst ? 10 : 11,
        openMinuteBrt: 30,
        closeHourBrt: _isUsDst ? 17 : 18,
        closeMinuteBrt: 0,
        preMarketHourBrt: _isUsDst ? 9 : 10,
        preMarketMinuteBrt: 0,
        themeColor: const Color(0xFF3B82F6),
        primaryAssets: ['Nasdaq-100 (NQ/MNQ)', 'S&P 500 (ES/MES)', 'Ouro (GC)', 'Petróleo WTI (CL)'],
        volatilityLevel: 'Máxima Global',
        strategyNotes: 'Sessão com maior liquidez e volume financeiro do mundo. O pico operacional ocorre entre a abertura (10:30 BRT) e o fechamento europeu (13:00 BRT).',
      ),

      // 3. LONDRES (EUROPA)
      const MarketSessionData(
        id: 'london',
        name: 'Londres · Europa',
        flag: '🇬🇧',
        city: 'Londres / Frankfurt',
        exchange: 'LSE · Euronext · Deutsche Börse',
        localTimezone: 'BST/GMT (UTC+1/0)',
        localHours: '08:00 - 16:30 Local',
        openHourBrt: 4,
        openMinuteBrt: 0,
        closeHourBrt: 13,
        closeMinuteBrt: 0,
        preMarketHourBrt: 3,
        preMarketMinuteBrt: 30,
        themeColor: Color(0xFF8B5CF6),
        primaryAssets: ['EUR/USD', 'GBP/USD', 'Índice DAX', 'FTSE 100'],
        volatilityLevel: 'Muito Alta',
        strategyNotes: 'Geralmente define o "Judas Swing" (falso rompimento da madrugada para caçar liquidez antes da tendência primária do dia).',
      ),

      // 4. ÁSIA & OCEANIA (TÓQUIO / SYDNEY)
      const MarketSessionData(
        id: 'asia',
        name: 'Ásia & Oceania',
        flag: '🇯🇵',
        city: 'Tóquio / Sydney',
        exchange: 'TSE (Tokyo) · ASX (Sydney) · HKEX',
        localTimezone: 'JST (UTC+9) · AEST (UTC+10)',
        localHours: '09:00 - 15:00 JST / 10:00 - 16:00 AEST',
        openHourBrt: 20, // 20:00 do dia anterior
        openMinuteBrt: 0,
        closeHourBrt: 5,  // 05:00 da manhã
        closeMinuteBrt: 0,
        themeColor: Color(0xFFEC4899),
        primaryAssets: ['USD/JPY', 'AUD/USD', 'Nikkei 225', 'Hang Seng'],
        volatilityLevel: 'Moderada / Consolidação',
        strategyNotes: 'Sessão caracterizada por movimentos laterais e consolidações. Delimita o "Asian Range" (Máxima e Mínima) frequentemente caçado em Londres.',
      ),
    ];
  }

  List<KillzoneData> _getKillzones() {
    final nyOpenMinutes = _isUsDst ? (10 * 60 + 30) : (11 * 60 + 30);
    final nyCloseMinutes = _isUsDst ? (17 * 60) : (18 * 60);

    return [
      const KillzoneData(
        name: 'London Open Killzone',
        session: 'Londres · Europa',
        hoursBrt: '04:00 - 07:00 BRT',
        startMinutesOfDayBrt: 4 * 60,
        endMinutesOfDayBrt: 7 * 60,
        impactBadge: 'Manipulação & Expansão',
        impactColor: Color(0xFF8B5CF6),
        description: 'Frequentemente forma a Máxima ou Mínima do dia no Forex e Commodities. Caça a liquidez do Asian Range com manipulação institucional (Judas Swing).',
        icon: Icons.flash_on_rounded,
      ),
      const KillzoneData(
        name: 'Abertura B3 Futuros',
        session: 'B3 · Brasil',
        hoursBrt: '09:00 - 10:00 BRT',
        startMinutesOfDayBrt: 9 * 60,
        endMinutesOfDayBrt: 10 * 60,
        impactBadge: 'Posicionamento Inicial',
        impactColor: Color(0xFF10B981),
        description: 'Abertura dos contratos futuros de WIN e WDO. Reage às notícias matinais e reflete a abertura das commodities e pré-mercado internacional.',
        icon: Icons.show_chart_rounded,
      ),
      const KillzoneData(
        name: 'Abertura B3 À Vista (Ações)',
        session: 'B3 · Brasil',
        hoursBrt: '10:00 - 10:30 BRT',
        startMinutesOfDayBrt: 10 * 60,
        endMinutesOfDayBrt: 10 * 60 + 30,
        impactBadge: 'Entrada de Volume Forte',
        impactColor: Color(0xFF059669),
        description: 'Entrada das ações de maior peso (Petrobras, Vale, Itaú). Traz oscilações bruscas e direcionamento sólido para o mini índice.',
        icon: Icons.account_balance_wallet_rounded,
      ),
      KillzoneData(
        name: 'NY Open & Overlap Global',
        session: 'Londres + Nova York',
        hoursBrt: _isUsDst ? '10:30 - 13:00 BRT' : '11:30 - 13:00 BRT',
        startMinutesOfDayBrt: nyOpenMinutes,
        endMinutesOfDayBrt: 13 * 60,
        impactBadge: 'Pico Máximo de Liquidez',
        impactColor: const Color(0xFFEF4444),
        description: 'O momento mais líquido do planeta: Londres ainda operando enquanto Nova York abre com força total. Rompimentos limpos e continuidade institucional.',
        icon: Icons.local_fire_department_rounded,
      ),
      const KillzoneData(
        name: 'London Close & Fixings',
        session: 'Londres · Europa',
        hoursBrt: '12:00 - 13:30 BRT',
        startMinutesOfDayBrt: 12 * 60,
        endMinutesOfDayBrt: 13 * 60 + 30,
        impactBadge: 'Reversão ou Desaceleração',
        impactColor: Color(0xFFD97706),
        description: 'Fechamento dos bancos europeus e fixação cambial de Londres. Movimentos estendidos da manhã costumam encontrar reversões para realização de lucros.',
        icon: Icons.assignment_turned_in_rounded,
      ),
      KillzoneData(
        name: 'Ajuste B3 & Fechamento',
        session: 'B3 + Nova York',
        hoursBrt: '16:50 - 18:00 BRT',
        startMinutesOfDayBrt: 16 * 60 + 50,
        endMinutesOfDayBrt: nyCloseMinutes,
        impactBadge: 'Fechamento Diário',
        impactColor: const Color(0xFF0284C7),
        description: 'Cálculo do Ajuste Diário da B3 para posições em contratos futuros de índice e dólar e fechamento das ações de Wall Street.',
        icon: Icons.lock_clock_rounded,
      ),
    ];
  }

  /// Verifica se uma sessão está aberta, em pré-mercado ou fechada
  Map<String, dynamic> _getSessionStatus(MarketSessionData session) {
    final nowBrt = _currentBrt;
    final isWeekend = nowBrt.weekday == DateTime.saturday ||
        (nowBrt.weekday == DateTime.sunday && nowBrt.hour < 19);

    if (isWeekend) {
      return {
        'status': 'Fim de Semana',
        'isOpen': false,
        'badgeColor': const Color(0xFF6B7280),
        'remainingText': 'Mercados fechados no sábado/domingo',
      };
    }

    final currentMinutes = nowBrt.hour * 60 + nowBrt.minute;
    final openMinutes = session.openHourBrt * 60 + session.openMinuteBrt;
    final closeMinutes = session.closeHourBrt * 60 + session.closeMinuteBrt;

    bool isOpen = false;
    bool isPreMarket = false;

    // Sessão que cruza a meia-noite (Ásia: 20:00 às 05:00)
    if (openMinutes > closeMinutes) {
      if (currentMinutes >= openMinutes || currentMinutes < closeMinutes) {
        isOpen = true;
      }
    } else {
      if (currentMinutes >= openMinutes && currentMinutes < closeMinutes) {
        isOpen = true;
      } else if (session.preMarketHourBrt != null) {
        final preStart = session.preMarketHourBrt! * 60 + session.preMarketMinuteBrt!;
        if (currentMinutes >= preStart && currentMinutes < openMinutes) {
          isPreMarket = true;
        }
      }
    }

    if (isOpen) {
      int minutesLeft = 0;
      if (openMinutes > closeMinutes) {
        if (currentMinutes >= openMinutes) {
          minutesLeft = (24 * 60 - currentMinutes) + closeMinutes;
        } else {
          minutesLeft = closeMinutes - currentMinutes;
        }
      } else {
        minutesLeft = closeMinutes - currentMinutes;
      }

      final hours = minutesLeft ~/ 60;
      final mins = minutesLeft % 60;

      return {
        'status': 'ABERTO AGORA',
        'isOpen': true,
        'badgeColor': const Color(0xFF10B981),
        'remainingText': 'Fecha em ${hours}h ${mins}m',
      };
    } else if (isPreMarket) {
      final minutesLeft = openMinutes - currentMinutes;
      return {
        'status': 'PRÉ-MERCADO',
        'isOpen': false,
        'badgeColor': const Color(0xFFF59E0B),
        'remainingText': 'Abre em ${minutesLeft}m',
      };
    } else {
      int minutesUntilOpen = 0;
      if (currentMinutes < openMinutes) {
        minutesUntilOpen = openMinutes - currentMinutes;
      } else {
        minutesUntilOpen = (24 * 60 - currentMinutes) + openMinutes;
      }

      final hours = minutesUntilOpen ~/ 60;
      final mins = minutesUntilOpen % 60;

      return {
        'status': 'FECHADO',
        'isOpen': false,
        'badgeColor': const Color(0xFFEF4444),
        'remainingText': 'Abre em ${hours}h ${mins}m',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final sessions = _getSessions();
    final killzones = _getKillzones();

    final timeFormatterBrt = DateFormat('HH:mm:ss');
    final dateFormatterBrt = DateFormat('EEEE, d \'de\' MMMM', 'pt_BR');
    final timeStrBrt = timeFormatterBrt.format(_currentBrt);
    final dateStrBrt = dateFormatterBrt.format(_currentBrt);

    final timeStrUtc = DateFormat('HH:mm').format(_currentUtc);

    // Contagem de pregões abertos
    final openSessionsCount = sessions.where((s) => _getSessionStatus(s)['isOpen'] == true).length;

    return Title(
      title: 'Horários de Mercado · Price Action Master',
      color: theme.primary.withAlpha(0XFF),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.secondaryBackground,
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => context.safePop(),
            child: Icon(
              Icons.chevron_left_rounded,
              color: theme.primaryText,
              size: 32.0,
            ),
          ),
          title: Text(
            'Horários de Mercado',
            style: theme.headlineMedium.override(
                  fontFamily: theme.headlineMediumFamily,
                  color: theme.primaryText,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                  useGoogleFonts: !theme.headlineMediumIsCustom,
                ),
          ),
          actions: [
            // Switch Horário de Verão dos EUA
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Center(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isUsDst = !_isUsDst;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: theme.secondaryBackground,
                        content: Text(
                          _isUsDst
                              ? '☀️ Horário de Verão EUA Ativado (NYSE 10:30 BRT)'
                              : '❄️ Horário de Inverno EUA Ativado (NYSE 11:30 BRT)',
                          style: TextStyle(color: theme.primaryText, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isUsDst
                          ? const Color(0xFFF59E0B).withAlpha(35)
                          : theme.primaryBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isUsDst ? const Color(0xFFF59E0B) : theme.lineColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isUsDst ? '☀️ DST Ativo' : '❄️ Inverno',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _isUsDst ? const Color(0xFFF59E0B) : theme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.5,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Live Clock Hero Card
                  _buildLiveClockCard(
                    theme: theme,
                    timeStrBrt: timeStrBrt,
                    dateStrBrt: dateStrBrt,
                    timeStrUtc: timeStrUtc,
                    openCount: openSessionsCount,
                  ),

                  const SizedBox(height: 16.0),

                  // 2. Timeline visual das 24h em Horário de Brasília
                  _build24HourTimeline(theme: theme),

                  const SizedBox(height: 18.0),

                  // 3. Segmented Control / Tabs
                  Row(
                    children: [
                      _buildTabButton(
                        theme: theme,
                        label: 'Sessões Mundiais',
                        icon: Icons.public_rounded,
                        index: 0,
                      ),
                      const SizedBox(width: 8.0),
                      _buildTabButton(
                        theme: theme,
                        label: 'Killzones (SMC)',
                        icon: Icons.bolt_rounded,
                        index: 1,
                      ),
                      const SizedBox(width: 8.0),
                      _buildTabButton(
                        theme: theme,
                        label: 'Guia do Trader',
                        icon: Icons.menu_book_rounded,
                        index: 2,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),

                  // 4. Tab Content
                  if (_selectedTabIndex == 0) ...[
                    ...sessions.map((session) => _buildSessionCard(theme: theme, session: session)),
                  ] else if (_selectedTabIndex == 1) ...[
                    ...killzones.map((kz) => _buildKillzoneCard(theme: theme, killzone: kz)),
                  ] else ...[
                    _buildTraderGuideCard(theme: theme),
                  ],

                  const SizedBox(height: 14.0),

                  // 5. Card Promocional TradingPlan
                  const TradingPlanPromoBanner(
                    variant: PromoVariant.auto,
                    utmContent: 'market_hours',
                  ),

                  const SizedBox(height: 10.0),

                  // 6. Ad Banner
                  const AdBannerPlaceholder(
                    height: 60.0,
                    margin: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Card com o relógio digital ao vivo em Brasília e contadores
  Widget _buildLiveClockCard({
    required FlutterFlowTheme theme,
    required String timeStrBrt,
    required String dateStrBrt,
    required String timeStrUtc,
    required int openCount,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.secondaryBackground,
            theme.secondaryBackground.withAlpha(210),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: theme.primary.withAlpha(60),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 10.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: openCount > 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (openCount > 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withAlpha(120),
                          blurRadius: 6,
                          spreadRadius: 1.5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'HORÁRIO DE BRASÍLIA (BRT · UTC-3)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: theme.secondaryText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.lineColor, width: 0.8),
                ),
                child: Text(
                  'UTC: $timeStrUtc',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: theme.secondaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                timeStrBrt,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: openCount > 0
                      ? const Color(0xFF10B981).withAlpha(25)
                      : const Color(0xFFEF4444).withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: openCount > 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  openCount > 0 ? '$openCount Pregões Abertos' : 'Mercados em Pausa',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: openCount > 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            dateStrBrt[0].toUpperCase() + dateStrBrt.substring(1),
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  /// Régua/Timeline interativa das 24 horas em Brasília com indicador da hora atual
  Widget _build24HourTimeline({required FlutterFlowTheme theme}) {
    final nowBrt = _currentBrt;
    final currentMinuteOfDay = nowBrt.hour * 60 + nowBrt.minute;
    final cursorFraction = (currentMinuteOfDay / 1440.0).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: theme.lineColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ciclo de 24 Horas (Horário de Brasília)',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryText,
                ),
              ),
              Text(
                'Agora: ${DateFormat('HH:mm').format(nowBrt)}',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Barras horizontais das sessões
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;

              // Função auxiliar para calcular posição e largura de um intervalo em minutos
              Widget buildBar(int startMin, int endMin, Color color, String label) {
                double left = (startMin / 1440.0) * totalWidth;
                double width = 0;
                if (endMin >= startMin) {
                  width = ((endMin - startMin) / 1440.0) * totalWidth;
                } else {
                  // Passa da meia noite
                  width = ((1440 - startMin + endMin) / 1440.0) * totalWidth;
                }

                return Positioned(
                  left: left,
                  width: width,
                  height: 18,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withAlpha(200),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }

              final nyStart = _isUsDst ? (10 * 60 + 30) : (11 * 60 + 30);
              final nyEnd = _isUsDst ? (17 * 60) : (18 * 60);

              return Column(
                children: [
                  // Linha da Timeline
                  SizedBox(
                    height: 22,
                    child: Stack(
                      children: [
                        // Fundo
                        Container(
                          height: 18,
                          decoration: BoxDecoration(
                            color: theme.primaryBackground,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Londres: 04:00 às 13:00
                        buildBar(4 * 60, 13 * 60, const Color(0xFF8B5CF6), 'Londres'),
                        // B3: 09:00 às 18:00
                        buildBar(9 * 60, 18 * 60, const Color(0xFF10B981), 'B3'),
                        // Nova York: 10:30/11:30 às 17:00/18:00
                        buildBar(nyStart, nyEnd, const Color(0xFF3B82F6), 'Nova York'),
                        // Ásia (Tóquio): 20:00 às 05:00
                        buildBar(20 * 60, 1440, const Color(0xFFEC4899), 'Ásia'),
                        buildBar(0, 5 * 60, const Color(0xFFEC4899), 'Ásia'),

                        // Cursor Vermelho de Posição Atual
                        Positioned(
                          left: (cursorFraction * totalWidth).clamp(0.0, totalWidth - 2),
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 2.5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xAAEF4444),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Marcadores de hora: 00h, 06h, 12h, 18h, 24h
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('00h', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('04h', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('09h', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('12h', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('18h', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('24h', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required FlutterFlowTheme theme,
    required String label,
    required IconData icon,
    required int index,
  }) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTabIndex = index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.primary : theme.secondaryBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? theme.primary : theme.lineColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : theme.secondaryText,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : theme.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Card de cada sessão individual
  Widget _buildSessionCard({
    required FlutterFlowTheme theme,
    required MarketSessionData session,
  }) {
    final statusInfo = _getSessionStatus(session);
    final isOpen = statusInfo['isOpen'] as bool;
    final badgeColor = statusInfo['badgeColor'] as Color;
    final statusText = statusInfo['status'] as String;
    final remainingText = statusInfo['remainingText'] as String;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: isOpen ? session.themeColor.withAlpha(120) : theme.lineColor,
          width: isOpen ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isOpen ? session.themeColor.withAlpha(25) : const Color(0x10000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header da Sessão
          Row(
            children: [
              Text(
                session.flag,
                style: const TextStyle(fontSize: 26),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      style: theme.titleMedium.override(
                            fontFamily: theme.titleMediumFamily,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: !theme.titleMediumIsCustom,
                          ),
                    ),
                    Text(
                      session.exchange,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: badgeColor, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: badgeColor,
                      ),
                    ),
                    Text(
                      remainingText,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: badgeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 20),

          // Horário Local vs Horário Brasília
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HORÁRIO DE BRASÍLIA',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: theme.secondaryText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${session.openHourBrt.toString().padLeft(2, '0')}:${session.openMinuteBrt.toString().padLeft(2, '0')} às ${session.closeHourBrt.toString().padLeft(2, '0')}:${session.closeMinuteBrt.toString().padLeft(2, '0')} BRT',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: session.themeColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FUSO LOCAL (${session.localTimezone})',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: theme.secondaryText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      session.localHours,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Principais Ativos
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: session.primaryAssets.map((asset) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: theme.lineColor, width: 0.6),
                ),
                child: Text(
                  asset,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: theme.primaryText),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Dica Estratégica
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: session.themeColor.withAlpha(12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: session.themeColor.withAlpha(40), width: 0.8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline_rounded, size: 16, color: session.themeColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    session.strategyNotes,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.primaryText,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card de cada Killzone institucional
  Widget _buildKillzoneCard({
    required FlutterFlowTheme theme,
    required KillzoneData killzone,
  }) {
    final nowBrt = _currentBrt;
    final currentMinutes = nowBrt.hour * 60 + nowBrt.minute;
    final isActive = currentMinutes >= killzone.startMinutesOfDayBrt &&
        currentMinutes < killzone.endMinutesOfDayBrt;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isActive ? killzone.impactColor : theme.lineColor,
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: killzone.impactColor.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(killzone.icon, color: killzone.impactColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        killzone.name,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'EM ANDAMENTO',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      killzone.hoursBrt,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: killzone.impactColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '· ${killzone.session}',
                      style: TextStyle(fontSize: 11, color: theme.secondaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  killzone.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.secondaryText,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Guia didático operacional por faixas de horário
  Widget _buildTraderGuideCard({required FlutterFlowTheme theme}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: theme.lineColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.psychology_rounded, color: Color(0xFFF59E0B), size: 22),
              SizedBox(width: 8),
              Text(
                'Manual do Trader: Quando Operar?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGuideItem(
            theme: theme,
            bulletColor: const Color(0xFF10B981),
            title: '1. Ouro dos Rompimentos (10:30 - 12:30 BRT)',
            text: 'Maior confluência de players institucionais do dia. Mercado à vista da B3 a todo vapor e Wall Street operando com grande volume. Setups de continuação de tendência e breakouts funcionam com melhor taxa de acerto.',
          ),
          const SizedBox(height: 10),
          _buildGuideItem(
            theme: theme,
            bulletColor: const Color(0xFFEF4444),
            title: '2. Horário do Almoço / Range Morto (13:00 - 14:30 BRT)',
            text: 'Londres fecha e os operadores de Nova York saem para o almoço. O volume cai drasticamente. Risco elevado de violinadas, falsos rompimentos e movimentos erráticos. Recomendado ficar de fora.',
          ),
          const SizedBox(height: 10),
          _buildGuideItem(
            theme: theme,
            bulletColor: const Color(0xFF3B82F6),
            title: '3. Horário de Verão dos EUA (DST) e B3',
            text: 'Quando os EUA entram no Horário de Verão (março a novembro), Nova York abre às 10:30 BRT. No inverno americano (novembro a março), abre às 11:30 BRT. Use o botão no topo da tela para alternar.',
          ),
          const SizedBox(height: 10),
          _buildGuideItem(
            theme: theme,
            bulletColor: const Color(0xFF8B5CF6),
            title: '4. Disciplina de Fechamento (Após 16:30 BRT)',
            text: 'O book da B3 começa a secar e a taxa de ajuste diário entra em cálculo. Operações novas de Day Trade após as 16:30 carregam risco desproporcional ao ganho.',
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem({
    required FlutterFlowTheme theme,
    required Color bulletColor,
    required String title,
    required String text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: bulletColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: theme.primaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: theme.secondaryText,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
