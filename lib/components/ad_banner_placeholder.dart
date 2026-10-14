import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/ad_service.dart';

class AdBannerPlaceholder extends StatefulWidget {
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
  State<AdBannerPlaceholder> createState() => _AdBannerPlaceholderState();
}

class _AdBannerPlaceholderState extends State<AdBannerPlaceholder> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _hasFailed = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    // Na Web não carregamos o SDK nativo do AdMob para evitar exceções
    if (kIsWeb) return;

    try {
      _bannerAd = BannerAd(
        adUnitId: AdService.bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() {
                _isLoaded = true;
                _hasFailed = false;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('Erro ao carregar BannerAd AdMob: ${error.message} (code: ${error.code})');
            ad.dispose();
            if (mounted) {
              setState(() {
                _bannerAd = null;
                _isLoaded = false;
                _hasFailed = true;
              });
            }
          },
        ),
      );

      _bannerAd!.load();
    } catch (e) {
      debugPrint('Exceção ao instanciar BannerAd: $e');
      _hasFailed = true;
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Se o anúncio real carregou com sucesso no Android/iOS, exibe o AdWidget
    if (_isLoaded && _bannerAd != null) {
      return Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    // 2. Se falhou ao carregar em produção (ex: usuário 100% offline), não quebra a interface
    if (_hasFailed && !kDebugMode && !kIsWeb) {
      return const SizedBox.shrink();
    }

    // 3. Em Web, em testes locais ou enquanto carrega: exibe o placeholder estilizado
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      height: widget.height,
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8.0),
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
                    widget.label ?? 'Espaço Publicitário (Ad Banner)',
                    style: TextStyle(
                      color: theme.secondaryText,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    kIsWeb
                        ? 'Google AdMob ativo em celulares Android/iOS'
                        : 'Carregando anúncio patrocinado...',
                    style: TextStyle(
                      color: theme.secondaryText.withAlpha(150),
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
