import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/local_data_manager.dart';
import 'package:price_action_master/backend/schema/platform_course_models.dart';
import 'package:price_action_master/backend/repositories/course_repository.dart';
import 'course_model.dart';
import 'module_panel_widget.dart';
export 'course_model.dart';

class CourseWidget extends StatefulWidget {
  final String? courseId;

  const CourseWidget({
    super.key,
    this.courseId,
  });

  static String routeName = 'Course';
  static String routePath = '/course';

  @override
  State<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  late CourseModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PlatformCourse? _course;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CourseModel());
    _loadCourseData();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadCourseData() async {
    final String cId = widget.courseId ?? 'candlesticks';
    try {
      final course = await LocalCourseRepository().getCourseById(cId);
      setState(() {
        _course = course;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading course JSON via repository: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Recarrega o estado de conclusão ao retornar para a tela
  void _onBackFromModule() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_course == null) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Text(
            'Curso não encontrado.',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
        ),
      );
    }

    final String courseTitle = _course!.title;
    final String courseDesc = _course!.description;
    final List<PlatformModule> modules = _course!.modules;

    // Calcula o progresso total
    int completedCount = 0;
    for (var m in modules) {
      if (LocalDataManager.isModuleCompleted(_course!.id, m.id)) {
        completedCount++;
      }
    }
    double progressPercent = modules.isEmpty ? 0.0 : completedCount / modules.length;

    return Title(
      title: courseTitle,
      color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => context.pop(),
            child: Icon(
              Icons.chevron_left_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 32.0,
            ),
          ),
          title: Text(
            courseTitle,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          elevation: 0.5,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Panel
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseDesc,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 13.0,
                              lineHeight: 1.4,
                            ),
                      ),
                      const SizedBox(height: 16.0),
                      // Progress Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Seu Progresso: $completedCount de ${modules.length} Módulos',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                ),
                          ),
                          Text(
                            '${(progressPercent * 100).toInt()}%',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      LinearProgressIndicator(
                        value: progressPercent,
                        color: FlutterFlowTheme.of(context).primary,
                        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                        minHeight: 8.0,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 20.0),

                // Modules Timeline / List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: modules.length,
                    itemBuilder: (context, index) {
                      final module = modules[index];
                      final bool isCompleted = LocalDataManager.isModuleCompleted(_course!.id, module.id);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Timeline line & check icon
                            Column(
                              children: [
                                Container(
                                  width: 42.0,
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? FlutterFlowTheme.of(context).success
                                        : FlutterFlowTheme.of(context).secondaryBackground,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isCompleted
                                          ? FlutterFlowTheme.of(context).success
                                          : FlutterFlowTheme.of(context).lineColor,
                                      width: 2.0,
                                    ),
                                    boxShadow: isCompleted
                                        ? [
                                            BoxShadow(
                                              color: FlutterFlowTheme.of(context).success.withAlpha(50),
                                              blurRadius: 8.0,
                                            )
                                          ]
                                        : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: isCompleted
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 22.0,
                                        )
                                      : Text(
                                          '${index + 1}',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                ),
                                if (index < modules.length - 1)
                                  Container(
                                    width: 2.0,
                                    height: 70.0,
                                    color: FlutterFlowTheme.of(context).lineColor,
                                  ),
                              ],
                            ),
                            const SizedBox(width: 16.0),

                            // Module Card
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  // Serializa para passar como JSON nas rotas
                                  final Map<String, dynamic> moduleData = module.toJson();

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ModulePanelWidget(
                                        courseId: _course!.id,
                                        moduleData: moduleData,
                                      ),
                                    ),
                                  );

                                  _onBackFromModule();
                                },
                                borderRadius: BorderRadius.circular(12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: isCompleted
                                          ? FlutterFlowTheme.of(context).success.withAlpha(60)
                                          : FlutterFlowTheme.of(context).lineColor,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        module.title,
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                              fontWeight: FontWeight.bold,
                                              color: isCompleted
                                                  ? FlutterFlowTheme.of(context).success
                                                  : FlutterFlowTheme.of(context).primaryText,
                                            ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      Text(
                                        module.description,
                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              fontSize: 11.0,
                                              lineHeight: 1.3,
                                            ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            isCompleted ? 'Concluído' : 'Iniciar Módulo',
                                            style: TextStyle(
                                              color: isCompleted
                                                  ? FlutterFlowTheme.of(context).success
                                                  : FlutterFlowTheme.of(context).primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11.0,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color: isCompleted
                                                ? FlutterFlowTheme.of(context).success
                                                : FlutterFlowTheme.of(context).primary,
                                            size: 16.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
