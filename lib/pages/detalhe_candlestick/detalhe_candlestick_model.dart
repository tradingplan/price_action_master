import '/components/trading_plan_logo/trading_plan_logo_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'detalhe_candlestick_widget.dart' show DetalheCandlestickWidget;
import 'package:flutter/material.dart';

class DetalheCandlestickModel
    extends FlutterFlowModel<DetalheCandlestickWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TradingPlanLogo component.
  late TradingPlanLogoModel tradingPlanLogoModel;

  @override
  void initState(BuildContext context) {
    tradingPlanLogoModel = createModel(context, () => TradingPlanLogoModel());
  }

  @override
  void dispose() {
    tradingPlanLogoModel.dispose();
  }
}
