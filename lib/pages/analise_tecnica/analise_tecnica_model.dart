import '/components/trading_plan_logo/trading_plan_logo_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'analise_tecnica_widget.dart' show AnaliseTecnicaWidget;
import 'package:flutter/material.dart';

class AnaliseTecnicaModel extends FlutterFlowModel<AnaliseTecnicaWidget> {
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
