import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_master/backend/local_data_manager.dart';
import 'package:price_action_master/flutter_flow/flutter_flow_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Suporte a Tema Dark / Light / Sistema', () {
    test('DarkModeTheme e LightModeTheme possuem tokens de cor válidos', () {
      final light = LightModeTheme();
      final dark = DarkModeTheme();

      expect(light.primaryBackground, isNotNull);
      expect(light.secondaryBackground, isNotNull);
      expect(light.primaryText, isNotNull);

      expect(dark.primaryBackground, isNotNull);
      expect(dark.secondaryBackground, isNotNull);
      expect(dark.primaryText, isNotNull);

      // Fundo escuro deve ter luminância menor que fundo claro
      expect(dark.primaryBackground.computeLuminance(),
          lessThan(light.primaryBackground.computeLuminance()));
      // Texto escuro deve ter luminância maior (quase branco) que texto claro (quase preto)
      expect(dark.primaryText.computeLuminance(),
          greaterThan(light.primaryText.computeLuminance()));
    });

    test('LocalDataManager persiste e recupera ThemeMode', () async {
      SharedPreferences.setMockInitialValues({});
      await LocalDataManager.init();

      expect(LocalDataManager.getThemeModeString(), equals('system'));
      expect(LocalDataManager.getThemeMode(), equals(ThemeMode.system));

      await LocalDataManager.setThemeModeString('dark');
      expect(LocalDataManager.getThemeModeString(), equals('dark'));
      expect(LocalDataManager.getThemeMode(), equals(ThemeMode.dark));

      await LocalDataManager.setThemeModeString('light');
      expect(LocalDataManager.getThemeModeString(), equals('light'));
      expect(LocalDataManager.getThemeMode(), equals(ThemeMode.light));
    });
  });
}

