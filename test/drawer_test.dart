import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_master/components/app_drawer_widget.dart';
import 'package:price_action_master/services/pro_access_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AppDrawerWidget renderiza seções e itens corretamente',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'pam_user_is_pro_lifetime': false});
    await ProAccessService().initialize();

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          drawer: AppDrawerWidget(),
          body: Center(child: Text('Teste Drawer')),
        ),
      ),
    );

    // Abre o drawer
    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    // Valida títulos das seções e itens
    expect(find.text('Price Action Master'), findsOneWidget);
    expect(find.text('CONTEÚDO PRINCIPAL'), findsOneWidget);
    expect(find.text('FERRAMENTAS & PRÁTICA'), findsOneWidget);
    expect(find.text('Playbook Operacional (20 Setups)'), findsOneWidget);
    expect(find.text('Calculadoras (Lote & Risco)'), findsOneWidget);
    expect(find.text('Tarot do Trader (Psicologia)'), findsOneWidget);
  });
}

