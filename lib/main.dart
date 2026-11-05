import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'backend/firebase/firebase_config.dart';
import 'backend/local_data_manager.dart';
import 'services/pro_access_service.dart';
import 'services/in_app_purchase_service.dart';
import 'components/app_drawer_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Inicialização segura do Google Mobile Ads (apenas em Android/iOS)
  if (!kIsWeb) {
    try {
      await MobileAds.instance.initialize();
    } catch (e) {
      debugPrint('Erro ao inicializar AdMob: $e');
    }
  }

  await initFirebase();
  await LocalDataManager.init();
  await ProAccessService().initialize();

  if (!kIsWeb) {
    try {
      await InAppPurchaseService().initialize();
    } catch (e) {
      debugPrint('Erro ao inicializar IAP: ');
    }
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.path;
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();
    _themeMode = LocalDataManager.getThemeMode();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    Future.delayed(const Duration(milliseconds: 2000),
        () => safeSetState(() => _appStateNotifier.stopShowingSplashImage()));
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Price Action Master',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('pt'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({
    Key? key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  }) : super(key: key);

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  static NavBarPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<NavBarPageState>();

  @override
  NavBarPageState createState() => NavBarPageState();
}

/// This is the State class that goes with NavBarPage.
class NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'Inicio';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  void didUpdateWidget(NavBarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPage != null && widget.initialPage != _currentPageName) {
      safeSetState(() {
        _currentPageName = widget.initialPage!;
        _currentPage = widget.page;
      });
    }
  }

  void changeTab(String tabName) {
    if (_currentPageName != tabName) {
      safeSetState(() {
        _currentPage = null;
        _currentPageName = tabName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const mainTabs = ['Inicio', 'Cursos', 'Playbook', 'VelasJaponesas'];
    final tabs = {
      'Inicio': InicioWidget(),
      'Cursos': const CursosWidget(),
      'Playbook': const EstrategiasListPage(),
      'VelasJaponesas': VelasJaponesasWidget(),
      'Calculadoras': CalculadorasWidget(),
      'Quiz': QuizWidget(),
      'Ajustes': const AjustesWidget(),
    };
    final currentIndex = mainTabs.indexOf(_currentPageName);

    return Scaffold(
      key: NavBarPage.scaffoldKey,
      drawer: const AppDrawerWidget(),
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName] ?? tabs['Inicio'],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 4.0,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: GNav(
              selectedIndex: currentIndex >= 0 ? currentIndex : 0,
              onTabChange: (i) => safeSetState(() {
                _currentPage = null;
                _currentPageName = mainTabs[i];
              }),
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              color: FlutterFlowTheme.of(context).secondaryText,
              activeColor: FlutterFlowTheme.of(context).primary,
              tabBackgroundColor: FlutterFlowTheme.of(context).primary.withAlpha(35),
              tabBorderRadius: 10.0,
              tabMargin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              gap: 4.0,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              duration: const Duration(milliseconds: 300),
              haptic: false,
              tabs: [
                GButton(
                  icon: currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                  text: 'Home',
                  iconSize: 22.0,
                ),
                GButton(
                  icon: currentIndex == 1 ? Icons.school_rounded : Icons.school_outlined,
                  text: 'Cursos',
                  iconSize: 22.0,
                ),
                GButton(
                  icon: currentIndex == 2
                      ? Icons.auto_graph_rounded
                      : Icons.auto_graph_outlined,
                  text: 'Playbook',
                  iconSize: 22.0,
                ),
                GButton(
                  icon: currentIndex == 3
                      ? Icons.candlestick_chart_rounded
                      : Icons.candlestick_chart_outlined,
                  text: 'Candles',
                  iconSize: 22.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
