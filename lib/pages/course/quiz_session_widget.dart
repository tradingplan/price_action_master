import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/local_data_manager.dart';
import 'package:price_action_master/backend/schema/platform_course_models.dart';
import 'package:price_action_master/backend/repositories/course_repository.dart';
import 'package:price_action_master/pages/course/renderers/course_renderers.dart';
import 'quiz_session_model.dart';
export 'quiz_session_model.dart';

// Pergunta do simulado com o curso de origem (exibido como categoria)
class _SessionQuestion {
  final String courseTitle;
  final PlatformQuiz quiz;

  const _SessionQuestion(this.courseTitle, this.quiz);
}

// Simulado geral: agrega os quizzes de todos os cursos em content/courses/
class QuizSessionWidget extends StatefulWidget {
  const QuizSessionWidget({super.key});

  static String routeName = 'QuizSession';
  static String routePath = '/quizSession';

  @override
  State<QuizSessionWidget> createState() => _QuizSessionWidgetState();
}

class _QuizSessionWidgetState extends State<QuizSessionWidget> {
  late QuizSessionModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<_SessionQuestion> _questions = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  String _screenState = 'intro'; // 'intro', 'quiz', 'results'

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QuizSessionModel());
    _loadQuestions();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final courses = await LocalCourseRepository().getAllCourses();
    final questions = <_SessionQuestion>[
      for (final course in courses)
        for (final module in course.modules)
          for (final quiz in module.quizzes) _SessionQuestion(course.title, quiz),
    ];
    if (!mounted) return;
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  void _startQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _isAnswered = false;
      _selectedOptionIndex = null;
      _screenState = 'quiz';
    });
  }

  void _handleAnswerSelection(int optionIndex) {
    if (_isAnswered) return;
    setState(() {
      _selectedOptionIndex = optionIndex;
      _isAnswered = true;
      if (optionIndex == _questions[_currentIndex].quiz.correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() async {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _isAnswered = false;
      });
      return;
    }

    setState(() {
      _screenState = 'results';
    });

    await LocalDataManager.saveQuizAttempt(
      category: 'GERAL',
      score: _score,
      totalQuestions: _questions.length,
      date: DateTime.now().toString().split(' ')[0], // YYYY-MM-DD
    );
  }

  double get _scorePct => _score / (_questions.isEmpty ? 1 : _questions.length);

  String _getClassification() {
    if (_scorePct >= 0.8) return 'Consistente 📈';
    if (_scorePct >= 0.5) return 'Sobrevivente ⚖️';
    return 'Aprendiz 📚';
  }

  String _getClassificationDescription() {
    if (_scorePct >= 0.8) {
      return 'Parabéns! Você demonstrou excelente leitura técnica de mercado e gestão de Price Action. Mantenha a disciplina de execução.';
    }
    if (_scorePct >= 0.5) {
      return 'Bom progresso. Você já entende conceitos chaves de mercado, mas ainda confunde alguns detalhes estruturais. Revise as lições erradas.';
    }
    return 'Atenção necessária. O mercado pune severamente a falta de técnica. Estude as explicações e repita o conteúdo de candles e estruturas antes de operar.';
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Quiz de Trading',
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
            'Quiz de Trading',
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildCurrentScreen(),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    if (_questions.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma pergunta disponível.',
          style: FlutterFlowTheme.of(context).bodyMedium,
        ),
      );
    }
    switch (_screenState) {
      case 'quiz':
        return _buildQuizScreen();
      case 'results':
        return _buildResultsScreen();
      case 'intro':
      default:
        return _buildIntroScreen();
    }
  }

  // --- TELA 1: INTRODUÇÃO ---
  Widget _buildIntroScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40.0),
            Container(
              width: 90.0,
              height: 90.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('🏆', style: TextStyle(fontSize: 48.0)),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Quiz de Trading',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Teste seu conhecimento com as perguntas de todos os cursos da plataforma.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
            const SizedBox(height: 32.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBulletInfo('🟢', '${_questions.length} perguntas realistas de mercado'),
                  const SizedBox(height: 12.0),
                  _buildBulletInfo('🟢', 'Explicações teóricas detalhadas pós-resposta'),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            SizedBox(
              width: double.infinity,
              height: 55.0,
              child: ElevatedButton(
                onPressed: _startQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 2.0,
                ),
                child: Text(
                  'Iniciar Quiz',
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletInfo(String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  // --- TELA 2: PERGUNTA ---
  Widget _buildQuizScreen() {
    final current = _questions[_currentIndex];
    final isLast = _currentIndex == _questions.length - 1;

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _questions.length,
          color: FlutterFlowTheme.of(context).primary,
          backgroundColor: FlutterFlowTheme.of(context).lineColor,
          minHeight: 6.0,
        ),
        Expanded(
          child: QuizRenderer(
            key: ValueKey(current.quiz.id),
            quiz: current.quiz,
            selectedIndex: _selectedOptionIndex,
            isAnswered: _isAnswered,
            onAnswerSelected: _handleAnswerSelection,
            title: current.courseTitle,
            subtitle: 'Questão ${_currentIndex + 1} de ${_questions.length}',
            onNext: _nextQuestion,
            nextLabel: isLast ? 'Ver Resultado' : 'Próxima Questão',
          ),
        ),
      ],
    );
  }

  // --- TELA 3: RESULTADOS ---
  Widget _buildResultsScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary.withAlpha(20),
                shape: BoxShape.circle,
                border: Border.all(color: FlutterFlowTheme.of(context).primary.withAlpha(50), width: 2),
              ),
              alignment: Alignment.center,
              child: const Text('🎯', style: TextStyle(fontSize: 48.0)),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Desempenho Final',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Você concluiu o teste de Price Action!',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(child: _buildStatCard('$_score / ${_questions.length}', 'ACERTOS', highlight: true)),
                const SizedBox(width: 16.0),
                Expanded(child: _buildStatCard(_getClassification(), 'CLASSIFICAÇÃO')),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              _getClassificationDescription(),
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12.0,
                    lineHeight: 1.5,
                  ),
            ),
            const SizedBox(height: 36.0),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: _startQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Refazer Quiz',
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            SizedBox(
              width: double.infinity,
              height: 45.0,
              child: OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: FlutterFlowTheme.of(context).lineColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Voltar ao Início',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, {bool highlight = false}) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            value,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                  color: highlight ? FlutterFlowTheme.of(context).primary : null,
                  fontSize: highlight ? null : 16.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6.0),
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
