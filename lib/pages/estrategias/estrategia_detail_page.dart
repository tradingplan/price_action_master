import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/schema/strategy_model.dart';
import '/services/pro_access_service.dart';
import '/services/in_app_purchase_service.dart';
import '/components/pro_upgrade_sheet.dart';

class EstrategiaDetailPage extends StatefulWidget {
  final StrategyModel strategy;

  const EstrategiaDetailPage({
    super.key,
    required this.strategy,
  });

  static String routeName = 'EstrategiaDetail';
  static String routePath = '/estrategia-detail';

  @override
  State<EstrategiaDetailPage> createState() => _EstrategiaDetailPageState();
}

class _EstrategiaDetailPageState extends State<EstrategiaDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> _checkedIndices = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleCheck(int index) {
    setState(() {
      if (_checkedIndices.contains(index)) {
        _checkedIndices.remove(index);
      } else {
        _checkedIndices.add(index);
      }
    });
  }

  void _resetChecklist() {
    setState(() {
      _checkedIndices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isProUser = ProAccessService().isPro;
    final isLocked = widget.strategy.isPro && !isProUser;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.primaryText, size: 20),
          onPressed: () => context.safePop(),
        ),
        title: Text(
          widget.strategy.nome,
          style: TextStyle(
            color: theme.primaryText,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (widget.strategy.isPro)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFF59E0B),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.workspace_premium_rounded, size: 14, color: Color(0xFFB45309)),
                      SizedBox(width: 4),
                      Text(
                        'PRO',
                        style: TextStyle(
                          color: Color(0xFFB45309),
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.primary,
          indicatorWeight: 3,
          labelColor: theme.primary,
          unselectedLabelColor: theme.secondaryText,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            const Tab(
              icon: Icon(Icons.menu_book_rounded, size: 18),
              text: 'Guia Operacional',
            ),
            Tab(
              icon: const Icon(Icons.checklist_rounded, size: 18),
              text: 'Checklist (${_checkedIndices.length}/${widget.strategy.checklist.length})',
            ),
          ],
        ),
      ),
      body: isLocked
          ? _buildLockedOverlay(context)
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOperationalGuide(theme),
                _buildChecklistTab(theme),
              ],
            ),
    );
  }

  Widget _buildLockedOverlay(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFEF3C7),
                border: Border.all(color: const Color(0xFFF59E0B), width: 2),
              ),
              child: const Icon(Icons.lock_rounded, size: 48, color: Color(0xFFB45309)),
            ),
            const SizedBox(height: 20),
            Text(
              widget.strategy.nome,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Este setup operacional é exclusivo para usuários da versão PRO Vitalícia.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.secondaryText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ProUpgradeSheet.show(
                    context,
                    featureHighlighted: widget.strategy.nome,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.workspace_premium_rounded),
                label: Text(
                  'Desbloquear por ' + InAppPurchaseService().formattedPrice + ' (Vitalício)',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationalGuide(FlutterFlowTheme theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Meta header
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.lineColor),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.strategy.categoria,
                      style: TextStyle(
                        color: theme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  for (final mercado in widget.strategy.mercados)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          mercado,
                          style: const TextStyle(
                            color: Color(0xFF047857),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (widget.strategy.descricaoCurta.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  widget.strategy.descricaoCurta,
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Render parsed markdown blocks
        ..._renderContentBlocks(widget.strategy.content, theme),
        const SizedBox(height: 40),
      ],
    );
  }

  List<Widget> _renderContentBlocks(String rawContent, FlutterFlowTheme theme) {
    final widgets = <Widget>[];
    final lines = rawContent.split(RegExp(r'\r?\n'));
    final buffer = StringBuffer();

    void flushText() {
      final text = buffer.toString().trim();
      if (text.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: _renderFormattedRichText(
              context,
              text,
              baseStyle: TextStyle(
                color: theme.primaryText,
                fontSize: 14.5,
                height: 1.6,
              ),
            ),
          ),
        );
      }
      buffer.clear();
    }

    int i = 0;
    while (i < lines.length) {
      final rawLine = lines[i];
      final line = rawLine.trim();

      if (line.isEmpty) {
        i++;
        continue;
      }

      // 1. Heading 2 (## )
      if (line.startsWith('## ')) {
        flushText();
        final title = line.substring(3).trim();
        widgets.add(_buildHeading2(theme, title));
        i++;
        continue;
      }

      // 2. Heading 3 (### )
      if (line.startsWith('### ')) {
        flushText();
        final title = line.substring(4).trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 6),
            child: Text(
              title,
              style: TextStyle(
                color: theme.primary,
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        i++;
        continue;
      }

      // 3. Heading 4 (#### )
      if (line.startsWith('#### ')) {
        flushText();
        final title = line.substring(5).trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(
              title,
              style: TextStyle(
                color: theme.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
        i++;
        continue;
      }

      // 4. Standalone Card: **Quando funciona**
      final lowerLine = line.toLowerCase();
      if (lowerLine == '**quando funciona**' || lowerLine.startsWith('**quando funciona')) {
        flushText();
        i++;
        final criteriaLines = <String>[];
        while (i < lines.length) {
          final nextTrimmed = lines[i].trim();
          if (nextTrimmed.isEmpty) {
            i++;
            if (i < lines.length && (lines[i].trim().startsWith('**') || lines[i].trim().startsWith('#'))) {
              break;
            }
            continue;
          }
          if (nextTrimmed.startsWith('**') || nextTrimmed.startsWith('#')) {
            break;
          }
          criteriaLines.add(nextTrimmed);
          i++;
        }
        final criteriaText = criteriaLines.join(' ').trim();
        if (criteriaText.isNotEmpty) {
          widgets.add(_buildQuandoFuncionaCard(context, theme, criteriaText));
        }
        continue;
      }

      // 5. Standalone Card: **Quando não funciona**
      if (lowerLine == '**quando não funciona**' ||
          lowerLine.startsWith('**quando não funciona') ||
          lowerLine == '**quando nao funciona**') {
        flushText();
        i++;
        final invalidationLines = <String>[];
        while (i < lines.length) {
          final nextTrimmed = lines[i].trim();
          if (nextTrimmed.isEmpty) {
            i++;
            if (i < lines.length && (lines[i].trim().startsWith('**') || lines[i].trim().startsWith('#'))) {
              break;
            }
            continue;
          }
          if (nextTrimmed.startsWith('**') || nextTrimmed.startsWith('#')) {
            break;
          }
          invalidationLines.add(nextTrimmed);
          i++;
        }
        final invalidationText = invalidationLines.join(' ').trim();
        if (invalidationText.isNotEmpty) {
          widgets.add(_buildQuandoNaoFuncionaCard(context, theme, invalidationText));
        }
        continue;
      }

      // 6. Standalone Bold Badge / Sub-heading (ex: **Contexto multi-timeframe (H1)**)
      if (line.startsWith('**') && line.endsWith('**') && line.length > 4 && !line.substring(2, line.length - 2).contains('**')) {
        flushText();
        final label = line.substring(2, line.length - 2).trim();
        widgets.add(_buildContextBadge(theme, label));
        i++;
        continue;
      }

      // 7. Image: ![alt](path)
      final imgMatch = RegExp(r'!\[(.*?)\]\((.*?)\)').firstMatch(line);
      if (imgMatch != null) {
        flushText();
        final caption = imgMatch.group(1) ?? '';
        final path = imgMatch.group(2) ?? '';
        widgets.add(_buildImageCard(context, theme, path, caption));
        i++;
        continue;
      }

      // 8. Blockquote (> Citação / Destaque)
      if (line.startsWith('>')) {
        flushText();
        final quoteLines = <String>[];
        while (i < lines.length && lines[i].trim().startsWith('>')) {
          quoteLines.add(lines[i].trim().replaceFirst(RegExp(r'^>\s*'), ''));
          i++;
        }
        final quoteText = quoteLines.join('\n');
        widgets.add(_buildQuoteCard(context, theme, quoteText));
        continue;
      }

      // 9. Bullet list item (- item ou * item)
      if (line.startsWith('- ') || line.startsWith('* ')) {
        flushText();
        String bulletText = line.substring(2).trim();
        bool isCheckbox = false;
        bool isChecked = false;

        if (bulletText.startsWith('[ ] ')) {
          isCheckbox = true;
          isChecked = false;
          bulletText = bulletText.substring(4).trim();
        } else if (bulletText.startsWith('[x] ') || bulletText.startsWith('[X] ')) {
          isCheckbox = true;
          isChecked = true;
          bulletText = bulletText.substring(4).trim();
        }

        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isCheckbox)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 8),
                    child: Icon(
                      isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      size: 16,
                      color: isChecked ? theme.primary : theme.secondaryText,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 10),
                    child: Icon(Icons.circle, size: 6, color: theme.primary),
                  ),
                Expanded(
                  child: _renderFormattedRichText(
                    context,
                    bulletText,
                    baseStyle: TextStyle(
                      color: theme.primaryText,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        i++;
        continue;
      }

      // 10. Numbered list item
      final numMatch = RegExp(r'^(\d+)\.\s+(.*)$').firstMatch(line);
      if (numMatch != null) {
        flushText();
        final numStr = numMatch.group(1);
        final itemText = numMatch.group(2) ?? '';
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    numStr!,
                    style: TextStyle(
                      color: theme.primary,
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _renderFormattedRichText(
                    context,
                    itemText,
                    baseStyle: TextStyle(
                      color: theme.primaryText,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        i++;
        continue;
      }

      buffer.writeln(line);
      i++;
    }
    flushText();

    return widgets;
  }

  /// Card Estilizado: QUANDO FUNCIONA (Verde / Sucesso)
  Widget _buildQuandoFuncionaCard(BuildContext context, FlutterFlowTheme theme, String content) {
    final items = content.contains('·')
        ? content.split('·').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
        : <String>[];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF10B981).withAlpha(80), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
              SizedBox(width: 8),
              Text(
                'QUANDO FUNCIONA (CENÁRIO IDEAL)',
                style: TextStyle(
                  color: Color(0xFF047857),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (items.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3, right: 8),
                      child: Icon(Icons.check, size: 14, color: Color(0xFF10B981)),
                    ),
                    Expanded(
                      child: _renderFormattedRichText(
                        context,
                        item,
                        baseStyle: TextStyle(
                          color: theme.primaryText,
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            )
          else
            _renderFormattedRichText(
              context,
              content,
              baseStyle: TextStyle(
                color: theme.primaryText,
                fontSize: 13.5,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  /// Card Estilizado: QUANDO NÃO FUNCIONA (Vermelho / Armadilha)
  Widget _buildQuandoNaoFuncionaCard(BuildContext context, FlutterFlowTheme theme, String content) {
    final items = content.contains('·')
        ? content.split('·').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
        : <String>[];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEF4444).withAlpha(80), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 18),
              SizedBox(width: 8),
              Text(
                'QUANDO NÃO FUNCIONA (FILTROS DE ARMADILHA)',
                style: TextStyle(
                  color: Color(0xFFB91C1C),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (items.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3, right: 8),
                      child: Icon(Icons.close, size: 14, color: Color(0xFFEF4444)),
                    ),
                    Expanded(
                      child: _renderFormattedRichText(
                        context,
                        item,
                        baseStyle: TextStyle(
                          color: theme.primaryText,
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            )
          else
            _renderFormattedRichText(
              context,
              content,
              baseStyle: TextStyle(
                color: theme.primaryText,
                fontSize: 13.5,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  /// Badge / Sub-heading para contexto Multi-Timeframe e rótulos
  Widget _buildContextBadge(FlutterFlowTheme theme, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: theme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.primary.withAlpha(60), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.layers_rounded, size: 14, color: theme.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: theme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Heading 2 Estilizado
  Widget _buildHeading2(FlutterFlowTheme theme, String title) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: theme.primary, width: 4),
          top: BorderSide(color: theme.lineColor, width: 0.8),
          right: BorderSide(color: theme.lineColor, width: 0.8),
          bottom: BorderSide(color: theme.lineColor, width: 0.8),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          color: theme.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Image Card com suporte a toque para Zoom Fullscreen
  Widget _buildImageCard(BuildContext context, FlutterFlowTheme theme, String rawPath, String caption) {
    String path = rawPath.trim();
    if (path.startsWith('images/')) {
      path = 'assets/images/estrategias/' + path.substring(7);
    } else if (!path.startsWith('assets/')) {
      path = 'assets/' + path;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            border: Border.all(color: theme.lineColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: () => _openImageFullscreen(context, path, caption),
                    child: Hero(
                      tag: 'strategy_img_$path',
                      child: Image.asset(
                        path,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 140,
                          color: theme.primaryBackground,
                          child: Center(
                            child: Icon(Icons.image_not_supported_rounded, color: theme.secondaryText, size: 36),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(160),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.zoom_in, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Ampliar',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (caption.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    caption,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.secondaryText,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Modal de visualização de imagem em tela cheia com zoom interativo
  void _openImageFullscreen(BuildContext context, String imagePath, String caption) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black.withAlpha(240),
        insetPadding: const EdgeInsets.all(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              minScale: 0.8,
              maxScale: 4.5,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image_rounded,
                  color: Colors.white54,
                  size: 64,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            if (caption.isNotEmpty)
              Positioned(
                bottom: 15,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(180),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    caption,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Citação / Blockquote (> )
  Widget _buildQuoteCard(BuildContext context, FlutterFlowTheme theme, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          border: Border(
            left: BorderSide(color: theme.primary, width: 3.5),
          ),
        ),
        child: _renderFormattedRichText(
          context,
          text,
          baseStyle: TextStyle(
            color: theme.primaryText,
            fontSize: 13.5,
            fontStyle: FontStyle.italic,
            height: 1.45,
          ),
        ),
      ),
    );
  }

  /// Renderizador Avançado de Rich Text Markdown (**bold**, *italic*, `code`)
  Widget _renderFormattedRichText(
    BuildContext context,
    String text, {
    TextStyle? baseStyle,
    TextAlign textAlign = TextAlign.start,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final defaultStyle = baseStyle ??
        TextStyle(
          color: theme.primaryText,
          fontSize: 14.0,
          height: 1.55,
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
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.5),
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              color: theme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                color: theme.primary.withAlpha(60),
                width: 0.8,
              ),
            ),
            child: Text(
              content,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: (defaultStyle.fontSize ?? 13.0) * 0.9,
                fontWeight: FontWeight.bold,
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
      textAlign: textAlign,
      text: TextSpan(children: spans),
    );
  }

  Widget _buildChecklistTab(FlutterFlowTheme theme) {
    final items = widget.strategy.checklist;
    final total = items.length;
    final checked = _checkedIndices.length;
    final isComplete = total > 0 && checked == total;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Status Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isComplete ? const Color(0xFFD1FAE5) : theme.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isComplete ? const Color(0xFF10B981) : theme.lineColor,
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    isComplete ? Icons.verified_rounded : Icons.pending_actions_rounded,
                    color: isComplete ? const Color(0xFF047857) : theme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isComplete ? 'SETUP 100% VALIDADO' : 'CHECKLIST PRÉ-TRADE',
                          style: TextStyle(
                            color: isComplete ? const Color(0xFF047857) : theme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isComplete
                              ? 'Todos os critérios foram atendidos. Gerencie o risco!'
                              : 'Marque todos os critérios antes de abrir a operação.',
                          style: TextStyle(
                            color: isComplete ? const Color(0xFF065F46) : theme.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: total > 0 ? checked / total : 0,
                  backgroundColor: theme.primaryBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isComplete ? const Color(0xFF10B981) : theme.primary,
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$checked de $total critérios checados',
                    style: TextStyle(
                      color: theme.secondaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (checked > 0)
                    GestureDetector(
                      onTap: _resetChecklist,
                      child: const Text(
                        'Limpar checagens',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Checklist Items
        for (int i = 0; i < items.length; i++) ...[
          _ChecklistItemWidget(
            text: items[i],
            isChecked: _checkedIndices.contains(i),
            onToggle: () => _toggleCheck(i),
          ),
          const SizedBox(height: 8),
        ],

        const SizedBox(height: 30),
      ],
    );
  }
}

class _ChecklistItemWidget extends StatelessWidget {
  final String text;
  final bool isChecked;
  final VoidCallback onToggle;

  const _ChecklistItemWidget({
    required this.text,
    required this.isChecked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isChecked ? const Color(0xFFECFDF5) : theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isChecked ? const Color(0xFF10B981) : theme.lineColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isChecked ? const Color(0xFF10B981) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isChecked ? const Color(0xFF10B981) : theme.secondaryText,
                  width: 1.5,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isChecked ? const Color(0xFF065F46) : theme.primaryText,
                  fontSize: 14,
                  fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                  decorationColor: const Color(0xFF10B981),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
