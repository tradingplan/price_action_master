import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../components/trading_plan_promo_banner.dart';
import 'calculadoras_model.dart';
export 'calculadoras_model.dart';

enum MarketCategory {
  todos,
  b3,
  mercadoAmericano,
  forex,
}

class ContractModel {
  final String title;
  final String description;
  final String rateText;
  final String ticksText;
  final double valuePerPoint;
  final double ticksPerPoint;
  final String currency; // 'BRL' or 'USD'
  final MarketCategory market;
  final Map<String, String> specs;

  const ContractModel({
    required this.title,
    required this.description,
    required this.rateText,
    required this.ticksText,
    required this.valuePerPoint,
    required this.ticksPerPoint,
    required this.currency,
    required this.market,
    required this.specs,
  });
}

class CalculadorasWidget extends StatefulWidget {
  const CalculadorasWidget({super.key});

  static String routeName = 'Calculadoras';
  static String routePath = '/calculadoras';

  @override
  State<CalculadorasWidget> createState() => _CalculadorasWidgetState();
}

class _CalculadorasWidgetState extends State<CalculadorasWidget> {
  late CalculadorasModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MarketCategory _selectedCategory = MarketCategory.todos;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalculadorasModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Definições de todos os contratos disponíveis
  static const List<ContractModel> allContracts = [
    // B3 (Mercado Brasileiro)
    ContractModel(
      title: 'DOL',
      description: 'DÓLAR CHEIO (B3)',
      rateText: 'R\$ 50/pt',
      ticksText: '2 ticks/pt',
      valuePerPoint: 50.0,
      ticksPerPoint: 2.0,
      currency: 'BRL',
      market: MarketCategory.b3,
      specs: {
        'Ativo': 'Contrato Futuro de Dólar Comercial (DOL)',
        'Lote Mínimo': '5 contratos (US\$ 250.000)',
        'Vencimento': 'Mensal (1º dia útil do mês de vencimento)',
        'Horário de Negociação': '09:00 - 18:00 (BRT)',
        'Margem Média': 'R\$ 10.000,00 por contrato',
        'Código de Negociação': 'DOL + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'WDO',
      description: 'MINI DÓLAR (B3)',
      rateText: 'R\$ 10/pt',
      ticksText: '2 ticks/pt',
      valuePerPoint: 10.0,
      ticksPerPoint: 2.0,
      currency: 'BRL',
      market: MarketCategory.b3,
      specs: {
        'Ativo': 'Mini Contrato Futuro de Dólar (WDO)',
        'Lote Mínimo': '1 contrato (US\$ 10.000)',
        'Vencimento': 'Mensal (1º dia útil do mês de vencimento)',
        'Horário de Negociação': '09:00 - 18:00 (BRT)',
        'Margem Média': 'R\$ 2.000,00 por contrato (Day Trade: ~R\$ 100)',
        'Código de Negociação': 'WDO + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'IND',
      description: 'ÍNDICE CHEIO (B3)',
      rateText: 'R\$ 250/pt',
      ticksText: '0.2 tick/pt',
      valuePerPoint: 250.0,
      ticksPerPoint: 0.2,
      currency: 'BRL',
      market: MarketCategory.b3,
      specs: {
        'Ativo': 'Contrato Futuro de Ibovespa (IND)',
        'Lote Mínimo': '5 contratos (R\$ 1,00 por ponto x 5 = R\$ 5)',
        'Vencimento': 'Meses pares (quarta-feira mais próxima do dia 15)',
        'Horário de Negociação': '09:00 - 18:00 (BRT)',
        'Margem Média': 'R\$ 15.000,00 por contrato',
        'Código de Negociação': 'IND + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'WIN',
      description: 'MINI ÍNDICE (B3)',
      rateText: 'R\$ 0.20/pt',
      ticksText: '0.2 tick/pt',
      valuePerPoint: 0.2,
      ticksPerPoint: 0.2,
      currency: 'BRL',
      market: MarketCategory.b3,
      specs: {
        'Ativo': 'Mini Contrato Futuro de Ibovespa (WIN)',
        'Lote Mínimo': '1 contrato (R\$ 0,20 por ponto)',
        'Vencimento': 'Meses pares (quarta-feira mais próxima do dia 15)',
        'Horário de Negociação': '09:00 - 18:00 (BRT)',
        'Margem Média': 'R\$ 2.000,00 por contrato (Day Trade: ~R\$ 100)',
        'Código de Negociação': 'WIN + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'BITFUT',
      description: 'BITCOIN FUTURO (B3)',
      rateText: 'R\$ 0.10/pt',
      ticksText: '0.05 tick/pt',
      valuePerPoint: 0.1,
      ticksPerPoint: 0.05,
      currency: 'BRL',
      market: MarketCategory.b3,
      specs: {
        'Ativo': 'Futuro de Bitcoin B3 (BIT)',
        'Lote Mínimo': '1 contrato (0.1 BTC)',
        'Liquidação': 'Financeira em Reais (B3)',
        'Horário de Negociação': '09:00 - 18:00 (BRT)',
        'Código de Negociação': 'BIT + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'CCM',
      description: 'MILHO FUTURO (B3)',
      rateText: 'R\$ 450/pt',
      ticksText: '100 ticks/pt',
      valuePerPoint: 450.0,
      ticksPerPoint: 100.0,
      currency: 'BRL',
      market: MarketCategory.b3,
      specs: {
        'Ativo': 'Futuro de Milho com Liquidação Financeira',
        'Lote Mínimo': '1 contrato (450 sacas de 60kg)',
        'Vencimento': 'Janeiro, Março, Maio, Julho, Agosto, Setembro, Novembro',
        'Horário de Negociação': '09:00 - 16:20 (BRT)',
        'Margem Média': 'R\$ 3.000,00 por contrato',
        'Código de Negociação': 'CCM + Letra do Mês + Ano',
      },
    ),

    // MERCADO AMERICANO (US Futures - CME / COMEX / NYMEX)
    ContractModel(
      title: 'NQ',
      description: 'E-MINI NASDAQ-100 (CME)',
      rateText: '\$ 20/ponto',
      ticksText: '4 ticks/pt (\$5.00)',
      valuePerPoint: 20.0,
      ticksPerPoint: 4.0,
      currency: 'USD',
      market: MarketCategory.mercadoAmericano,
      specs: {
        'Ativo': 'E-mini NASDAQ-100 Index Futures',
        'Lote Mínimo': '1 contrato (US\$ 20 x índice)',
        'Tamanho do Tick': '0.25 ponto = US\$ 5.00',
        'Bolsa': 'CME Globex (Chicago Mercantile Exchange)',
        'Horário': 'Domingo a Sexta, 18:00 - 17:00 ET (23h de pregão)',
        'Liquidação': 'Financeira em USD',
        'Código': 'NQ + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'MNQ',
      description: 'MICRO E-MINI NASDAQ-100 (CME)',
      rateText: '\$ 2/ponto',
      ticksText: '4 ticks/pt (\$0.50)',
      valuePerPoint: 2.0,
      ticksPerPoint: 4.0,
      currency: 'USD',
      market: MarketCategory.mercadoAmericano,
      specs: {
        'Ativo': 'Micro E-mini NASDAQ-100 Index Futures',
        'Lote Mínimo': '1 contrato (US\$ 2 x índice - 1/10 do NQ)',
        'Tamanho do Tick': '0.25 ponto = US\$ 0.50',
        'Bolsa': 'CME Globex',
        'Horário': 'Domingo a Sexta, 18:00 - 17:00 ET',
        'Liquidação': 'Financeira em USD',
        'Código': 'MNQ + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'ES',
      description: 'E-MINI S&P 500 (CME)',
      rateText: '\$ 50/ponto',
      ticksText: '4 ticks/pt (\$12.50)',
      valuePerPoint: 50.0,
      ticksPerPoint: 4.0,
      currency: 'USD',
      market: MarketCategory.mercadoAmericano,
      specs: {
        'Ativo': 'E-mini S&P 500 Index Futures',
        'Lote Mínimo': '1 contrato (US\$ 50 x índice)',
        'Tamanho do Tick': '0.25 ponto = US\$ 12.50',
        'Bolsa': 'CME Globex',
        'Horário': 'Domingo a Sexta, 18:00 - 17:00 ET',
        'Liquidação': 'Financeira em USD',
        'Código': 'ES + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'MES',
      description: 'MICRO E-MINI S&P 500 (CME)',
      rateText: '\$ 5/ponto',
      ticksText: '4 ticks/pt (\$1.25)',
      valuePerPoint: 5.0,
      ticksPerPoint: 4.0,
      currency: 'USD',
      market: MarketCategory.mercadoAmericano,
      specs: {
        'Ativo': 'Micro E-mini S&P 500 Index Futures',
        'Lote Mínimo': '1 contrato (US\$ 5 x índice - 1/10 do ES)',
        'Tamanho do Tick': '0.25 ponto = US\$ 1.25',
        'Bolsa': 'CME Globex',
        'Horário': 'Domingo a Sexta, 18:00 - 17:00 ET',
        'Liquidação': 'Financeira em USD',
        'Código': 'MES + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'GC',
      description: 'GOLD FUTURES / OURO (COMEX)',
      rateText: '\$ 100/ponto',
      ticksText: '10 ticks/pt (\$10.00)',
      valuePerPoint: 100.0,
      ticksPerPoint: 10.0,
      currency: 'USD',
      market: MarketCategory.mercadoAmericano,
      specs: {
        'Ativo': 'Gold Futures (100 Onças Troy)',
        'Lote Mínimo': '1 contrato (100 oz)',
        'Tamanho do Tick': '0.10 ponto = US\$ 10.00',
        'Bolsa': 'COMEX (CME Group)',
        'Horário': 'Domingo a Sexta, 18:00 - 17:00 ET',
        'Código': 'GC + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'MGC',
      description: 'MICRO GOLD FUTURES (COMEX)',
      rateText: '\$ 10/ponto',
      ticksText: '10 ticks/pt (\$1.00)',
      valuePerPoint: 10.0,
      ticksPerPoint: 10.0,
      currency: 'USD',
      market: MarketCategory.mercadoAmericano,
      specs: {
        'Ativo': 'Micro Gold Futures (10 Onças Troy - 1/10 do GC)',
        'Lote Mínimo': '1 contrato (10 oz)',
        'Tamanho do Tick': '0.10 ponto = US\$ 1.00',
        'Bolsa': 'COMEX (CME Group)',
        'Horário': 'Domingo a Sexta, 18:00 - 17:00 ET',
        'Código': 'MGC + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'CL',
      description: 'CRUDE OIL WTI / PETRÓLEO (NYMEX)',
      rateText: '\$ 1.000/ponto',
      ticksText: '100 ticks/pt (\$10.00)',
      valuePerPoint: 1000.0,
      ticksPerPoint: 100.0,
      currency: 'USD',
      market: MarketCategory.mercadoAmericano,
      specs: {
        'Ativo': 'Crude Oil Light Sweet Futures (1.000 Barris)',
        'Lote Mínimo': '1 contrato (1.000 barris de petróleo)',
        'Tamanho do Tick': '0.01 ponto = US\$ 10.00',
        'Bolsa': 'NYMEX (CME Group)',
        'Horário': 'Domingo a Sexta, 18:00 - 17:00 ET',
        'Código': 'CL + Letra do Mês + Ano',
      },
    ),
    ContractModel(
      title: 'MCL',
      description: 'MICRO CRUDE OIL WTI (NYMEX)',
      rateText: '\$ 100/ponto',
      ticksText: '100 ticks/pt (\$1.00)',
      valuePerPoint: 100.0,
      ticksPerPoint: 100.0,
      currency: 'USD',
      market: MarketCategory.mercadoAmericano,
      specs: {
        'Ativo': 'Micro WTI Crude Oil Futures (100 Barris - 1/10 do CL)',
        'Lote Mínimo': '1 contrato (100 barris de petróleo)',
        'Tamanho do Tick': '0.01 ponto = US\$ 1.00',
        'Bolsa': 'NYMEX (CME Group)',
        'Horário': 'Domingo a Sexta, 18:00 - 17:00 ET',
        'Código': 'MCL + Letra do Mês + Ano',
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.sizeOf(context).width > 768;

    // Filtrar contratos
    final filteredContracts = allContracts.where((c) {
      if (_selectedCategory == MarketCategory.todos) return true;
      return c.market == _selectedCategory;
    }).toList();

    final showForexCalculator = _selectedCategory == MarketCategory.todos ||
        _selectedCategory == MarketCategory.forex;

    return Title(
      title: 'Calculadoras de Mercado',
      color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pop();
            },
            child: Icon(
              Icons.chevron_left_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 32.0,
            ),
          ),
          title: Text(
            'Calculadoras',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  useGoogleFonts: !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0.5,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ferramentas de precisão para sua gestão de risco em B3, EUA e Forex.',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                  const SizedBox(height: 14.0),

                  // CATEGORY FILTER CHIPS
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          context,
                          label: 'Todos',
                          icon: Icons.grid_view_rounded,
                          category: MarketCategory.todos,
                        ),
                        const SizedBox(width: 8.0),
                        _buildFilterChip(
                          context,
                          label: 'B3 🇧🇷',
                          icon: Icons.show_chart_rounded,
                          category: MarketCategory.b3,
                        ),
                        const SizedBox(width: 8.0),
                        _buildFilterChip(
                          context,
                          label: 'Mercado Americano 🇺🇸',
                          icon: Icons.public_rounded,
                          category: MarketCategory.mercadoAmericano,
                        ),
                        const SizedBox(width: 8.0),
                        _buildFilterChip(
                          context,
                          label: 'Forex 💱',
                          icon: Icons.currency_exchange_rounded,
                          category: MarketCategory.forex,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18.0),

                  // FOREX CALCULATOR CARD (SE SELECIONADO FOREX OU TODOS)
                  if (showForexCalculator) ...[
                    const ForexProfitCalculatorCard(),
                    const SizedBox(height: 16.0),
                  ],

                  // CONTRATOS FUTUROS (B3 E MERCADO AMERICANO)
                  if (filteredContracts.isNotEmpty) ...[
                    if (isWideScreen)
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.38,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        itemCount: filteredContracts.length,
                        itemBuilder: (context, index) {
                          final item = filteredContracts[index];
                          return CalculatorCard(contract: item);
                        },
                      )
                    else
                      Column(
                        children: filteredContracts
                            .map((c) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: CalculatorCard(contract: c),
                                ))
                            .toList(),
                      ),
                  ],

                  // CARD PROMOCIONAL TRADING PLAN
                  const SizedBox(height: 12.0),
                  const TradingPlanPromoBanner(
                    variant: PromoVariant.planilhas,
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

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required MarketCategory category,
  }) {
    final isSelected = _selectedCategory == category;
    final primaryColor = FlutterFlowTheme.of(context).primary;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      borderRadius: BorderRadius.circular(30.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
            color: isSelected ? primaryColor : FlutterFlowTheme.of(context).lineColor,
            width: 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withAlpha(70),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.0,
              color: isSelected ? Colors.white : FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(width: 6.0),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                    color: isSelected ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12.0,
                    useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CALCULATOR CARD PARA CONTRATOS FUTUROS (B3 E CME)
// ---------------------------------------------------------------------------
class CalculatorCard extends StatefulWidget {
  final ContractModel contract;

  const CalculatorCard({
    super.key,
    required this.contract,
  });

  @override
  State<CalculatorCard> createState() => _CalculatorCardState();
}

class _CalculatorCardState extends State<CalculatorCard> {
  late TextEditingController _contractsController;
  late TextEditingController _pointsController;

  double get _contracts => double.tryParse(_contractsController.text.replaceAll(',', '.')) ?? 0.0;
  double get _points => double.tryParse(_pointsController.text.replaceAll(',', '.')) ?? 0.0;

  @override
  void initState() {
    super.initState();
    _contractsController = TextEditingController(text: '1');
    _pointsController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _contractsController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  String _formatCurrency(double value) {
    if (widget.contract.currency == 'USD') {
      final format = NumberFormat.currency(locale: 'en_US', symbol: '\$ ');
      return format.format(value);
    } else {
      final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ');
      return format.format(value);
    }
  }

  void _showSpecsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Especificações: ${widget.contract.title}',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),
                  ...widget.contract.specs.entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                  ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalTicks = _points * widget.contract.ticksPerPoint;
    final totalValue = _contracts * _points * widget.contract.valuePerPoint;

    final ticksFormatted = totalTicks.toStringAsFixed(totalTicks.truncateToDouble() == totalTicks ? 0 : 2);
    final valueFormatted = _formatCurrency(totalValue);

    final isUsd = widget.contract.currency == 'USD';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).lineColor,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row (Título / Descrição e Preços)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.contract.title,
                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                  fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                ),
                          ),
                          const SizedBox(width: 6.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isUsd ? Colors.blue.withAlpha(35) : Colors.green.withAlpha(35),
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: isUsd ? Colors.blue.withAlpha(80) : Colors.green.withAlpha(80),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              isUsd ? 'EUA 🇺🇸' : 'B3 🇧🇷',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: isUsd ? Colors.blue : Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        widget.contract.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 10.5,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.contract.rateText,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                          ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      widget.contract.ticksText,
                      textAlign: TextAlign.end,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 10.5,
                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 18.0, thickness: 1.0),

            // Inputs Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contratos',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                            ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _contractsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: '1',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).lineColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pontos',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                            ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _pointsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: '1',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).lineColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),

            // Outputs Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).error.withAlpha(20),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).error.withAlpha(51),
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'TOTAL TICKS',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                color: FlutterFlowTheme.of(context).error,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                              ),
                        ),
                        const SizedBox(height: 3.0),
                        Text(
                          ticksFormatted,
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                color: FlutterFlowTheme.of(context).error,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).success.withAlpha(20),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).success.withAlpha(51),
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'RESULTADO',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                color: FlutterFlowTheme.of(context).success,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                              ),
                        ),
                        const SizedBox(height: 3.0),
                        Text(
                          valueFormatted,
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                color: FlutterFlowTheme.of(context).success,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            // Footer Link
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () => _showSpecsBottomSheet(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Text(
                    'Especificações do Contrato',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CALCULADORA DE LUCRO FOREX (AVANÇADA E COMPLETA)
// ---------------------------------------------------------------------------
class ForexPairConfig {
  final String symbol;
  final String name;
  final double contractSize;
  final String quoteCurrency;
  final String? baseCurrency;
  final bool isIndex;
  final double defaultOpen;
  final double defaultClose;
  final double pipMultiplier;

  const ForexPairConfig({
    required this.symbol,
    required this.name,
    required this.contractSize,
    required this.quoteCurrency,
    this.baseCurrency,
    this.isIndex = false,
    required this.defaultOpen,
    required this.defaultClose,
    required this.pipMultiplier,
  });
}

class ForexProfitCalculatorCard extends StatefulWidget {
  const ForexProfitCalculatorCard({super.key});

  @override
  State<ForexProfitCalculatorCard> createState() => _ForexProfitCalculatorCardState();
}

class _ForexProfitCalculatorCardState extends State<ForexProfitCalculatorCard> {
  static const Map<String, ForexPairConfig> pairs = {
    'EURUSD': ForexPairConfig(
      symbol: 'EURUSD',
      name: 'Euro / US Dollar',
      contractSize: 100000,
      quoteCurrency: 'USD',
      defaultOpen: 1.08500,
      defaultClose: 1.08900,
      pipMultiplier: 10000,
    ),
    'GBPUSD': ForexPairConfig(
      symbol: 'GBPUSD',
      name: 'Great Britain Pound / US Dollar',
      contractSize: 100000,
      quoteCurrency: 'USD',
      defaultOpen: 1.29500,
      defaultClose: 1.30000,
      pipMultiplier: 10000,
    ),
    'USDJPY': ForexPairConfig(
      symbol: 'USDJPY',
      name: 'US Dollar / Japanese Yen',
      contractSize: 100000,
      quoteCurrency: 'JPY',
      baseCurrency: 'USD',
      defaultOpen: 154.20,
      defaultClose: 153.50,
      pipMultiplier: 100,
    ),
    'USDCHF': ForexPairConfig(
      symbol: 'USDCHF',
      name: 'US Dollar / Swiss Franc',
      contractSize: 100000,
      quoteCurrency: 'CHF',
      baseCurrency: 'USD',
      defaultOpen: 0.88500,
      defaultClose: 0.89000,
      pipMultiplier: 10000,
    ),
    'AUDUSD': ForexPairConfig(
      symbol: 'AUDUSD',
      name: 'Australian Dollar / US Dollar',
      contractSize: 100000,
      quoteCurrency: 'USD',
      defaultOpen: 0.65500,
      defaultClose: 0.65900,
      pipMultiplier: 10000,
    ),
    'USDCAD': ForexPairConfig(
      symbol: 'USDCAD',
      name: 'US Dollar / Canadian Dollar',
      contractSize: 100000,
      quoteCurrency: 'CAD',
      baseCurrency: 'USD',
      defaultOpen: 1.38500,
      defaultClose: 1.38000,
      pipMultiplier: 10000,
    ),
    'NZDUSD': ForexPairConfig(
      symbol: 'NZDUSD',
      name: 'New Zealand Dollar / US Dollar',
      contractSize: 100000,
      quoteCurrency: 'USD',
      defaultOpen: 0.59800,
      defaultClose: 0.60200,
      pipMultiplier: 10000,
    ),
    'XAUUSD': ForexPairConfig(
      symbol: 'XAUUSD',
      name: 'Gold Spot / US Dollar',
      contractSize: 100,
      quoteCurrency: 'USD',
      defaultOpen: 2730.00,
      defaultClose: 2745.00,
      pipMultiplier: 100,
    ),
    'HK50': ForexPairConfig(
      symbol: 'HK50',
      name: 'Hong Kong 50 Index',
      contractSize: 1,
      quoteCurrency: 'HKD',
      isIndex: true,
      defaultOpen: 20500.0,
      defaultClose: 20750.0,
      pipMultiplier: 1.0,
    ),
  };

  String _selectedPair = 'EURUSD';
  String _accountCurrency = 'USD'; // 'USD' or 'BRL'
  bool _isBuy = true;

  late TextEditingController _lotsController;
  late TextEditingController _openPriceController;
  late TextEditingController _closePriceController;
  late TextEditingController _usdBrlController;

  @override
  void initState() {
    super.initState();
    final p = pairs[_selectedPair]!;
    _lotsController = TextEditingController(text: '0.10');
    _openPriceController = TextEditingController(text: p.defaultOpen.toString());
    _closePriceController = TextEditingController(text: p.defaultClose.toString());
    _usdBrlController = TextEditingController(text: '5.50');
  }

  @override
  void dispose() {
    _lotsController.dispose();
    _openPriceController.dispose();
    _closePriceController.dispose();
    _usdBrlController.dispose();
    super.dispose();
  }

  void _onPairChanged(String? newPair) {
    if (newPair == null || !pairs.containsKey(newPair)) return;
    setState(() {
      _selectedPair = newPair;
      final p = pairs[newPair]!;
      _openPriceController.text = p.defaultOpen.toString();
      _closePriceController.text = p.defaultClose.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pairConfig = pairs[_selectedPair] ?? pairs['EURUSD']!;

    final lots = double.tryParse(_lotsController.text.replaceAll(',', '.')) ?? 0.0;
    final openPrice = double.tryParse(_openPriceController.text.replaceAll(',', '.')) ?? 0.0;
    final closePrice = double.tryParse(_closePriceController.text.replaceAll(',', '.')) ?? 0.0;
    final usdBrlRate = double.tryParse(_usdBrlController.text.replaceAll(',', '.')) ?? 5.50;

    // CÁLCULO DE LUCRO/PREJUÍZO
    double profitInQuote = 0.0;
    if (openPrice > 0 && closePrice > 0 && lots > 0) {
      if (_isBuy) {
        profitInQuote = (closePrice - openPrice) * lots * pairConfig.contractSize;
      } else {
        profitInQuote = (openPrice - closePrice) * lots * pairConfig.contractSize;
      }
    }

    double profitInUSD = 0.0;
    if (pairConfig.quoteCurrency == 'USD') {
      profitInUSD = profitInQuote;
    } else if (pairConfig.baseCurrency == 'USD') {
      profitInUSD = closePrice > 0 ? (profitInQuote / closePrice) : 0.0;
    } else if (pairConfig.quoteCurrency == 'HKD') {
      profitInUSD = profitInQuote / 7.80; // Peg HKD/USD
    } else {
      profitInUSD = profitInQuote;
    }

    final finalResult = _accountCurrency == 'BRL' ? profitInUSD * usdBrlRate : profitInUSD;

    // Pips e Pip Value
    final priceDiff = (closePrice - openPrice).abs();
    final totalPips = priceDiff * pairConfig.pipMultiplier;
    final pipValueInUSD = totalPips > 0
        ? (profitInUSD.abs() / totalPips)
        : (lots * (pairConfig.contractSize / pairConfig.pipMultiplier));
    final finalPipValue = _accountCurrency == 'BRL' ? pipValueInUSD * usdBrlRate : pipValueInUSD;

    final currencyPrefix = _accountCurrency == 'BRL' ? 'R\$ ' : '\$ ';
    final resultFormatted = finalResult.abs().toStringAsFixed(2);
    final isProfit = finalResult >= 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withAlpha(50),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8.0,
            color: Color(0x22000000),
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    Icons.currency_exchange_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calculadora de Lucro Forex & Pips',
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                            ),
                      ),
                      Text(
                        'Simule operações com lotes, paridades e taxa de câmbio',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 11.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24.0, thickness: 1.0),

            // Selectores (Par e Moeda da Conta)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Par de Moedas',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                            ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).lineColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPair,
                            isExpanded: true,
                            dropdownColor: FlutterFlowTheme.of(context).secondaryBackground,
                            items: pairs.keys.map((p) {
                              return DropdownMenuItem<String>(
                                value: p,
                                child: Text(
                                  p,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                            onChanged: _onPairChanged,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Moeda Conta',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                            ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).lineColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _accountCurrency,
                            isExpanded: true,
                            dropdownColor: FlutterFlowTheme.of(context).secondaryBackground,
                            items: const [
                              DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                              DropdownMenuItem(value: 'BRL', child: Text('BRL (R\$)')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _accountCurrency = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),

            // SE MOEDA FOR BRL, MOSTRAR CAMPO DE TAXA USD/BRL
            if (_accountCurrency == 'BRL') ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cotação USD / BRL',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                        ),
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    controller: _usdBrlController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: '5.50',
                      prefixText: 'R\$ ',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).lineColor,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14.0),
            ],

            // Lote e Direção (Compra / Venda)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Volume (Lotes)',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                            ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _lotsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: '0.10',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).lineColor,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Direção',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                            ),
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isBuy = true),
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 9.0),
                                decoration: BoxDecoration(
                                  color: _isBuy ? FlutterFlowTheme.of(context).success : FlutterFlowTheme.of(context).primaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: _isBuy ? FlutterFlowTheme.of(context).success : FlutterFlowTheme.of(context).lineColor,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'COMPRA',
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                    color: _isBuy ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isBuy = false),
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 9.0),
                                decoration: BoxDecoration(
                                  color: !_isBuy ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).primaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: !_isBuy ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).lineColor,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'VENDA',
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                    color: !_isBuy ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),

            // Preço de Abertura e Fechamento
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preço de Entrada',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                            ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _openPriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: '1.08500',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).lineColor,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preço de Saída',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                            ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _closePriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: '1.08900',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).lineColor,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18.0),

            // RESULTADOS / PAINEL DE PERFORMANCE FOREX
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isProfit
                    ? FlutterFlowTheme.of(context).success.withAlpha(20)
                    : FlutterFlowTheme.of(context).error.withAlpha(20),
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(
                  color: isProfit
                      ? FlutterFlowTheme.of(context).success.withAlpha(60)
                      : FlutterFlowTheme.of(context).error.withAlpha(60),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'RESULTADO ESTIMADO',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: isProfit
                          ? FlutterFlowTheme.of(context).success
                          : FlutterFlowTheme.of(context).error,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${isProfit ? "+" : "-"}$currencyPrefix$resultFormatted',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      color: isProfit
                          ? FlutterFlowTheme.of(context).success
                          : FlutterFlowTheme.of(context).error,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Divider(height: 1.0),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'PIPS / PONTOS',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            totalPips.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'VALOR DO PIP',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            '$currencyPrefix${finalPipValue.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'CONTRATO',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            pairConfig.contractSize >= 1000
                                ? '${(pairConfig.contractSize / 1000).toInt()}k'
                                : '${pairConfig.contractSize.toInt()}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
