import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/components/trading_plan_logo/trading_plan_logo_widget.dart';
import '/components/trading_plan_promo_banner.dart';
import '/components/ad_banner_placeholder.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/main.dart';
import 'inicio_model.dart';
import '../../backend/repositories/course_repository.dart';
import '../../backend/schema/platform_course_models.dart';
import '../../backend/local_data_manager.dart';
export 'inicio_model.dart';

class InicioWidget extends StatefulWidget {
  const InicioWidget({super.key});

  static String routeName = 'Inicio';
  static String routePath = '/inicio';

  @override
  State<InicioWidget> createState() => _InicioWidgetState();
}

class _InicioWidgetState extends State<InicioWidget>
    with TickerProviderStateMixin {
  late InicioModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  IconData _getCourseIcon(String id) {
    switch (id) {
      case 'analise_tecnica':
        return Icons.stacked_line_chart;
      case 'candlesticks':
        return Icons.candlestick_chart_outlined;
      case 'figuras':
        return Icons.ssid_chart_sharp;
      case 'smc':
        return Icons.radar_outlined;
      case 'elliott':
        return Icons.waves_outlined;
      case 'gestao_risco':
        return Icons.shield_outlined;
      case 'wyckoff':
        return Icons.trending_up;
      default:
        return Icons.school_outlined;
    }
  }

  Color _getCourseColor(BuildContext context, String id) {
    final theme = FlutterFlowTheme.of(context);
    switch (id) {
      case 'analise_tecnica':
        return theme.primary;
      case 'candlesticks':
        return theme.success;
      case 'figuras':
        return theme.alternate;
      case 'smc':
        return theme.primary;
      case 'elliott':
        return const Color(0xFF3F51B5);
      case 'gestao_risco':
        return const Color(0xFF009688);
      case 'wyckoff':
        return const Color(0xFFE65100);
      default:
        return theme.primary;
    }
  }

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InicioModel());

    animationsMap.addAll({
      'heroOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeOutQuad,
            delay: 0.0.ms,
            duration: 500.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'coursesOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeOutQuad,
            delay: 100.0.ms,
            duration: 500.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'toolsOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeOutQuad,
            delay: 200.0.ms,
            duration: 500.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Title(
      title: 'Price Action Master',
      color: theme.primary.withAlpha(0XFF),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: theme.primaryBackground,
          appBar: AppBar(
            backgroundColor: theme.secondaryBackground,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: theme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.trending_up_rounded,
                    color: theme.primary,
                    size: 22.0,
                  ),
                ),
                const SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Action Master',
                      style: theme.titleMedium.override(
                        fontFamily: 'ITCErasStd',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                    ),
                    Text(
                      'Guia Prático • 100% Offline',
                      style: TextStyle(
                        color: theme.secondaryText,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.school_outlined,
                  color: theme.primaryText,
                  size: 22.0,
                ),
                tooltip: 'Ver Cursos',
                onPressed: () {
                  if (NavBarPage.of(context) != null) {
                    NavBarPage.of(context)!.changeTab('Cursos');
                  } else {
                    context.goNamed(CursosWidget.routeName);
                  }
                },
              ),
            ],
            centerTitle: false,
            elevation: 0.5,
          ),
          body: SafeArea(
            top: true,
            bottom: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Hero Card (Estilo eDemy Moderno)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: theme.lineColor),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6.0,
                          color: Color(0x10000000),
                          offset: Offset(0.0, 3.0),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              'assets/images/bull_chart_hero.png',
                              width: double.infinity,
                              height: 190.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 14.0),
                          Text(
                            'Domine o Price Action & Análise Técnica',
                            textAlign: TextAlign.center,
                            style: theme.headlineSmall.override(
                              fontFamily: theme.headlineSmallFamily,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Padrões de candles, figuras gráficas, Smart Money (SMC) e Teoria de Elliott explicados de forma simples e direta.',
                            textAlign: TextAlign.center,
                            style: theme.bodySmall.override(
                              fontFamily: theme.bodySmallFamily,
                              fontSize: 13.0,
                              color: theme.secondaryText,
                              lineHeight: 1.35,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            width: double.infinity,
                            height: 46.0,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (NavBarPage.of(context) != null) {
                                  NavBarPage.of(context)!.changeTab('Cursos');
                                } else {
                                  context.goNamed(CursosWidget.routeName);
                                }
                              },
                              icon: const Icon(Icons.school_rounded, size: 20.0),
                              label: const Text(
                                'Explorar Cursos',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primary,
                                foregroundColor: Colors.white,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animateOnPageLoad(animationsMap['heroOnPageLoadAnimation']!),

                  const SizedBox(height: 18.0),

                  // 2. Repetição Espaçada (se houver itens pendentes)
                  FutureBuilder<List<PlatformSpacedRepetitionItem>>(
                    future: LocalDataManager.getDueReviewItems(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      final dueItems = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.primary.withAlpha(35),
                                theme.secondaryBackground,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: theme.primary.withAlpha(120),
                              width: 1.2,
                            ),
                          ),
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              Container(
                                width: 42.0,
                                height: 42.0,
                                decoration: BoxDecoration(
                                  color: theme.primary.withAlpha(35),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.psychology_rounded,
                                  color: theme.primary,
                                  size: 24.0,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Repetição Espaçada',
                                          style: TextStyle(
                                            color: theme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                        const SizedBox(width: 6.0),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0, vertical: 2.0),
                                          decoration: BoxDecoration(
                                            color: theme.primary,
                                            borderRadius: BorderRadius.circular(6.0),
                                          ),
                                          child: Text(
                                            '${dueItems.length} pendente${dueItems.length > 1 ? "s" : ""}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3.0),
                                    Text(
                                      'Revise agora: ${dueItems.first.title}${dueItems.length > 1 ? " e mais ${dueItems.length - 1} conceito(s)" : ""}.',
                                      style: TextStyle(
                                        color: theme.secondaryText,
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // 3. Seção: Cursos em Destaque (Estilo eDemy Top Selling Courses)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'APRENDA NO SEU RITMO',
                        style: TextStyle(
                          color: theme.primary,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cursos em Destaque',
                            style: theme.titleLarge.override(
                              fontFamily: theme.titleLargeFamily,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (NavBarPage.of(context) != null) {
                                NavBarPage.of(context)!.changeTab('Cursos');
                              } else {
                                context.goNamed(CursosWidget.routeName);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Ver todos',
                                    style: TextStyle(
                                      color: theme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                  const SizedBox(width: 2.0),
                                  Icon(Icons.chevron_right_rounded, size: 16.0, color: theme.primary),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),

                      // Carrossel Horizontal de Cursos
                      FutureBuilder<List<PlatformCourse>>(
                        future: LocalCourseRepository().getAllCourses(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox(
                              height: 150.0,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final courses = snapshot.data!;
                          return SizedBox(
                            height: 172.0,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: courses.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 12.0),
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                final courseColor = _getCourseColor(context, course.id);

                                return InkWell(
                                  onTap: () {
                                    context.pushNamed(
                                      CourseWidget.routeName,
                                      queryParameters: {
                                        'courseId': serializeParam(
                                          course.id,
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                      extra: <String, dynamic>{
                                        '__transition_info__': const TransitionInfo(
                                          hasTransition: true,
                                          transitionType: PageTransitionType.rightToLeft,
                                        ),
                                      },
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(14.0),
                                  child: Container(
                                    width: 195.0,
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: theme.secondaryBackground,
                                      borderRadius: BorderRadius.circular(14.0),
                                      border: Border.all(color: theme.lineColor),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x0E000000),
                                          offset: Offset(0.0, 2.0),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Header do Card: Ícone + Badge Grátis
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 40.0,
                                              height: 40.0,
                                              decoration: BoxDecoration(
                                                color: courseColor.withAlpha(25),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(
                                                _getCourseIcon(course.id),
                                                color: courseColor,
                                                size: 22.0,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 7.0, vertical: 3.0),
                                              decoration: BoxDecoration(
                                                color: theme.success.withAlpha(22),
                                                borderRadius: BorderRadius.circular(6.0),
                                              ),
                                              child: Text(
                                                'GRÁTIS',
                                                style: TextStyle(
                                                  color: theme.success,
                                                  fontSize: 9.5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),

                                        // Título do Curso
                                        Text(
                                          course.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.titleSmall.override(
                                            fontFamily: theme.titleSmallFamily,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.5,
                                          ),
                                        ),

                                        const SizedBox(height: 6.0),

                                        // Módulos
                                        Row(
                                          children: [
                                            Icon(Icons.menu_book_rounded,
                                                size: 13.0, color: theme.secondaryText),
                                            const SizedBox(width: 4.0),
                                            Text(
                                              '${course.modules.length} Módulos',
                                              style: TextStyle(
                                                color: theme.secondaryText,
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ).animateOnPageLoad(animationsMap['coursesOnPageLoadAnimation']!),

                  const SizedBox(height: 22.0),

                  // 4. Seção: Ferramentas & Prática (Quick Access Cards)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FERRAMENTAS & PRÁTICA',
                        style: TextStyle(
                          color: theme.primary,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Acesse os Utilitários',
                        style: theme.titleLarge.override(
                          fontFamily: theme.titleLargeFamily,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12.0),

                      // Grid de Ferramentas (Calculadoras, Candlesticks, Quizzes, Tarot)
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.5,
                        children: [
                          _buildQuickToolCard(
                            context: context,
                            title: 'Calculadoras',
                            subtitle: 'Lote, Risco & Tamanho',
                            icon: Icons.calculate_outlined,
                            iconColor: theme.primary,
                            onTap: () {
                              if (NavBarPage.of(context) != null) {
                                NavBarPage.of(context)!.changeTab('Calculadoras');
                              } else {
                                context.goNamed(CalculadorasWidget.routeName);
                              }
                            },
                          ),
                          _buildQuickToolCard(
                            context: context,
                            title: 'Candlesticks',
                            subtitle: 'Catálogo de Padrões',
                            icon: Icons.candlestick_chart_outlined,
                            iconColor: theme.success,
                            onTap: () {
                              if (NavBarPage.of(context) != null) {
                                NavBarPage.of(context)!.changeTab('VelasJaponesas');
                              } else {
                                context.goNamed(VelasJaponesasWidget.routeName);
                              }
                            },
                          ),
                          _buildQuickToolCard(
                            context: context,
                            title: 'Quizzes',
                            subtitle: '25 Questões Randômicas',
                            icon: Icons.quiz_outlined,
                            iconColor: const Color(0xFF3F51B5),
                            onTap: () {
                              if (NavBarPage.of(context) != null) {
                                NavBarPage.of(context)!.changeTab('Quiz');
                              } else {
                                context.goNamed(QuizWidget.routeName);
                              }
                            },
                          ),
                          _buildQuickToolCard(
                            context: context,
                            title: 'Tarot Trader',
                            subtitle: 'Psicologia & Reflexão',
                            icon: Icons.auto_awesome_rounded,
                            iconColor: const Color(0xFFE65100),
                            onTap: () {
                              context.pushNamed(
                                TarotWidget.routeName,
                                extra: <String, dynamic>{
                                  '__transition_info__': const TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.rightToLeft,
                                  ),
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ).animateOnPageLoad(animationsMap['toolsOnPageLoadAnimation']!),

                  const SizedBox(height: 20.0),

                  // 5. Banner Promocional do TradingPlan
                  const TradingPlanPromoBanner(
                    variant: PromoVariant.auto,
                    margin: EdgeInsets.only(bottom: 8.0),
                  ),

                  // 6. Placeholder para Anúncio (Banner AdMob acima do Trading Plan)
                  const AdBannerPlaceholder(
                    height: 60.0,
                    margin: EdgeInsets.symmetric(vertical: 6.0),
                  ),

                  // 7. Logo TradingPlan
                  Container(
                    margin: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                    alignment: Alignment.center,
                    child: wrapWithModel(
                      model: _model.tradingPlanLogoModel,
                      updateCallback: () => safeSetState(() {}),
                      child: const TradingPlanLogoWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickToolCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: theme.lineColor),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x0C000000),
              offset: Offset(0.0, 2.0),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34.0,
                  height: 34.0,
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: iconColor, size: 20.0),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 12.0, color: theme.secondaryText),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: theme.titleSmall.override(
                fontFamily: theme.titleSmallFamily,
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.secondaryText,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
