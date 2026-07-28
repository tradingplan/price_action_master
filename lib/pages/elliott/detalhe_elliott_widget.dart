import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'detalhe_elliott_model.dart';
export 'detalhe_elliott_model.dart';

class DetalheElliottWidget extends StatefulWidget {
  final Map<String, dynamic>? concept;

  const DetalheElliottWidget({
    super.key,
    this.concept,
  });

  static String routeName = 'DetalheElliott';
  static String routePath = '/detalheElliott';

  @override
  State<DetalheElliottWidget> createState() => _DetalheElliottWidgetState();
}

class _DetalheElliottWidgetState extends State<DetalheElliottWidget> {
  late DetalheElliottModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late List<bool> _checklistStatus;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalheElliottModel());

    final rules = widget.concept?['rules'] as List<dynamic>? ?? [];
    _checklistStatus = List<bool>.generate(rules.length, (index) => false);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final concept = widget.concept ?? {};
    final String nome = concept['nome'] ?? 'Conceito Elliott';
    final String description = concept['description'] ?? '';
    final String chartType = concept['chart'] ?? '';
    final List<dynamic> rules = concept['rules'] as List<dynamic>? ?? [];

    return Title(
      title: nome,
      color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
            nome,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.bold,
                ),
          ),
          elevation: 0.5,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Diagram Illustration Panel
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    height: 220.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElliottIllustration(type: chartType),
                    ),
                  ),
                ),

                // Description Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    'Teoria e Psicologia',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                // Description Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  child: Text(
                    description,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          lineHeight: 1.4,
                        ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Checklist Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    'Checklist das Ondas',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                // Checklist explanation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                  child: Text(
                    'Valide a contagem de ondas marcando as regras verificadas em seu gráfico:',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ),
                const SizedBox(height: 8.0),

                // Checklist Items
                ...List.generate(rules.length, (index) {
                  final String ruleText = rules[index];
                  final isChecked = _checklistStatus[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isChecked
                            ? FlutterFlowTheme.of(context).success.withAlpha(15)
                            : FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: isChecked
                              ? FlutterFlowTheme.of(context).success.withAlpha(80)
                              : FlutterFlowTheme.of(context).lineColor,
                        ),
                      ),
                      child: CheckboxListTile(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            _checklistStatus[index] = val ?? false;
                          });
                        },
                        title: Text(
                          ruleText,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                color: isChecked
                                    ? FlutterFlowTheme.of(context).success
                                    : FlutterFlowTheme.of(context).primaryText,
                                fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
                              ),
                        ),
                        activeColor: FlutterFlowTheme.of(context).success,
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- WIDGET DE ILUSTRAÇÃO DAS ONDAS DE ELLIOTT ---
class ElliottIllustration extends StatelessWidget {
  final String type;

  const ElliottIllustration({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(280, 165),
      painter: ElliottDiagramPainter(
        type: type,
        primaryColor: FlutterFlowTheme.of(context).primary,
        errorColor: FlutterFlowTheme.of(context).error,
        successColor: FlutterFlowTheme.of(context).success,
        textColor: FlutterFlowTheme.of(context).primaryText,
      ),
    );
  }
}

// --- PINTOR DE DIAGRAMAS DE ELLIOTT ---
class ElliottDiagramPainter extends CustomPainter {
  final String type;
  final Color primaryColor;
  final Color errorColor;
  final Color successColor;
  final Color textColor;

  ElliottDiagramPainter({
    required this.type,
    required this.primaryColor,
    required this.errorColor,
    required this.successColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = textColor.withAlpha(150)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (type == 'impulse') {
      // Ciclo completo de 5 ondas
      final points = [
        Offset(size.width * 0.05, size.height * 0.90), // início
        Offset(size.width * 0.22, size.height * 0.60), // Onda 1
        Offset(size.width * 0.35, size.height * 0.78), // Onda 2
        Offset(size.width * 0.65, size.height * 0.20), // Onda 3
        Offset(size.width * 0.78, size.height * 0.50), // Onda 4
        Offset(size.width * 0.95, size.height * 0.10), // Onda 5
      ];

      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);

      // Linha tracejada de topo da Onda 1 para mostrar que a Onda 4 não invade o território da 1
      _drawDottedLine(canvas, points[1], Offset(points[4].dx, points[1].dy), successColor);

      // Desenhar bolinhas nas pontas
      _drawMarkers(canvas, points);

      // Labels
      _drawText(canvas, "1", points[1] + const Offset(-4, -18), textColor, fontWeight: FontWeight.bold);
      _drawText(canvas, "2", points[2] + const Offset(-4, 6), textColor);
      _drawText(canvas, "3", points[3] + const Offset(-4, -18), textColor, fontWeight: FontWeight.bold);
      _drawText(canvas, "4", points[4] + const Offset(-4, 6), textColor);
      _drawText(canvas, "5", points[5] + const Offset(-4, -18), textColor, fontWeight: FontWeight.bold);

      _drawText(canvas, "Regra 3: Sem sobreposição da Onda 4 com o topo da 1", Offset(size.width * 0.25, size.height * 0.88), successColor, fontSize: 8.5);
    } else if (type == 'corrective') {
      // Ciclo Corretivo A-B-C
      final points = [
        Offset(size.width * 0.10, size.height * 0.10), // topo anterior
        Offset(size.width * 0.38, size.height * 0.65), // Onda A
        Offset(size.width * 0.65, size.height * 0.35), // Onda B
        Offset(size.width * 0.90, size.height * 0.90), // Onda C
      ];

      final correctivePaint = Paint()
        ..color = primaryColor
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, correctivePaint);

      // Linha pontilhada no fundo da Onda A para mostrar o rompimento da Onda C
      _drawDottedLine(canvas, points[1], Offset(points[3].dx, points[1].dy), primaryColor);

      _drawMarkers(canvas, points);

      // Labels
      _drawText(canvas, "A", points[1] + const Offset(-4, 6), primaryColor, fontWeight: FontWeight.bold);
      _drawText(canvas, "B", points[2] + const Offset(-4, -18), primaryColor, fontWeight: FontWeight.bold);
      _drawText(canvas, "C", points[3] + const Offset(-4, 6), primaryColor, fontWeight: FontWeight.bold);
    } else if (type == 'rules') {
      // Ilustração educativa das 3 Regras Invioláveis
      final points = [
        Offset(size.width * 0.05, size.height * 0.90), // início
        Offset(size.width * 0.20, size.height * 0.58), // 1
        Offset(size.width * 0.32, size.height * 0.82), // 2 (não rompe o início de 1 - Regra 1)
        Offset(size.width * 0.65, size.height * 0.18), // 3 (a maior - Regra 2)
        Offset(size.width * 0.78, size.height * 0.48), // 4 (não invade a 1 - Regra 3)
        Offset(size.width * 0.95, size.height * 0.10), // 5
      ];

      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);

      _drawMarkers(canvas, points);

      // Destaques de regras em tela
      // Regra 1: Dotted line no chão da 1
      _drawDottedLine(canvas, points[0], Offset(points[2].dx + 20, points[0].dy), successColor);
      // Regra 3: Dotted line no topo da 1
      _drawDottedLine(canvas, points[1], Offset(points[4].dx + 20, points[1].dy), successColor);

      // Rótulos explicativos
      _drawText(canvas, "R1: Onda 2 acima da mín.", points[2] + const Offset(8, 4), successColor, fontSize: 8.0, fontWeight: FontWeight.bold);
      _drawText(canvas, "R2: Onda 3 é a maior", points[3] + const Offset(-90, 0), primaryColor, fontSize: 8.0, fontWeight: FontWeight.bold);
      _drawText(canvas, "R3: Onda 4 acima do topo 1", points[4] + const Offset(-110, -14), successColor, fontSize: 8.0, fontWeight: FontWeight.bold);

      // Labels principais
      _drawText(canvas, "1", points[1] + const Offset(-4, -16), textColor);
      _drawText(canvas, "2", points[2] + const Offset(-4, 6), textColor);
      _drawText(canvas, "3", points[3] + const Offset(-4, -16), textColor);
      _drawText(canvas, "4", points[4] + const Offset(-4, 6), textColor);
      _drawText(canvas, "5", points[5] + const Offset(-4, -16), textColor);
    }
  }

  void _drawMarkers(Canvas canvas, List<Offset> points) {
    final markerPaint = Paint()
      ..color = textColor
      ..style = PaintingStyle.fill;
    for (var p in points) {
      canvas.drawCircle(p, 3.5, markerPaint);
    }
  }

  void _drawDottedLine(Canvas canvas, Offset p1, Offset p2, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    double dx = p2.dx - p1.dx;
    double dy = p2.dy - p1.dy;
    double distance = sqrt(dx * dx + dy * dy);
    int dashCount = (distance / 5.0).floor();
    for (int i = 0; i < dashCount; i += 2) {
      double t1 = i / dashCount;
      double t2 = (i + 1) / dashCount;
      canvas.drawLine(
        Offset(p1.dx + dx * t1, p1.dy + dy * t1),
        Offset(p1.dx + dx * t2, p1.dy + dy * t2),
        paint,
      );
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color, {double fontSize = 9, FontWeight fontWeight = FontWeight.normal}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight, fontFamily: 'sans-serif'),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
