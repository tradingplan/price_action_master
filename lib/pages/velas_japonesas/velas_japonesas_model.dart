import '/components/trading_plan_logo/trading_plan_logo_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'velas_japonesas_widget.dart' show VelasJaponesasWidget;
import 'package:flutter/material.dart';

class VelasJaponesasModel extends FlutterFlowModel<VelasJaponesasWidget> {
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
