import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/local_data_manager.dart';
import 'package:price_action_master/backend/schema/platform_course_models.dart';
import 'package:price_action_master/pages/course/renderers/course_renderers.dart';
import 'module_panel_model.dart';
export 'module_panel_model.dart';

class ModulePanelWidget extends StatefulWidget {
  final String courseId;
  final Map<String, dynamic> moduleData;

  const ModulePanelWidget({
    super.key,
    required this.courseId,
    required this.moduleData,
  });

  static String routeName = 'ModulePanel';
  static String routePath = '/modulePanel';

  @override
  State<ModulePanelWidget> createState() => _ModulePanelWidgetState();
}

class _ModulePanelWidgetState extends State<ModulePanelWidget> {
  late ModulePanelModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late PlatformModule _module;
  late List<bool> _exerciseChecklist;
  int? _selectedQuizIndex;
  bool _isQuizAnswered = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModulePanelModel());

    // Desserializa a estrutura recebida no novo formato
    _module = PlatformModule.fromJson(widget.moduleData);

    // Inicializa estados
    final totalChecks = _module.exercises.isNotEmpty ? _module.exercises.first.checklist.length : 0;
    _exerciseChecklist = List<bool>.generate(totalChecks, (index) => false);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _finishModule() async {
    // 1. Persiste a conclusão do módulo
    await LocalDataManager.setModuleCompleted(widget.courseId, _module.id, true);

    // 2. Concede e persiste a XP definida no Schema do Módulo
    await LocalDataManager.addXP(_module.xpValue);

    // 3. Exibe feedback pedagógico e gamificado
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: FlutterFlowTheme.of(context).success,
        content: Row(
          children: [
            const Icon(Icons.stars, color: Colors.white),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'Módulo "${_module.title}" concluído! +${_module.xpValue} XP obtidos.',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Title(
        title: _module.title,
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.chevron_left_rounded,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 32.0,
              ),
            ),
            title: Text(
              _module.title,
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
            ),
            bottom: TabBar(
              isScrollable: true,
              labelColor: FlutterFlowTheme.of(context).primary,
              unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
              indicatorColor: FlutterFlowTheme.of(context).primary,
              indicatorWeight: 3.0,
              tabs: const [
                Tab(icon: Icon(Icons.menu_book), text: 'Lição'),
                Tab(icon: Icon(Icons.remove_red_eye), text: 'Exemplos'),
                Tab(icon: Icon(Icons.task_alt), text: 'Exercício'),
                Tab(icon: Icon(Icons.help_center), text: 'Quiz'),
                Tab(icon: Icon(Icons.emoji_events), text: 'Desafio'),
              ],
            ),
            elevation: 0.5,
          ),
          body: TabBarView(
            children: [
              // 1. Aba Lição
              _module.lessons.isNotEmpty
                  ? LessonRenderer(lesson: _module.lessons.first)
                  : const Center(child: Text('Nenhuma lição disponível.')),

              // 2. Aba Exemplos (Canvas Vector Graphics)
              _module.examples.isNotEmpty
                  ? ExampleRenderer(example: _module.examples.first)
                  : const Center(child: Text('Nenhum exemplo disponível.')),

              // 3. Aba Exercícios (Checklist)
              _module.exercises.isNotEmpty
                  ? ExerciseRenderer(
                      exercise: _module.exercises.first,
                      checklistState: _exerciseChecklist,
                      onChanged: (newState) {
                        setState(() {
                          _exerciseChecklist = newState;
                        });
                      },
                    )
                  : const Center(child: Text('Nenhum exercício disponível.')),

              // 4. Aba Quiz (Múltipla Escolha)
              _module.quizzes.isNotEmpty
                  ? QuizRenderer(
                      quiz: _module.quizzes.first,
                      selectedIndex: _selectedQuizIndex,
                      isAnswered: _isQuizAnswered,
                      onAnswerSelected: (index) {
                        setState(() {
                          _selectedQuizIndex = index;
                          _isQuizAnswered = true;
                        });
                      },
                    )
                  : const Center(child: Text('Nenhum quiz disponível.')),

              // 5. Aba Desafios (Conclusão e XP)
              _module.challenges.isNotEmpty
                  ? ChallengeRenderer(
                      challenge: _module.challenges.first,
                      isExerciseDone: _exerciseChecklist.every((e) => e == true),
                      isQuizDone: _isQuizAnswered,
                      onCompletePressed: _finishModule,
                    )
                  : const Center(child: Text('Nenhum desafio disponível.')),
            ],
          ),
        ),
      ),
    );
  }
}
