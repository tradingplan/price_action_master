import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/components/safe_image_widget.dart';
import '/components/trading_plan_promo_banner.dart';
import '/backend/schema/candlesticks_record.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../detalhe_candlestick/detalhe_candlestick_widget.dart';
import 'velas_japonesas_model.dart';
export 'velas_japonesas_model.dart';

class VelasJaponesasWidget extends StatefulWidget {
  const VelasJaponesasWidget({super.key});

  static String routeName = 'VelasJaponesas';
  static String routePath = '/velasJaponesas';

  @override
  State<VelasJaponesasWidget> createState() => _VelasJaponesasWidgetState();
}

class _VelasJaponesasWidgetState extends State<VelasJaponesasWidget> {
  late VelasJaponesasModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<CandlesticksRecord> _allCandles = [];
  bool _isLoading = true;
  String _selectedFilter = 'Todos'; // 'Todos', 'Alta', 'Baixa', 'Indecisão'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VelasJaponesasModel());
    _loadCandlesticks();
  }

  @override
  void dispose() {
    _model.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCandlesticks() async {
    try {
      final String jsonStr = await rootBundle.loadString('assets/jsons/candlesticks.json');
      final List<dynamic> rawList = json.decode(jsonStr) as List<dynamic>;

      final records = rawList.map((item) {
        final map = item as Map<String, dynamic>;
        final String candleId = map['id'] ?? 'candle_${DateTime.now().millisecondsSinceEpoch}';
        return CandlesticksRecord.getDocumentFromData(
          map,
          FirebaseFirestore.instance.doc('candlesticks/$candleId'),
        );
      }).toList();

      setState(() {
        _allCandles = records;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading candlesticks JSON: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<CandlesticksRecord> get _filteredCandles {
    return _allCandles.where((c) {
      final matchesFilter = _selectedFilter == 'Todos' ||
          c.pattern.toLowerCase().contains(_selectedFilter.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          c.nome.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  Color _getPatternColor(BuildContext context, String pattern) {
    final lower = pattern.toLowerCase();
    if (lower.contains('alta')) {
      return FlutterFlowTheme.of(context).success;
    }
    if (lower.contains('baixa')) {
      return FlutterFlowTheme.of(context).error;
    }
    return FlutterFlowTheme.of(context).secondaryText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final displayedCandles = _filteredCandles;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          'Candlesticks',
          style: theme.headlineSmall.override(
            fontFamily: theme.headlineSmallFamily,
            color: theme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            // Barra de Pesquisa e Filtros
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              color: theme.secondaryBackground,
              child: Column(
                children: [
                  // Campo de busca
                  Container(
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: theme.lineColor),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar candle (ex: Martelo, Doji...)',
                        hintStyle: theme.bodySmall.override(
                          fontFamily: theme.bodySmallFamily,
                          color: theme.secondaryText,
                        ),
                        prefixIcon: Icon(Icons.search, color: theme.secondaryText, size: 20.0),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: theme.secondaryText, size: 18.0),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      style: theme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Chips de Filtro
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Todos', 'Todos'),
                        const SizedBox(width: 8.0),
                        _buildFilterChip('Alta', 'Alta 📈'),
                        const SizedBox(width: 8.0),
                        _buildFilterChip('Baixa', 'Baixa 📉'),
                        const SizedBox(width: 8.0),
                        _buildFilterChip('Indecisão', 'Indecisão ⚖️'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),

            // Lista de Candlesticks
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : displayedCandles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 48.0, color: theme.secondaryText),
                              const SizedBox(height: 12.0),
                              Text(
                                'Nenhum candlestick encontrado',
                                style: theme.bodyMedium.override(
                                  fontFamily: theme.bodyMediumFamily,
                                  color: theme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          itemCount: displayedCandles.length + 1,
                          itemBuilder: (context, index) {
                            if (index == displayedCandles.length) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 4.0, bottom: 50.0),
                                child: TradingPlanPromoBanner(
                                  variant: PromoVariant.auto,
                                ),
                              );
                            }

                            final candle = displayedCandles[index];
                            final patternColor = _getPatternColor(context, candle.pattern);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: InkWell(
                                onTap: () {
                                  context.pushNamed(
                                    DetalheCandlestickWidget.routeName,
                                    queryParameters: {
                                      'singleCandle': serializeParam(
                                        candle,
                                        ParamType.Document,
                                      ),
                                    }.withoutNulls,
                                    extra: <String, dynamic>{
                                      'singleCandle': candle,
                                      '__transition_info__': TransitionInfo(
                                        hasTransition: true,
                                        transitionType: PageTransitionType.rightToLeft,
                                      ),
                                    },
                                  );
                                },
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.secondaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: theme.lineColor),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: const Color(0x12000000),
                                        offset: const Offset(0.0, 2.0),
                                      )
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      // Ícone / Figura
                                      Container(
                                        width: 46.0,
                                        height: 46.0,
                                        decoration: BoxDecoration(
                                          color: patternColor.withAlpha(20),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        alignment: Alignment.center,
                                        child: SafeImageWidget(
                                          imageOrIcon: candle.icon.isNotEmpty ? candle.icon : '🕯️',
                                          width: 38.0,
                                          height: 38.0,
                                          fit: BoxFit.contain,
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),

                                      // Informações
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    candle.nome,
                                                    style: theme.titleSmall.override(
                                                      fontFamily: theme.titleSmallFamily,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14.5,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 6.0, vertical: 2.0),
                                                  decoration: BoxDecoration(
                                                    color: patternColor.withAlpha(25),
                                                    borderRadius: BorderRadius.circular(4.0),
                                                  ),
                                                  child: Text(
                                                    candle.pattern,
                                                    style: TextStyle(
                                                      color: patternColor,
                                                      fontSize: 10.5,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              candle.description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.bodySmall.override(
                                                fontFamily: theme.bodySmallFamily,
                                                color: theme.secondaryText,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Icon(Icons.chevron_right, color: theme.secondaryText, size: 20.0),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = key;
        });
      },
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : theme.primaryBackground,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? theme.primary : theme.lineColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.primaryText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
