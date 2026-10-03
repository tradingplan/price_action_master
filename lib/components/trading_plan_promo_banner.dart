import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_theme.dart';

enum PromoVariant {
  auto,
  planilhas,
  comunidade,
  ferramentas,
}

class PromoContent {
  final IconData icon;
  final String title;
  final String tag;
  final String description;

  const PromoContent({
    required this.icon,
    required this.title,
    required this.tag,
    required this.description,
  });
}

class TradingPlanPromoBanner extends StatelessWidget {
  final PromoVariant variant;
  final String url;
  final EdgeInsetsGeometry? margin;

  const TradingPlanPromoBanner({
    super.key,
    this.variant = PromoVariant.auto,
    this.url = 'https://www.tradingplan.com.br',
    this.margin,
  });

  static const List<PromoContent> _allPromos = [
    PromoContent(
      icon: Icons.auto_graph_rounded,
      title: 'Planilhas & Diário de Trade',
      tag: 'GRÁTIS',
      description: 'Leve sua gestão a sério. Baixe planilhas e diários de trade no portal tradingplan.com.br',
    ),
    PromoContent(
      icon: Icons.public_rounded,
      title: 'Ecossistema Trading Plan',
      tag: 'OFICIAL',
      description: 'Análises de mercado, setups diários e ferramentas exclusivas no portal tradingplan.com.br',
    ),
    PromoContent(
      icon: Icons.calculate_rounded,
      title: 'Ferramentas & Gestão de Risco',
      tag: 'ACESSAR',
      description: 'Acesse simuladores de lote, checklists operacionais e gestão no portal tradingplan.com.br',
    ),
  ];

  PromoContent _getSelectedPromo() {
    switch (variant) {
      case PromoVariant.planilhas:
        return _allPromos[0];
      case PromoVariant.comunidade:
        return _allPromos[1];
      case PromoVariant.ferramentas:
        return _allPromos[2];
      case PromoVariant.auto:
        final randomIdx = Random().nextInt(_allPromos.length);
        return _allPromos[randomIdx];
    }
  }

  @override
  Widget build(BuildContext context) {
    final promo = _getSelectedPromo();

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        borderRadius: BorderRadius.circular(14.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primary.withAlpha(28),
                FlutterFlowTheme.of(context).secondaryBackground,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).primary.withAlpha(70),
              width: 1.0,
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 6.0,
                color: Color(0x14000000),
                offset: Offset(0.0, 2.0),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: Icon(
                  promo.icon,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6.0,
                      runSpacing: 2.0,
                      children: [
                        Text(
                          promo.title,
                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            promo.tag,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      promo.description,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 10.5,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6.0),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.0,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
