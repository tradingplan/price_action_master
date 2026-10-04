import 'package:flutter/material.dart';
import '/backend/repositories/course_repository.dart';
import '/backend/schema/platform_course_models.dart';
import '/components/trading_plan_promo_banner.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../course/course_widget.dart';
import 'cursos_model.dart';
export 'cursos_model.dart';

class CursosWidget extends StatefulWidget {
  const CursosWidget({super.key});

  static String routeName = 'Cursos';
  static String routePath = '/cursos';

  @override
  State<CursosWidget> createState() => _CursosWidgetState();
}

class _CursosWidgetState extends State<CursosWidget> {
  late CursosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<PlatformCourse> _allCourses = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CursosModel());
    _loadCourses();
  }

  @override
  void dispose() {
    _model.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    try {
      final courses = await LocalCourseRepository().getAllCourses();
      setState(() {
        _allCourses = courses;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar cursos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<PlatformCourse> get _filteredCourses {
    if (_searchQuery.isEmpty) return _allCourses;
    final query = _searchQuery.toLowerCase();
    return _allCourses.where((c) {
      return c.title.toLowerCase().contains(query) ||
          c.description.toLowerCase().contains(query);
    }).toList();
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final displayedCourses = _filteredCourses;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          'Cursos',
          style: theme.headlineSmall.override(
            fontFamily: theme.headlineSmallFamily,
            color: theme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0.5,
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Barra de Busca e Contador
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 12.0),
              color: theme.secondaryBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo de busca no estilo moderno eDemy
                  Container(
                    height: 46.0,
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: theme.lineColor),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar cursos (ex: SMC, Elliott, Dow...)',
                        hintStyle: theme.bodySmall.override(
                          fontFamily: theme.bodySmallFamily,
                          color: theme.secondaryText,
                        ),
                        prefixIcon: Icon(Icons.search_rounded, color: theme.secondaryText, size: 22.0),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: theme.secondaryText, size: 18.0),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      style: theme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Contador de cursos disponíveis
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${displayedCourses.length} cursos disponíveis',
                        style: theme.bodySmall.override(
                          fontFamily: theme.bodySmallFamily,
                          color: theme.secondaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        '100% Grátis & Offline',
                        style: TextStyle(
                          color: theme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Lista de Cursos
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : displayedCourses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded, size: 48.0, color: theme.secondaryText),
                              const SizedBox(height: 12.0),
                              Text(
                                'Nenhum curso encontrado',
                                style: theme.bodyMedium.override(
                                  fontFamily: theme.bodyMediumFamily,
                                  color: theme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 20.0),
                          itemCount: displayedCourses.length + 1,
                          itemBuilder: (context, index) {
                            // Banner Promocional no final da lista
                            if (index == displayedCourses.length) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 20.0),
                                child: TradingPlanPromoBanner(
                                  variant: PromoVariant.auto,
                                ),
                              );
                            }

                            final course = displayedCourses[index];
                            final courseColor = _getCourseColor(context, course.id);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: InkWell(
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
                                      '__transition_info__': TransitionInfo(
                                        hasTransition: true,
                                        transitionType: PageTransitionType.rightToLeft,
                                      ),
                                    },
                                  );
                                },
                                borderRadius: BorderRadius.circular(14.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.secondaryBackground,
                                    borderRadius: BorderRadius.circular(14.0),
                                    border: Border.all(color: theme.lineColor),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x12000000),
                                        offset: Offset(0.0, 2.0),
                                      )
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(14.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Ícone / Thumbnail estilizado
                                      Container(
                                        width: 54.0,
                                        height: 54.0,
                                        decoration: BoxDecoration(
                                          color: courseColor.withAlpha(22),
                                          borderRadius: BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: courseColor.withAlpha(50),
                                            width: 1.0,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          _getCourseIcon(course.id),
                                          color: courseColor,
                                          size: 28.0,
                                        ),
                                      ),
                                      const SizedBox(width: 14.0),

                                      // Informações do Curso
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Trading Plan • Price Action',
                                              style: TextStyle(
                                                color: theme.secondaryText,
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 3.0),
                                            Text(
                                              course.title,
                                              style: theme.titleSmall.override(
                                                fontFamily: theme.titleSmallFamily,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.5,
                                              ),
                                            ),
                                            const SizedBox(height: 6.0),
                                            Row(
                                              children: [
                                                Icon(Icons.menu_book_rounded,
                                                    size: 13.0, color: theme.secondaryText),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  '${course.modules.length} Módulos',
                                                  style: TextStyle(
                                                    color: theme.secondaryText,
                                                    fontSize: 11.5,
                                                  ),
                                                ),
                                                const SizedBox(width: 12.0),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 6.0, vertical: 2.0),
                                                  decoration: BoxDecoration(
                                                    color: theme.success.withAlpha(25),
                                                    borderRadius: BorderRadius.circular(4.0),
                                                  ),
                                                  child: Text(
                                                    'GRÁTIS',
                                                    style: TextStyle(
                                                      color: theme.success,
                                                      fontSize: 9.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: theme.secondaryText,
                                        size: 22.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
