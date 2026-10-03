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
    final theme = FlutterFlowTheme.of(context);
    final List<Widget> widgets = [];
    final lines = rawText.split('\n');
    int i = 0;

    while (i < lines.length) {
      final rawLine = lines[i];
      final trimmed = rawLine.trim();

      if (trimmed.isEmpty) {
        i++;
        continue;
      }

      // 1. Cabeçalhos (#, ##, ###)
      if (trimmed.startsWith('#')) {
        int level = 0;
        while (level < trimmed.length && trimmed[level] == '#') {
          level++;
        }
        final headerText = trimmed.substring(level).trim();

        TextStyle headerStyle;
        double topPadding;
        double bottomPadding;

        if (level == 1) {
          headerStyle = theme.titleMedium.override(
            fontFamily: theme.titleMediumFamily,
            color: theme.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 16.5,
          );
          topPadding = 20.0;
          bottomPadding = 8.0;
        } else if (level == 2) {
          headerStyle = theme.titleSmall.override(
            fontFamily: theme.titleSmallFamily,
            color: theme.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          );
          topPadding = 16.0;
          bottomPadding = 6.0;
        } else {
          // level >= 3
          headerStyle = theme.bodyMedium.override(
            fontFamily: theme.bodyMediumFamily,
            color: theme.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          );
          topPadding = 14.0;
          bottomPadding = 6.0;
        }

        widgets.add(
          Padding(
            padding: EdgeInsets.only(
              top: widgets.isEmpty ? 0 : topPadding,
              bottom: bottomPadding,
            ),
            child: _renderFormattedRichText(context, headerText, baseStyle: headerStyle),
          ),
        );
        i++;
        continue;
      }

      // 2. Blockquotes (> Citação / Destaque)
      if (trimmed.startsWith('>')) {
        final quoteLines = <String>[];
        while (i < lines.length && lines[i].trim().startsWith('>')) {
          quoteLines.add(lines[i].trim().replaceFirst(RegExp(r'^>\s*'), ''));
          i++;
        }
        final quoteText = quoteLines.join('\n');
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 12.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                border: Border(
                  left: BorderSide(
                    color: theme.primary,
                    width: 3.5,
                  ),
                ),
              ),
              child: _renderFormattedRichText(
                context,
                quoteText,
                baseStyle: theme.bodyMedium.override(
                  fontFamily: theme.bodyMediumFamily,
                  color: theme.primaryText,
                  fontSize: 13.0,
                  fontStyle: FontStyle.italic,
                  lineHeight: 1.45,
                ),
              ),
            ),
          ),
        );
        continue;
      }

      // 3. Bullet List (* item ou - item)
      final bulletMatch = RegExp(r'^(\s*)([\*\-])\s+(.*)$').firstMatch(rawLine);
      if (bulletMatch != null) {
        final indentSpace = bulletMatch.group(1) ?? '';
        final isSubItem = indentSpace.length >= 2;
        final itemText = bulletMatch.group(3) ?? '';

        widgets.add(
          Padding(
            padding: EdgeInsets.only(
              left: isSubItem ? 20.0 : 6.0,
              bottom: 6.0,
              top: 2.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, right: 8.0),
                  child: Text(
                    isSubItem ? '◦' : '•',
                    style: TextStyle(
                      color: theme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: isSubItem ? 12.0 : 15.0,
                    ),
                  ),
                ),
                Expanded(
                  child: _renderFormattedRichText(context, itemText),
                ),
              ],
            ),
          ),
        );
        i++;
        continue;
      }

      // 4. Numbered List (1. item, 2. item)
      final numberedMatch = RegExp(r'^(\s*)(\d+)\.\s+(.*)$').firstMatch(rawLine);
      if (numberedMatch != null) {
        final indentSpace = numberedMatch.group(1) ?? '';
        final number = numberedMatch.group(2) ?? '1';
        final isSubItem = indentSpace.length >= 2;
        final itemText = numberedMatch.group(3) ?? '';

        widgets.add(
          Padding(
            padding: EdgeInsets.only(
              left: isSubItem ? 20.0 : 6.0,
              bottom: 6.0,
              top: 2.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8.0, top: 1.0),
                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
                  decoration: BoxDecoration(
                    color: theme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    '$number.',
                    style: TextStyle(
                      color: theme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.5,
                    ),
                  ),
                ),
                Expanded(
                  child: _renderFormattedRichText(context, itemText),
                ),
              ],
            ),
          ),
        );
        i++;
        continue;
      }

      // 5. Parágrafo Normal (agrupa linhas contínuas de texto)
      final paragraphLines = <String>[rawLine.trim()];
      i++;
      while (i < lines.length) {
        final nextLine = lines[i];
        final nextTrimmed = nextLine.trim();
        if (nextTrimmed.isEmpty ||
            nextTrimmed.startsWith('#') ||
            nextTrimmed.startsWith('>') ||
            RegExp(r'^\s*([\*\-]|\d+\.)\s+').hasMatch(nextLine)) {
          break;
        }
        paragraphLines.add(nextTrimmed);
        i++;
      }

      final fullPara = paragraphLines.join(' ');
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _renderFormattedRichText(context, fullPara),
        ),
      );
    }

    return widgets;
  }

  Widget _renderFormattedRichText(
    BuildContext context,
    String text, {
    TextStyle? baseStyle,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final defaultStyle = baseStyle ??
        theme.bodyMedium.override(
          fontFamily: theme.bodyMediumFamily,
          color: theme.secondaryText,
          fontSize: 13.0,
          lineHeight: 1.5,
        );

    final spans = <InlineSpan>[];
    final pattern = RegExp(r'(\*\*[^*]+?\*\*|`[^`]+?`|\*[^*]+?\*|_[^_]+?_)');
    int lastMatchEnd = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: defaultStyle,
        ));
      }

      final matchText = match.group(0)!;
      if (matchText.startsWith('**') && matchText.endsWith('**')) {
        final content = matchText.substring(2, matchText.length - 2);
        spans.add(TextSpan(
          text: content,
          style: defaultStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryText,
          ),
        ));
      } else if (matchText.startsWith('`') && matchText.endsWith('`')) {
        final content = matchText.substring(1, matchText.length - 1);
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                color: theme.lineColor,
                width: 1.0,
              ),
            ),
            child: Text(
              content,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: (defaultStyle.fontSize ?? 13.0) * 0.9,
                fontWeight: FontWeight.w600,
                color: theme.primary,
              ),
            ),
          ),
        ));
      } else if ((matchText.startsWith('*') && matchText.endsWith('*')) ||
          (matchText.startsWith('_') && matchText.endsWith('_'))) {
        final content = matchText.substring(1, matchText.length - 1);
        spans.add(TextSpan(
          text: content,
          style: defaultStyle.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: defaultStyle,
      ));
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
