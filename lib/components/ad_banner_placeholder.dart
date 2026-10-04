import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AdBannerPlaceholder extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry? margin;
  final String? label;

  const AdBannerPlaceholder({
    super.key,
    this.height = 65.0,
    this.margin,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: theme.lineColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 3.0,
            color: Color(0x0A000000),
            offset: Offset(0.0, 1.5),
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Conteúdo central do Placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: theme.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.ad_units_outlined,
                  size: 18.0,
                  color: theme.secondaryText,
                ),
              ),
              const SizedBox(width: 8.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label ?? 'Espaço Publicitário (Ad Banner)',
                    style: TextStyle(
                      color: theme.secondaryText,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Reservado para Google AdMob / Banner',
                    style: TextStyle(
                      color: theme.secondaryText.withAlpha(150),
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tag "ADS" discreta no canto superior esquerdo
          Positioned(
            top: 6.0,
            left: 8.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 1.5),
              decoration: BoxDecoration(
                color: theme.secondaryText.withAlpha(25),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                'AD',
                style: TextStyle(
                  color: theme.secondaryText,
                  fontSize: 8.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
