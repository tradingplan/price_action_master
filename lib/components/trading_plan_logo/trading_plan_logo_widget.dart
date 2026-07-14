import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Image.asset(
        'assets/images/TP-logo-website-URL-500x60-white.png',
        width: double.infinity,
        height: 100.0,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
