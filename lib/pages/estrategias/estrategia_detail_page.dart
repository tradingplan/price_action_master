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
    final lines = rawContent.split('\n');
    final buffer = StringBuffer();

    void flushText() {
      final text = buffer.toString().trim();
      if (text.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              text,
              style: TextStyle(
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

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Heading 2
      if (line.startsWith('## ')) {
        flushText();
        final title = line.substring(3).trim();
        widgets.add(const SizedBox(height: 16));
        widgets.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border(
                left: BorderSide(color: theme.primary, width: 4),
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
          ),
        );
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // Heading 3
      if (line.startsWith('### ')) {
        flushText();
        final title = line.substring(4).trim();
        widgets.add(const SizedBox(height: 12));
        widgets.add(
          Text(
            title,
            style: TextStyle(
              color: theme.primary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        widgets.add(const SizedBox(height: 6));
        continue;
      }

      // Heading 4
      if (line.startsWith('#### ')) {
        flushText();
        final title = line.substring(5).trim();
        widgets.add(const SizedBox(height: 10));
        widgets.add(
          Text(
            title,
            style: TextStyle(
              color: theme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        widgets.add(const SizedBox(height: 4));
        continue;
      }

      // Image: ![alt](path)
      final imgMatch = RegExp(r'!\[(.*?)\]\((.*?)\)').firstMatch(line);
      if (imgMatch != null) {
        flushText();
        final caption = imgMatch.group(1) ?? '';
        final path = imgMatch.group(2) ?? '';
        widgets.add(const SizedBox(height: 12));
        widgets.add(
          ClipRRect(
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
                  Image.asset(
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
        widgets.add(const SizedBox(height: 12));
        continue;
      }

      // Bullet list item
      if (line.startsWith('- ')) {
        flushText();
        final bulletText = line.substring(2).trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, size: 6, color: theme.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    bulletText,
                    style: TextStyle(
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
        continue;
      }

      // Numbered list item
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
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    numStr!,
                    style: TextStyle(
                      color: theme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    itemText,
                    style: TextStyle(
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
        continue;
      }

      buffer.writeln(line);
    }
    flushText();

    return widgets;
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
