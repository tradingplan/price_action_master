import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'elliott_model.dart';
import 'detalhe_elliott_widget.dart';
export 'elliott_model.dart';

class ElliottWidget extends StatefulWidget {
  const ElliottWidget({super.key});

  static String routeName = 'OndasElliott';
  static String routePath = '/ondasElliott';

  @override
  State<ElliottWidget> createState() => _ElliottWidgetState();
}

class _ElliottWidgetState extends State<ElliottWidget> {
  late ElliottModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> _concepts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => _model = createModel(context, () => ElliottModel()));
    _loadElliottData();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadElliottData() async {
    try {
      final String jsonStr = await rootBundle.loadString('assets/jsons/elliott.json');
      setState(() {
        _concepts = json.decode(jsonStr);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Elliott JSON: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Ondas de Elliott',
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
            'Ondas de Elliott',
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
                  child: Column(
                    children: [
                      // Header Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.waves_outlined,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 32.0,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  'Teoria das Ondas de Elliott',
                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              'Desenvolvida por Ralph Nelson Elliott na década de 1930, esta teoria baseia-se na premissa de que os mercados financeiros se movem em padrões cíclicos repetitivos. Esses ciclos refletem a psicologia de massa dos participantes do mercado, alternando entre pessimismo e otimismo em ondas fractais.',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 12.0,
                                    lineHeight: 1.4,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, thickness: 1),
                      const SizedBox(height: 16.0),

                      // List of concepts
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _concepts.length,
                          itemBuilder: (context, index) {
                            final concept = _concepts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: InkWell(
                                onTap: () {
                                  context.pushNamed(
                                    DetalheElliottWidget.routeName,
                                    extra: <String, dynamic>{
                                      'concept': concept,
                                    },
                                  );
                                },
                                borderRadius: BorderRadius.circular(12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).lineColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          concept['icon'] ?? '📈',
                                          style: const TextStyle(fontSize: 24.0),
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              concept['nome'] ?? '',
                                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              concept['description'] ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    fontSize: 11.0,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        size: 24.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40.0),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
