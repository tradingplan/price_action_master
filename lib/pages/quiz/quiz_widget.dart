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

  List<dynamic> _allQuestions = [];
  List<dynamic> _questions = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  String _screenState = 'intro'; // 'intro', 'quiz', 'results'
  String _selectedCategory = 'Todos';

  static const List<String> _categories = [
    'Todos',
    'Candlesticks',
    'SMC',
    'Ondas de Elliott',
    'Figuras Gráficas',
    'Método Wyckoff',
    'Análise Técnica',
    'Gestão de Risco',
  ];

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
      final List<dynamic> raw = json.decode(jsonStr) as List<dynamic>;
      setState(() {
        _allQuestions = raw;
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
    List<Map<String, dynamic>> pool = [];

    if (_selectedCategory == 'Todos') {
      pool = _allQuestions.map((q) => Map<String, dynamic>.from(q as Map)).toList();
    } else {
      final filter = _selectedCategory.toLowerCase();
      pool = _allQuestions
          .where((q) {
            final cat = (q['category'] as String? ?? '').toLowerCase();
            return cat.contains(filter) ||
                (_selectedCategory == 'SMC' && (cat.contains('smc') || cat.contains('smart money'))) ||
                (_selectedCategory == 'Figuras Gráficas' && (cat.contains('figuras') || cat.contains('graficas'))) ||
                (_selectedCategory == 'Método Wyckoff' && cat.contains('wyckoff')) ||
                (_selectedCategory == 'Análise Técnica' && (cat.contains('analise') || cat.contains('tecnica') || cat.contains('técnica'))) ||
                (_selectedCategory == 'Gestão de Risco' && (cat.contains('gestao') || cat.contains('gestão') || cat.contains('risco')));
          })
          .map((q) => Map<String, dynamic>.from(q as Map))
          .toList();
    }

    if (pool.isEmpty) {
      pool = _allQuestions.map((q) => Map<String, dynamic>.from(q as Map)).toList();
    }

    // 1. Embaralha a ordem das questões no pool
    final random = Random();
    pool.shuffle(random);

    // 2. Seleciona 5 questões para a rodada
    final int roundCount = min(5, pool.length);
    final selectedBatch = pool.take(roundCount).toList();

    // 3. Embaralha as 4 alternativas de cada pergunta mantendo a resposta correta sincronizada
    final preparedQuestions = selectedBatch.map((q) {
      final rawOptions = List<String>.from(q['options'] as List);
      final int originalCorrectIndex = q['correct_index'] as int;
      final String correctOptionText = rawOptions[originalCorrectIndex];

      rawOptions.shuffle(random);
      final int newCorrectIndex = rawOptions.indexOf(correctOptionText);

      return {
        ...q,
        'options': rawOptions,
        'correct_index': newCorrectIndex,
      };
    }).toList();

    setState(() {
      _questions = preparedQuestions;
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
    final int correctIndex = currentQuestion['correct_index'] as int;

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
      // Finalizou a rodada do Quiz
      setState(() {
        _screenState = 'results';
      });

      // Grava o resultado no banco local
      await LocalDataManager.saveQuizAttempt(
        category: _selectedCategory,
        score: _score,
        totalQuestions: _questions.length,
        date: DateTime.now().toString().split(' ')[0], // YYYY-MM-DD
      );
    }
  }

  String _getClassification() {
    final double pct = _score / (_questions.isEmpty ? 1 : _questions.length);
    if (pct >= 0.8) return 'Consistente 📈';
    if (pct >= 0.6) return 'Sobrevivente ⚖️';
    return 'Aprendiz 📚';
  }

  String _getClassificationDescription() {
    final double pct = _score / (_questions.isEmpty ? 1 : _questions.length);
    if (pct >= 0.8) {
      return 'Excelente desempenho! Você demonstrou domínio refinado de Price Action, estruturas e leitura técnica de mercado.';
    }
    if (pct >= 0.6) {
      return 'Bom progresso! Você compreende a lógica dos padrões, mas ainda comete deslizes em detalhes estruturais. Continue praticando.';
    }
    return 'Atenção necessária. O mercado pune a falta de técnica. Estude as explicações e repita as rodadas de quiz para fixar os conceitos.';
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
            onTap: () {
              if (_screenState != 'intro') {
                setState(() {
                  _screenState = 'intro';
                });
              } else {
                context.pop();
              }
            },
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
          bottom: true,
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

  // --- TELA 1: INTRODUÇÃO & SELEÇÃO DE CATEGORIA ---
  Widget _buildIntroScreen() {
    final theme = FlutterFlowTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 90.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0),
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: theme.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              '🏆',
              style: TextStyle(fontSize: 40.0),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Simulado de Price Action',
            style: theme.headlineSmall.override(
                  fontFamily: theme.headlineSmallFamily,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Desafie seus conhecimentos com perguntas inéditas e aleatórias a cada rodada.',
            textAlign: TextAlign.center,
            style: theme.bodyMedium.override(
                  fontFamily: theme.bodyMediumFamily,
                  color: theme.secondaryText,
                ),
          ),
          const SizedBox(height: 24.0),

          // Seletor de Categorias
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'ESCOLHA O TEMA DO QUIZ',
              style: theme.bodySmall.override(
                    fontFamily: theme.bodySmallFamily,
                    color: theme.secondaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.0,
                  ),
            ),
          ),
          const SizedBox(height: 10.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategory = cat;
                  });
                },
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primary : theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: isSelected ? theme.primary : theme.lineColor,
                    ),
                  ),
                  child: Text(
                    cat == 'Todos' ? '🎲 Todas (Misto Aleatório)' : cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : theme.primaryText,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24.0),

          // Info Box
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: theme.lineColor),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBulletInfo('🎲', '5 questões sorteadas do banco de ${_allQuestions.length} perguntas'),
                const SizedBox(height: 10.0),
                _buildBulletInfo('🔄', 'Alternativas A, B, C, D embaralhadas a cada tentativa'),
                const SizedBox(height: 10.0),
                _buildBulletInfo('📊', 'Explicações teóricas detalhadas e registro no histórico'),
              ],
            ),
          ),
          const SizedBox(height: 30.0),

          // Start Button
          SizedBox(
            width: double.infinity,
            height: 52.0,
            child: ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 2.0,
              ),
              child: Text(
                'Iniciar Quiz (${_selectedCategory == 'Todos' ? 'Misto' : _selectedCategory})',
                style: theme.titleSmall.override(
                      fontFamily: theme.titleSmallFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
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
                  fontSize: 12.5,
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
    final String questionText = currentQuestion['question'] as String? ?? '';
    final String category = currentQuestion['category'] as String? ?? 'GERAL';
    final String illustrationType = currentQuestion['illustration_type'] as String? ?? '';
    final List<dynamic> options = currentQuestion['options'] as List<dynamic>? ?? [];
    final int correctIndex = currentQuestion['correct_index'] as int? ?? 0;
    final String explanation = currentQuestion['explanation'] as String? ?? '';

    final double progress = (_currentIndex + 1) / _questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 90.0),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  category,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),

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
          const SizedBox(height: 18.0),

          // Question Prompt
          Text(
            questionText,
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  lineHeight: 1.4,
                ),
          ),
          const SizedBox(height: 14.0),

          // Illustration Panel (quando houver tipo de ilustração)
          if (illustrationType.isNotEmpty) ...[
            Container(
              width: double.infinity,
              height: 130.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
              ),
              alignment: Alignment.center,
              child: QuizIllustration(type: illustrationType),
            ),
            const SizedBox(height: 16.0),
          ],

          // Options List
          Column(
            children: List.generate(options.length, (idx) {
              final String text = options[idx] as String;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
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
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13.0),
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
                      fontSize: 13.0,
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
            height: 46.0,
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
    final theme = FlutterFlowTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 90.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0),
          Container(
            width: 90.0,
            height: 90.0,
            decoration: BoxDecoration(
              color: theme.primary.withAlpha(20),
              shape: BoxShape.circle,
              border: Border.all(color: theme.primary.withAlpha(50), width: 2),
            ),
            alignment: Alignment.center,
            child: const Text(
              '🎯',
              style: TextStyle(fontSize: 44.0),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Desempenho da Rodada',
            style: theme.headlineSmall.override(
                  fontFamily: theme.headlineSmallFamily,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Tema: ${_selectedCategory == 'Todos' ? 'Misto Geral' : _selectedCategory}',
            style: theme.bodySmall.override(
                  fontFamily: theme.bodySmallFamily,
                  color: theme.secondaryText,
                ),
          ),
          const SizedBox(height: 20.0),

          // Score Row
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: theme.lineColor),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Text(
                        '$_score / ${_questions.length}',
                        style: theme.headlineSmall.override(
                              fontFamily: theme.headlineSmallFamily,
                              color: theme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'ACERTOS',
                        style: theme.bodySmall.override(
                              fontFamily: theme.bodySmallFamily,
                              color: theme.secondaryText,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: theme.lineColor),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Text(
                        _getClassification(),
                        style: theme.headlineSmall.override(
                              fontFamily: theme.headlineSmallFamily,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'CLASSIFICAÇÃO',
                        style: theme.bodySmall.override(
                              fontFamily: theme.bodySmallFamily,
                              color: theme.secondaryText,
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
          const SizedBox(height: 18.0),

          // Description
          Text(
            _getClassificationDescription(),
            textAlign: TextAlign.center,
            style: theme.bodySmall.override(
                  fontFamily: theme.bodySmallFamily,
                  color: theme.secondaryText,
                  fontSize: 12.0,
                  lineHeight: 1.5,
                ),
          ),
          const SizedBox(height: 30.0),

          // Action Buttons
          SizedBox(
            width: double.infinity,
            height: 50.0,
            child: ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.casino_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Novo Quiz Aleatório',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          SizedBox(
            width: double.infinity,
            height: 46.0,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _screenState = 'intro';
                });
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.lineColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Trocar Categoria / Temas',
                style: theme.bodyMedium.override(
                      fontFamily: theme.bodyMediumFamily,
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
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
