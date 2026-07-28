import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'calculadoras_model.dart';
export 'calculadoras_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.sizeOf(context).width > 768;

    final cards = [
      const CalculatorCard(
        title: 'DOL',
        description: 'DÓLAR CHEIO',
        rateText: 'R\$ 50/ponto',
        ticksText: '2 tick/ponto',
        valuePerPoint: 50.0,
        ticksPerPoint: 2.0,
        specs: {
          'Lote Mínimo': '5 contratos',
          'Vencimento': 'Mensal (último dia útil)',
          'Horário de Negociação': '09:00 - 18:00',
          'Margem Média': 'R\$ 10.000,00 por contrato',
          'Código': 'DOL + Letra do Mês + Ano',
        },
      ),
      const CalculatorCard(
        title: 'WDO',
        description: 'MINI DÓLAR',
        rateText: 'R\$ 10/ponto',
        ticksText: '2 tick/ponto',
        valuePerPoint: 10.0,
        ticksPerPoint: 2.0,
        specs: {
          'Lote Mínimo': '1 contrato',
          'Vencimento': 'Mensal (último dia útil)',
          'Horário de Negociação': '09:00 - 18:00',
          'Margem Média': 'R\$ 2.000,00 por contrato',
          'Código': 'WDO + Letra do Mês + Ano',
        },
      ),
      const CalculatorCard(
        title: 'IND',
        description: 'ÍNDICE CHEIO',
        rateText: 'R\$ 250/ponto',
        ticksText: '0.2 tick/ponto',
        valuePerPoint: 250.0,
        ticksPerPoint: 0.2,
        specs: {
          'Lote Mínimo': '5 contratos',
          'Vencimento': 'Meses pares (quarta-feira mais próxima do dia 15)',
          'Horário de Negociação': '09:00 - 18:00',
          'Margem Média': 'R\$ 15.000,00 por contrato',
          'Código': 'IND + Letra do Mês + Ano',
        },
      ),
      const CalculatorCard(
        title: 'WIN',
        description: 'MINI ÍNDICE',
        rateText: 'R\$ 0.2/ponto',
        ticksText: '0.2 tick/ponto',
        valuePerPoint: 0.2,
        ticksPerPoint: 0.2,
        specs: {
          'Lote Mínimo': '1 contrato',
          'Vencimento': 'Meses pares (quarta-feira mais próxima do dia 15)',
          'Horário de Negociação': '09:00 - 18:00',
          'Margem Média': 'R\$ 2.000,00 por contrato',
          'Código': 'WIN + Letra do Mês + Ano',
        },
      ),
      const CalculatorCard(
        title: 'BITFUT',
        description: 'BITCOIN FUTURO',
        rateText: 'R\$ 0.1/ponto',
        ticksText: '0.05 tick/ponto',
        valuePerPoint: 0.1,
        ticksPerPoint: 0.05,
        specs: {
          'Lote Mínimo': '1 contrato (0.1 BTC)',
          'Liquidação': 'Financeira',
          'Horário de Negociação': '09:00 - 18:00',
          'Código': 'BIT + Letra do Mês + Ano',
        },
      ),
      const CalculatorCard(
        title: 'CCM',
        description: 'MILHO FUTURO',
        rateText: 'R\$ 450/ponto',
        ticksText: '100 tick/ponto',
        valuePerPoint: 450.0,
        ticksPerPoint: 100.0,
        specs: {
          'Lote Mínimo': '1 contrato (450 sacas de 60kg)',
          'Vencimento': 'Janeiro, Março, Maio, Julho, Setembro, Novembro',
          'Horário de Negociação': '09:00 - 16:20',
          'Margem Média': 'R\$ 3.000,00 por contrato',
          'Código': 'CCM + Letra do Mês + Ano',
        },
      ),
    ];

    return Title(
      title: 'Calculadoras',
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
          actions: [],
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
                    'Ferramentas de precisão para sua gestão de risco.',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  if (isWideScreen)
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 1.45,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      children: cards,
                    )
                  else
                    Column(
                      children: cards.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: c,
                      )).toList(),
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
}

class CalculatorCard extends StatefulWidget {
  final String title;
  final String description;
  final String rateText;
  final String ticksText;
  final double valuePerPoint;
  final double ticksPerPoint;
  final Map<String, String> specs;

  const CalculatorCard({
    super.key,
    required this.title,
    required this.description,
    required this.rateText,
    required this.ticksText,
    required this.valuePerPoint,
    required this.ticksPerPoint,
    required this.specs,
  });

  @override
  State<CalculatorCard> createState() => _CalculatorCardState();
}

class _CalculatorCardState extends State<CalculatorCard> {
  late TextEditingController _contractsController;
  late TextEditingController _pointsController;
  final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

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
                      child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Especificações: ${widget.title}',
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
                ...widget.specs.entries.map((entry) => Padding(
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalTicks = _points * widget.ticksPerPoint;
    final totalValue = _contracts * _points * widget.valuePerPoint;

    // Formata o tick com casas decimais apenas se necessário
    final ticksFormatted = totalTicks.toStringAsFixed(totalTicks.truncateToDouble() == totalTicks ? 0 : 2);
    final valueFormatted = _currencyFormat.format(totalValue);

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
            // Top Row (DOL / Descrição e Preços)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                            color: FlutterFlowTheme.of(context).primary,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                          ),
                    ),
                    Text(
                      widget.description,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 11.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.rateText,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                          ),
                    ),
                    Text(
                      widget.ticksText,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 11.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20.0, thickness: 1.0),

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
            const SizedBox(height: 16.0),

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
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                        const SizedBox(height: 4.0),
                        Text(
                          ticksFormatted,
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                color: FlutterFlowTheme.of(context).error,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
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
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                        const SizedBox(height: 4.0),
                        Text(
                          valueFormatted,
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                color: FlutterFlowTheme.of(context).success,
                                fontSize: 18.0,
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
            const SizedBox(height: 12.0),

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
