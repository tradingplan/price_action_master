import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'detalhe_smc_model.dart';
export 'detalhe_smc_model.dart';

class DetalheSMCWidget extends StatefulWidget {
  final Map<String, dynamic>? concept;

  const DetalheSMCWidget({
    super.key,
    this.concept,
  });

  static String routeName = 'DetalheSMC';
  static String routePath = '/detalheSMC';

  @override
  State<DetalheSMCWidget> createState() => _DetalheSMCWidgetState();
}

class _DetalheSMCWidgetState extends State<DetalheSMCWidget> {
  late DetalheSMCModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late List<bool> _checklistStatus;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalheSMCModel());

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
    final String nome = concept['nome'] ?? 'Conceito SMC';
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
                      child: SMCIllustration(type: chartType),
                    ),
                  ),
                ),

                // Description Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    'Descrição Conceitual',
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
                    'Checklist de Identificação',
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
                    'Toque nos itens abaixo para verificar se o cenário gráfico cumpre as exigências do conceito para entrada:',
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

// --- WIDGET DE ILUSTRAÇÃO DOS DIAGRAMAS DE SMC ---
class SMCIllustration extends StatelessWidget {
  final String type;

  const SMCIllustration({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == 'order_block') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 160),
            painter: SMCCandlePainter(
              type: type,
              primaryColor: FlutterFlowTheme.of(context).primary,
              errorColor: FlutterFlowTheme.of(context).error,
              successColor: FlutterFlowTheme.of(context).success,
              textColor: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ],
      );
    } else if (type == 'fvg') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 160),
            painter: SMCCandlePainter(
              type: type,
              primaryColor: FlutterFlowTheme.of(context).primary,
              errorColor: FlutterFlowTheme.of(context).error,
              successColor: FlutterFlowTheme.of(context).success,
              textColor: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ],
      );
    } else {
      return CustomPaint(
        size: const Size(260, 160),
        painter: SMCDiagramPainter(
          type: type,
          primaryColor: FlutterFlowTheme.of(context).primary,
          errorColor: FlutterFlowTheme.of(context).error,
          successColor: FlutterFlowTheme.of(context).success,
          textColor: FlutterFlowTheme.of(context).primaryText,
        ),
      );
    }
  }
}

// --- PINTOR DE CANDLES DE SMC (ORDER BLOCK E FVG) ---
class SMCCandlePainter extends CustomPainter {
  final String type;
  final Color primaryColor;
  final Color errorColor;
  final Color successColor;
  final Color textColor;

  SMCCandlePainter({
    required this.type,
    required this.primaryColor,
    required this.errorColor,
    required this.successColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {


    if (type == 'order_block') {
      // Desenha 3 velas: 1 de Baixa (Vermelha), e 2 de forte Alta (Verdes)
      // Vela 1 (Vermelha) - Order Block
      final x1 = size.width * 0.15;
      _drawCandle(canvas, x: x1, yTop: size.height * 0.50, yBottom: size.height * 0.75, wickTop: size.height * 0.40, wickBottom: size.height * 0.85, isRed: true, width: 22);

      // Vela 2 (Verde) - Expansão forte
      final x2 = size.width * 0.45;
      _drawCandle(canvas, x: x2, yTop: size.height * 0.25, yBottom: size.height * 0.52, wickTop: size.height * 0.20, wickBottom: size.height * 0.58, isRed: false, width: 22);

      // Vela 3 (Verde) - Continuação
      final x3 = size.width * 0.75;
      _drawCandle(canvas, x: x3, yTop: size.height * 0.08, yBottom: size.height * 0.27, wickTop: size.height * 0.05, wickBottom: size.height * 0.32, isRed: false, width: 22);

      // Desenha o bloco translúcido do Order Block estendendo da Vela 1
      final blockPaint = Paint()
        ..color = successColor.withAlpha(30)
        ..style = PaintingStyle.fill;

      
      final rect = Rect.fromLTRB(x1 - 15, size.height * 0.50, size.width, size.height * 0.75);
      canvas.drawRect(rect, blockPaint);
      
      // Dotted horizontal boundaries
      _drawDottedLine(canvas, Offset(x1 - 15, size.height * 0.50), Offset(size.width, size.height * 0.50), successColor);
      _drawDottedLine(canvas, Offset(x1 - 15, size.height * 0.75), Offset(size.width, size.height * 0.75), successColor);

      // Rótulo da zona
      _drawText(canvas, "ZONA DE MITIGAÇÃO (OB)", Offset(x2, size.height * 0.60), successColor, fontSize: 9.0, fontWeight: FontWeight.bold);
    } else if (type == 'fvg') {
      // Ineficiência em 3 velas de alta consecutivas
      // Vela 1 (Verde pequena)
      final x1 = size.width * 0.15;
      _drawCandle(canvas, x: x1, yTop: size.height * 0.65, yBottom: size.height * 0.85, wickTop: size.height * 0.58, wickBottom: size.height * 0.90, isRed: false, width: 22);

      // Vela 2 (Verde gigante)
      final x2 = size.width * 0.45;
      _drawCandle(canvas, x: x2, yTop: size.height * 0.20, yBottom: size.height * 0.67, wickTop: size.height * 0.15, wickBottom: size.height * 0.72, isRed: false, width: 22);

      // Vela 3 (Verde pequena superior)
      final x3 = size.width * 0.75;
      _drawCandle(canvas, x: x3, yTop: size.height * 0.05, yBottom: size.height * 0.22, wickTop: size.height * 0.02, wickBottom: size.height * 0.38, isRed: false, width: 22);

      // Gap está entre a máxima da Vela 1 (wickTop = 0.58) e a mínima da Vela 3 (wickBottom = 0.38)
      final gapTop = size.height * 0.38;
      final gapBottom = size.height * 0.58;

      // Desenha o bloco de Gap
      final gapPaint = Paint()
        ..color = Colors.orange.withAlpha(35)
        ..style = PaintingStyle.fill;
      
      final rect = Rect.fromLTRB(x1 - 15, gapTop, size.width, gapBottom);
      canvas.drawRect(rect, gapPaint);

      _drawDottedLine(canvas, Offset(x1 - 15, gapTop), Offset(size.width, gapTop), Colors.orange);
      _drawDottedLine(canvas, Offset(x1 - 15, gapBottom), Offset(size.width, gapBottom), Colors.orange);

      _drawText(canvas, "FAIR VALUE GAP (IMBALANCE)", Offset(x2 - 10, gapTop + 4), Colors.orange, fontSize: 9.0, fontWeight: FontWeight.bold);
    }
  }

  void _drawCandle(Canvas canvas, {required double x, required double yTop, required double yBottom, required double wickTop, required double wickBottom, required bool isRed, required double width}) {
    final color = isRed ? errorColor : successColor;
    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final wickPaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Wick
    canvas.drawLine(Offset(x, wickTop), Offset(x, wickBottom), wickPaint);
    // Body
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(x - width/2, yTop, x + width/2, yBottom), const Radius.circular(2)), bodyPaint);
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

// --- PINTOR DE DIAGRAMAS DE ESTRUTURA DE SMC (BOS E CHOCH) ---
class SMCDiagramPainter extends CustomPainter {
  final String type;
  final Color primaryColor;
  final Color errorColor;
  final Color successColor;
  final Color textColor;

  SMCDiagramPainter({
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

    if (type == 'bos') {
      // Desenha ondas de alta com rompimento continuado
      final points = [
        Offset(size.width * 0.05, size.height * 0.85),
        Offset(size.width * 0.30, size.height * 0.40), // Topo 1
        Offset(size.width * 0.50, size.height * 0.65), // Fundo 2
        Offset(size.width * 0.85, size.height * 0.15), // Topo 3
      ];

      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);

      // Dotted horizontal line from peak 1
      final double lineY = points[1].dy;
      _drawDottedLine(canvas, points[1], Offset(size.width * 0.90, lineY), successColor);

      // Draw green marker at breakout intersection
      final double breakX = points[2].dx + (points[3].dx - points[2].dx) * ((lineY - points[2].dy) / (points[3].dy - points[2].dy));
      canvas.drawCircle(Offset(breakX, lineY), 4.5, Paint()..color = successColor..style = PaintingStyle.fill);

      // Label BOS
      _drawText(canvas, "BOS (Ruptura)", Offset(breakX - 10, lineY - 18), successColor, fontSize: 10, fontWeight: FontWeight.bold);
    } else if (type == 'choch') {
      // Reversão de tendência: de Alta para Baixa
      final points = [
        Offset(size.width * 0.05, size.height * 0.70),
        Offset(size.width * 0.25, size.height * 0.25), // Topo 1
        Offset(size.width * 0.45, size.height * 0.55), // Fundo 2
        Offset(size.width * 0.65, size.height * 0.15), // Topo Superior
        Offset(size.width * 0.85, size.height * 0.85), // Rompe Fundo 2!
      ];

      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);

      // Dotted horizontal line at Fundo 2
      final double lineY = points[2].dy;
      _drawDottedLine(canvas, points[2], Offset(size.width * 0.90, lineY), errorColor);

      // Draw red circle at breakout intersection
      final double breakX = points[3].dx + (points[4].dx - points[3].dx) * ((lineY - points[3].dy) / (points[4].dy - points[3].dy));
      canvas.drawCircle(Offset(breakX, lineY), 4.5, Paint()..color = errorColor..style = PaintingStyle.fill);

      // Label CHoCH
      _drawText(canvas, "CHoCH (Quebra de Caráter)", Offset(breakX - 30, lineY + 8), errorColor, fontSize: 10, fontWeight: FontWeight.bold);
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
