import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/local_data_manager.dart';
import 'quiz_model.dart';
export 'quiz_model.dart';

class QuizWidget extends StatefulWidget {
  const QuizWidget({super.key});

  static String routeName = 'Quiz';
  static String routePath = '/quiz';

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  late QuizModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> _questions = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  String _screenState = 'intro'; // 'intro', 'quiz', 'results'

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QuizModel());
    _loadQuizData();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadQuizData() async {
    try {
      final String jsonStr = await rootBundle.loadString('assets/jsons/quiz.json');
      setState(() {
        _questions = json.decode(jsonStr);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading quiz JSON: $e');
      setState(() {
        _isLoading = false;
      });
    }
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

    final currentQuestion = _questions[_currentIndex];
    final int correctIndex = currentQuestion['correct_index'];

    setState(() {
      _selectedOptionIndex = optionIndex;
      _isAnswered = true;
      if (optionIndex == correctIndex) {
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
    } else {
      // Finalizou o Quiz
      setState(() {
        _screenState = 'results';
      });

      // Grava o resultado no banco local
      await LocalDataManager.saveQuizAttempt(
        category: 'GERAL',
        score: _score,
        totalQuestions: _questions.length,
        date: DateTime.now().toString().split(' ')[0], // YYYY-MM-DD
      );
    }
  }

  String _getClassification() {
    final double pct = _score / (_questions.isEmpty ? 1 : _questions.length);
    if (pct >= 0.8) return 'Consistente 📈';
    if (pct >= 0.5) return 'Sobrevivente ⚖️';
    return 'Aprendiz 📚';
  }

  String _getClassificationDescription() {
    final double pct = _score / (_questions.isEmpty ? 1 : _questions.length);
    if (pct >= 0.8) {
      return 'Parabéns! Você demonstrou excelente leitura técnica de mercado e gestão de Price Action. Mantenha a disciplina de execução.';
    }
    if (pct >= 0.5) {
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
              child: Text(
                '🏆',
                style: TextStyle(fontSize: 48.0),
              ),
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
              'Teste seu conhecimento prático sobre padrões de velas, figuras gráficas, Smart Money (SMC) e Ondas de Elliott.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
            const SizedBox(height: 32.0),
            // Info Box
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
                  _buildBulletInfo('🟢', '5 perguntas realistas de mercado'),
                  const SizedBox(height: 12.0),
                  _buildBulletInfo('🟢', 'Gráficos e ilustrações vetoriais exclusivas'),
                  const SizedBox(height: 12.0),
                  _buildBulletInfo('🟢', 'Explicações teóricas detalhadas pós-resposta'),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            // Start Button
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
    if (_questions.isEmpty) return const SizedBox();

    final currentQuestion = _questions[_currentIndex];
    final String questionText = currentQuestion['question'];
    final String category = currentQuestion['category'];
    final String illustrationType = currentQuestion['illustration_type'];
    final List<dynamic> options = currentQuestion['options'];
    final int correctIndex = currentQuestion['correct_index'];
    final String explanation = currentQuestion['explanation'];

    final double progress = (_currentIndex + 1) / _questions.length;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questão ${_currentIndex + 1} de ${_questions.length}',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                Text(
                  category,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Progress Bar
            Container(
              width: double.infinity,
              height: 6.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).lineColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: ((progress * 100).round()),
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: ((100 - (progress * 100)).round()),
                    child: const SizedBox(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // Question Prompt
            Text(
              questionText,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16.0),

            // Illustration Panel
            Container(
              width: double.infinity,
              height: 140.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
              ),
              alignment: Alignment.center,
              child: QuizIllustration(type: illustrationType),
            ),
            const SizedBox(height: 20.0),

            // Options List
            Column(
              children: List.generate(options.length, (idx) {
                final String text = options[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildOptionButton(
                    index: idx,
                    text: text,
                    correctIndex: correctIndex,
                  ),
                );
              }),
            ),

            // Feedback Panel (shows up after answering)
            if (_isAnswered) ...[
              const SizedBox(height: 8.0),
              _buildFeedbackPanel(correctIndex, explanation),
            ],
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required int index,
    required String text,
    required int correctIndex,
  }) {
    Color buttonColor = FlutterFlowTheme.of(context).secondaryBackground;
    Color borderColor = FlutterFlowTheme.of(context).lineColor;
    Color textColor = FlutterFlowTheme.of(context).primaryText;
    Widget? iconWidget;

    if (_isAnswered) {
      if (index == correctIndex) {
        // Opção Correta (fica verde)
        buttonColor = FlutterFlowTheme.of(context).success.withAlpha(20);
        borderColor = FlutterFlowTheme.of(context).success;
        textColor = FlutterFlowTheme.of(context).success;
        iconWidget = Icon(Icons.check_circle, color: FlutterFlowTheme.of(context).success, size: 20);
      } else if (_selectedOptionIndex == index) {
        // Opção incorreta que o usuário escolheu (fica vermelha)
        buttonColor = FlutterFlowTheme.of(context).error.withAlpha(20);
        borderColor = FlutterFlowTheme.of(context).error;
        textColor = FlutterFlowTheme.of(context).error;
        iconWidget = Icon(Icons.cancel, color: FlutterFlowTheme.of(context).error, size: 20);
      } else {
        // Outras opções incorretas não selecionadas (ficam esmaecidas)
        textColor = FlutterFlowTheme.of(context).secondaryText;
      }
    } else {
      // Efeitos de Hover/Seleção visual pré-resposta
      if (_selectedOptionIndex == index) {
        borderColor = FlutterFlowTheme.of(context).primary;
      }
    }

    return InkWell(
      onTap: () => _handleAnswerSelection(index),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: borderColor, width: _selectedOptionIndex == index || (_isAnswered && index == correctIndex) ? 1.8 : 1.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            if (iconWidget != null) ...[
              const SizedBox(width: 8.0),
              iconWidget,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackPanel(int correctIndex, String explanation) {
    final bool isCorrect = _selectedOptionIndex == correctIndex;
    final feedbackTitle = isCorrect ? 'Resposta Correta!' : 'Resposta Incorreta...';
    final feedbackIcon = isCorrect ? '✔️' : '❌';
    final feedbackColor = isCorrect ? FlutterFlowTheme.of(context).success : FlutterFlowTheme.of(context).error;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: feedbackColor.withAlpha(100), width: 1.5),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(feedbackIcon, style: const TextStyle(fontSize: 18.0)),
              const SizedBox(width: 8.0),
              Text(
                feedbackTitle,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: feedbackColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            explanation,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 12.0,
                  lineHeight: 1.4,
                ),
          ),
          const SizedBox(height: 16.0),
          // Botão Próxima
          SizedBox(
            width: double.infinity,
            height: 45.0,
            child: ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                _currentIndex == _questions.length - 1 ? 'Ver Resultado' : 'Próxima Questão',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
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
              child: const Text(
                '🎯',
                style: TextStyle(fontSize: 48.0),
              ),
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

            // Score Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        Text(
                          '$_score / ${_questions.length}',
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                color: FlutterFlowTheme.of(context).primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'ACERTOS',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        Text(
                          _getClassification(),
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'CLASSIFICAÇÃO',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Description
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

            // Actions Buttons
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
}

// --- WIDGET DE ILUSTRAÇÃO ---
class QuizIllustration extends StatelessWidget {
  final String type;

  const QuizIllustration({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == 'hammer') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCandle(context, isRed: true, bodyHeight: 45, wickTop: 10, wickBottom: 10, offset: -10),
          const SizedBox(width: 20),
          _buildCandle(context, isRed: true, bodyHeight: 30, wickTop: 10, wickBottom: 10, offset: 5),
          const SizedBox(width: 20),
          _buildCandle(context, isRed: false, bodyHeight: 18, wickTop: 2, wickBottom: 55, offset: 15),
        ],
      );
    } else if (type == 'engulfing') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCandle(context, isRed: true, bodyHeight: 25, wickTop: 10, wickBottom: 10, offset: 10),
          const SizedBox(width: 20),
          _buildCandle(context, isRed: false, bodyHeight: 65, wickTop: 12, wickBottom: 12, offset: -10, width: 22),
        ],
      );
    } else {
      return Container(
        width: 200,
        height: 100,
        alignment: Alignment.center,
        child: CustomPaint(
          size: const Size(200, 100),
          painter: DiagramPainter(
            type: type,
            primaryColor: FlutterFlowTheme.of(context).primary,
            errorColor: FlutterFlowTheme.of(context).error,
            successColor: FlutterFlowTheme.of(context).success,
            textColor: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
      );
    }
  }

  Widget _buildCandle(
    BuildContext context, {
    required bool isRed,
    required double bodyHeight,
    required double wickTop,
    required double wickBottom,
    required double offset,
    double width = 14,
  }) {
    final color = isRed ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).success;
    return Transform.translate(
      offset: Offset(0, offset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 2, height: wickTop, color: color),
          Container(
            width: width,
            height: bodyHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(width: 2, height: wickBottom, color: color),
        ],
      ),
    );
  }
}

// --- PINTOR DE DIAGRAMAS VETORIAIS ---
class DiagramPainter extends CustomPainter {
  final String type;
  final Color primaryColor;
  final Color errorColor;
  final Color successColor;
  final Color textColor;

  DiagramPainter({
    required this.type,
    required this.primaryColor,
    required this.errorColor,
    required this.successColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = textColor.withAlpha(150)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (type == 'choch') {
      final points = [
        Offset(size.width * 0.05, size.height * 0.75),
        Offset(size.width * 0.20, size.height * 0.30),
        Offset(size.width * 0.35, size.height * 0.60),
        Offset(size.width * 0.50, size.height * 0.15),
        Offset(size.width * 0.65, size.height * 0.85), // Breakout point
        Offset(size.width * 0.80, size.height * 0.55),
        Offset(size.width * 0.95, size.height * 0.90),
      ];

      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);

      // Draw red circle at break point
      final circlePaint = Paint()
        ..color = errorColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points[4], 4.0, circlePaint);

      // Draw support dotted line
      _drawDottedLine(canvas, Offset(points[2].dx, points[2].dy), Offset(size.width * 0.80, points[2].dy), errorColor);

      // Draw label "CHoCH"
      _drawText(canvas, "CHoCH", Offset(points[2].dx + 10, points[2].dy - 16), errorColor, fontSize: 9.0, fontWeight: FontWeight.bold);
    } else if (type == 'elliott') {
      final points = [
        Offset(size.width * 0.05, size.height * 0.90),
        Offset(size.width * 0.20, size.height * 0.60), // 1
        Offset(size.width * 0.30, size.height * 0.80), // 2
        Offset(size.width * 0.55, size.height * 0.20), // 3
        Offset(size.width * 0.65, size.height * 0.50), // 4
        Offset(size.width * 0.80, size.height * 0.10), // 5
        Offset(size.width * 0.87, size.height * 0.40), // A
        Offset(size.width * 0.93, size.height * 0.24), // B
        Offset(size.width * 0.98, size.height * 0.70), // C
      ];

      // Draw impulse waves
      final path1 = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i <= 5; i++) {
        path1.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path1, paint);

      // Draw corrective waves in color primary
      final correctivePaint = Paint()
        ..color = primaryColor
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      
      final path2 = Path()..moveTo(points[5].dx, points[5].dy);
      for (int i = 6; i < points.length; i++) {
        path2.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path2, correctivePaint);

      // Wave labels
      _drawText(canvas, "1", points[1] + const Offset(-4, -14), textColor);
      _drawText(canvas, "2", points[2] + const Offset(-4, 4), textColor);
      _drawText(canvas, "3", points[3] + const Offset(-4, -14), textColor);
      _drawText(canvas, "4", points[4] + const Offset(-4, 4), textColor);
      _drawText(canvas, "5", points[5] + const Offset(-4, -14), textColor);
      _drawText(canvas, "A", points[6] + const Offset(4, -5), primaryColor, fontWeight: FontWeight.bold);
      _drawText(canvas, "B", points[7] + const Offset(-4, -14), primaryColor, fontWeight: FontWeight.bold);
      _drawText(canvas, "C", points[8] + const Offset(4, -5), primaryColor, fontWeight: FontWeight.bold);
    } else if (type == 'oco_inverted') {
      final points = [
        Offset(size.width * 0.08, size.height * 0.25),
        Offset(size.width * 0.25, size.height * 0.625), // Left Shoulder
        Offset(size.width * 0.33, size.height * 0.30),  // Neckline left
        Offset(size.width * 0.46, size.height * 0.875), // Head
        Offset(size.width * 0.58, size.height * 0.30),  // Neckline right
        Offset(size.width * 0.66, size.height * 0.625), // Right Shoulder
        Offset(size.width * 0.83, size.height * 0.25),  // Breakout
        Offset(size.width * 0.95, size.height * 0.10),
      ];

      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);

      // Draw dotted neckline
      _drawDottedLine(canvas, points[2], Offset(points[4].dx + (size.width * 0.25), points[4].dy), successColor);
    }
  }

  void _drawDottedLine(Canvas canvas, Offset p1, Offset p2, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    
    double dx = p2.dx - p1.dx;
    double dy = p2.dy - p1.dy;
    double distance = sqrt(dx * dx + dy * dy);
    int dashCount = (distance / 6.0).floor();
    for (int i = 0; i < dashCount; i += 2) {
      double t1 = i / dashCount;
      double t2 = (i + 1) / dashCount;
      canvas.drawLine(
        Offset(p1.dx + dx * t1, p1.dy + dy * t1),
        Offset(p1.dx + dx * t2, p1.dy + dy * t2),
        paint,
      );
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color, {double fontSize = 10, FontWeight fontWeight = FontWeight.normal}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight, fontFamily: 'sans-serif'),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
