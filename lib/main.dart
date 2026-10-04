import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'backend/firebase/firebase_config.dart';
import 'backend/local_data_manager.dart';
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

  await initFirebase();
  await LocalDataManager.init();

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
    final tabs = {
      'Inicio': InicioWidget(),
      'Cursos': const CursosWidget(),
      'Calculadoras': CalculadorasWidget(),
      'VelasJaponesas': VelasJaponesasWidget(),
      'Quiz': QuizWidget(),
      'Ajustes': const AjustesWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
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
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
            child: GNav(
              selectedIndex: currentIndex >= 0 ? currentIndex : 0,
              onTabChange: (i) => safeSetState(() {
                _currentPage = null;
                _currentPageName = tabs.keys.toList()[i];
              }),
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              color: const Color(0x8A000000),
              activeColor: FlutterFlowTheme.of(context).secondaryBackground,
              tabBackgroundColor: FlutterFlowTheme.of(context).accent1,
              tabBorderRadius: 8.0,
              tabMargin: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 2.0),
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 7.0),
              gap: 3.0,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              duration: const Duration(milliseconds: 350),
              haptic: false,
              tabs: [
                GButton(
                  icon: currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                  text: 'Home',
                  iconSize: 20.0,
                ),
                GButton(
                  icon: currentIndex == 1 ? Icons.school_rounded : Icons.school_outlined,
                  text: 'Cursos',
                  iconSize: 20.0,
                ),
                GButton(
                  icon: currentIndex == 2
                      ? Icons.calculate_rounded
                      : Icons.calculate_outlined,
                  text: 'Calculadoras',
                  iconSize: 20.0,
                ),
                GButton(
                  icon: currentIndex == 3
                      ? Icons.candlestick_chart_rounded
                      : Icons.candlestick_chart_outlined,
                  text: 'Candlesticks',
                  iconSize: 20.0,
                ),
                GButton(
                  icon: currentIndex == 4
                      ? Icons.quiz_rounded
                      : Icons.quiz_outlined,
                  text: 'Quiz',
                  iconSize: 20.0,
                ),
                GButton(
                  icon: currentIndex == 5
                      ? Icons.settings_rounded
                      : Icons.settings_outlined,
                  text: 'Ajustes',
                  iconSize: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
