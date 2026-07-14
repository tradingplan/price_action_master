import '/components/trading_plan_logo/trading_plan_logo_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'inicio_widget.dart' show InicioWidget;
import 'package:flutter/material.dart';

class InicioModel extends FlutterFlowModel<InicioWidget> {
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
