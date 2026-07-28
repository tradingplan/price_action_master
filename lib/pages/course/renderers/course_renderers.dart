import 'package:flutter/material.dart';
import 'package:price_action_master/backend/schema/platform_course_models.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import 'vector_painter.dart';
import '../../smc/detalhe_smc_widget.dart';
import '../../elliott/detalhe_elliott_widget.dart';
import '../../quiz/quiz_widget.dart';

// --- 1. RENDERIZADOR DE LIÇÕES (LessonRenderer) ---
class LessonRenderer extends StatelessWidget {
  final PlatformLesson lesson;

  const LessonRenderer({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.title,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16.0),
            ..._parseMarkdownContent(context, lesson.content),
          ],
        ),
      ),
    );
  }

  List<Widget> _parseMarkdownContent(BuildContext context, String rawText) {
    final List<Widget> widgets = [];
    final paragraphs = rawText.split('\n\n');

    for (final p in paragraphs) {
      final cleanPara = p.trim();
      if (cleanPara.isEmpty) continue;

      if (cleanPara.startsWith('* ') || cleanPara.startsWith('- ')) {
        // Tratar como Bullet Point
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Expanded(
                  child: _renderFormattedText(context, cleanPara.substring(2)),
                ),
              ],
            ),
          ),
        );
      } else {
        // Parágrafo Normal
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _renderFormattedText(context, cleanPara),
          ),
        );
      }
    }
    return widgets;
  }

  Widget _renderFormattedText(BuildContext context, String text) {
    final List<TextSpan> spans = [];
    final parts = text.split('**');

    for (int i = 0; i < parts.length; i++) {
      final isBold = i % 2 == 1;
      spans.add(
        TextSpan(
          text: parts[i],
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold
                ? FlutterFlowTheme.of(context).primaryText
                : FlutterFlowTheme.of(context).secondaryText,
            fontSize: 13.0,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}

// --- 2. RENDERIZADOR DE EXEMPLOS (ExampleRenderer) ---
class ExampleRenderer extends StatelessWidget {
  final PlatformExample example;

  const ExampleRenderer({super.key, required this.example});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              example.title,
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              height: 220.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
              ),
              padding: const EdgeInsets.all(12.0),
              alignment: Alignment.center,
              child: _buildChartWidget(context),
            ),
            const SizedBox(height: 12.0),
            Text(
              example.description,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12.0,
                    lineHeight: 1.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartWidget(BuildContext context) {
    // 1. Prioridade para Vector Canvas Dinâmico
    if (example.vectorCanvas != null) {
      return CustomPaint(
        size: Size(example.vectorCanvas!.width, example.vectorCanvas!.height),
        painter: GenericVectorPainter(
          canvasData: example.vectorCanvas!,
          context: context,
        ),
      );
    }

    // 2. Fallback de suporte a Ilustradores Legados (Ponte de Transição)
    final type = example.chartType ?? '';
    if (type == 'bos' || type == 'choch' || type == 'order_block' || type == 'fvg') {
      return SMCIllustration(type: type);
    }
    if (type == 'impulse' || type == 'corrective' || type == 'rules') {
      return ElliottIllustration(type: type);
    }
    if (type == 'hammer' || type == 'engulfing' || type == 'oco_inverted') {
      return QuizIllustration(type: type);
    }

    return const Icon(Icons.bar_chart_rounded, size: 48.0);
  }
}

// --- 3. RENDERIZADOR DE EXERCÍCIOS (ExerciseRenderer) ---
class ExerciseRenderer extends StatefulWidget {
  final PlatformExercise exercise;
  final List<bool> checklistState;
  final Function(List<bool>) onChanged;

  const ExerciseRenderer({
    super.key,
    required this.exercise,
    required this.checklistState,
    required this.onChanged,
  });

  @override
  State<ExerciseRenderer> createState() => _ExerciseRendererState();
}

class _ExerciseRendererState extends State<ExerciseRenderer> {
  late List<bool> _state;

  @override
  void initState() {
    super.initState();
    _state = List.from(widget.checklistState);
    if (_state.length != widget.exercise.checklist.length) {
      _state = List<bool>.generate(widget.exercise.checklist.length, (index) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prática Recomendada',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.exercise.instruction,
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
            const SizedBox(height: 16.0),
            ...List.generate(widget.exercise.checklist.length, (index) {
              final ruleText = widget.exercise.checklist[index];
              final isChecked = _state[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isChecked
                        ? FlutterFlowTheme.of(context).success.withAlpha(15)
                        : FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isChecked
                          ? FlutterFlowTheme.of(context).success.withAlpha(80)
                          : FlutterFlowTheme.of(context).lineColor,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: isChecked,
                    onChanged: (val) {
                      setState(() {
                        _state[index] = val ?? false;
                      });
                      widget.onChanged(_state);
                    },
                    title: Text(
                      ruleText,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: isChecked
                                ? FlutterFlowTheme.of(context).success
                                : FlutterFlowTheme.of(context).primaryText,
                            fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
                          ),
                    ),
                    activeColor: FlutterFlowTheme.of(context).success,
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// --- 4. RENDERIZADOR DE QUIZZES (QuizRenderer) ---
class QuizRenderer extends StatefulWidget {
  final PlatformQuiz quiz;
  final int? selectedIndex;
  final bool isAnswered;
  final Function(int) onAnswerSelected;

  const QuizRenderer({
    super.key,
    required this.quiz,
    required this.selectedIndex,
    required this.isAnswered,
    required this.onAnswerSelected,
  });

  @override
  State<QuizRenderer> createState() => _QuizRendererState();
}

class _QuizRendererState extends State<QuizRenderer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pergunta de Fixação',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12.0),
            Text(
              widget.quiz.question,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16.0),
            ...List.generate(widget.quiz.options.length, (index) {
              final optionText = widget.quiz.options[index];
              final isCorrect = index == widget.quiz.correctIndex;

              Color cardColor = FlutterFlowTheme.of(context).primaryBackground;
              Color borderColor = FlutterFlowTheme.of(context).lineColor;
              Color textColor = FlutterFlowTheme.of(context).primaryText;

              if (widget.isAnswered) {
                if (isCorrect) {
                  cardColor = FlutterFlowTheme.of(context).success.withAlpha(20);
                  borderColor = FlutterFlowTheme.of(context).success;
                  textColor = FlutterFlowTheme.of(context).success;
                } else if (widget.selectedIndex == index) {
                  cardColor = FlutterFlowTheme.of(context).error.withAlpha(20);
                  borderColor = FlutterFlowTheme.of(context).error;
                  textColor = FlutterFlowTheme.of(context).error;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () {
                    if (widget.isAnswered) return;
                    widget.onAnswerSelected(index);
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            optionText,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        if (widget.isAnswered && isCorrect)
                          Icon(Icons.check_circle, color: FlutterFlowTheme.of(context).success, size: 20.0),
                        if (widget.isAnswered && !isCorrect && widget.selectedIndex == index)
                          Icon(Icons.cancel, color: FlutterFlowTheme.of(context).error, size: 20.0),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (widget.isAnswered) ...[
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.selectedIndex == widget.quiz.correctIndex ? 'Resposta Correta! 🎉' : 'Resposta Incorreta ❌',
                      style: TextStyle(
                        color: widget.selectedIndex == widget.quiz.correctIndex
                            ? FlutterFlowTheme.of(context).success
                            : FlutterFlowTheme.of(context).error,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.quiz.explanation,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 11.5,
                            lineHeight: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// --- 5. RENDERIZADOR DE DESAFIOS (ChallengeRenderer) ---
class ChallengeRenderer extends StatelessWidget {
  final PlatformChallenge challenge;
  final bool isExerciseDone;
  final bool isQuizDone;
  final VoidCallback onCompletePressed;

  const ChallengeRenderer({
    super.key,
    required this.challenge,
    required this.isExerciseDone,
    required this.isQuizDone,
    required this.onCompletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isReadyToComplete = isExerciseDone && isQuizDone;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.title,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12.0),
            Text(
              challenge.description,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    lineHeight: 1.5,
                  ),
            ),
            const SizedBox(height: 40.0),

            // Requisitos de Conclusão informativos
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: FlutterFlowTheme.of(context).lineColor),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REQUISITOS DE CONCLUSÃO',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 9.0,
                        ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Icon(
                        isExerciseDone ? Icons.check_circle : Icons.circle_outlined,
                        color: isExerciseDone
                            ? FlutterFlowTheme.of(context).success
                            : FlutterFlowTheme.of(context).secondaryText,
                        size: 16.0,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Completar o checklist de Prática Recomendada',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isExerciseDone
                              ? FlutterFlowTheme.of(context).primaryText
                              : FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(
                        isQuizDone ? Icons.check_circle : Icons.circle_outlined,
                        color: isQuizDone
                            ? FlutterFlowTheme.of(context).success
                            : FlutterFlowTheme.of(context).secondaryText,
                        size: 16.0,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Responder a pergunta de fixação do Quiz',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isQuizDone
                              ? FlutterFlowTheme.of(context).primaryText
                              : FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),

            // Botão de Finalizar Módulo
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: isReadyToComplete ? onCompletePressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).success,
                  disabledBackgroundColor: FlutterFlowTheme.of(context).lineColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'CONCLUIR MÓDULO',
                  style: TextStyle(
                    color: isReadyToComplete
                        ? Colors.white
                        : FlutterFlowTheme.of(context).secondaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
