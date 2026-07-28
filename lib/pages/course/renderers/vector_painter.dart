import 'dart:math';
import 'package:flutter/material.dart';
import 'package:price_action_master/backend/schema/platform_course_models.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';

class GenericVectorPainter extends CustomPainter {
  final PlatformVectorCanvas canvasData;
  final BuildContext context;

  GenericVectorPainter({required this.canvasData, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final double widthScale = size.width;
    final double heightScale = size.height;

    final Color primary = FlutterFlowTheme.of(context).primary;
    final Color success = FlutterFlowTheme.of(context).success;
    final Color error = FlutterFlowTheme.of(context).error;
    final Color text = FlutterFlowTheme.of(context).primaryText;

    Color getColor(String? style) {
      if (style == 'primary') return primary;
      if (style == 'success') return success;
      if (style == 'error') return error;
      return text;
    }

    for (final el in canvasData.elements) {
      final Color elColor = getColor(el.colorStyle);
      final paint = Paint()
        ..color = elColor
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      if (el.type == 'line') {
        if (el.x1 != null && el.y1 != null && el.x2 != null && el.y2 != null) {
          canvas.drawLine(
            Offset(el.x1! * widthScale, el.y1! * heightScale),
            Offset(el.x2! * widthScale, el.y2! * heightScale),
            paint,
          );
        }
      } else if (el.type == 'dotted_line') {
        if (el.x1 != null && el.y1 != null && el.x2 != null && el.y2 != null) {
          _drawDottedLine(
            canvas,
            Offset(el.x1! * widthScale, el.y1! * heightScale),
            Offset(el.x2! * widthScale, el.y2! * heightScale),
            elColor,
          );
        }
      } else if (el.type == 'circle') {
        if (el.cx != null && el.cy != null) {
          final radius = (el.r ?? 0.02) * widthScale;
          paint.style = PaintingStyle.fill;
          canvas.drawCircle(
            Offset(el.cx! * widthScale, el.cy! * heightScale),
            radius,
            paint,
          );
        }
      } else if (el.type == 'text') {
        if (el.x != null && el.y != null && el.content != null) {
          _drawText(
            canvas,
            el.content!,
            Offset(el.x! * widthScale, el.y! * heightScale),
            elColor,
          );
        }
      } else if (el.type == 'candle') {
        if (el.cx != null && el.cy != null) {
          final isRed = el.content == 'red';
          final candleColor = isRed ? error : success;
          final double cxPix = el.cx! * widthScale;
          final double cyPix = el.cy! * heightScale;
          final double bH = (el.x1 ?? 0.1) * heightScale;
          final double wT = (el.y1 ?? 0.05) * heightScale;
          final double wB = (el.y2 ?? 0.05) * heightScale;
          final double candleWidth = 14.0;

          final candlePaint = Paint()
            ..color = candleColor
            ..style = PaintingStyle.fill;

          final linePaint = Paint()
            ..color = candleColor
            ..strokeWidth = 2.0
            ..style = PaintingStyle.stroke;

          // Wick top
          canvas.drawLine(
            Offset(cxPix, cyPix - bH / 2),
            Offset(cxPix, cyPix - bH / 2 - wT),
            linePaint,
          );
          // Body
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset(cxPix, cyPix), width: candleWidth, height: bH),
              Radius.circular(2.0),
            ),
            candlePaint,
          );
          // Wick bottom
          canvas.drawLine(
            Offset(cxPix, cyPix + bH / 2),
            Offset(cxPix, cyPix + bH / 2 + wB),
            linePaint,
          );
        }
      }
    }
  }

  void _drawDottedLine(Canvas canvas, Offset p1, Offset p2, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    double dx = p2.dx - p1.dx;
    double dy = p2.dy - p1.dy;
    double distance = sqrt(dx * dx + dy * dy);
    int dashCount = (distance / 6.0).floor();
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

  void _drawText(Canvas canvas, String text, Offset offset, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 9.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'sans-serif',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
