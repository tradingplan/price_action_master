import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'trading_plan_logo_model.dart';
export 'trading_plan_logo_model.dart';

class TradingPlanLogoWidget extends StatefulWidget {
  const TradingPlanLogoWidget({super.key});

  @override
  State<TradingPlanLogoWidget> createState() => _TradingPlanLogoWidgetState();
}

class _TradingPlanLogoWidgetState extends State<TradingPlanLogoWidget> {
  late TradingPlanLogoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TradingPlanLogoModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Future<void> _openTradingPlan() async {
    final uri = Uri.parse('https://www.tradingplan.com.br');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InkWell(
        onTap: _openTradingPlan,
        borderRadius: BorderRadius.circular(10.0),
        child: Image.asset(
          'assets/images/TP-logo-website-URL-500x60-white.png',
          width: double.infinity,
          height: 48.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
